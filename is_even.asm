# program determines
# whether the input number is even or odd

# here I declare constant string literals
.data
	user_prompt: .asciiz "Please, enter an integer: "
	is_even_message: .asciiz "The number is even"
	is_odd_message: .asciiz "The number is odd"

# declaring entry point to our program
.text
	.globl main

main:
	# reading input from the user
	# and storing it in $v0
	jal read_input
	
	# storing remainder of input by 2 in $t0
	# $t0 = $v0 mod 2
	rem $t0, $v0, 2
	
	# if remainder is 0, 
	# then the number is even
	beqz $t0, even_case
	
	# else the number is odd
	la $a0, is_odd_message
	li $v0, 4
	syscall
	j exit

# special label for if the number is even
even_case:
	la $a0, is_even_message
	li $v0, 4
	syscall
	j exit
	
# declaring subroutine for user input
read_input:
	li $v0, 4
	la $a0, user_prompt
	syscall
	li $v0, 5
	syscall
	jr $ra

# label used to exit the program
exit:
	li $v0, 10
	syscall
