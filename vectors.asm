.data
	size_input_message: .asciiz "Vector size: "
	vector_input_message: .asciiz "Original vector:\n"
	invalid_size_message: .asciiz "The size of vector should be positive (> 0). "
	output_message: .asciiz "The value of dot product is: "
	
.text
main:
	# read size
	jal read_size
	# save input in $s0
	move $s0, $v0
	
	# validate if size is positive
	blez $s0, invalid_size
	
	# printing vector message
	li $v0, 4
	la $a0, vector_input_message
	syscall
	
	# now we loop
	# loop counter $t0
	li $t0, 0
	# dot product $t1
	li $t1, 0
	loop:
		# reading current input
		li $v0, 5
		syscall
		
		# if 0 jump to loop_end
		beqz $v0, loop_end
		
		# adding to dot product index * value of non-zero element
		mul $t2, $t0, $v0
		add $t1, $t1, $t2
		
	loop_end:
		# increasing loop counter
		# and looping until it's less than size input	
		add $t0, $t0, 1
		blt $t0, $s0, loop
	
	# printing output message
	li $v0, 4
	la $a0, output_message
	syscall
	
	# printing result
	li $v0, 1
	move $a0, $t1
	syscall
	
	# exiting
	j exit
	

invalid_size:
	li $v0, 4
	la $a0, invalid_size_message
	syscall
	j exit

# subroutine for reading vector size
read_size:
	# print message
	li $v0, 4
	la $a0, size_input_message
	syscall
	# read input
	li $v0, 5
	syscall
	# jump back
	jr $ra

# program endpoint
exit:
	li $v0, 10
	syscall