# checked variant of factorial
# if overflow occures, prints overflow message

.data
	input_message: .asciiz "Please, enter an integer: "
	output_message: .asciiz "The factorial is: "
	invalid_input_message: .asciiz "Input is non-positive, factorial is 1"
	overflow_message: .asciiz "Overflow occured. "

.text
main:
	# reading user input
	# now it is located in $v0
	jal input
	
	# validationg inpput: if less than 0, exit
	ble $v0, 0, invalid_input
	
	# $t0 is loop counter (int i = 0)
	li $t0, 0
	# $t1 is current factorial value
	li $t1, 1
	# $t2 is loop limit (user input); $t2 = $v0
	move $t2, $v0
	
loop:
	# we multiply without checking overflow
	# $t1 *= ($t0 + 1)
	add $t3, $t0, 1
	mul $t1, $t1, $t3
	
	# now we are trying to detect an overflow
	mfhi $t3
	bnez $t3, overflow
	
	# increase the counter and repeat loop
	# if counter is not limit
	add $t0, $t0, 1
	bne $t0, $t2, loop
	
	# now, factorial is in $t1
	# let's print the answer
	move $a1, $t1
	j output

input:
	# printing input message
	li $v0, 4
	la $a0, input_message
	syscall
	# reading integer (now it's located in $v0)
	li $v0, 5
	syscall
	jr $ra

output:
	# printing output message
	li $v0, 4
	la $a0, output_message
	syscall
	# printing integer (integer is in $a1)
	li $v0, 1
	move $a0, $a1
	syscall
	# exiting
	j exit

invalid_input:
	# printing that input is invalid
	li $v0, 4
	la $a0, invalid_input_message
	syscall
	# exiting
	j exit

overflow:
	# printing overflow message
	li $v0, 4
	la $a0, overflow_message
	syscall
	# exiting
	j exit

exit:
	li $v0, 10
	syscall