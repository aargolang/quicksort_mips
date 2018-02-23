.data

arr: .word 10,2,17,9,6,4,8

.text

main:
# ------------------------- main()
#
# s0 -> A = address of arr[]
# s1 -> low = starting index
# s2 -> high = ending index

la $s0, arr			# A = &arr[]
li $s1, 0			# low = 0
li $s2, 6			# high = 6
addi $sp, $sp, -4
sw $s0, 0($sp)

move $a0, $s0			# call quickSort(A, low, high)
move $a1, $s1			#
move $a2, $s2			#
jal QUICKSORT			#

la $a0, arr			# A = &arr[]
la $s0, 0($a0)			# A = &arr[]
move $a0, $s0			# call printarr(A)
lw $s0, 0($sp)
jal PRINTARR			# 

li $v0, 10			# end program
syscall				# end program

QUICKSORT:
# ------------------------- quickSort(A,low,high)
# a0=A, a1=low, a2=high
#
# s0 = pi
# 
bge $a1, $a2, DONTSORT

addi $sp, $sp, -20		# store s0 and aarguments
sw $s0, 0($sp)			#
sw $a0, 4($sp)			#
sw $a1, 8($sp)			#
sw $a2, 12($sp)			#
sw $ra, 16($sp)			#

jal PARTITION			# pi = partition(A,low,high)
move $s0, $v0			#  

move $a2, $s0			# call quickSort(A, low, pi)
jal QUICKSORT			#

lw $a0, 4($sp)			# load address of A into arg1
lw $a2, 12($sp)			# call quickSort(A, pi+1, high)
addi $a1, $s0, 1		#
jal QUICKSORT			#

lw $s0, 0($sp)			# recover all aguments and return address
lw $a0, 4($sp)			#
lw $a1, 8($sp)			#
lw $a2, 12($sp)			#
lw $ra, 16($sp)			#	
addi $sp, $sp, 20		# 

DONTSORT:

jr $ra

PARTITION:
# ------------------------- partition(A, low, high)
# 
# a0=A, a1=low, a2=high
#
# s0 -> pivot
# s1 -> i
# s2 -> j
# s3 -> &A[i]
# s4 -> &A[j]
# s5 -> A[i]
# s6 -> A[j]
# t0 -> t (temp)
# t1 -> swap1
# t2 -> swap2

addi $sp, $sp, -16		# store previously used values onto stack
sw $s0, 0($sp)			# 
sw $s1, 4($sp)			# 
sw $s2, 8($sp)			# 
sw $s3, 12($sp)			# 

sll $t0, $a1, 2			# t = 4*lo
add $t0, $t0, $a0		# t = t + A = &A[lo]
lw $s0, 0($t0)			# pivot = A[lo]

addi $s1, $a1, -1		# i = lo - 1
addi $s2, $a2, 1		# j = hi + 1
LOOP:
  DO1:
    addi $s1, $s1, 1		# i++
    sll $t0, $s1, 2		# t = 4*i
    add $s3, $t0, $a0 		# s3 = &A[i]
    lw $s5, 0($s3)		# s5 = A[i]
    bge $s5, $s0, EXITDO1	# while(A[i] < pivot)
    j DO1
  EXITDO1:

  DO2:
    addi $s2, $s2, -1		# j--
    sll $t0, $s2, 2		# t = 4*j
    add $s4, $t0, $a0 		# s3 = &A[j]
    lw $s6, 0($s4)		# s6 = A[j]
    ble $s6, $s0, EXITDO2	# while(A[j] > pivot)
    j DO2
  EXITDO2:
	
  blt $s1, $s2, NOEXITFORYOU
    move $v0, $s2		# returnvalue = j
    lw $s0, 0($sp)		# 
    lw $s1, 4($sp)		# 
    lw $s2, 8($sp)		# 
    lw $s3, 12($sp)		# 
    addi $sp, $sp, 16		# store previously used values onto stack
    jr $ra			# return j
  NOEXITFORYOU:

  # dont know if the next 4 lines are needed
  #sll $t0, $s1, 2		# t = 4*i
  #add $s3, $t0, $a0 		# s3 = &A[i]  
  #sll $t0, $s2, 2		# t = 4*j
  #add $s4, $t0, $a0 		# s3 = &A[j]
  
  lw $t1, 0($s3)		# sawp A[j] and A[i]
  lw $t2, 0($s4)		# 
  sw $t1, 0($s4)		# 
  sw $t2, 0($s3)		#

j LOOP
	

PRINTARR:
# ------------------------- printArr(A)
#
# s0 -> array[]
# s1 -> array[i]
# s2 -> *array[i]
# s3 -> i

addi $sp, $sp, -16		# save everything
sw $s0, 0($sp)			#
sw $s1, 4($sp)			#
sw $s2, 8($sp)			#
sw $s3, 12($sp)			#

li $s3, 0			# i = 0
la $s0, 0($a0)			# S0 = argument1

WHILE:
bgt $s3, 6, ENDWHILE		# if (i > 6), end while
sll $s1, $s3, 2			# array[i] = 4*i
add $s1, $s1, $s0		# array[i] = s1 + addressof array
lw $s2, 0($s1)			# s2 = value of array[i]

move $a0, $s2			# print *array[i]
li $v0, 1			#
syscall				#
li $a0, 32			# print space
li $v0, 11			#
syscall				#

addi $s3, $s3, 1		# i++

j WHILE
ENDWHILE:

li $a0, '\n'			# print newline
li $v0, 11			#
syscall	

sw $s0, 0($sp)			# recover everything
sw $s1, 4($sp)			#
sw $s2, 8($sp)			#
sw $s3, 12($sp)			#
addi $sp, $sp, 16		#
	
jr $ra