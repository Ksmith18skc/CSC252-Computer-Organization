.data
    input_string: .space 256       # Space for input string
    output_string: .space 256      # Space for output string
    new_line: .asciiz "\n"
    prompt: .asciiz "Encode or Decode a sentence? (yes/no/decode): "
    start_prompt: .asciiz "welcom back agent...(begin message below) "
    file_name: .asciiz "C:/Users/socce/252workspace/asm6/asm6/filesaveFolder/testFile.txt"
    yes_response: .asciiz "yes"
    decode_response: .asciiz "decode"
    error_message: .asciiz "Error opening file.\n"
    toWrite: .asciiz "Ewtfffff.\n"
    encoded: .asciiz "Encoded Results:\n"
    name_prompt: .asciiz "Enter your name: "
    dept_prompt: .asciiz "Enter your department: "
    time_prompt: .asciiz "Enter the current time: " # sort of captcha
    passcode_prompt: .asciiz "Enter your secret passcode: "
    name: .space 50                # Space for the user's name
    passcode: .space 50            # Space for the secret passcode
    dept: .space 50                # Space for the user's dept
    time: .space 50                # Space for the user's time
    
.text
.globl main

main:
    # Print time prompt
    li $v0, 4
    la $a0, time_prompt
    syscall
    
    # Read time
    li $v0, 8
    la $a0, time
    li $a1, 50
    syscall

    # Print dept prompt
    li $v0, 4
    la $a0, dept_prompt
    syscall
    
    # Read dept
    li $v0, 8
    la $a0, dept
    li $a1, 50
    syscall

    # Print name prompt
    li $v0, 4
    la $a0, name_prompt
    syscall

    # Read name
    li $v0, 8
    la $a0, name
    li $a1, 50
    syscall

    # Print passcode prompt
    li $v0, 4
    la $a0, passcode_prompt
    syscall

    # Read passcode
    li $v0, 8
    la $a0, passcode
    li $a1, 50
    syscall

    # Continue with the original code
    li $v0, 4
    la $a0, start_prompt
    syscall
    
    # Print a newline
    li $v0, 4
    la $a0, new_line
    syscall

    # Wait for any key to continue
    li $v0, 8
    la $a0, input_string
    li $a1, 1
    syscall

    # Proceed to the original main functionality
    j prompt_loop



    # Initial prompt loop
prompt_loop:
    # Read a string from the user
    li $v0, 8                    # Syscall code for read_string
    la $a0, input_string         # Address of the buffer to store the string
    li $a1, 256                  # Maximum number of characters to read
    syscall

    # Clear the output_string buffer before transformation
    la $t1, output_string        # Pointer to output string
    li $t3, 256                  # Number of bytes to clear
    clear_output_loop:
        sb $zero, 0($t1)         # Store zero in the output string
        addi $t1, $t1, 1         # Increment the output string pointer
        addi $t3, $t3, -1        # Decrement the count
        bnez $t3, clear_output_loop # Continue clearing if count not zero

    # Prepare for transformation
    la $t0, input_string         # Pointer to input string
    la $t1, output_string        # Pointer to output string
    j transform_loop             # Jump to start transformation

transform_loop:

    lb $t2, 0($t0)                 # Load byte from input string
    beqz $t2, end_transform        # End loop if null character

    # Check and transform the character (both encode and decode operations are symmetric)
    addi $t3, $zero, 'a'
    addi $t4, $zero, 'm'
    addi $t5, $zero, 'n'
    addi $t6, $zero, 'z'
    addi $t7, $zero, 'A'
    addi $t8, $zero, 'M'
    addi $t9, $zero, 'N'
    addi $s1, $zero, 'Z'
    blt $t2, $t3, not_lowercase    # Jump if character is less than 'a'
    ble $t2, $t4, rot13_add        # Check if character is between 'a' and 'm'
    bge $t2, $t5, rot13_sub        # Check if character is between 'n' and 'z'

not_lowercase:
    blt $t2, $t7, next_char        # Jump if character is less than 'A'
    ble $t2, $t8, rot13_add        # Check if character is between 'A' and 'M'
    bge $t2, $t9, rot13_sub        # Check if character is between 'N' and 'Z'

    # If not a letter, just copy it to output
    j next_char

rot13_add:
    addi $t2, $t2, 13              # Add 13 to the character
    j next_char

rot13_sub:
    addi $t2, $t2, -13             # Subtract 13 from the character

next_char:
    sb $t2, 0($t1)                 # Store byte in output string
    addi $t0, $t0, 1               # Increment input string pointer
    addi $t1, $t1, 1               # Increment output string pointer
    j transform_loop               # Repeat the loop

end_transform:
    beq $s6, 1, decode_print    # If decode flag is set, skip copying to encoded buffer

    # Append to encoded buffer
    la $t0, output_string          # Start of the output string
    la $t1, encoded                # Start of the encoded buffer

find_end_of_encoded:
    lb $t3, 0($t1)                 # Load byte from encoded buffer
    beqz $t3, copy_to_encoded      # Found end of encoded data
    addi $t1, $t1, 1               # Move to the next byte in encoded
    j find_end_of_encoded

copy_to_encoded:
    lb $t3, 0($t0)                 # Load byte from output string
    beqz $t3, finish_copy_to_encoded # Check for end of output string
    sb $t3, 0($t1)                 # Store byte in encoded buffer
    addi $t0, $t0, 1               # Move to next character in output string
    addi $t1, $t1, 1               # Move to next character in encoded buffer
    j copy_to_encoded

finish_copy_to_encoded:
    sb $zero, 0($t1)               # Null-terminate the encoded buffer



    # Print the transformed string
    li $v0, 4                      # Syscall code for print_string
    la $a0, output_string          # Address of the string to print
    syscall

    # Print a newline
    li $v0, 4
    la $a0, new_line
    syscall

    # Ask user if they want to encode/decode another sentence
    li $v0, 4                      # Syscall code for print_string
    la $a0, prompt
    syscall

    li $v0, 8                      # Syscall code for read_string
    la $a0, input_string           # Address of the buffer to store the response
    li $a1, 256
    syscall

    # Check if response is "yes"
    la $t0, input_string
    la $t1, yes_response
    la $t2, decode_response        # Address for "decode"
    li $t3, 3                      # Length of "yes"
    li $t4, 6                      # Length of "decode"
    li $v0, 1                      # Assume "yes"

compare_loop:
    beqz $t3, check_response       # End loop if end of "yes"
    lb $s0, 0($t0)                 # Load byte from input
    lb $s1, 0($t1)                 # Load byte from "yes"
    lb $s2, 0($t2)                 # Load byte from "decode"
    bne $s0, $s1, check_decode     # If bytes do not match "yes", check "decode"
    addi $t0, $t0, 1               # Increment input pointer
    addi $t1, $t1, 1               # Increment "yes" pointer
    addi $t3, $t3, -1              # Decrement length
    j compare_loop                 # Repeat loop

check_decode:
    bne $s0, $s2, exit_program     # If bytes do not match "decode", exit
    addi $t0, $t0, 1               # Increment input pointer
    addi $t2, $t2, 1               # Increment "decode" pointer
    addi $t4, $t4, -1              # Decrement length
    beqz $t4, decode               # If end of "decode", go to decode
    j check_decode                 # Continue checking "decode"

check_response:
    bnez $v0, prompt_loop          # If response was "yes", prompt again


decode:
    li $s6, 1                   # Set decode mode flag

    # Jump back to prompt for a string to decode
    j prompt_loop

decode_print:
    # Print only the output_string after decode command
    li $v0, 4                    # Syscall code for print_string
    la $a0, output_string        # Address of the string to print
    syscall

    # Print a newline
    li $v0, 4
    la $a0, new_line
    syscall




exit_program:
    # Compute the length of the encoded string
    la $a0, encoded              # Load the address of the encoded buffer
    li $t0, 0                    # Initialize length counter

compute_length:
    lb $t1, 0($a0)               # Load byte from encoded buffer
    beqz $t1, done_computing     # If byte is zero (end of string), stop
    addi $a0, $a0, 1             # Move to the next byte
    addi $t0, $t0, 1             # Increment the length counter
    j compute_length             # Loop until null terminator is found

done_computing:
    move $a2, $t0                # Move calculated length to $a2 for use in syscall

    # Open file
    li $v0, 13                   # open_file syscall code = 13
    la $a0, file_name            # get the file name
    li $a1, 1                    # file flag = write (1)
    syscall
    move $s1, $v0                # save the file descriptor in $s1

    # Write the encoded string to the file
    li $v0, 15                   # write_file syscall code = 15
    move $a0, $s1                # file descriptor
    la $a1, encoded              # address of the string to write
    move $a2, $t0                # length of the string to write
    syscall

    # Close the file
    li $v0, 16                   # close_file syscall code
    move $a0, $s1                # file descriptor to close
    syscall

    # Print a newline
    li $v0, 4
    la $a0, new_line
    syscall

    # Print all encoded strings
    li $v0, 4
    la $a0, encoded
    syscall

    # Exit the program
    li $v0, 10                   # exit syscall code
    syscall
