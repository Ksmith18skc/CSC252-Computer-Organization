# Author: Kory Smith

.data
TEST_MSG:  .asciiz "this is a test \n"
NL: 		.asciiz "\n"
SPACE: 			.asciiz " "
PERIOD:			.asciiz ".\n"
EXCLAMATION: 		.asciiz "!\n"
bottleMSG1:		.asciiz " bottles of "
bottleMSG2: 		.asciiz " on the wall, "
bottleMSG3: 		.asciiz "Take one down, pass it around, "
bottleMSG4:		.asciiz " on the wall"
bottleMSGend: 		.asciiz "No more bottles of "

.text 
.globl strlen
.globl bottles
.globl gcf
.globl longestSorted
.globl rotate


#     	This function calculates the length of a null-terminated string.
#	The function reads characters sequentially from the memory location
#       pointed to by $a0 until it encounters a null terminator ('\0').
#     	- It maintains a count of characters read and returns this count.
#     	- The address of the string is given directly as an argument
strlen:
	addiu	$sp, $sp, -24		# create stack space
	sw 	$ra, 4($sp) 		# save frame pointer
	sw 	$fp, 0($sp)		# save return address
	addiu 	$fp, $sp, 20		# change frame pointer
	
	addi 	$v0, $zero, 0 		# v0 = count
	add 	$t1, $zero, $a0		# t1 = string
	
loop_strlen:
	lb 	$t0, 0($t1) 		# t0 = str[i]
	beq	$t0, $zero, end_strlen 	# if (str[i] = null)
	addi 	$t1, $t1, 1		# add 1 to pointer of str
	addi 	$v0, $v0, 1		# count ++ 
	
	j loop_strlen			# jump back to loop
		
end_strlen:
	lw 	$fp, 0($sp)		# load old return address
	lw 	$ra, 4($sp)		# load old frame pointer
	addiu 	$sp, $sp, 24		# change stack pointer
	jr 	$ra			# return 
	
 	
#     	This function calculates the Greatest Common Factor (GCF) of two integers
#     	using a recursive algorithm.
#     	- The function first swaps the values of a and b if a is less than b.
#     	- If b is equal to 1, the function returns 1 (base case for recursion).
#     	- If a is divisible by b (a % b == 0), then b is the GCF and is returned.
#     	- Otherwise, the function recursively calls itself with arguments b and a % b
gcf:
	addiu	$sp, $sp, -24		# create stack space
	sw 	$ra, 4($sp) 		# save frame pointer
	sw 	$fp, 0($sp)		# save return address
	addiu 	$fp, $sp, 20		# change frame pointer
	
	# Store values for arguments
	add 	$t0, $zero, $a0		# t0 = int a
	add 	$t1, $zero, $a1		# t1 = int b
	
gcf_if1:
	slt 	$t2, $t0, $t1		# t2 = (a < b)
	beq 	$t2, $zero, gcf_if2	# if (a >= b) try second if
	
	add 	$t2, $zero, $t0 		# t2 = a
	add 	$t0, $zero, $t1		# a = b
	add 	$t1, $zero, $t2		# b = a
	
gcf_if2:
	addi 	$t2, $zero, 1		# t2 = 1
	bne 	$t1, $t2, gcf_if3 	# if (b != 1) try third ii 
	
	addi	$v0, $zero, 1		# retVal = 1
	j 	gcf_Epil			# return 1
	
gcf_if3:
	
	div 	$t0, $t1			# hi/lo a/b
	mfhi	$t2 			# t2 = a % b 
	bne 	$t2, $zero, gcf_else	# if (a % b != 0) do else 
	
	add	$v0, $zero, $t1		# retVal = b
	j 	gcf_Epil			# return b 
	
gcf_else:
	div 	$t0, $t1			# hi/lo a/b
	mfhi	$t2			# t0 = a % b 
	
	add 	$a0, $zero, $t1		# a = b
	add 	$a1, $zero, $t2 		# b = a % b 
	jal 	gcf
	
gcf_Epil:
	lw 	$fp, 0($sp)		# load old return address
	lw 	$ra, 4($sp)		# load old frame pointer
	addiu 	$sp, $sp, 24		# change stack pointer
	jr	$ra
	
		
#     	This function simulates the lyrics of the "99 Bottles of Beer" song for a given
#     	count of bottles and a specified item.
#     	- The function uses a loop to iterate from the given count down to 1, printing
#       the lyrics for each iteration.
#     	- It then prints a final message when there are no more bottles left.
bottles:
	addiu	$sp, $sp, -24		# create stack space
	sw 	$ra, 4($sp) 		# save frame pointer
	sw 	$fp, 0($sp)		# save return address
	addiu 	$fp, $sp, 20		# change frame pointer
	
	add 	$t4, $zero, $a0 		# t4 = count
	add 	$t5, $zero, $a1		# t5 = drink 
	add 	$t0, $zero, $a0 		# i = count 
	
loop_bottles:
	slt 	$t1, $zero, $t0 		# 0 < i
	addi 	$t2, $zero, 1		# t2 = 1 
	bne 	$t1, $t2, zero_bottles	# if ( i < 0 ) exit for loop
	
	addi 	$v0, $zero, 1		# print_int
	add 	$a0, $zero, $t0	 	# print_int(i)
	syscall
	
	addi 	$v0, $zero, 4		# print_str
	la 	$a0, bottleMSG1 	# print_str(bottleMSG1)
	syscall
	
	addi 	$v0, $zero, 4		# print_str
	add 	$a0, $zero, $t5		# print_str(drink)
	syscall
	
	addi 	$v0, $zero, 4		# print_str
	la 	$a0, bottleMSG2 	# print_str(bottleMSG2)
	syscall
	
	addi 	$v0, $zero, 1		# print_int
	add 	$a0, $zero, $t0	 	# print_int(i)
	syscall
	
	addi 	$v0, $zero, 4		# print_str
	la 	$a0, bottleMSG1 	# print_str(bottleMSG1)
	syscall
	
	addi 	$v0, $zero, 4		# print_str
	add 	$a0, $zero, $t5		# print_str(drink)
	syscall
	
	addi 	$v0, $zero, 4		# print_str
	la 	$a0, EXCLAMATION 	# print_str("!\n")
	syscall
	
	addi 	$v0, $zero, 4		# print_str
	la 	$a0, bottleMSG3 	# print_str(bottleMSG3)
	syscall
	
	sub 	$t0, $t0, $t2 		# i --
	
	addi 	$v0, $zero, 1		# print_int
	add 	$a0, $zero, $t0	 	# print_int(i)
	syscall
	
	addi 	$v0, $zero, 4		# print_str
	la 	$a0, bottleMSG1 	# print_str(bottleMSG1)
	syscall
	
	addi 	$v0, $zero, 4		# print_str
	add 	$a0, $zero, $t5		# print_str(drink)
	syscall
	
	addi 	$v0, $zero, 4		# print_str
	la 	$a0, bottleMSG4 	# print_str(bottlesFouth)
	syscall
	
	addi 	$v0, $zero, 4		# print_str
	la 	$a0, PERIOD	 	# print_str(".\n")
	syscall
	
	addi 	$v0, $zero, 4		# print_str
	la 	$a0, NL	 	# print_str("\n")
	syscall
	
	beq 	$t0, $zero, zero_bottles # if i = 0, exit loop
	j loop_bottles
	
zero_bottles: 
	addi 	$v0, $zero, 4 		# print_str()
	la 	$a0, bottleMSGend		# print_str(No more..)
	syscall 
	
	addi 	$v0, $zero, 4		# print_str()
	add 	$a0, $zero, $t5 		# print_str(drink)
	syscall
	
	addi 	$v0, $zero, 4 		# print_str()
	la 	$a0, bottleMSG4	# print_str(" on the wall")
	syscall
	
	addi 	$v0, $zero, 4 		# print_str()
	la 	$a0, EXCLAMATION		# print_str("!\n")
	syscall
	
	addi 	$v0, $zero, 4 		# print_str()
	la 	$a0, NL		# print_str("\n")
	syscall
	
	
	lw 	$fp, 0($sp)		# load old return address
	lw 	$ra, 4($sp)		# load old frame pointer
	addiu 	$sp, $sp, 24		# change stack pointer
	jr	$ra			# END BOTTLES
	
	
#     	This function calculates the length of the longest sorted run (ascending)
#     	in an array of integers.
#     	- The function scans through the array to find the longest sorted run.
#     	- It only checks for ascending sequences.
#     	- If the array is empty, the function returns 0.
#     	- If the array is not empty, the smallest possible return value is 1.
longestSorted:
	addiu	$sp, $sp, -24		# create stack space
	sw 	$ra, 4($sp) 		# save frame pointer
	sw 	$fp, 0($sp)		# save return address
	addiu 	$fp, $sp, 20		# change frame pointer
	
	# Save sX registers here.
	addiu 	$sp, $sp, -32			
	sw 	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw 	$s2, 8($sp)
	sw 	$s3, 12($sp)
	sw 	$s4, 16($sp)
	sw 	$s5, 20($sp)
	sw	$s6, 24($sp)
	sw	$s7, 28($sp)
	
	add 	$t0, $zero, $a0
	add 	$s0, $zero, $a0		# s0 = int[] array
	add	$s1, $a1, $zero 		# s1 = array.length()
	
sortedCheck1:
	bne  	$s1, $zero, sortedCheck2	# if (length != 0) jump to first
	add 	$v0, $zero, $zero	# retval = 0
	j 	sorted_Epil
	
sortedCheck2: 
	addi	$t2, $zero, 1		# t2 = 1
	bne 	$s1, $t2, sortedRule	# if (length != 1) go to sortedRule
	addi	$v0, $zero, 1		# retval = 1
	j 	sorted_Epil
	
sortedRule:
	addi 	$s2, $zero, 1	 	# s2 = count = 1
	addi 	$s3, $zero, 1		# s3 = longest = 1
	
	add 	$s4, $zero, $zero 	# s4 = i = 0
	
sortedLoop:

	addi 	$t1, $s1, -1		# t1 = length - 1
	slt 	$t0, $s4, $t1		# t0 = (i < length - 1)
	beq 	$t0, $zero, retLongest	# if (false) return longest
	
	addi 	$t0, $s4, 1		# t0 = i + 1
	addi 	$t2, $zero, 4 		# t2 = 4
	
	mult 	$t0, $t2 		# (i + 1) * 4
	mflo	$t0 			# t0 = (i - 1) * 4
	
	mult 	$s4, $t2			# (i) * 4
	mflo 	$t1 			# t1 = (i) * 4
	
	add 	$t0, $s0, $t0 		# t0 = &a[i+1]
	add 	$t1, $s0, $t1 		# t1 = &a[i]
	
	lw	$t2, 0($t0)		# t2 = array[i + 1]
	lw 	$t3, 0($t1) 		# t3 = array[i]
	
	slt 	$t4, $t2, $t3 		# t4 = (a[i + 1]) < a[i])
	addi 	$t5, $zero, 1		# t5 = 1
	beq 	$t4, $t5, keepSortedLoop	# if (true) 
	
	addi 	$s2, $s2, 1		# count ++
	
	slt 	$t4, $s3, $s2 		# t4 = (max < count)
	beq 	$t4, $zero, sortedElse 	# if (false)
	add	$s3, $s2, $zero 		# longest = count
	
	j 	keepSortedLoop
	
sortedElse: 
	addi 	$s2, $zero, 1		# count = 1
	
keepSortedLoop:
	addi	$s4, $s4, 1		# i ++
	j 	sortedLoop	
	
retLongest:
	add 	$v0, $zero, $s3 
	j 	sorted_Epil
	
	
sorted_Epil:
	
	# Load s0, s1, s2, s3 registers back.
	lw	$s7, 28($sp)
	lw 	$s6, 24($sp)
	lw	$s5, 20($sp)
	lw 	$s4, 16($sp)
	lw 	$s3, 12($sp)
	lw 	$s2, 8($sp)
	lw	$s1, 4($sp)
	lw 	$s0, 0($sp)
	addiu 	$sp, $sp, 32
	
	lw 	$fp, 0($sp)		# load old return address
	lw 	$ra, 4($sp)		# load old frame pointer
	addiu 	$sp, $sp, 24		# change stack pointer
	jr	$ra
	

#     	This function rotates a set of six integers a specified number of times
#     	and calculates a return value based on the result of a utility function.
#     	- The function uses a loop to rotate the six integers the specified number
#       of times.
#     	- It calls a utility function `util` with the rotated integers and adds the
#       return value of `util` to `retval`.
#     	- After each rotation, the integers are shifted such that a becomes b, b becomes
#       c, and so on, with f becoming the original value of a.
rotate:
	addiu	$sp, $sp, -28		# create stack space
	sw 	$ra, 4($sp) 		# save frame pointer
	sw 	$fp, 0($sp)		# save return address
	addiu 	$fp, $sp, 24		# change frame pointer
	
	lw 	$t4, 16($sp)		# t4 = d
	lw 	$t5, 20($sp)		# t5 = e
	lw 	$t6, 24($sp)		# t6 = f
	
	# Save sX registers here.
	addiu 	$sp, $sp, -32			
	sw 	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw 	$s2, 8($sp)
	sw 	$s3, 12($sp)
	sw 	$s4, 16($sp)
	sw 	$s5, 20($sp)
	sw	$s6, 24($sp)
	sw	$s7, 28($sp)
	
	# Now we can sRegisters use them. 
	add 	$s1, $zero, $a1		# s1 = a
	add 	$s2, $zero, $a2		# s2 = b
	add 	$s3, $zero, $a3		# s3 = c
	add	$s4, $zero, $t4		# s4 = d
	add 	$s5, $zero, $t5 		# s5 = e
	add 	$s6, $zero, $t6		# s6 = f
	
	# Initialize/Store returnVal, i, and count
	add 	$s0, $zero, $zero	# s0 = retVal
	add 	$t0, $zero, $zero	# i = 0
	add 	$s7, $zero, $a0 		# s7 = count
	
	# Start of for-loop until i >= count
rotateLoop:
	addi 	$t1, $zero, 1		# t1 = 1
	slt	$t3, $t0, $s7		# t3 = (i < count)
	bne 	$t3, $t1, rotate_Epil 	# if (i > count) exit for
	
	# Create new args for util()
	add 	$a0, $zero, $s1		# a0 = a
	add 	$a1, $zero, $s2		# a1 = b
	add 	$a2, $zero, $s3		# a2 = c
	add 	$a3, $zero, $s4		# a3 = d
	
	# Store last two params. 
	sw      $s5, -8($sp)		# param e
	sw      $s6, -4($sp)		# param f
	
	# Save tX Register in sX Register
	add	$s5, $zero, $t0		# s5 = $t0
	
	jal 	util
	add 	$s0, $s0, $v0 		# retval += util(a, b, c, d, e, f)
	
	# Get tX Register back
	add 	$t0, $zero, $s5
	
	# Get sX Registers back
	lw 	$s6, -4($sp)		# s6 = f
	lw 	$s5, -8($sp) 		# s5 = e
	
	# Swap all values
	add 	$t1, $zero, $s1		# t1 = a
	add	$s1, $zero, $s2		# a = b
	add 	$s2, $zero, $s3		# b = c
	add	$s3, $zero, $s4		# c = d
	add	$s4, $zero, $s5		# d = e
	add 	$s5, $zero, $s6		# e = f
	add 	$s6, $zero, $t1 		# f = temp
	
	addi 	$t0, $t0, 1		# i ++  
	j 	rotateLoop
	
	# Here after i >= count 
rotate_Epil:
	add	$v0, $zero, $s0 		# v0 = retVal
	
	# Store d, e, f back onto stack
	lw 	$s3, 16($sp)
	lw 	$s2, 20($sp)
	lw 	$s1, 24($sp)
	
	# Load s0, s1, s2, s3 registers back.
	lw	$s7, 28($sp)
	lw 	$s6, 24($sp)
	lw	$s5, 20($sp)
	lw 	$s4, 16($sp)
	lw 	$s3, 12($sp)
	lw 	$s2, 8($sp)
	lw	$s1, 4($sp)
	lw 	$s0, 0($sp)
	addiu 	$sp, $sp, 32
	
	lw 	$ra, 4($sp)
	lw 	$fp, 0($sp)
	addiu 	$sp, $sp, 28
	jr	$ra
	
	
	
