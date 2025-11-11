# Author: Kory Smith

.data
TurtleObject:
    .byte 0    # x
    .byte 0    # y
    .byte 0    # dir
    .byte 1    # padding to align name to a word boundary
    .word 0    # name (4 byte word)
    .word 0    # odom (4 byte word)
    
    
Turtle: 	.asciiz "Turtle "
apostrophe:	.asciiz """"" """
comma:		.asciiz ","
pos: 		.asciiz "  pos "
dir: 		.asciiz "  dir "
North: 		.asciiz "North"
East: 		.asciiz "East"
South: 		.asciiz "South"
West: 		.asciiz "West"
odometer: 		.asciiz "  odometer "
NEWLINE:		.asciiz "\n"
TESTSTR:	.asciiz "THIS IS A TEST STRING"
.text

.globl turtle_init
.globl turtle_debug
.globl turtle_move
.globl turtle_turnLeft
.globl turtle_turnRight
.globl turtle_searchName
.globl turtle_sortByX_indirect


turtle_init:
	addiu	$sp, $sp, -24		# create stack space
	sw 	$ra, 4($sp) 		# save frame pointer
	sw 	$fp, 0($sp)		# save return address
	addiu 	$fp, $sp, 20		# change frame pointer
	
	
	sb	$zero, 0($a0)		# x = 0
	sb 	$zero, 1($a0)		# y = 0
	sb 	$zero, 2($a0)		# dir = 0
	sw	$a1, 4($a0)		# name = param name
	sw 	$zero, 8($a0)		# odom = 0

	lw $ra, 4($sp) 			# get return address from stack
	lw $fp, 0($sp) 			# restore the caller’s frame pointer
	addiu $sp, $sp, 24 		# restore the caller’s stack pointer
	jr $ra 				# return to caller’s code



turtle_debug:
    	addiu   $sp, $sp, -24       # create stack space
    	sw      $ra, 4($sp)         # save frame pointer
    	sw      $fp, 0($sp)         # save return address
    	addiu   $fp, $sp, 20        # change frame pointer

    	addiu   $sp, $sp, -4        # allocate stack space
    	sw      $s0, 0($sp)         # store s0 onto stack

    	add     $s0, $zero, $a0     # s0 = Turtle *obj



    	lb      $t0, 0($s0)         # t0 = x

    	addi    $s0, $s0, 1         # s0 = 1
    	lb      $t1, 0($s0)         # t1 = y

    	addi    $s0, $s0, 1         # s0 = 2
    	lb      $t2, 0($s0)         # t2 = dir

    	addi    $s0, $s0, 2         # s0 = 4
    	lw      $t3, 0($s0)         # t3 = name

    	addi    $s0, $s0, 4         # s0 = 8
    	lw      $t4, 0($s0)         # t4 = odom

# print turtle name
	addi 	$v0, $zero, 4		# print_str()
	la	$a0, Turtle 		# print_str(Turtle ")
	syscall
	
	# Print "
    	addi $v0, $zero, 11
    	addi $a0, $zero, 34
    	syscall
	
	addi 	$v0, $zero, 4		
	add	$a0, $zero, $t3		# print_str(name)
	syscall
	
	# Print "
    	addi $v0, $zero, 11
    	addi $a0, $zero, 34
    	syscall
	
	addi 	$v0, $zero, 4		
	la	$a0, NEWLINE		# print_str("\n")
	syscall
	
	# print position
	addi 	$v0, $zero, 4		
	la	$a0, pos		# print_str("pos ")
	syscall
	
	addi 	$v0, $zero, 1		
	add	$a0, $zero, $t0		# print_(x)
	syscall
	
	addi 	$v0, $zero, 4		
	la	$a0, comma		# print_(",")
	syscall
	
	addi 	$v0, $zero, 1		
	add	$a0, $zero, $t1		# print_(y)
	syscall
	
	addi 	$v0, $zero, 4		
	la	$a0, NEWLINE		# print_("\n")
	syscall
	
	
	# print direction
	addi	$v0, $zero, 4		
	la	$a0, dir		# print_(" dir ")
	syscall
	

	
	add	$a0, $zero, $t2		
	jal 	fetch_Dir		
	add	$t2, $zero, $v0		# t2 = Dir
	
	addi 	$v0, $zero, 4		
	add 	$a0, $zero, $t2		# print_(dir)
	syscall
	
	addi 	$v0, $zero, 4		
	la	$a0, NEWLINE		# print_("\n")
	syscall
	
	
	# print odometer
	addi 	$v0, $zero, 4		
	la 	$a0, odometer		# print_("  odometer ")
	syscall
	
	addi 	$v0, $zero, 1		
	add	$a0, $zero, $t4		# print_(odom)
	syscall
	
	addi 	$v0, $zero, 4		
	la	$a0, NEWLINE		# print_("\n")
	syscall
	
	addi 	$v0, $zero, 4		
	la	$a0, NEWLINE		# print_("\n")
	syscall
	
	lw	$s0, 0($sp)		# load s0 back from stack
	addiu 	$sp, $sp, 4		# fix stack pointer
	lw 	$fp, 0($sp)		# load old return address
	lw 	$ra, 4($sp)		# load old frame pointer
	addiu 	$sp, $sp, 24		# change stack pointer
	jr	$ra
	

fetch_Dir:
	
	add 	$t1, $zero, $zero		# t1 = 0
	
	tryNorth:
	bne	$a0, $t1, tryEast		# if (dir != 0), tryEast
	la	$t0, North			# retval  = "North"
	j returnDirection
	
	tryEast:
	addi	$t1, $t1, 1			# t1 ++
	bne	$a0, $t1, trySouth		# if (dir != 1), trySouth
	la	$t0, East			# retval  = "East"
	j returnDirection
	
	trySouth:
	addi	$t1, $t1, 1			# t1 ++
	bne	$a0, $t1, tryWest		# if (dir != 2), tryWest
	la	$t0, South			# retval  = "South"
	j returnDirection
	
	tryWest: 
	la	$t0, West			# retval  = "West"
	
	returnDirection:
	add 	$v0, $zero, $t0			# return retVal
	jr	$ra
	


turtle_turnLeft:

    	lb      $t0, 2($a0)         # t2 = dir
	beq	$t0, $zero, dir0
	addiu	$t0, $t0, -1
	sb	$t0, 2($a0)
	jr      $ra                 # return to caller’s code

	dir0:
		addi	$t0, $zero, 3
		sb	$t0, 2($a0)
    		jr      $ra                 # return to caller’s code



turtle_turnRight:

        lb      $t0, 2($a0)         # t2 = dir
	addi	$t9, $zero, 3
	beq	$t0, $t9, dir3
	addiu	$t0, $t0, 1
	sb	$t0, 2($a0)
	jr      $ra                 # return to caller’s code

	dir3:
		addi	$t0, $zero, 0
		sb	$t0, 2($a0)
    		jr      $ra                 # return to caller’s code




turtle_move:

	# Update Odometer
	lw	$t0, 8($a0)		
	sra	$t1, $a1, 31		
	xor	$t2, $a1, $t1		# absVal[distance]
	sub	$t2, $t2, $t1	
	add	$t0, $t2, $t0		
	sw	$t0, 8($a0)		# Turtle -> odom = t0 




    # $a0 = Turtle object pointer 


    # Update position 
    lb      $t2, 2($a0)         # Load dir 
    lb      $t0, 0($a0)         # Load x 
    lb      $t1, 1($a0)         # Load y 

    slt     $t3, $a1, $zero       
    
    # check if positive or negative int
    beq     $t3, $zero, check_positive   # double check if it's positive
    j       move_backward         	# If $a1 < 0, must be negative

check_positive:

    beq     $a1, $zero, move_done   	# If dist = zero break
    j       move_forward          

move_forward:
    beq     $t2, $zero, move_northFWD  # If dir = (0), move north
    addi	$t8, $zero, 1
    beq     $t2, $t8, move_eastFWD   	# If dir = (1), move east
    addi	$t8, $zero, 2
    beq     $t2, $t8, move_southFWD  	# If dir = (2), move south

    j       move_westFWD               # If dir = (3), move west

move_backward:
	
	
    beq     $t2, $zero, move_northBWD  # If dir = (0), move south
    addi	$t8, $zero, 3
    beq     $t2, $t8, move_westBWD   	# If dir = (3), move west
    addi	$t8, $zero, 2
    beq     $t2, $t8, move_southBWD  	# If dir = (2), move north
    j       move_eastBWD               # If dir = (1), move east


move_westFWD:

	addWLoop:
		beq	$a1, $zero, move_done		# if (dis == 0) break
		addiu	$t7, $zero, -10			# t7 = MIN_Y
		beq	$t0, $t7, move_done		# if (x == -10) break
		addiu	$t0, $t0, -1			# x --; 
		addiu	$a1, $a1, -1			# dis --;  
		j 	addWLoop
	j       move_done



move_southBWD:
	subSLoop:
		beq	$a1, $zero, move_done		# if (dist == 0) break
		addi	$t7, $zero, 10			# t7 = 10
		beq	$t1, $t7, move_done		# if (y == 10) break
		addi	$t1, $t1, 1			# y ++; 
		addi	$a1, $a1, 1			# dist ++; 
		j	subSLoop
    	j       move_done
move_northBWD:
	subNLoop:
		beq	$a1, $zero, move_done		# if (dist == 0) break
		addiu	$t7, $zero, -10			# t7 = -10
		beq	$t1, $t7, move_done		# if (y == -10) break
		addiu	$t1, $t1, -1			# y --; 
		addi	$a1, $a1, 1			# dist ++; 
		j	subNLoop
    	j       move_done
move_westBWD:
	subWLoop:
		beq	$a1, $zero, move_done		# if (dist == 0) break
		addi	$t7, $zero, 10			# t7 = 10
		beq	$t0, $t7, move_done		# if (x == 10) break
		addi	$t0, $t0, 1			# x ++; 
		addi	$a1, $a1, 1			# dist ++; 
		j	subWLoop
    	j       move_done
move_eastBWD:
	subELoop:
		beq	$a1, $zero, move_done		# if (dist == 0) break
		addiu	$t7, $zero, -10		# t7 = 10
		beq	$t0, $t7, move_done		# if (x == 10) break
		addi	$t0, $t0, -1			# x --; 
		addi	$a1, $a1, 1			# dist ++; 
		j	subELoop
    	j       move_done
move_northFWD:
   	addNLoop:
		beq	$a1, $zero, move_done		# if (dis == 0) break
		addi	$t7, $zero, 10			# t7 = MAX_Y
		beq	$t1, $t7, move_done		# if (y == 10) break
		addi	$t1, $t1, 1			# y ++
		addiu	$a1, $a1, -1			# dis --; 
		j 	addNLoop
	j move_done
move_eastFWD:
	addELoop:
		beq	$a1, $zero, move_done		# if (dist == 0) break
		addi	$t7, $zero, 10			# t7 = 10
		beq	$t0, $t7, move_done		# if (x == 10) break
		addi	$t0, $t0, 1			# x ++; 
		addi	$a1, $a1, -1			# dist --; 
		j	addELoop
    	j       move_done
move_southFWD:
	addSLoop:
		beq	$a1, $zero, move_done		# if (dis == 0) break
		addiu	$t7, $zero, -10			# t7 = MIN_Y
		beq	$t1, $t7, move_done		# if (y == -10) break
		addiu	$t1, $t1, -1			# y --; 
		addiu	$a1, $a1, -1			# dis --; 
		j 	addSLoop


move_done:
	sb 	$t0, 0($a0)		# x = t0
	sb	$t1, 1($a0)		# y = t1
	sb 	$t2, 2($a0) 		# dir = t2
	jr	$ra
	
	
turtle_searchName:
	addiu	$sp, $sp, -24		# create stack space
	sw 	$ra, 4($sp)		# save frame pointer
	sw 	$fp, 0($sp)		# save return address
	addiu 	$fp, $sp, 20		# change frame pointer
	
	# Save s Regsiters
	addiu	$sp, $sp, -20
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw 	$s2, 8($sp)
	sw	$s3, 12($sp)
	sw 	$s4, 16($sp)
	add	$s0, $zero, $zero 	# i = 0 
	add 	$s1, $zero, $a0		# name = *TurtleArray
	add	$s2, $zero, $a1		# t2 = arrayLen
	
	while:
		slt	$s3, $s0, $s2		
		beq	$s3, $zero, not_Found	# if   (i > arrayLen) return -1
		lw 	$a0, 4($s1)		# a0 = Turtle[i]
		add	$a1, $zero, $a2		# a1 = needle
		jal 	strcmp 
		beq	$v0, $zero, Found	# if(name == needle) return i
		addi	$s1, $s1, 12		# name += 12
		addi	$s0, $s0, 1		# i ++
	j while 
		
	not_Found:
	addiu	$v0, $zero, -1	# retVal = -1
	j 	returni
	
	Found:
	add	$v0, $zero, $s0	# Retval = i 
	j 	returni

	returni: 
	# return registers
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw 	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw 	$s4, 16($sp)
	addi	$sp, $sp, 20
	lw    $ra, 4($sp)		# load back return address
	lw    $fp, 0($sp)		# load back frame pointer
	addiu $sp, $sp, 24		# reset stack pointer
	jr    $ra
	
	




turtle_sortByX_indirect:
	
	addiu	$sp, $sp, -24		# create stack space
	sw 	$ra, 4($sp)		# save frame pointer
	sw 	$fp, 0($sp)		# save return address
	addiu 	$fp, $sp, 20		# change frame pointer
	
	# Save s Regsiters
	addiu	$sp, $sp, -20
	sw	$s0,  0($sp)	
	sw	$s1,  4($sp) 
	sw 	$s2,  8($sp) 
	sw	$s3, 12($sp)
	sw 	$s4, 16($sp)
	add	$s0, $zero, $a0		# s0 = Turtle**
	add	$t7, $zero, $s0		# t7 = a0
	add	$t0, $zero, $zero	# i = 0
	addi    $s4, $zero, 4        	# $s4 = 4
	mult    $a1, $s4             
	sll     $a1, $a1, 2          	# arrayLen = arrayLen * 4

	addiu	$a1, $a1, -4		# arrayLen --
	
	sortLoop:
	slt	$t1, $t0, $a1	
	beq	$t1, $zero, end		# if (i > arrLen) break loop
	add	$t1, $zero, $zero 	# t1 = j = 0
	addi	$s1, $zero, 4		
	
		cmpLoop:
		
		add	$t5, $t7, $s1		# t5 = &Turtle[j + 1]
		add	$t6, $t7, $t1		# t6 = &Turtle[j]
		sub	$t4, $a1, $t0
		slt	$t2, $t1, $t4	
		beq	$t2, $zero, incriment		# if ( j > arrayLen) break cmpLoop
		# check Turtle[i.x] < Turtle[i.y]
		lw	$s2, 0($t5)			# t5 = Turtle[i]
		lw	$s3, 0($t6)			# t6 = Turtle[j]
		lb 	$t3, 0($s2)			
		lb 	$t2, 0($s3)			
		# Now we need compare the two and swap if necessary 
		slt	$s4, $t3, $t2		# if arr[j + 1] < arr[j] skip
		beq	$s4, $zero, skip 	
		# else swap the pointers
		sw	$s2, 0($t6)			# Turtle[j+1]   = temp
		sw	$s3, 0($t5)			# Turtle[j]     = Turtle[j+1]
		
		skip:
		addi	$t1, $t1, 4			# j ++
		addi	$s1, $s1, 4			# j + 1 ++
		j 	cmpLoop
	
	incriment: 
	addi	$t0, $t0, 4			# i ++;
	j 	sortLoop 
	
	
	end:

	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw 	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw 	$s4, 16($sp)
	addi	$sp, $sp, 20

	lw    $ra, 4($sp)		# load back return address
	lw    $fp, 0($sp)		# load back frame pointer
	addiu $sp, $sp, 24		# reset stack pointer
	jr    $ra