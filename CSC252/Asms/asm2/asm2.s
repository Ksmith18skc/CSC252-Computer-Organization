# Author: Kory Smith

.data
FIB_MSG: .asciiz "Fibonacci Numbers:\n"
FIB_FORMAT: .asciiz " %d: %d\n"
TEST_MSG:  .asciiz "this is a test \n"
COLON: .asciiz ":"
TAB: .asciiz "  "
SPACE: .asciiz " "
ASCENDING: .asciiz "Run Check: ASCENDING\n"
DESCENDING: .asciiz "Run Check: DESCENDING\n"
NEITHER: .asciiz "Run Check: NEITHER\n"
COUNT_MSG: .asciiz "Word Count: "
SWAPPED_MSG: .asciiz "String successfully swapped!\n"



.text 
.globl studentMain
studentMain:
    	addiu $sp, $sp, -24   # allocate stack space -- default of 24 here
    	sw $fp, 0($sp)        # save caller’s frame pointer
    	sw $ra, 4($sp)        # save return address
    	addiu $fp, $sp, 20    # setup main’s frame pointer

	# Initialize variables
	addi $t6, $zero, 0  # Initialize fib_sum to 0
	addi $t7, $zero, 0     # Initialize loop counter to 0
	addi $t8, $zero, 0     # Initialize current Fibonacci number to 1
	addi $t9, $zero, 1     # Initialize previous Fibonacci number to 0


    	# Load the address of fib into $a1
	la $a1, fib
	lw $a1, 0($a1)
        
	bne $a1, $zero, FIB
	j SQUARE
	
	
# Fibonacci:
# This code prints Fibonacci numbers up to the input fib value, using an iterative algorithm.
# It checks if fib is not zero, then prints Fibonacci numbers starting from 0 and 1,
# up to fib using a while loop.
	
FIB:
    	# Print FIB_MSG
	addi $v0, $zero, 4       # syscall code for printing string
	la $a0, FIB_MSG           # load address of the string "Fibonacci Numbers:\n" into $a0
	syscall


INITIAL_PRINT:
	la $a1, fib
	lw $a1, 0($a1)
	addi $a1, $a1, 1
    
	slt $t5, $t7, $a1        # Check if n < fib

	
	beq $t5, $zero, END_INITIAL_PRINT_EXIT  # Exit loop if n >= fib

    	# Print TAB "	"
	addi $v0, $zero, 4        # syscall code for printing string
	la $a0, TAB             # load address of the string ":" into $a0
	syscall

    	# Print current Fibonacci number
	add $a0, $t7, $zero       # load n into $a0 for printing
	add $a1, $t8, $zero       # load fib(n) into $a1 for printing
	addi $v0, $zero, 1        # syscall code for printing integer
	syscall

    	# Print formatting ":"
	addi $v0, $zero, 4        # syscall code for printing string
	la $a0, COLON             # load address of the string ":" into $a0
	syscall

    	# Print TAB "	"
	addi $v0, $zero, 4        # syscall code for printing string
	la $a0, SPACE             # load address of the string ":" into $a0
 	syscall

	# Calculate next Fibonacci number
	add $t3, $t8, $t9         # cur = prev + beforeThat
	add $t9, $t8, $zero       # beforeThat = prev
	add $t8, $t3, $zero       # prev = cur

	# Load the next Fibonacci number into $a0 for printing
	add $a0, $t3, $zero


	# Load fib(n) into $a1 for printing
	add $a1, $t8, $zero

	# Print next Fibonacci number
	addi $v0, $zero, 1        # syscall code for printing integer
	syscall

    
    	# Increment loop counter
	addi $t7, $t7, 1          # n++


    	# Print newline
	addi $a0, $zero, 10       # ASCII value for newline
  	addi $v0, $zero, 11       # syscall code for printing character
  	syscall


  	j INITIAL_PRINT           # Jump back to INITIAL_PRINT



END_INITIAL_PRINT_EXIT:


	la $a1, square			
	lw $a1, 0($a1)
	addi $a2, $zero, 1
	beq $a1, $a2, SQUARE_SETUP		# if square == 1
	

	
   	j RUN_CHECK_SETUP                        # Jump to the end of the program if square != 1
	
	
SQUARE_SETUP:

    	# Print newline
	addi $a0, $zero, 10       # ASCII value for newline
  	addi $v0, $zero, 11       # syscall code for printing character
  	syscall
	
	
# Square:
# This code prints a square shape using the specified square_fill character and square_size.
# It checks if square is not zero, then uses a nested loop to print each row of the square.
# The square is constructed using characters for corners ('+'), edges ('|' or '-'), and fill character.
	
SQUARE:



    	# Load the address of square into $a1 and check if it's non-zero
    	la $a1, square
    	lw $a1, 0($a1)
    
    	bne $a1, $zero, SQUARE_LOOP
    	j RUN_CHECK

SQUARE_LOOP:
    	# Load the address of square_size into $a1
    	la $a1, square_size
    	lw $a1, 0($a1)
    	addi $s6, $s6, 1

	beq $a1, $s6, SQUARE_ONE
    	# Initialize row counter to 0
    	addi $t0, $zero, 1
    

SQUARE_ROW_LOOP:
    	slt $t2, $t0, $a1  # Check if row < square_size

    	beq $t0, $s6, FIRST_LAST_ROW  

    	# Check if it's the first or last row
    	beq $t0, $zero, FIRST_LAST_ROW     # If $t0 is 0, jump to FIRST_LAST_ROW
    	beq $t0, $a1, FIRST_LAST_ROW       # If $t0 equals $a1 (square_size), jump to FIRST_LAST_ROW

    	# Print the left border
    	addi $a0, $zero, 124   # ASCII value for '|'
    	addi $v0, $zero, 11    # Syscall code for printing character
    	syscall

    	# Print the fill character for each column in the row
    	la $t4, square_fill    # Load the address of square_fill into $t4
    	lb $t4, 0($t4)         # Load the character from memory
    	addi $t1, $zero, 2     # Initialize column counter to 1

SQUARE_COLUMN_LOOP:

    	slt $t3, $t1, $a1      # Check if column < square_size
    
    	beq $t3, $zero, SQUARE_COLUMN_LOOP_END

    	# Print the fill character
    	add $a0, $t4, $zero    # Load square_fill into $a0 for printing
    	addi $v0, $zero, 11    # Syscall code for printing character
    	syscall

    	# Increment column counter
   	addi $t1, $t1, 1       # Increment column counter
    	j SQUARE_COLUMN_LOOP   # Repeat for the next column

SQUARE_COLUMN_LOOP_END:
    	# Print the right border or newline
    	addi $a0, $zero, 124    # ASCII value for '|'
    	addi $v0, $zero, 11    # Syscall code for printing characters
    	syscall

    	j SQUARE_ROW_LOOP_END  # Jump to end of row loop

FIRST_LAST_ROW:
    	# Print the left border
    	addi $a0, $zero, 43    # ASCII value for '+'
    	addi $v0, $zero, 11    # Syscall code for printing character
    	syscall

    	# Print the '-' character for square_size - 2 times
    	addi $t6, $a1, -2       # square_size - 2

    	beq $t6, $zero, SKIP_PRINT_HYPHEN  # Skip printing '-' if square_size <= 2


PRINT_HYPHEN_LOOP:
    	addi $a0, $zero, 45    # ASCII value for '-'
    	addi $v0, $zero, 11    # Syscall code for printing character
    	syscall

    	addi $t6, $t6, -1      # Decrement loop counter
    	bne $t6, $zero, PRINT_HYPHEN_LOOP  # Loop until loop counter is zero

SKIP_PRINT_HYPHEN:
    	# Print the '+' character
    	addi $a0, $zero, 43    # ASCII value for '+'
    	addi $v0, $zero, 11    # Syscall code for printing character
    	syscall

    	j SQUARE_ROW_LOOP_END

SQUARE_ROW_LOOP_END:
    	addi $a0, $zero, 10    # ASCII value for newline
    	addi $v0, $zero, 11    # Syscall code for printing character
    	syscall
    
    	beq $t2, $zero, RUN_CHECK_SETUP 
    	# Increment row counter
    	addi $t0, $t0, 1       # Increment row counter
    	j SQUARE_ROW_LOOP      # Jump back to start of row loop

SQUARE_END_LOOP:
	addi $a0, $zero, 10    # ASCII value for newline
    	addi $v0, $zero, 11    # Syscall code for printing character
    	syscall
    	j RUN_CHECK


SQUARE_ONE:
	addi $a0, $zero, 43    # ASCII value for '+'
    	addi $v0, $zero, 11    # Syscall code for printing character
    	syscall
    	addi $a0, $zero, 43    # ASCII value for '+'
    	addi $v0, $zero, 11    # Syscall code for printing character
    	syscall
    	
    	
    	addi $a0, $zero, 10    # ASCII value for newline
   	addi $v0, $zero, 11    # Syscall code for printing character
    	syscall

    	j RUN_CHECK_SETUP
    	
    	
    	
RUN_CHECK_SETUP:
    	addi $a0, $zero, 10    # ASCII value for newline
   	addi $v0, $zero, 11    # Syscall code for printing character
    	syscall
    	
    	
# Run Check:
# This code checks if the given array of integers is in ascending, descending, or neither order.
# It scans through the array and compares each value with the one before to determine the order.
# It then prints the result as "Run Check: ASCENDING", "Run Check: DESCENDING", or "Run Check: NEITHER".
# If the array is both ascending and descending (e.g., all elements are the same), it prints both ascending and descending lines.

    	
RUN_CHECK:
	
	add $t0, $zero, $zero
	
        # Load the address of runcheck into $a1 and check if it's non-zero
    	la $a1, runCheck
    	lw $a1, 0($a1)
    	bne $a1, $zero, CHECK_BASE_CASES
    
    
    	j COUNT_WORDS	
    	
    	
    	
CHECK_BASE_CASES:


	la $a2, intArray
    	lw $a0, 0($a2)
    	
	la $a3, intArray_len
    	lw $a3, 0($a3)

	addi $s6, $zero, 1
	beq $a3, $zero, PRINT_BOTH
	beq $a3, $s6, PRINT_BOTH
	addi $a3, $a3, -1


# Check to see if all values within intArray are equal, if so jump to BOTH
CHECK_BOTH:

	add $t0, $t0, $zero # Initialize index i = 0
	beq $t0, $a3, PRINT_BOTH  # If i == length, print BOTH
	
	# Load intArray[i] into $s6
    	la $t1, intArray                 # Load address of intArray into $t1
    	sll $t2, $t0, 2                  # Calculate byte offset (4 bytes per integer)
    	add $t1, $t1, $t2                # Calculate address of intArray[i]
    	lw $s6, 0($t1)                   # Load intArray[i] into $s6

    	# Load intArray[i+1] into $s7
    	addi $t2, $t0, 1                 # Calculate index i+1
    	sll $t2, $t2, 2                  # Calculate byte offset (4 bytes per integer)
    	add $t3, $t1, $t2                # Calculate address of intArray[i+1]
    	lw $s7, 0($t3)                   # Load intArray[i+1] into $s7

    	bne $s6, $s7, CHECK_ASCENDING    # If not, it's not ascending


    	addi $t0, $t0, 1                 # Increment i
	
	
CHECK_ASCENDING_EQUAL:
	beq $t0, $a3, PRINT_BOTH  # If i == length, print BOTH
	addi $t0, $t0, 1                 # Increment i
    	beq $s7, $s6, CHECK_ASCENDING     # If equal, continue with ASCENDING_LOOP


CHECK_ASCENDING:
    	addi $t0, $zero, 0         # Initialize index i = 0
    	addi $t9, $zero, 1         # Initialize index j = 1
ASCENDING_LOOP:
    	beq $t0, $a3, ASCENDING_PRINT   # If i == length, print ASCENDING

    	# Load intArray[i] into $s6
    	la $t1, intArray                 # Load address of intArray into $t1
    	sll $t2, $t0, 2                  # Calculate byte offset (4 bytes per integer)
    	add $t1, $t1, $t2                # Calculate address of intArray[i]
    	lw $s6, 0($t1)                   # Load intArray[i] into $s6
 
    
        # Load intArray[i+1] into $s7 with sign-extension
    	add $t2, $t9, $zero                 # Calculate index i+1
    	sll $t2, $t2, 2                  # Calculate byte offset (4 bytes per integer)
    	add $t3, $t1, $t2                # Calculate address of intArray[i+1]
    	lw $s7, 0($t3)                   # Load intArray[i+1] into $s7 with sign-extension
    
    

    	slt $t4, $s7, $s6                # Check if intArray[i+1] < intArray[i]
    	bne $t4, $zero, NOT_ASCENDING    # If not, it's not ascending

    	addi $t0, $t0, 1                 # Increment i
    	
    	
    	bne $t0, $a3, ASCENDING_LOOP   # If i == length, print ASCENDING
    	beq $s7, $s6, PRINT_BOTH     # If equal, continue with ASCENDING_LOOP
    	
    	
    	
    	j ASCENDING_LOOP                 # Repeat loop

NOT_ASCENDING:
    	j CHECK_DESCENDING        # If not ascending, check descending

ASCENDING_PRINT:
    	# Print "Run Check: ASCENDING"
    	addi $v0, $zero, 4        # syscall code for printing string
    	la $a0, ASCENDING         # load address of ASCENDING into $a0
    	syscall
    
    	addi $a0, $zero, 10    # ASCII value for newline
    	addi $v0, $zero, 11    # Syscall code for printing character
    	syscall

    	j COUNT_WORDS                     # Jump to end

CHECK_DESCENDING:
    	addi $t0, $zero, 0         # Initialize index i = 0
    	addi $t9, $zero, 1         # Initialize index j = 1
DESCENDING_LOOP:
    	beq $t0, $a3, DESCENDING_PRINT  # If i == length, print DESCENDING

    	# Load intArray[i] into $s6
    	la $t1, intArray                 # Load address of intArray into $t1
    	sll $t2, $t0, 2                  # Calculate byte offset (4 bytes per integer)
    	add $t1, $t1, $t2                # Calculate address of intArray[i]
    	lw $s6, 0($t1)                   # Load intArray[i] into $s6

        # Load intArray[i+1] into $s7 with sign-extension
    	add $t2, $t9, $zero                 # Calculate index i+1
    	sll $t2, $t2, 2                  # Calculate byte offset (4 bytes per integer)
    	add $t3, $t1, $t2                # Calculate address of intArray[i+1]
    	lw $s7, 0($t3)                   # Load intArray[i+1] into $s7 with sign-extension
    


    	slt $t4, $s7, $s6                # Check if intArray[i+1] < intArray[i]
    	beq $t4, $zero, CHECK_DESCENDING_EQUAL   # If not, it's not descending

    	addi $t0, $t0, 1                 # Increment i
    	j DESCENDING_LOOP                # Repeat loop


CHECK_DESCENDING_EQUAL:
    	beq $t0, $a3, PRINT_BOTH  # If i == length, print BOTH
    	addi $t0, $t0, 1                 # Increment i

    	beq $s7, $s6, DESCENDING_LOOP     # If equal, continue with ASCENDING_LOOP

    	# If not equal, it's not descending
    	j NOT_DESCENDING



NOT_DESCENDING:
    	j PRINT_NEITHER               # If not descending, check ascending
    
    
PRINT_NEITHER:
    	# Print "Run Check: NEITHER"
    	addi $v0, $zero, 4        # syscall code for printing string
    	la $a0, NEITHER        # load address of DESCENDING into $a0
    	syscall

    	addi $a0, $zero, 10    # ASCII value for newline
    	addi $v0, $zero, 11    # Syscall code for printing character
    	syscall

    	j COUNT_WORDS                     # Jump to end


DESCENDING_PRINT:
    	# Print "Run Check: DESCENDING"
    	addi $v0, $zero, 4        # syscall code for printing string
    	la $a0, DESCENDING        # load address of DESCENDING into $a0
    	syscall

    	addi $a0, $zero, 10    # ASCII value for newline
    	addi $v0, $zero, 11    # Syscall code for printing character
    	syscall

    	j COUNT_WORDS                     # Jump to end

    	
PRINT_BOTH:
	# Print Ascending 
	addi $v0, $zero, 4        # syscall code for printing ASCENDING
	la $a0, ASCENDING         
	syscall

	addi $v0, $zero, 4        # syscall code for printing DESCENDING
	la $a0, DESCENDING        
	syscall


    	addi $a0, $zero, 10    # ASCII value for newline
    	addi $v0, $zero, 11    # Syscall code for printing character
    	syscall
	
	j COUNT_WORDS


# countWords:
# This code counts the number of words in the given string str.
# Words are separated by spaces or newlines. It ignores leading and trailing spaces, and multiple spaces in a row.
# It then prints the number of words as "Word Count: <count>", followed by a blank line for formatting.


COUNT_WORDS:

	la 	$s3, countWords		# s3 = &countWords
	lw 	$s3, 0($s3) 		# s3 = countWords
	
	addi 	$t0, $zero, 1		# t0 = 1
	beq 	$s3, $t0, CHECK_WORD_CT 	# Start countWords if countWords == 1
	j LEAVE_WORD_CT
	
CHECK_WORD_CT:
	
	la 	$s7, str			# s7 = &str
	addi 	$t0, $zero, 1 	# t0 = 1 (word count)
	
	addi 	$t1, $zero, 0 		# i = 0
	
	    # if str leads with blanks space initialize # t0 = 0 (word count)
	    # else, # t0 = 1 (word count)
SKIP_SPACE:
    	lb $t2, 0($s7)              # Load the character at the current position
    	beq $t2, $zero, END_SKIP_SPACE   # Exit loop if the character is null
    	
    	# Check if the character is not a space, newline, or tab
    	addi $t3, $zero, 32                # ASCII value of space (' ')
    	beq $t2, $t3, INCREASE_CHAR   # Skip space
    	addi $t3, $zero, 10                  # ASCII value of newline ('\n')
    	beq $t2, $t3, INCREASE_CHAR   # Skip newline
    	addi $t3, $zero, 9          # ASCII value of tab ('\t')
    	beq $t2, $t3, INCREASE_CHAR   # Skip tab
    	
    	
    	j LOOP_WORD_CT   # Continue loop
END_SKIP_SPACE:
	addi 	$t0, $zero, 0 	# t0 = 0 (word count)
	addi $s7, $s7, 1    # Move to the next character
    	j LOOP_WORD_CT   # Continue loop

INCREASE_CHAR:
	# addi 	$t0, $zero, 0 	# t0 = 0 (word count)
    	addi $s7, $s7, 1    # Move to the next character
    	j SKIP_SPACE         # Check the next character

	
LOOP_WORD_CT: 
	
	add 	$t2, $s7, $t1		# t2 = pointer to access array at. 
	lb 	$t3, 0($t2)		# t3 = str[i] 
	beq 	$t3, $zero, PRINT_WORD_CT 	# if (str[i] = null), last print.
	
	addi 	$t4, $t1, 1		# t4 = i + 1
	add 	$t4, $s7, $t4 		# t4 = &str[i + 1]
	lb 	$t4, 0($t4) 		# t4 = str[i + 1]
	

	addi 	$t5, $zero, 0x20 	# t5 = " " 
	addi 	$t6, $zero, 0xA		# t6 = "\n"
	
	beq 	$t3, $t5, INCREASE_CHAR_INDEX	# if str[i] = " " continue with loop. 
	beq 	$t3, $t6,  INCREASE_CHAR_INDEX	# if str[i] = "\n" continue with loop.


	beq 	$t4, $t5, INCREASE_CT 	# if str[i + 1] = " " then count ++
	
	
	beq 	$t4, $t6,  INCREASE_CT	# if str[i + 1] = "/n" then count ++
	
	beq	$t4, $zero, PRINT_WORD_CT
	
	j INCREASE_CHAR_INDEX
	 
INCREASE_CT:
	addi 	$t0, $t0, 1		# count ++
INCREASE_CHAR_INDEX:
	addi 	$t1, $t1, 1		# i ++
    	j LOOP_WORD_CT
	
	
	
SUB_CT:
	addi 	$t0, $t0, -1		# count --
	# Print COUNT_MSG
	addi $v0, $zero, 4       # syscall code for printing string
	la $a0, COUNT_MSG           # load address of the string "Word Count:\n" into $a0
	syscall
	
	
	addi 	$v0, $zero, 1 		# print_int
	add 	$a0, $zero, $t0		# print_int(count)
	syscall
	
    	addi $a0, $zero, 10    # ASCII value for newline
   	addi $v0, $zero, 11    # Syscall code for printing character
    	syscall
	
    	addi $a0, $zero, 10    # ASCII value for newline
   	addi $v0, $zero, 11    # Syscall code for printing character
    	syscall
	j REV_STR
	
	
PRINT_WORD_CT: 
    	#and $t5, $t3, $t4      # Perform bitwise AND of $t3 and $t4, result in $t5
    	beq $t3, $zero, SUB_CT  # Branch to 'SUB_CT' if $t5 (result of AND) is equal to 0
	beq $t4, $t5, SUB_CT 	# if str[i + 1] = " " then count ++
	beq $t4, $t6,  SUB_CT	# if str[i + 1] = "/n" then count ++
	
	
	# Print COUNT_MSG
	addi $v0, $zero, 4       # syscall code for printing string
	la $a0, COUNT_MSG           # load address of the string "Word Count:\n" into $a0
	syscall
	
	
	addi 	$v0, $zero, 1 		# print_int
	add 	$a0, $zero, $t0		# print_int(count)
	syscall
	
    	addi $a0, $zero, 10    # ASCII value for newline
   	addi $v0, $zero, 11    # Syscall code for printing character
    	syscall
	
    	addi $a0, $zero, 10    # ASCII value for newline
   	addi $v0, $zero, 11    # Syscall code for printing character
    	syscall
	
	LEAVE_WORD_CT:				# End of Task 4 countWords
	j REV_STR



# revString:
# This code reverses the given string str in memory.
# It uses a two-pointer approach, starting from the beginning and end of the string, swapping characters until they meet in the middle.
# It then prints "String successfully swapped!" followed by a blank line.


REV_STR:
	la 	$s7, str			# s7 = &str


	la	$s4, revString		# s4 = &revString
	lw 	$s4, 0($s4) 		# s4 = revString


	addi 	$t0, $zero, 1
	bne 	$s4, $t0, END		# if (revString == 1)
	
	add 	$t0, $zero, $zero 	# t0 = head(0)
	add 	$t1, $zero, $zero	# t1 = tail(0)
	
	# find length of string by searching for first null
	FIND_LEN:
	add 	$t2, $s7, $t1 		# t2 = &str[tail]
	lb	$t2, 0($t2) 		# t2 = str[tail] 
	beq 	$t2, $zero, endWhile1 	# if (str[tail] == 0) exit while loop
	addi 	$t1, $t1, 1		# tail ++
	j FIND_LEN
	
	endWhile1:
	addi 	$t9, $zero, 1		# t9 = 1
	sub 	$t9, $zero, $t9		# t9 = -1
	add 	$t1, $t1, $t9 		# tail -- 
	

	PERFORM_SWAP: 
	slt 	$t4, $t0, $t1		# t4 = (head < tail)
	addi 	$t2, $zero, 1		# t2 = 1
		
	bne 	$t2, $t4, PRINT_REV 	# if ( head > tail ), skip while loop
	
	add 	$t2, $s7, $t0 		# t2 = &str[head]
	lb	$t5, 0($t2) 		# t5 = str[head] 
	
	add 	$t3, $s7, $t1 		# t2 = &str[tail]
	lb	$t6, 0($t3) 		# t6 = str[tail] 
	
	sb 	$t5, 0($t3)		# str[tail] = str[head]
	sb 	$t6, 0($t2)		# str{head] = str{tail]
	
	
	addi 	$t0, $t0, 1		# head ++
	
	addi 	$t9, $zero, 1		# t9 = 1
	sub 	$t9, $zero, $t9		# t9 = -4
	
	add	$t1, $t1, $t9		# tail --
	
	j PERFORM_SWAP
	
	PRINT_REV:
	
	addi 	$v0, $zero, 4 		# print_str
	la 	$a0, SWAPPED_MSG		# print_str("String successfully swapped!\n")
	syscall
	
    	addi $a0, $zero, 10    # ASCII value for newline
   	addi $v0, $zero, 11    # Syscall code for printing character
    	syscall

    	
END:

    	lw $ra, 4($sp)          # get return address from stack
    	lw $fp, 0($sp)          # restore the caller’s frame pointer
    	addiu $sp, $sp, 24      # restore the caller’s stack pointer
    	jr $ra                  # return to caller’s code
