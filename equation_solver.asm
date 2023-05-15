# this program will solve a quadratic equation of the form
# Ax^2 + Bx + C = 0 where
# A, B, C are floating point numbers

# declaring our constants
.data
	instruction_message: .asciiz "Now you will be asked to enter coefficients of Ax^2 + Bx + C = 0: "
	prompt_message: .asciiz "Please, enter a float: "
	negative_discriminant_message: .asciiz "Discriminant is negative, no real roots"
	root_message: .asciiz "The root is: "
	four_float: .float 4.0
	two_float: .float 2.0
	zero_float: .float 0.0
	
# program code
.text
main:
	# printing instruction
	li $v0, 4
	la $a0, instruction_message
	syscall
	jal new_line
	
	# saving A, B, C
	# in $f1, $f2, $f3 registers of Coproc 1
	jal  read_input
	mov.s $f1, $f0
	jal read_input
	mov.s $f2, $f0
	jal read_input
	mov.s $f3, $f0
	
	# now, we can proceed with 
	# actual calculations having in mind that
	
	# A = $f1  B = $f2  C = $f3 
	
	# D = b^2 - 4ac or in our case 
	# $t4 = $f2 ^ 2 - 4 * $f1 * $f3
	
	mul.s $f4, $f2, $f2
	mul.s $f5, $f1, $f3
	lwc1 $f6, four_float
	mul.s $f5, $f5, $f6
	sub.s $f4, $f4, $f5
	
	# now discriminant is in $f4
	
	# we need to check if discriminant is negative
	lwc1 $f5, zero_float
	c.lt.s $f4, $f5
	bc1t negative_discriminant_case
	
	# x = (-B +- sqrt(D)) / 2A
	neg.s $f2, $f2
	sqrt.s $f4, $f4
	lwc1 $f5, two_float
	mul.s $f1, $f1, $f5
	
	# $f1 = 2A  $f2 = -B  $f4 = sqrt(D)
	
	# finding the first root
	add.s $f5, $f2, $f4
	div.s $f5, $f5, $f1
	
	# finding the second root
	sub.s $f6, $f2, $f4
	div.s $f6, $f6, $f1
	
	# printing roots
	mov.s $f12, $f5
	jal print_root
	mov.s $f12, $f6
	jal print_root
	
	# end of execution
	j exit

# label for jump if D is negative
negative_discriminant_case:
	li $v0, 4
	la $a0, negative_discriminant_message
	syscall
	j exit

# subroutine for prompting user
# saves floating input number into $f0
read_input:
	li $v0, 4
	la $a0, prompt_message
	syscall
	
	li $v0, 6
	syscall
	jr $ra

# subroutine for printing root
# root is located in $f12
print_root:
	li $v0, 4
	la $a0, root_message
	syscall
	
	li $v0, 2
	syscall
	
	add $t0, $ra, $zero
	jal new_line
	jr $t0

# subroutine for printing new line
new_line:
	li $v0, 11
	li $a0, '\n'
	syscall
	jr $ra

# program endpoint
exit:
	li $v0, 10
	syscall
	