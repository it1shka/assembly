# defining constants
.data
	vector_size_message: .asciiz "Please, enter vector size: "
	invalid_size_message: .asciiz "Vector size is invalid (it should be greater than 0)"
	element_prompt_message_start: .asciiz "Please, enter element "
	element_prompt_message_end: .asciiz ": "
	first_vector_message: .asciiz "Now, enter the first vector: \n"
	second_vector_message: .asciiz "Let's enter the second vector: \n"
	first_transformed_vectors_message: .asciiz "First order and value vectors: \n"
	second_transformed_vectors_message: .asciiz "Second order and value vectors: \n"
	
.text
main:
	# reading vector size
	jal read_vector_size
	# saving it in $s0
	move $s0, $v0
	# just adding a new line
	jal new_line
	# if vector input is less than 0, exit
	blez $s0, invalid_vector_size
	
	# entering the first vector
	move $a0, $s0
	la $a1, first_vector_message
	jal read_vector
	move $s1, $v0
	
	# printing the first vector
	move $a0, $s1
	move $a1, $s0
	jal print_array
	jal new_line
	
	# entering the second vector
	move $a0, $s0
	la $a1, second_vector_message
	jal read_vector
	move $s2, $v0
	
	# printing the second vector
	move $a0, $s2
	move $a1, $s0
	jal print_array
	jal new_line
	
	# new line 
	jal new_line
	
	# now after we have read the vectors,
	# time to transform them and to compute
	# a dot product
	
	# allocating four arrays:
	# $s3, $s5 -- order vectors
	# $s4, $s6 -- value vectors
	move $a0, $s0
	jal allocate_array
	move $s3, $v0 # $s3
	move $a0, $s0
	jal allocate_array
	move $s4, $v0 # $s4
	move $a0, $s0
	jal allocate_array
	move $s5, $v0 # $s5
	move $a0, $s0
	jal allocate_array
	move $s6, $v0 # $s6
	
	# transforming ($s3, $s4), ($s5, $s6)
	move $a0, $s0
	move $a1, $s1
	move $a2, $s3
	move $a3, $s4
	jal transform_vector
	
	move $a0, $s0 # we can remove it, but ok
	move $a1, $s2
	move $a2, $s5
	move $a3, $s6
	jal transform_vector
	
	# let's print our transformed vectors for the first
	li $v0, 4
	la $a0, first_transformed_vectors_message
	syscall
	move $a0, $s3
	move $a1, $s0
	jal print_array
	jal new_line
	move $a0, $s4
	move $a1, $s0
	jal print_array
	jal new_line

	# let's print our transformed vectors for the second
	li $v0, 4
	la $a0, second_transformed_vectors_message
	syscall
	
	move $a0, $s5
	move $a1, $s0
	jal print_array
	jal new_line
	move $a0, $s6
	move $a1, $s0
	jal print_array
	jal new_line
	
	# jumping to the program endpoint
	j exit
	
# case when vector size in invalid
invalid_vector_size:
	# printing message
	li $v0, 4
	la $a0, invalid_size_message
	syscall
	# jumping to the exit
	j exit

# subroutine for transforming original vector
# into order vector and value vector
# $a0: vector size
# $a1: original vector address
# $a2: order vector address
# $a3: value vector address
transform_vector:
	# loop counter
	li $t0, 0
	# insert index for value vector
	li $t1, 0
	transform_loop:
		bge $t0, $a0, transform_loop_end
		# $t2: general vector offset
		sll $t2, $t0, 2
		# $t3: current original vector address
		add $t3, $a1, $t2
		
		# $t4: original vector value at current index
		lw $t4, ($t3)
		beqz $t4, transform_loop_tail
		
		# setting current at order vector to 1
		add $t3, $a2, $t2
		li $t5, 1
		sw $t5, ($t3)
		
		# setting current at value vector to $t4
		add $t3, $a3, $t1
		sw $t4, ($t3)
		add $t1, $t1, 4 
		
		transform_loop_tail:
		addiu $t0, $t0, 1
		j transform_loop
	transform_loop_end:
	
	# return back
	jr $ra

# subroutine for reading a vector
# $a0: vector size
# $a1: prompt message
# $v0: vector address
read_vector:
	# saving vector size in $t0
	move $t0, $a0
	# allocating space for a vector
	sll $a0, $a0, 2
	li $v0, 9
	syscall
	# saving original address in $t7
	move $t7, $v0
	# printing a vector message
	li $v0, 4
	move $a0, $a1
	syscall
	# fill the vector in a loop
	li $t1, 0
	move $t2, $t7
	read_vector_loop:
		bge $t1, $t0, read_vector_loop_end
		# printing prompt message
		li $v0, 4
		la $a0, element_prompt_message_start
		syscall
		li $v0, 1
		move $a0, $t1
		syscall
		li $v0, 4
		la $a0, element_prompt_message_end
		syscall
		# reading integer from console
		li $v0, 5
		syscall
		# storing it in array
		sw $v0, ($t2)		
		# loop counter increase
		addiu $t1, $t1, 1
		addiu $t2, $t2, 4
		j read_vector_loop
	read_vector_loop_end:
	# return back
	move $v0, $t7
	jr $ra

# subroutine for reading vector size
# $t0: vector size
read_vector_size:
	# printing the prompt message
	li $v0, 4
	la $a0, vector_size_message
	syscall
	# reading integer
	li $v0, 5
	syscall
	# returning back
	jr $ra

# subroutine for array allocation
# allocated array contains zeroes
# $a0: size of array to be allocated
# $v0: return address of array
allocate_array:
	# saving array size for later use in a loop
	move $t0, $a0
	# allocating array of $a0 * 4 size
	li $v0, 9
	sll $a0, $a0, 2
	syscall
	# filling the array with zeroes
	li $t1, 0
	move $t2, $v0
	allocate_array_loop:
		bge	$t1, $t0, allocate_array_loop_end
		sw $zero, ($t2)
		# increasing address by one word (4 bytes) 
		# and counter by one
		addiu $t2, $t2, 4
		addiu $t1, $t1, 1
		j allocate_array_loop
	allocate_array_loop_end:
	# returning back
	jr $ra
	
# subroutine for array printing
# $a0: array address
# $a1: array size
print_array:
	li $t0, 0
	move $t1, $a0
	print_array_loop:
		bge $t0, $a1, print_array_loop_end
		# printing current integer
		li $v0, 1
		lw $a0, ($t1)
		syscall
		# printing space
		li $v0, 11
		li $a0, ' '
		syscall
		# increasing address by one word (4 bytes) 
		# and counter by one
		addiu $t1, $t1, 4
		addiu $t0, $t0, 1
		j print_array_loop
	print_array_loop_end:
	# returning back
	jr $ra

# small subroutine for printing a new line
new_line:
	li $v0, 11
	li $a0, '\n'
	syscall
	jr $ra

# exiting the program
exit:
	li $v0, 10
	syscall
