# Kory Smith
# CSC252 ASM5.s

.data

newLine: .asciiz "\n"
dashes: .asciiz "----------------"
otherString: .asciiz "<other>: "
colon: .asciiz ": "

.text


.globl countLetters
countLetters:

    addiu   $sp, $sp, 	-24             # allocate stack space 
    sw      $fp, 0($sp)               	# save callers frame pointer
    sw      $ra, 4($sp)               	# save return address
    addiu   $fp, $sp, 	20              # save frame pointer

    addiu   $sp, $sp, 	-104            # allocate more stack space 

    add     $t0, $zero, $zero         	
    addi    $t2, $zero, 26            	


   
LOOP:					
    slt     $t1, $t0, 	$t2		# While (t0 < 26)
    beq     $t1, $zero, BR		
    add     $t3, $zero, $t0            # t3 = t0
    sll     $t3, $t3, 	2              # shift left

    add     $t3, $sp, 	$t3             # stack[i]
    sw      $zero, 0($t3)		# t3 = zero
    addi    $t0, $t0, 	1              	# t0++
    j       LOOP	
    
    
BR:

    add     $t0, $zero, $a0           	# t0 = a0
    addi    $t1, $zero, 0             	# t1 = 0

    addi    $v0, $zero, 4             	# dashes
    la      $a0, dashes
    syscall 

    addi    $v0, $zero, 4             	#  newLine
    la      $a0, newLine
    syscall 

    addi    $v0, $zero, 4             	# print string
    add     $a0, $zero, $t0
    syscall 

    addi    $v0, $zero, 4             	# newLine
    la      $a0, newLine
    syscall 

    addi    $v0, $zero, 4             	# dashes
    la      $a0, dashes
    syscall 

    addi    $v0, $zero, 4             	# newLine
    la      $a0, newLine
    syscall 

    add     $t8, $zero, $t0           	# t8 = t0


#This runs through the array and looks for letters to increase counts.
    
LOOP1:
    lb      $t4, 0($t8)               	# $t4 = current letter
    beq     $t4, $zero, PRINT         	# if (0), then print

    slti    $t5, $t4, 	'a'             # if( t4 < a)

    bne     $t5, $zero, CASE1     	# if(0) case1

    addi    $t3, $zero, 'z'		# t3 = z
    slt     $t5, $t3, 	$t4             # if(t3 < t4)
    bne     $t5, $zero, CASE1     	# J case1

    addi    $t2, $zero, 'a'           	# t2  = a
    sub     $t5, $t4, 	$t2             # t5 = (t4 - t2)

    sll     $t5, $t5, 	2               # shift left

    add     $t6, $sp, 	$t5             # t6 = (stack pointer + t5)
    lw      $t7, 0($t6)               	

    addi    $t7, $t7, 	1               # incriment t7 
    sw      $t7, 0($t6)               	# store t7 

    j       INCREMENT

CASE1:
    slti    $t5, $t4, 	'A'             # $t4 > 'A'
    bne     $t5, $zero, CASE2 	        # Jump to CASE2 
        
    addi    $t3, $zero, 'Z'             # $t3 = 'Z'
    slt     $t5, $t3, 	$t4            
    bne     $t5, $zero, CASE2 	        # Jump to CASE2 if $t4 <= 'Z'

    addi    $t2, $zero, 'A'             # $t2 = 'A'
    sub     $t5, $t4, 	$t2             # $t5 = ($t4 - 'A')

    sll     $t5, $t5, 	2               # Shift left

    add     $t6, $sp, 	$t5             # $t6 = (stack pointer + $t5)
    lw      $t7, 0($t6)               	# Load word at address $t6 into $t7

    addi    $t7, $t7, 	1               # Increment $t7
    sw      $t7, 0($t6)                 # Store $t7 

    j       INCREMENT                  

CASE2:
    addi    $t1, $t1, 	1               # t1++
    

INCREMENT:
    addi    $t8, $t8, 	1               # t8++
    j       LOOP1

PRINT:
    addi    $t8, $zero, 0             	# t8 = 0



# printf("%c: %d\n", ’a’+i, letters[i]);
LOOPEND:
    slti    $t9, $t8, 	26              # if (t8 > 26) 
    beq     $t9, $zero, COUNTDONE   	# CountDone

    addi    $t9, $t8, 	'a'             

    addi    $v0, $zero, 11
    add     $a0, $zero, $t9           	# println(a+i);
    syscall 

    addi    $v0, $zero, 4
    la      $a0, colon             	# println(column);
    syscall 

    sll     $t5, $t8, 	2               # shift left
    add     $t9, $sp, 	$t5             # t9  =  (stack pointer + t5)

    lw      $t2, 0($t9)               	# loading stack pointer into t2

    addi    $v0, $zero, 1
    add     $a0, $zero, $t2           	# println(letters[i]);
    syscall 

    addi    $v0, $zero, 4
    la      $a0, newLine            	# newLine
    syscall 

    addi    $t8, $t8, 1               	# i++
    j       LOOPEND


COUNTDONE:
    addi    $v0, $zero, 4
    la      $a0, otherString           #  println(other);
    syscall 

    addi    $v0, $zero, 1
    add     $a0, $zero, $t1           	
    syscall 

    addi    $v0, $zero, 4
    la      $a0, newLine            	# newLine
    syscall 

    addiu   $sp, $sp, 	104		# delete stack

    lw      $ra, 4($sp)               	# get return address from stack
    lw      $fp, 0($sp)              	# restore frame pointer
    addiu   $sp, $sp, 	24              # restore stack pointer
    jr      $ra                        











.globl subsCipher
subsCipher:

    addiu   $sp, $sp, 	-24             # allocate stack space 
    sw      $fp, 0($sp)              	# save callers frame pointer
    sw      $ra, 4($sp)              	# save return address
    addiu   $fp, $sp, 	20              # setup mains frame pointer

    sw      $a0, 8($sp)               	# store $a0
    sw      $a1, 12($sp)              	# store $a1

    jal     strLen

    lw      $a0, 8($sp)			
    lw      $a1, 12($sp)		

    add     $t0, $a0, 	$zero           # t0 = a0
    add     $t1, $a1, 	$zero           # t1 = a1

    addi    $t2, $v0, 	1               # t2 = v0 + 1

    addi    $t3, $zero, 0xffff        	# 16 mask bits
    sll     $t3, $t3, 	16              # shift mask 16 bits
    ori     $t3, $t3, 	0xfffc          

    addi    $t4, $t2, 	3               
    and     $t4, $t4, 	$t3             # t4 = $t3+3 AND $t3

    sub     $sp, $sp, 	$t4             # stackpointer - $t4

    addi    $t5, $zero, 0             	# i = 0

    addi    $t6, $t2, 	-1              # t6 = t2 -1

	

LOOP3:
    slt     $t7, $t5, 	$t6             # if(i> len-1)
    beq     $t7, $zero, OUTT		# J OUTT

    add     $t8, $t0, 	$t5             # $t8 = current character
    lb      $t8, 0($t8)
    add     $t9, $t1, 	$t8             
    lb      $t9, 0($t9)

    add     $t3, $sp, 	$t5            
    sb      $t9, 0($t3)

    addi    $t5, $t5, 	1               # i++
    j       LOOP3

OUTT:
    addi    $t3, $zero, '\0'          	# \0 = null
    add     $t5, $sp, 	$t6             # t5 = (stackpointer + t6)

    sb      $t3, 0($t5) 	      	

    add     $a0, $sp, 	$zero           # a0 = stackpointer

    sw      $t4, 0($fp)               	# save $t4 to $fp
    jal     printSubstitutedString

    lw      $t4, 0($fp)               	

DONE:

    add     $sp, $sp, 	$t4             # remove stack space

    lw      $ra, 4($sp)              	# get return address from stack
    lw      $fp, 0($sp)               	# restore frame pointer
    addiu   $sp, $sp, 	24              # restore stack pointer
    jr      $ra                     	

.globl strLen
strLen:

    addiu   $sp, $sp, 	-24             # allocate stack space
    sw      $fp, 0($sp)               	# save frame pointer
    sw      $ra, 4($sp)               	# save return address
    addiu   $fp, $sp, 	20              # setup mains frame pointer

    addi    $t0, $zero, 0             	# count = 0
    addi    $t1, $zero, 0             	# i = 0
    add     $t2, $zero, $a0           	# t2  = a0
    addi    $t3, $zero, '\0'          	# null

    # this counts the length of the string
LOOP4:
    add     $t4, $zero, $t1           	# t4 = t1
    add     $t5, $t2, 	$t4             # str[index]
    lb      $t6, 0($t5)               	
    beq     $t3, $t6, 	STRLENDONE      # while (str[iindex]!= null)
    addi    $t0, $t0, 	1               # count++
    addi    $t1, $t1, 	1               # index +=1
    j       LOOP4

STRLENDONE:
    add     $v0, $t0, 	$zero           # save count
    lw      $ra, 4($sp)               	
    lw      $fp, 0($sp)               	
    addiu   $sp, $sp, 	24              
    jr      $ra                        
