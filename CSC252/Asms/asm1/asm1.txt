.data
    EQUALS_MSG: .asciiz "EQUALS\n"
    NOTHING_EQUALS_MSG: .asciiz "NOTHING EQUALS\n"
    ASCENDING_ORDER: .asciiz "ASCENDING\n"
    DESCENDING_ORDER: .asciiz "DESCENDING\n"
    ALL_EQUAL: .asciiz "ALL EQUAL\n"
    UNORDERED: .asciiz "UNORDERED\n"
    REVERSE_ORDER: .asciiz "REVERSE\n"
    RED: .asciiz "red: "
    ORANGE: .asciiz "orange: "
    YELLOW: .asciiz "yellow: "
    GREEN: .asciiz "green: "
    BLUE: .asciiz "blue: "
    PURPLE: .asciiz "purple: "
    MSG: .asciiz "this is a test MSGGG"


.text 
.globl studentMain
studentMain:
    addiu $sp, $sp, -24   # allocate stack space -- default of 24 here
    sw $fp, 0($sp)        # save caller’s frame pointer
    sw $ra, 4($sp)        # save return address
    addiu $fp, $sp, 20    # setup main’s frame pointer
    
    

    la $s0, red
    lw $s0, 0($s0)
    
    la $s1, orange
    lw $s1, 0($s1)
    
    la $s2, yellow
    lw $s2, 0($s2)
    
    la $s3, green
    lw $s3, 0($s3)
    
    la $s4, blue
    lw $s4, 0($s4)
    
    la $s5, purple
    lw $s5, 0($s5)
    
    la $t0, equals
    lw $t0, 0($t0)        # Load the value from memory location 'equals'
    
    la $t1, order
    lw $t1, 0($t1)        # Load the value from memory location 'order'
    
    la $t2, reverse
    lw $t2, 0($t2)        # Load the value from memory location 'reverse'
    
    la $t3, print
    lw $t3, 0($t3)        # Load the value from memory location 'print'

    addi $t6, $zero, 0     # Load immediate value 0 into $t6
    
    beq $t0, $t6, TASK_2  # Check if equals is 0
    
    addi $t5, $zero, 1     # Load immediate value 1 into $t5
    
    beq $t0, $t5, CHECK_EQ # Check if equals is 1

TASK_2:
    	la $t1, order
    	lw $t1, 0($t1)        # Load the value from memory location 'order'
    
        addi $t6, $zero, 0     # Load immediate value 0 into $t6
        addi $t5, $zero, 1     # Load immediate value 1 into $t5
	beq $t1, $t6, TASK_3  # Check if order is 0
	beq $t1, $t5, CHECK_O  # Check if order is 1
	
TASK_3:

    	la $t2, reverse
    	lw $t2, 0($t2)        # Load the value from memory location 'reverse'
    
        addi $t5, $zero, 1     # Load immediate value 1 into $t5
        addi $t6, $zero, 0     # Load immediate value 0 into $t6
    
	beq $t2, $t6, TASK_4  # Check if reverse is 0
	beq $t1, $t5, EXE_REV  # Check if reverse is 1
	
# Read all 6 color values, and write them back to memory in the reverse
# order they previously were.	
	
EXE_REV:
# s0-s5 : red-purple

    	la $s0, red
   	lw $t0, 0($s0)  # load red into temp0
    
    	la $s1, orange
    	lw $t1, 0($s1)  # load orange into temp1
    
    	la $s2, yellow
   	lw $t2, 0($s2)  # load yellow into temp2
    
    	la $s3, green
    	lw $t3, 0($s3)  # load green into temp3
    
    	la $s4, blue
    	lw $t4, 0($s4)  # load blue into temp4
    
    	la $s5, purple
    	lw $t5, 0($s5)  # load purple into temp5
    	


    	sw $t5, 0($s0)  # write purple back to red's location
    	sw $t4, 0($s1)  # write blue back to orange's location
    	sw $t3, 0($s2)  # write green back to yellow's location
    	sw $t2, 0($s3)  # write yellow back to green's location
    	sw $t1, 0($s4)  # write orange back to blue's location
    	sw $t0, 0($s5)  # write red back to purple's location

    	# Print "REVERSE"
    	addi $v0, $zero, 4
    	la $a0, REVERSE_ORDER
    	syscall
    	j TASK_4  # Continue to TASK4
    
    
TASK_4: 
    	la $t3, print
    	lw $t3, 0($t3)        # Load the value from memory location 'print'

	beq $t3, $t6, EXIT  # Check if order is 0
	beq $t3, $t5, PRINT_OUT  # Check if order is 1
	
PRINT_OUT:
	addi $v0, $zero, 4       # syscall code for printing string
	la $a0, RED              # load address of the string "RED" into $a0
	syscall

	la $s0, red              # load address of the variable red into $s0
	lw $a0, 0($s0)            # load the value stored at red into $a0

	addi $v0, $zero, 1        # syscall code for printing integer
	syscall
	
	addi $v0, $zero, 11      # NEW Line
	addi $a0, $zero, '\n'
	syscall

    
        # Print ORANGE
    	addi $v0, $zero, 4       # syscall code for printing string
    	la $a0, ORANGE           # load address of the string "orange: " into $a0
    	syscall

    	la $s0, orange           # load address of the variable orange into $s0
    	lw $a0, 0($s0)           # load the value stored at orange into $a0

    	addi $v0, $zero, 1        # syscall code for printing integer
    	syscall
    	
	addi $v0, $zero, 11      # NEW Line
	addi $a0, $zero, '\n'
	syscall

    # Print YELLOW
    	addi $v0, $zero, 4       # syscall code for printing string
    	la $a0, YELLOW           # load address of the string "yellow: " into $a0
    	syscall

    	la $s0, yellow           # load address of the variable yellow into $s0
    	lw $a0, 0($s0)           # load the value stored at yellow into $a0

    	addi $v0, $zero, 1        # syscall code for printing integer
    	syscall
    	
    	addi $v0, $zero, 11      # NEW Line
	addi $a0, $zero, '\n'
	syscall


    # Print GREEN
    	addi $v0, $zero, 4       # syscall code for printing string
    	la $a0, GREEN            # load address of the string "green: " into $a0
    	syscall

    	la $s0, green            # load address of the variable green into $s0
    	lw $a0, 0($s0)           # load the value stored at green into $a0

    	addi $v0, $zero, 1        # syscall code for printing integer
    	syscall
    	
	addi $v0, $zero, 11      # NEW Line
	addi $a0, $zero, '\n'
	syscall


    # Print BLUE
    	addi $v0, $zero, 4       # syscall code for printing string
    	la $a0, BLUE             # load address of the string "blue: " into $a0
    	syscall

    	la $s0, blue             # load address of the variable blue into $s0
    	lw $a0, 0($s0)           # load the value stored at blue into $a0

    	addi $v0, $zero, 1        # syscall code for printing integer
    	syscall
    	
    	addi $v0, $zero, 11      # NEW Line
	addi $a0, $zero, '\n'
	syscall


    # Print PURPLE
    	addi $v0, $zero, 4       # syscall code for printing string
    	la $a0, PURPLE           # load address of the string "purple: " into $a0
    	syscall

    	la $s0, purple           # load address of the variable purple into $s0
    	lw $a0, 0($s0)           # load the value stored at purple into $a0

    	addi $v0, $zero, 1        # syscall code for printing integer
    	syscall
    	
    	addi $v0, $zero, 11      # NEW Line
	addi $a0, $zero, '\n'
	syscall

    	j EXIT
    
    
# Read all 6 color values. Check to see if they are all in order
# either ascending or descending.
CHECK_O:
        
    # Check if all values are equal
    beq $s0, $s1, CHECK_EQ_PAIR1
	j CHECK_ASC
	
CHECK_EQ_PAIR1:
    beq $s0, $s2, CHECK_EQ_PAIR2
    	j CHECK_ASC
    
CHECK_EQ_PAIR2:
    beq $s0, $s3, CHECK_EQ_PAIR3
    	j CHECK_ASC
    	
CHECK_EQ_PAIR3:
    beq $s0, $s4, CHECK_EQ_PAIR4
	j CHECK_ASC

CHECK_EQ_PAIR4:
    beq $s0, $s5, CHECK_EQ_PAIR5
	j CHECK_ASC

CHECK_EQ_PAIR5:
    beq $s1, $s2, CHECK_EQ_PAIR6
	j CHECK_ASC

CHECK_EQ_PAIR6:
    beq $s1, $s3, CHECK_EQ_PAIR7
	j CHECK_ASC

CHECK_EQ_PAIR7:
    beq $s1, $s4, CHECK_EQ_PAIR8
	j CHECK_ASC

CHECK_EQ_PAIR8:
    beq $s1, $s5, CHECK_EQ_PAIR9
	j CHECK_ASC

CHECK_EQ_PAIR9:
    beq $s2, $s3, CHECK_EQ_PAIR10
	j CHECK_ASC

CHECK_EQ_PAIR10:
    beq $s2, $s4, CHECK_EQ_PAIR11
	j CHECK_ASC

CHECK_EQ_PAIR11:
    beq $s2, $s5, CHECK_EQ_PAIR12
	j CHECK_ASC

CHECK_EQ_PAIR12:
    beq $s3, $s4, CHECK_EQ_PAIR13
	j CHECK_ASC

CHECK_EQ_PAIR13:
    beq $s3, $s5, CHECK_EQ_PAIR14
	j CHECK_ASC

CHECK_EQ_PAIR14:
    beq $s4, $s5, ALL_EQ
	j CHECK_ASC

CHECK_ASC:
    # Compare colors for ascending order
    
    
    slt $t4, $s1, $s0
    bne $t4, $zero, UNORDERED_ASC
    slt $t4, $s2, $s1
    bne $t4, $zero, UNORDERED_ASC
    slt $t4, $s3, $s2
    bne $t4, $zero, UNORDERED_ASC
    slt $t4, $s4, $s3
    bne $t4, $zero, UNORDERED_ASC
    slt $t4, $s5, $s4
    bne $t4, $zero, UNORDERED_ASC
    j ASCENDING_ORDER_PRINT
    
    CHECK_EQ_ALL:
    # If all values are equal, print "ALL EQUAL" and exit
    addi $v0, $zero, 4
    la $a0, ALL_EQUAL
    syscall
    j TASK_3

UNORDERED_ASC:
    # Compare colors for descending order
    slt $t4, $s0, $s1
    bne $t4, $zero, UNORDERED_DESC
    slt $t4, $s1, $s2
    bne $t4, $zero, UNORDERED_DESC
    slt $t4, $s2, $s3
    bne $t4, $zero, UNORDERED_DESC
    slt $t4, $s3, $s4
    bne $t4, $zero, UNORDERED_DESC
    slt $t4, $s4, $s5
    bne $t4, $zero, UNORDERED_DESC
    j DESCENDING_ORDER_PRINT
   
    
UNORDERED_DESC:
    # If none of the above conditions are met, it means the colors are unordered
    addi $v0, $zero, 4
    la $a0, UNORDERED
    syscall
    j TASK_3
    
ASCENDING_ORDER_PRINT:
    # If ascending order is found, print "ASCENDING" and exit
    addi $v0, $zero, 4
    la $a0, ASCENDING_ORDER
    syscall
    j TASK_3

DESCENDING_ORDER_PRINT:
    # If descending order is found, print "DESCENDING" and exit
    addi $v0, $zero, 4
    la $a0, DESCENDING_ORDER
    syscall
    j TASK_3    
    
ALL_EQ:
    # If descending order is found, print "ALL EQUAL" and exit
    addi $v0, $zero, 4
    la $a0, ALL_EQUAL
    syscall
    j TASK_3  
       
CHECK_EQ:
    # Compare colors for equality
    beq $s0, $s1, PRINT_EQUALS
    beq $s0, $s2, PRINT_EQUALS
    beq $s0, $s3, PRINT_EQUALS
    beq $s1, $s2, PRINT_EQUALS
    beq $s1, $s3, PRINT_EQUALS
    beq $s2, $s3, PRINT_EQUALS

    # If no equals found, print "NOTHING EQUALS" and exit
    addi $v0, $zero, 4
    la $a0, NOTHING_EQUALS_MSG
    syscall
    j TASK_2

PRINT_EQUALS:
    # If equals found, print "EQUALS" and exit
    addi $v0, $zero, 4
    la $a0, EQUALS_MSG
    syscall
    j TASK_2

EXIT:
    # Exit the program
    lw $ra, 4($sp)        # get return address from stack
    lw $fp, 0($sp)        # restore the caller’s frame pointer
    addiu $sp, $sp, 24    # restore the caller’s stack pointer
    jr $ra               # return to caller’s code
