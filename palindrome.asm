.data
	size_prompt: .asciiz "Please, enter string size: "
	string_prompt: .asciiz "Please, enter string: "
	combined_string_message: .asciiz "This is a combined string: "
	is_palindrom_message: .asciiz "The combined string IS palindrom. "
	is_not_palindrom_message: .asciiz "The combined string IS NOT palindrom. "
	
.text
main:
	# input string
	jal input_string
	move $s0, $v0
	move $s1, $v1
	
	# input string
	jal input_string
	move $s2, $v0
	move $s3, $v1
	
	# allocate space for combined string
	li $v0, 9
	add $a0, $s0, $s2
	sub $a0, $a0, 1
	move $s4, $a0
	syscall
	move $s5, $v0
	
	# initialize combined string
	li $t0, 0
	init_loop:
		bge $t0, $s4, init_loop_end
		add $t1, $s5, $t0
		li $t2, ' '
		sb $t2, ($t1)
		addiu $t0, $t0, 1
		j init_loop
	init_loop_end:
	# setting up 0-terminator
	add $t0, $s5, $s4
	sub $t0, $t0, 1
	li $t1, '\0'
	sb $t1, ($t0)
	
	# loop 1 for copying from the first string
	li $t0, 0
	sub $t1, $s0, 1
	first_loop:
		bge $t0, $t1, first_loop_end
		add $t2, $s1, $t0
		lb $t3, ($t2)
		 
		sll $t2, $t0, 1
		add $t2, $t2, $s5
		sb $t3, ($t2)
		
		addiu $t0, $t0, 1
		j first_loop
	first_loop_end:
	
	# loop 2 for copying from the second string
	li $t0, 0
	sub $t1, $s2, 1
	second_loop:
		bge $t0, $t1, second_loop_end
		add $t2, $s3, $t0
		lb $t3, ($t2)
		 
		sll $t2, $t0, 1
		addiu $t2, $t2, 1
		add $t2, $t2, $s5
		sb $t3, ($t2)
		
		addiu $t0, $t0, 1
		j second_loop
	second_loop_end:
	
	# printing combined string
	li $v0, 4
	la $a0, combined_string_message
	syscall
	move $a0, $s5
	syscall
	li $v0, 11
	li $a0, '\n'
	syscall
	
	# detecting if it is a palindrome
	li $t0, 0
	sub $t1, $s4, 1
	pal_loop:
		beq $t0, $t1, end_pal_loop
		
		move $t2, $s5
		add $t2, $t2, $t0
		lb $t3, ($t2)
		
		move $t2, $s5
		add $t2, $t2, $t1
		sub $t2, $t2, $t0
		sub $t2, $t2, 1
		lb $t4, ($t2)
		
		bne $t3, $t4, is_not_a_palindrom_case
		
		addiu $t0, $t0, 1
		j pal_loop
	end_pal_loop:
	
	# printing that it is indeed a palindrome
	li $v0, 4
	la $a0, is_palindrom_message
	syscall
	
	# exiting
	j exit

# if not a palindrom
is_not_a_palindrom_case:
	li $v0, 4
	la $a0, is_not_palindrom_message
	syscall
	j exit

input_string:
	li $v0, 4
	la $a0, size_prompt
	syscall
	li $v0, 5
	syscall
	add $t0, $v0, 1
	li $v0, 9
	move $a0, $t0
	syscall
	move $t1, $v0
	li $v0, 4
	la $a0, string_prompt
	syscall
	li $v0, 8
	move $a0, $t1
	move $a1, $t0
	syscall
	li $v0, 11
	la $a0, '\n'
	syscall
	move $v0, $t0
	move $v1, $t1
	jr $ra

exit:
	li $v0, 10
	syscall