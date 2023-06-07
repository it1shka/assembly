.data
  array_size_prompt: .asciiz "Enter the size of the array: "
  array_element_prompt: .asciiz "Enter the array element element: "
  array_print_message: .asciiz "The array elements are: "
  illegal_array_size_message: .asciiz "The array size should be positive."
  unsorted_array_message: .asciiz "The unsorted array is:\n"
  sorted_array_message: .asciiz "The sorted array is:\n"

.text
main:
  # reading array size
  # and storing it in $s0
  li $v0, 4
  la $a0, array_size_prompt
  syscall

  li $v0, 5
  syscall
  move $s0, $v0
  
  # if array size <= 0, exit
  blez $s0, illegal_array_size

  # allocating memory for array
  # and storing the address in $s1
  li $v0, 9
  move $a0, $s0
  sll $a0, $a0, 2
  syscall
  move $s1, $v0

  # reading array elements
  # and storing them in the array
  li $t0, 0
  move $t1, $s1
  read_array_loop:
    bge $t0, $s0, read_array_loop_end
    li $v0, 4
    la $a0, array_element_prompt
    syscall

    li $v0, 5
    syscall
    sw $v0, ($t1)

    addi $t0, $t0, 1
    addi $t1, $t1, 4
    j read_array_loop
  read_array_loop_end:

  # printing the array
  li $v0, 4
  la $a0, unsorted_array_message
  syscall
  move $a0, $s1
  move $a1, $s0
  jal print_array

  # sorting the array
  move $a0, $s1
  move $a1, $s0
  jal bubble_sort

  # printing a sorted array
  li $v0, 4
  la $a0, sorted_array_message
  syscall
  move $a0, $s1
  move $a1, $s0
  jal print_array

  # jumping to exit
  j exit

# bubble sort procedure
# accepts array address in $a0
# and array size in $a1
bubble_sort:
  # popping out values on a stack
  addi $sp, $sp, -12
  sw $ra, 8($sp)
  sw $a0, 4($sp)
  sw $a1, 0($sp)

  # outer loop 
  # $t0 -- counter, $t1 -- outer loop limit
  li $t0, 0
  lw $t1, 0($sp)
  sub $t1, $t1, 1
  outer_loop:
    bge $t0, $t1, outer_loop_end

    # inner loop
    li $t2, 0
    sub $t3, $t1, $t0
    inner_loop:
      bge $t2, $t3, inner_loop_end

      # performing maybe swap
      lw $a0, 4($sp)
      move $a1, $t2
      add $a2, $t2, 1
      jal maybe_swap

      addi $t2, $t2, 1
      j inner_loop
    inner_loop_end:

    addi $t0, $t0, 1
    j outer_loop
  outer_loop_end:

  # restoring values from stack and returning
  lw $ra, 8($sp)
  addi $sp, $sp, 12
  jr $ra
 
# procedure that swaps two elements
# if first > second
# accepts array address in $a0
# accepts i in $a1
# accepts j in $a2
maybe_swap:
	# popping values on our stack
	addi $sp, $sp, -16
	sw $ra, 12($sp)
	sw $a0, 8($sp)
	sw $a1, 4($sp)
	sw $a2, 0($sp)
	
	# performing maybe swap
	lw $t4, 8($sp)
	
	# $t5 -- array + i
	# $t6 -- array[i]
	lw $t5, 4($sp)
	sll $t5, $t5, 2
	add $t5, $t5, $t4
	lw $t6, ($t5)
	
	# $t7 -- array + j
	# $t8 -- array[j]
	lw $t7, 0($sp)
	sll $t7, $t7, 2
	add $t7, $t7, $t4
	lw $t8, ($t7)
	
	bge $t8, $t6, else_branch
		sw $t6, ($t7)
		sw $t8, ($t5)
	else_branch:
	
	# restoring a stack and returning
	lw $ra, 12($sp)
	addi $sp, $sp, 16
	jr $ra

# procedure for printing an array
# accepts array address in $a0
# and array size in $a1
print_array:
  # popping out values on a stack
  addi $sp, $sp, -12
  sw $ra, 8($sp)
  sw $a0, 4($sp)
  sw $a1, 0($sp)

  # printing array elements
  li $t0, 0
  lw $t1, 0($sp)
  print_array_loop:
    bge $t0, $t1, print_array_loop_end
    lw $a0, 4($sp)
    sll $t2, $t0, 2
    add $a0, $a0, $t2
    lw $a0, ($a0)
    li $v0, 1
    syscall

    li $v0, 11
    li $a0, ' '
    syscall

    addi $t0, $t0, 1
    j print_array_loop
  print_array_loop_end:

  # printing a new line
  li $v0, 11
  li $a0, '\n'
  syscall

  # restoring values from stack and returning
  lw $ra, 8($sp)
  addi $sp, $sp, 12
  jr $ra

# if the size is <= 0, break
illegal_array_size:
	li $v0, 4
	la $a0, illegal_array_size_message
	syscall
	j exit

# program endpoint
exit:
  li $v0, 10
  syscall
