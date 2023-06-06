.data
  array_size_prompt: .asciiz "Enter the size of the array: "
  array_element_prompt: .asciiz "Enter the array element element: "
  array_print_message: .asciiz "The array elements are: "

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
  li $t1, $s1
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
  la $a0, array_print_message
  syscall

  li $t0, 0
  li $t1, $s1
  print_array_loop:
    bge $t0, $s0, print_array_loop_end
    lw $a0, ($t1)
    li $v0, 1
    syscall

    li $v0, 11
    li $a0, ' '
    syscall

    addi $t0, $t0, 1
    addi $t1, $t1, 4
    j print_array_loop
  print_array_loop_end:

  # jumping to exit
  j exit

# bubble sort procedure
# accepts array address in $a0
# and array size in $a1
bubble_sort:
  # create a stack frame

# program endpoint
exit:
  li $v0, 10
  syscall