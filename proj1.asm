# Vivian Yee
# VIYEE
# 112145534

.data
# Command-line arguments
num_args: .word 0
addr_arg0: .word 0
addr_arg1: .word 0
no_args: .asciiz "You must provide at least one command-line argument.\n"

# Error messages
invalid_operation_error: .asciiz "INVALID_OPERATION\n"
invalid_args_error: .asciiz "INVALID_ARGS\n"

# Output strings
royal_flush_str: .asciiz "ROYAL_FLUSH\n"
straight_flush_str: .asciiz "STRAIGHT_FLUSH\n"
four_of_a_kind_str: .asciiz "FOUR_OF_A_KIND\n"
full_house_str: .asciiz "FULL_HOUSE\n"
simple_flush_str: .asciiz "SIMPLE_FLUSH\n"
simple_straight_str: .asciiz "SIMPLE_STRAIGHT\n"
high_card_str: .asciiz "HIGH_CARD\n"

zero_str: .asciiz "ZERO\n"
neg_infinity_str: .asciiz "-INF\n"
pos_infinity_str: .asciiz "+INF\n"
NaN_str: .asciiz "NAN\n"
floating_point_str: .asciiz "_2*2^"

# Put your additional .data declarations here, if any.

# Main program starts here
.text
.globl main
main:
    # Do not modify any of the code before the label named "start_coding_here"
    # Begin: save command-line arguments to main memory
    sw $a0, num_args
    beqz $a0, zero_args
    li $t0, 1
    beq $a0, $t0, one_arg
two_args:
    lw $t0, 4($a1)
    sw $t0, addr_arg1
one_arg:
    lw $t0, 0($a1)
    sw $t0, addr_arg0
    j start_coding_here
zero_args:
    la $a0, no_args
    li $v0, 4
    syscall
    j exit
    # End: save command-line arguments to main memory

start_coding_here:
    # Start the assignment by writing your code here
    j check_first # Checks if the first command-line argument

# PART 1 
check_first: # Checks first command-line argument
    lw $s0, addr_arg0 # Loads first command-line argument into $s0
    lbu $t0, 0($s0) # Loads first byte of $s0 into $t0
    li $t1, 'M'
    li $t2, 'F'
    li $t3, 'P'
    beq $t0, $t1, only_one_char # If first character is 'M', jump to only_one_char
    beq $t0, $t2, only_one_char # If first character is 'F', jump to only_one_char
    beq $t0, $t3, only_one_char # If first character is 'P', jump to only_one_char
    j invalid_operation_error_print # If neither of these characters, print 'INVALID_OPERATION'
    
only_one_char: # Checks if the first command-line argument has one char
    lw $s0 addr_arg0 # Loads first command-line argument into $s0
    lbu $t0,1($s0) # Loads second byte of $s0 into $t0
    bnez $t0, invalid_operation_error_print # If $t0 is not 0 (has two chars) print 'INVALID_OPERATION'
    j check_total_line_args # Checks what letter is being commanded 
    
check_total_line_args: # Checks the total number of line arguments
    lw $t0, num_args # Loads the number of arguments in command-line
    li $t1, 2 # Must have two line arguments
    bne $t1, $t0, invalid_args_error_print # If it doesn't have two, print 'INVALID_ARGS'exit
    j check_which_func # Checks which function is being typed
    
check_which_func:
    lw $s0, addr_arg0 # Loads first command-line argument into $s0
    lbu $t0, 0($s0) # Loads first byte of $s0 into $t0
    li $t1, 'M'
    li $t2, 'F'
    li $t3, 'P'
    beq $t0, $t1, input_M # If first character is 'M', jump to input_M
    beq $t0, $t2, input_F # If first character is 'F', jump to input_F
    beq $t0, $t3, input_P # If first character is 'P', jump to input_P

# PART 2
input_M: # Interpreting 8 hex digits as a R-type instruction
    lw $t0, addr_arg1 # Second command argument
    li $t1, 0 # Beginning
    li $t2,8 # End
    li $s2, 0 # New holder
    li $s4, 4 # Counter for part_one_loop
    li $s5, 0 # R Offset for part_one_loop
    input_M_1_loop: # 0-9 -48, A-F -55
        lbu $s0, 0($t0) # Load first character into $s0
        li $t3, 57 # Where numbers end 
        bgt $s0, $t3, letter_to_binaryM # If the ASCII value is greater than 57, it's a letter
        j number_to_binaryM # It's a number
        letter_to_binaryM: # Converting letter to binary
            addi $s1, $s0, -55 # Converts ASCII to binary
            sll $s2, $s2, 4 # Moves the new holder 4 bits to the left
            add $s2, $s2, $s1 # Moves $s1 to the holder
            j input_M_1_loop_end # Jumps to counter
        number_to_binaryM: # Converting number to binary
            addi $s1, $s0, -48 # Converts ASCII to binary
            sll $s2, $s2, 4 # Moves the new holder 4 bits to the left
            add $s2, $s2, $s1 # Moves $s1 to the holder
            j input_M_1_loop_end # Jumps to counter
        input_M_1_loop_end: # Counter
            addi $t1, $t1, 1 # Counts
            addi $t0, $t0, 1 # Counts
            bne $t1, $t2, input_M_1_loop # Jumps to counter
            j print_part_one_loop
    print_part_one_loop: # Prints all numbers in MIPS R-type instruction
        srl $s3, $s2, 26 # Moves to the right 26 bits to get 6 bits
        bnez $s3, invalid_args_error_print
        move $a0, $s3
        li $v0, 1
        syscall # Prints value of opcode
        sll $t4, $s2, 6 # Makes the bits move 6 to the left 
        li $t5, ' ' # Space
        move $a0, $t5
        li $v0, 11
        syscall # Prints space
        j print_part_one_loop_2
        print_part_one_loop_2: # Loops through 5 bit values
            beqz $s4, print_part_one_loop_3 # Check if $s4 is 0
            sllv $s7, $t4, $s5 # Moves to the left $s5 bits
            srl $s3, $s7, 27 # Moves to the right 27 bits to get 5 bits
            move $a0, $s3 
            li $v0, 1
            syscall # Prints number
            li $t5, ' ' # Space
            move $a0, $t5
            li $v0, 11
            syscall # Prints space
            addi $s5, $s5, +5 # Counter +5 bits
            addi $s4, $s4, -1 # Counter of loop -1
            j print_part_one_loop_2 # Goes back to the loop_2
        print_part_one_loop_3: # Prints value of funct
            sll $s7, $s2, 26 # Moves to the right 26 bits to get rid of rest of bits
            srl $s3, $s7, 26 # Moves to the right 26 bits to get 6 bits
            move $a0, $s3
            li $v0, 1
            syscall # Prints value of funct
            j exit

# PART 3
input_F: # Interpreting 4 hex digits as a 16-bit float number
    lw $t0, addr_arg1
    li $t1, 0 # Beginning
    li $t2, 4 # End
    input_F_1_loop: # 0-9 -48, A-F -55
        lbu $s0, 0($t0) # Load first character into $s0
        li $t3, 57 # Where numbers end 
        li $t4, 70 # Where letters end
        bgt $s0, $t4, invalid_args_error_print # If ASCII value is greater than 70, it's out of range
        bgt $s0, $t3, letter_to_binaryF # If the ASCII value is greater than 57, it's a letter
        j number_to_binaryF # It's a number
        letter_to_binaryF: # Converting letter to binary
            addi $s1, $s0, -55 # Converts ASCII to binary
            sll $s2, $s2, 4 # Moves the new holder 4 bits to the left
            add $s2, $s2, $s1 # Moves $s1 to the holder
            j input_F_1_loop_end # Jumps to counter
        number_to_binaryF: # Converting number to binary
            addi $s1, $s0, -48 # Converts ASCII to binary
            sll $s2, $s2, 4 # Moves the new holder 4 bits to the left
            add $s2, $s2, $s1 # Moves $s1 to the holder
            j input_F_1_loop_end # Jumps to counter
        input_F_1_loop_end: # Counter
            addi $t1, $t1, 1 # Counts
            addi $t0, $t0, 1 # Counts
            bne $t1, $t2, input_F_1_loop # Jumps to counter
            j part_2_check
    part_2_check:
        sll $t0, $s2, 17
        beqz $t0, print_part_2_zero # If everything is 0, print 'ZERO'
        j print_part_2_check_1 # Checks the next test
        print_part_2_zero: # Prints 'ZERO'
            la $a0, zero_str
            li $v0, 4
            syscall # Prints 'ZERO'
            j exit
        print_part_2_check_1: # Next test
            srl $t0, $s2, 10 # Shift right 10 to get sign and exponent
            li $t1, 63
            li $t3, 31
            beq  $t0, $t3, print_part_2_plusinfornan # If sign is 1 and rest is 1, check for NAN or +inf
            beq $t0, $t1, print_part_2_neginfornan # If sign is 0 and rest is 1, check for NAN or -inf
            j print_part_2_loop # If nothing, continue
            print_part_2_neginfornan: # Check for NAN or -inf
                sll $t0, $s2, 22
                beqz $t0, print_part_2_neg_inf # If the frac are 0's, then it's -inf
                bnez $t0, print_part_2_NAN # If it's not 0, then its NAN
                j exit
                j print_part_2_loop
                print_part_2_neg_inf: # Print '-INF'
                    la $a0, neg_infinity_str
   		     li $v0, 4  
    		     syscall # Print '-INF'
    		     j exit 
             print_part_2_plusinfornan: # Check for NAN or +inf
                sll $t0, $s2, 22
                beqz $t0, print_part_2_plus_inf # If the frac are 0's, then it's +inf
                bnez $t0, print_part_2_NAN # If it's not 0, then its NAN
                j print_part_2_loop
                print_part_2_plus_inf: # Print '+INF'
                    la $a0, pos_infinity_str
    		     li $v0, 4 
    		     syscall # Print '+INF'
    		     j exit 
   	print_part_2_NAN: # Print 'NAN'
   	    la $a0, NaN_str
   	    li $v0, 4
   	    syscall # Print 'NAN'
   	    j exit
        j print_part_2_loop
    print_part_2_loop: # Regular configuration
    	srl $s3, $s2, 15 # Get sign
    	bnez $s3, print_negative # If sign is one print negative
    	j print_part_2_1 # If sign is 0, skip print negative
    	print_negative:
    	    li $a0, '-'
    	    li $v0, 11
    	    syscall # Print negative
    	    j print_part_2_1
    	print_part_2_1: # Prints one and decimal
    	    li $a0, 1
    	    li $v0, 1
    	    syscall # Prints 1
    	    li $a0, '.'
    	    li $v0, 11
    	    syscall # Prints decimal
    	 j print_part_2_loop_frac
    print_part_2_loop_frac: # Print binary fraction
    	sll $s3, $s2, 22 # Makes the binary fraction by moving 22 spaces left
    	srl $s3, $s3, 22 # Makes the binary fraction by moving it back to the right
    	li $t5, 0 # Counter
    	li $t6, 10 # Counter stop
    	li $t7, -512 # -2^9
    	move $s4, $s3 # Remainder
    	j binary_print_part_2 # Print part 2 binary
    	binary_print_part_2: # Print part 2 binary
    	    div $s4, $t7 # Divide previous remainder (s4) by 2^counter (t7)
    	    mflo $s5 # Quotient
    	    beqz $s5, no_minus_t7 # If quotient is 0
    	    j minus_t7 # If quotient is 1
    	    minus_t7: # Minus t7 to remainder
    	        add $s4, $s4, $t7 # Adds 2^counter (t7)
    	        li $a0, 1
    	        li $v0, 1
    	        syscall # Prints 1
    	        j end_part_2_loop # Jumps to counter
    	    no_minus_t7: # Prints 0
    	        li $a0, 0
    	        li $v0, 1
    	        syscall # Prints 0
    	        j end_part_2_loop # Jumps to counter
    	    end_part_2_loop: # Counter
    	    	li $s6, 2
    	        div $t7, $s6 # Divides 2^counter (t7) by 2 to get 2^counter-1
    	        mflo $t7 # Replaces t7 value with quotient
    	        move $a0, $t7
    	        addi $t5, $t5, 1 # Counter
    	        bne $t6, $t5, binary_print_part_2 # If counter is not 9, go back to loop
    	        j print_part_2_loop_exp
    print_part_2_loop_exp:
        la $a0, floating_point_str
        li $v0, 4
        syscall # Print '_2*2^'
        sll $s3, $s2, 17
        srl $s3, $s3, 27
        addi $s3, $s3, -15 # Subtract bias of 15
        move $a0, $s3
        li $v0, 1
        syscall # Print exponent
        li $a0, '\n'
        li $v0, 11
        syscall # New line
        j exit    	   

# PART 4
input_P: # Identifying five card hand 	from draw poker
    lw $t0, addr_arg1
    li $s1, 0 # Holds numbers 
    li $s2, 0 # Holds Suits
    li $t1, 0
    li $t2, 5
    li $t3, 50 # ASCII value of 2
    li $t4, 57 # ASCII value of 9
    j part_3_loop_1_check
    part_3_loop_1_check:
        lbu $s0, 0($t0)
        bge $s0, $t3, part_3_loop_1_check_2 # If it's a number greater than 1's ASCII value
        j invalid_args_error_print
        part_3_loop_1_check_2:
            ble $s0, $t4, part_3_check_goodN # It's a number 2-9
            j letters
            part_3_check_goodN:
                addi $s3, $s0, -48
                j part_3_check_good
            letters:
                li $s4, 'A' # Ace
                beq $s4, $s0, part_3_check_goodA
                j after_a
                part_3_check_goodA:
                    li $s3, 14 # Value of A is 14
                    j part_3_check_good
                after_a:
                li $s4, 'J' # Jack
                beq $s4, $s0, part_3_check_goodJ
                j after_j
                part_3_check_goodJ:
                    li $s3, 11 # Value of J is 11
                    j part_3_check_good
                after_j:
                li $s4, 'Q' # Queen
                beq  $s4, $s0, part_3_check_goodQ
                j after_q
                part_3_check_goodQ:
                    li $s3, 12 # Value of Q is 12
                    j part_3_check_good
                after_q:
                li $s4, 'K' # King
                beq $s4, $s0, part_3_check_goodK
                j after_k
                part_3_check_goodK:
                    li $s3, 13 # Value of K is 13
                    j part_3_check_good
                after_k:
                li $s4, 'T' # Ten
                beq $s4, $s0, part_3_check_goodT
                j invalid_args_error_print
                part_3_check_goodT:
                    li $s3, 10 # Value of T is 10
                    j part_3_check_good
        part_3_check_good:
            addi $t0, $t0, 2 # Bit skips suits
            addi $t1, $t1, 1 # Counter
            sll $s1, $s1, 4
            add $s1, $s1, $s3
            blt $t1, $t2, part_3_loop_1_check # Loop
            lw $t0, addr_arg1
            lbu $s0,1($t0) # Set value of initial loop to be the second char
            li $t1, 1
            li $t2, 6
            j part_3_loop_2_check # Checks suit
            
    part_3_loop_2_check: # Checks suit
        lbu $s0,1($t0)
        li $t4, 83 # Spades
        li $t5, 67 # Clubs
        li $t6, 72 # Hearts
        li $t7, 68 # Diamonds
        beq $t4, $s0, part_3_check_good2S
        j after_S
        part_3_check_good2S:
            li $s3, 1 # Value of spades is 1
            j part_3_check_good2
        after_S:
        beq $t5, $s0, part_3_check_good2C
        j after_C
        part_3_check_good2C:
            li $s3, 2 # Value of clover is 2
            j part_3_check_good2
        after_C:
        beq $t6, $s0, part_3_check_good2H
        j after_H
        part_3_check_good2H:
            li $s3, 3 # Value of hearts is 3
            j part_3_check_good2
        after_H:
        beq $t7, $s0, part_3_check_good2D
        j invalid_args_error_print
        part_3_check_good2D:
            li $s3, 4 # Value of diamonds is 4
            j part_3_check_good2
        part_3_check_good2:
            addi $t0, $t0, 2 # But skips numbers 
            addi $t1, $t1, 1 # Counter
            sll $s2, $s2, 4
            add $s2, $s2, $s3
            blt $t1, $t2, part_3_loop_2_check # Loop
            j start_checking_hand # Start finding value of hand
            
    start_checking_hand:
        li $t0, 0 # New sorted number
        li $t1, 0 # New sorted suit
        j selection_sort
        selection_sort:
            li $t3, 20 # Original shift right
            li $t8, 15 # Minimum
            li $t7, 0 # Address of minimum
            move $s3, $s1
            li $s4, 5 # Counter for how many loops
            li $s5, 20
            j selection_sort_1
            selection_sort_1: # Selection sort start
                addi $t3, $t3, -4 # Counter
                srlv $t4, $s3, $t3
                andi $t4, $t4, 0x0000000F
                blt $t4, $t8, new_min1 # If t4 is new min, set as new min
                j no_new_min
                new_min1: # set t4 as new min
                    move $t8, $t4
                    move $t7, $t3 # set t7 as adress of new min
                    bnez $t3, selection_sort_1 # go back to loop unless counter is 0
                    j remove1 
                no_new_min:
                    bnez $t3, selection_sort_1 # No new min, go back to loop unless counter is 0
                    j remove1
                remove1:
                    addi $t7, $t7, 4
                    srlv $t6, $s3, $t7
                    addi $t7, $t7, -4
                    sllv $t6, $t6, $t7 # Gets the values to the left of the min
                    beqz $t7, zero_placement
                    j no_zero_placement
                    zero_placement:
                        li $t9, 0
                        j zero_placement_after
                    no_zero_placement:
                        li $t9, -1
                        addi $t7, $t7, -32
                        mul $t7, $t7, $t9
                        sllv $t9, $s3, $t7
                        srlv $t9, $t9, $t7 # Gets the values to the right of the min
                    zero_placement_after:
                        add $s3, $t9, $t6 # Removes value of minimum
                        sll $t0, $t0, 4
                        add $t0, $t0, $t8
                        addi $s4, $s4, -1
                        bnez $s4, setup_selection_sort_1  # goes back to loop if still have values
                        li $t3, 20 # Original shift right
                        li $t8, 15 # Minimum
                        li $t7, 0 # Address of minimum
                        move $s3, $s2
                        li $s4, 5 # Counter for how many loops
                        li $s5, 20
                        j selection_sort_2 # sorting for suits
                    setup_selection_sort_1:
                        addi $s5, $s5, -4
                        move $t3, $s5 # Original shift right
                        li $t8, 15 # Minimum
                        li $t7, 0 # Address of minimum
                        j selection_sort_1
            selection_sort_2: # sorting for suits
                addi $t3, $t3, -4
                srlv $t4, $s3, $t3
                andi $t4, $t4, 0x0000000F
                blt $t4, $t8, new_min2 # if t4 is new min, set as new min
                j no_new_min2
                new_min2: 
                    move $t8, $t4 # set t4 as new min
                    move $t7, $t3
                    bnez $t3, selection_sort_2 # go back and loop if counter is not 0
                    j remove2
                no_new_min2:
                    bnez $t3, selection_sort_2 # go back and loop if counter is not 0
                    j remove2
                remove2:
                    addi $t7, $t7, 4
                    srlv $t6, $s3, $t7
                    addi $t7, $t7, -4
                    sllv $t6, $t6, $t7 # Gets the values to the left of the min
                    beqz $t7, zero_placement2
                    j no_zero_placement2
                    zero_placement2:
                        li $t9, 0
                        j zero_placement_after2
                    no_zero_placement2:
                        li $t9, -1
                        addi $t7, $t7, -32
                        mul $t7, $t7, $t9
                        sllv $t9, $s3, $t7
                        srlv $t9, $t9, $t7 # Gets the values to the right of the min
                    zero_placement_after2:
                        add $s3, $t9, $t6 # Removes value of minimum
                        sll $t1, $t1, 4
                        add $t1, $t1, $t8
                        addi $s4, $s4, -1
                        bnez $s4, setup_selection_sort_2 # goes back to loop if still have values
                        j straight
                    setup_selection_sort_2:
                        addi $s5, $s5, -4
                        move $t3, $s5 # Original shift right
                        li $t8, 15 # Reset minimum
                        li $t7, 0 # Address of minimum
                        j selection_sort_2
    straight:
        li $t2, 4
        li $t3, 16
        j straight_loop_1
        straight_loop_1:
            srlv $t4, $t0, $t3 # get value
            andi $t4, $t4, 0x0000000F
            addi $t3, $t3, -4
            srlv $t5, $t0, $t3 # get value of the one after
            andi $t5, $t5, 0x0000000F
            addi $t4, $t4, 1
            beqz $t3, straight_check_suit # if counter is done, check if suit is all same
            beq $t5, $t4, straight_loop_1 # loop back if it's chronological
            j full_house # if neither, check if its a full house
            straight_check_suit: # check if suit is all the same
                li $t3, 16 # initialize counter
                j straight_check_suit_loop_1
                straight_check_suit_loop_1:
                    beqz $t3, royal_flush # if counter is done, go check if its royal flush
                    srlv $t4, $t1, $t3 # get value
                    andi $t4, $t4, 0x0000000F
                    addi $t3, $t3, -4
                    srlv $t5, $t1, $t3 # get value of the one after
                    andi $t5, $t5, 0x0000000F
                    beq $t5, $t4, straight_check_suit_loop_1 # loop back if it's chronological
                    j simple_straight_str_print # if neither, it's just a simple straight
            royal_flush: # check if royal flush
                sll $t2, $t1, 28
                srl $t2, $t2, 28
                li $t3, 1
                beq $t2, $t3, royal_flush2 # If all spades
                j straight_flush_str_print
                royal_flush2:
                    sll $t2, $t0, 28
                    srl $t2, $t2, 28
                    li $t3, 14
                    beq $t2, $t3, royal_flush_str_print # If last number is Ace
                    j straight_flush_str_print # its a royal flush
        full_house: # check if its full house
            li $t2, 8 # Number of reps counter
            li $t3, 16 # if the first three are the same number
            j full_house_loop_1
            full_house_loop_1:
                beq $t3, $t2, full_house_loop_102 # If three counter, go check if there's double
                srlv $t4, $t0, $t3 # get value
                andi $t4, $t4, 0x0000000F
                addi $t3, $t3, -4
                srlv $t5, $t0, $t3 # get value after that
                andi $t5, $t5, 0x0000000F
                beq $t5, $t4, full_house_loop_1
                j full_house_loop_2
                full_house_loop_102: # Check if other has double
                    sll $t2, $t0, 28
                    srl $t2, $t2, 28
                    sll $t3, $t0, 24
                    srl $t3, $t3, 28
                    beq $t2, $t3, full_house_str_print # if theyre the same value, its a full house
                    beq $t3, $t5, four_of_a_kind_str_print # if the same number repeats again, its four of a kind
                    j exit
            full_house_loop_2:
                li $t3, 8 # if last three are the same number
                j full_house_loop_201
                full_house_loop_201:
                    beqz $t3, full_house_loop_3 # If three counter, go check if there's double
                    srlv $t4, $t0, $t3 # get value
                    andi $t4, $t4, 0x0000000F
                    addi $t3, $t3, -4
                    srlv $t5, $t0, $t3 # get value after that
                    andi $t5, $t5, 0x0000000F
                    beq $t5, $t4, full_house_loop_201
                    j flush
                    full_house_loop_3:
                        srl $t2, $t0, 16
                        sll $t3, $t0, 16
                        srl $t3, $t3, 28
                        beq $t2, $t3, full_house_str_print # if theyre the same value, its a full house
                        beq $t3, $t5, four_of_a_kind_str_print # if the same number repeats again, its four of a kind
        flush:
            li $t3, 16
            j flush_1
            flush_1:
                beqz $t3, simple_flush_str_print # if counter is 0, its a simple flush
                srlv $t4, $t1, $t3 # get value
                andi $t4, $t4, 0x0000000F
                addi $t3, $t3, -4
                srlv $t5, $t1, $t3 # get value after that
                andi $t5, $t5, 0x0000000F
                beq $t5, $t4, flush_1 # if theyre equal, loop back
                j high_card_str_print # if it has no combos, its just high card
        
royal_flush_str_print: # Print 'ROYAL FLUSH'
    la $a0, royal_flush_str
    li $v0, 4
    syscall
    j exit

straight_flush_str_print: # Print 'STRAIGHT FLUSH'
    la $a0, straight_flush_str
    li $v0, 4
    syscall
    j exit

four_of_a_kind_str_print: # Print FOUR OF A KIND
    la $a0, four_of_a_kind_str
    li $v0, 4
    syscall
    j exit

full_house_str_print: # Print FULL HOUSE
    la $a0, full_house_str
    li $v0, 4
    syscall
    j exit

simple_flush_str_print: # Print SIMPLE FLUSH
    la $a0, simple_flush_str
    li $v0, 4
    syscall
    j exit

simple_straight_str_print: # Print SIMPLE STRAIGHT
    la $a0, simple_straight_str
    li $v0, 4
    syscall
    j exit

high_card_str_print: # Print HIGH CARD
    la $a0, high_card_str
    li $v0, 4
    syscall
    j exit

        
invalid_operation_error_print: # Prints 'INVALID_OPERATION'
    la $a0, invalid_operation_error 
    li $v0, 4 
    syscall # Prints 'INVALID_OPERATION'
    j exit 

invalid_args_error_print: # Prints 'INVALID_ARGS'
    la $a0, invalid_args_error 
    li $v0, 4 
    syscall # Prints 'INVALID_ARGS'
    j exit 

exit:
    li $v0, 10   # terminate program
    syscall
