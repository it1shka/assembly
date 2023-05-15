.data
	prompt: .asciiz "Please, enter an integer: "
	output_message: .asciiz "The result is: "

.text
	.globl main

# main entry point
main:
	jal print_prompt
	jal get_input
	add $a0, $v0, $zero
	jal calculate_fibonacci
	add $a1, $v0, $zero
	jal print_result
	j exit

# prints prompt to the console
print_prompt:
	li $v0, 4
	la $a0, prompt
	syscall
	jr $ra

# gets input from user and stores it inside $v0
get_input:
	li $v0, 5
	syscall
	jr $ra

# calculates fibonacci in a loop
calculate_fibonacci:
	li $t0, 0
	li $s0, 0
	li $s1, 1
loop:
	addi $t0, $t0, 1
	beq $t0, $a0, loop_end
	
	add $t1, $s1, $zero
	add $s1, $s1, $s0
	add $s0, $t1, $zero
	
	j loop
loop_end:
	add $v0, $s1, $zero
	jr $ra

# printing result
print_result:
	li $v0, 4
	la $a0, output_message
	syscall
	
	li $v0, 1
	add $a0, $a1, $zero
	syscall
	  
	jr $ra

# exitst with OK status
exit:
	li $v0, 10
	syscall