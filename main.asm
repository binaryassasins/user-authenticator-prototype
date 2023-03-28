# Lab 1 exercise
# Author: Mohamad Syafiq Asyraf Bin Bharudin
# This program illustrates how authentication of a user is being done by comparing input of the user with several samples provided
# (usernames defined in database) byte by byte

.data 
	welcome:		.asciiz "Welcome! This is an authentication process\n"
	username:		.asciiz "Please enter a valid username (less than 10 characters): "
	
	# Define three usernames 
	user1:			.asciiz "Syafiq"
	user2:			.asciiz "Abu"
	user3:			.asciiz "Ali"
	# Store all three usernames in an array
	database:		.word user1, user2, user3
	
	auth:			.asciiz "Hi @"
	input:			.space 11 # Input size require 10 bytes (1 character requires 1 byte) + 1 byte extra for null terminator (\0)
	invalidMsg:		.asciiz "Sorry, invalid username "

.text
	main:
		li 	$t1, 0	# Initial offset of the array (0 bytes).
		li 	$t2, 8	# Last offset of the array (0+4+4 = 8 bytes).
		
		# Print out a message string with a welcome message "Welcome! This is an authentication process\n"
		li	$v0, 4 # Syscall service to print string
		la	$a0, welcome
		syscall

		# Print out a message string with the message "Please enter a valid username (less than 10 characters) "
		li	$v0, 4 # Syscall service to print string
		la 	$a0, username
		syscall
	
		# Get an input from user to enter a username (string) less than 10 characters.
		li	$v0, 8 # Syscall service to read string from user
		la	$a0, input
		la	$a1, 10 # Declare 10 characters to be read at most
		syscall
	
	# Do the process to authenticate the username.
	Loop:
		la	$s0, database # Load the address of the database into $s0
		lw 	$a0, database($t1) # Load the word base address into $a0 
		lb	$s1, 0($a0) # Load bytes of characters with an offset of 0 into $s1
		
		lb	$s2, input # Load bytes of characters of input into $s2
		
		beq	$s1,$s2, Authenticated # If $s1 is equal to $s2 (compare byte by byte), then do Authenticated subroutine, else execute instruction below
		addi 	$t1, $t1, 4 # Increment the current offset ($t1 = 0) by 4 bytes (+1 iteration) and assign to $t1
		ble 	$t1, $t2, Loop # Iterate for 2^n = $t2 = 8 = 2^3 = 3 times (3 elements in the array), do Loop subroutine for n-1 times [ble = branch if less than or equals to]
		jal 	InvalidUser # Jump and link to InvalidUser subroutine
		
		# End of program	
		li $v0, 10
		syscall

	# Greet user that has been validated
	Authenticated:
		li	$v0,4
		la	$a0,auth
		syscall
		# Append user input 
		li	$v0,4
		la	$a0,input
		syscall
	
		# End of program
		li $v0, 10
		syscall

	# Print invalid message if the user doesn't exist
	InvalidUser:
		li	$v0, 4
		la	$a0, invalidMsg
		syscall
		
		jr $ra # Return to the next instruction of the register address