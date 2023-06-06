.data
	input_message: .asciiz "Please, enter an integer: "
	not_defined_message: .asciiz "Factorial is not defined for negative numbers. "
	overflow_message: .asciiz "Overflow occured: factorial is too big. "
	output_message: .asciiz "The result is: "
	
.text
main:
	# we are reading input
	# and saving it in $s0
	jal read_input
	move $s0, $v0
	
	# now we need to validate input
	# factorial is not defined for negative numbers 
	blt $s0, 0, not_defined
	
	# we create a for loop (below is pseudocode)
	# for ($t0 = 1; $t0 < $s0; $t0++) {
	#    $t1 *= $t0
	#    check_for_overflow($t1)
	# }
	
	# $t0 is loop counter
	# $t1 is factorial
	li $t0, 1
	li $t1, 1
	loop:
		# if loop counter bigger than limit, exit
		bgt $t0, $s0, loop_end
		
		# multiplying our factorial variable
		mul $t1, $t1, $t0
		
		# now we try to decect an overflow
		# we load our HI register into $t2
		mfhi $t2
		# and if it's not zero, then it's an overflow 
		# and we jump to overflow label
		bnez $t2, overflow
		
		# adding 1 to loop counter, 
		# jumping if loop counter is less than or equal to input
		add $t0, $t0, 1
		j loop
	loop_end:
	
	# the result is stored in $t1
	
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

# if factorial is not defined,
# we print message and jump to exit
not_defined:
	li $v0, 4
	la $a0, not_defined_message
	syscall
	j exit

# overflow case:
# print overflow message and exit
overflow:
	li $v0, 4
	la $a0, overflow_message
	syscall
	j exit

# subroutine that reads input
# and stores it in $v0
read_input:
	# prints input message
	li $v0, 4
	la $a0, input_message
	syscall 
	# reads integer
	li $v0, 5
	syscall
	# returns
	jr $ra

# program endpoint
exit:
	li $v0, 10
	syscall
