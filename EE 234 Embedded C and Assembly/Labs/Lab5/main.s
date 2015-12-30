# ***************************************************************************************************************************
# * Author: Michael Mentele                                                                                                              *
# * Course: EE 234 Microprocessor Systems - Lab # 5                                                                           *
# * Project: Robomal                                                                                                               *
# * File: CodeTemplate.s                                                                                                    *
# * Description: This file is provided to help you get started with MIPS32 (.s) assembly programs.                          *
# *              You may use this template for getting started with .S files also, in which preprocessor directives         *
# *              are allowed.                                                                                               *                           
# *                                                                                                                         *
# * Inputs:                                                                                                                 *
# * Outputs:                                                                                                                *
# * Computations:                                                                                                           *
# *                                                                                                                         *
# * Revision History:                                                                                                       *
# *************************************************************************************************************************** 


# ***************************************************************************************************************************
# *                                                                                                                         *
# *                                           Include Files                                                                 *
# *                                                                                                                         *
# ***************************************************************************************************************************


# ***************************************************************************************************************************
# *                                                                                                                         *
# *                                           Global Symbols                                                                *
# *                                                                                                                         *
# ***************************************************************************************************************************

.GLOBAL main

# ***************************************************************************************************************************
# *                                                                                                                         *
# *                                           Data Segment                                                                  *
# *                                                                                                                         *
# ***************************************************************************************************************************

# This is where all variables are defined.
# We generally assign pointer/address registers to these variables and access them indirectly via these registers.

.DATA                        # The start of the data segment

#Robot executes a square
square: .word 0x00420002,0x00410090,0x00440003,0x00420002,0x00410090,0x00440003,0x00420002,0x00410090,0x00440003,0x00420002,0x00410090,0x00440003,0x00330000, 0



# ***************************************************************************************************************************
# *                                                                                                                         *
# *                                           Code Segment                                                                  *
# *                                                                                                                         *
# ***************************************************************************************************************************

.TEXT                        # The start of the code segment
	
		                         
.ENT main                    # Setup a main entry point
main:

	##initialize and specify program
	LA $s1, square #fetch the instruction
	LI $s5, 0  #set data memory location to 0
	JAL setup_LEDs #map portb pins
	
		loop:
		
		#Decode
		LW $s2, 0($s1) #store the current instruction
		SRL $s3, $s2, 16  #zero out first 16 bits of opcode
		ANDI $s4, $s2, 0x0000FFFF #Preserve the operand
		
		#navigates to a subroutine that executes based on the opcode
		JAL	do
			
		#Array location
		ADDI $s1, $s1, 4 #move to the next instruction in your program
		ADDI $s5, $s5, 1 #add one to data cell counter
		SW $t0, 0($s1)
		BEQZ $t0, end
		
		J loop

	
end:

j ledflash
	
.END main

# ***************************************************************************************************************************
# *                                                                                                                         *
# *                                           Subroutine Definitions                                                        *
# *                                                                                                                         *
# ***************************************************************************************************************************

################################################### Do ######################################################################
# ***************************************************************************************************************************
# * Function Name: DO                                                                                                         *
# * Description: This subroutine determines which instruction to execute based on the opcode                                                                                                          *
# *                                                                                                                         *
# * Inputs:	s3	                                                                                                            *
# * Outputs: none	                                                                                                            *
# * Computations: none                                                                                                           *
# *                                                                                                                         *
# * Errors: ...                                                                                                                *
# * Registers Preserved: s1, ra                                                                                                    *
# *                                                                                                                         *
# * Preconditions: none                                                                                                         *
# * Postconditions: none                                                                                                        *
# *                                                                                                                         *
# * Revision History: 10.14.2012                                                                                                       *
# ***************************************************************************************************************************

.ENT do
do:

	doing:
	
		#initialize counter
		LI $t0, 0b10 #value of first instruction to be checked
		
		#Save return address because we have subroutines
		ADDI $sp, $sp, -4
		SW $ra, 0($sp) # push
		
		
		#data transfer instructions
		#READ
		BEQ $s3, $t0, rd
		rd:
			JAL read
			B done
		#WRITE
		BEQ $s3, $t0, wrt
		wrt:
			JAL write
			B done
		#LOAD
		BEQ $s3, $t0, ld
		ld:
			JAL load
			B done
		#STORE
		BEQ $s3, $t0, str
		str:
			JAL store
			B done
		
		
		#arithmetic instructions
		#ADDITION
		BEQ $s3, $t0, adtn
		adtn:
			JAL addition
			B done
		#SUBTRACTION
		BEQ $s3, $t0, sbtrt
		sbtrt:
			JAL subtraction
			B done
		#MULTIPLY
		BEQ $s3, $t0, mltpy
		mltpy:
			JAL multiply
			B done
		
		
		
		#Branch Instructions 
		#BRANCH
		BEQ $s3, $t0, brnch
		brnch:
			JAL branch
			B done
		#BRANCHEQ
		BEQ $s3, $t0, brneq
		brneq:
			JAL brancheq
			B done
		#BRANCHNE
		BEQ $s3, $t0, brnne
		brnne:
			JAL branchne
			B done
		#HALT
		BEQ $s3, $t0, hlt
		hlt:
			JAL halt
			B done
		
		
		#Robot Control Instructions (RCI)
		#LEFT
		BEQ $s3, $t0, lft
		lft:
			JAL left
			B done
		#RIGHT
		BEQ $s3, $t0, rht
		rht:
			JAL right
			B done
		#FORWARD
		BEQ $s3, $t0, fwd
		fwd:
			JAL forward
			B done
		#BACKWARD
		BEQ $s3, $t0, bwd
		bwd:
			JAL backward
			B done	
		#BRAKE
		BEQ $s3, $t0, brk
		brk:
			JAL brake
			B done
		
		#increment till we enter one of the subroutines
		ADDI $t0, 1
		
		J doing
			
		#you finished the instruction so return to main
		done:
			
		#reset return address
		LW $ra, 0($sp) # pop
		ADDI $sp, $sp, 4
	
		JR $ra

.END do
#############################################################################################################################
############################################### End of DO ###################################################################


####################################DATA TRANSFER INSTRUCTIONS ##############################################################
# ***************************************************************************************************************************
# * Function Name: READ                                                                                                          *
# * Description: Read PORTE 7:0 and store it into a specific data memory cell.                                                                                                          *
# *                                                                                                                         *
# * Inputs:	$s1, $s4, $s5	                                                                                                            *
# * Outputs: n/a	                                                                                                            *
# * Computations: none                                                                                                         *
# *                                                                                                                         *
# * Errors: n/a                                                                                                                *
# * Registers Preserved: $s1, $s4, $s5                                                                                                   *
# *                                                                                                                         *
# * Preconditions: none                                                                                                          *
# * Postconditions: PORTE is saved to a specific location                                                                                                        *
# *                                                                                                                         *
# * Revision History: 10.14.2012                                                                                                      *
# ***************************************************************************************************************************

.ENT read
read:

	#Set pins 0-7 to inputs preserve other pins
	LW $t0, (TRISE)
	ORI $t0, $t0, 0x00FF
	SW $t0, (TRISE)

	#Deterine relative memory cell locations
	SW $t0, 0($s4) #get operand
	SUB $t0, $t0, $s5 #subtract operand (location) from current location to get distance to data cell you want to store your read to) 
	
	#Navigate to and save porte at memory location
	SLL $t0, $t0, 2 #shift by 2 to multiply by 4 so you can shift your actual memory location
	LW $t1, (PORTE) #read port E
	ADD $a0, $s1, $t0 #go to memory location
	SW $t1, 0($a0) #save PORTE into the specific memory location

	J $ra


.END read

# ***************************************************************************************************************************
# * Function Name: WRITE                                                                                                         *
# * Description: Write to PORTE 7:0 from a specific data memory cell                                                                                                           *
# *                                                                                                                         *
# * Inputs: s1, s4, s5		                                                                                                            *
# * Outputs: none	                                                                                                            *
# * Computations: none                                                                                                          *
# *                                                                                                                         *
# * Errors: none                                                                                                                *
# * Registers Preserved: s1, s4, s5                                                                                                   *
# *                                                                                                                         *
# * Preconditions: none                                                                                                         *
# * Postconditions: PORTE gets the value of the selected memory cell.                                                                                                        *
# *                                                                                                                         *
# * Revision History: 10.14.2012                                                                                                      *
# ***************************************************************************************************************************

.ENT write
write:

	#setup portE pins 7:0 as outputs while preserving all other pins
	LW $t0, (TRISE)
	ANDI $t0, $t0, 0xFF00
	SW $t0, (TRISE)
	
	#Deterine relative memory cell locations
	SW $t0, 0($s4) #get operand
	SUB $t0, $t0, $s5 #subtract operand (location) from current location to get distance to data cell you want to store your read to) 
	
	#Navigate to memory location and save the value to porte
	SLL $t0, $t0, 2 #shift by 2 to multiply by 4 so you can shift your actual memory location
	ADD $a0, $s1, $t0 #go to memory location
	LW $t1, 0($a0) #read data memory cell
	#SW $t1, 0($LATE) #save memory cell to portE
	
	JR $ra

.END write

# ***************************************************************************************************************************
# * Function Name: LOAD                                                                                                         *
# * Description: Loads a word from a specific data memory cell into s0                                                                                                           *
# *                                                                                                                         *
# * Inputs: s4		                                                                                                            *
# * Outputs: s0	                                                                                                            *
# * Computations: none                                                                                                          *
# *                                                                                                                         *
# * Errors: none                                                                                                               *
# * Registers Preserved: s4, s5                                                                                                  *
# *                                                                                                                         *
# * Preconditions: none                                                                                                         *
# * Postconditions: Accumulator gets called data memory cell value                                                                                                         *
# *                                                                                                                         *
# * Revision History: 10.15.2012                                                                                                      *
# ***************************************************************************************************************************

.ENT load
load:

	#Deterine relative memory cell locations
	SW $t0, 0($s4) #get operand
	SUB $t0, $t0, $s5 #subtract operand (location) from current location to get distance to data cell you want to store your read to) 
	
	#Navigate to memory location and save the value to s0
	SLL $t0, $t0, 2 #shift by 2 to multiply by 4 so you can shift your actual memory location
	ADD $a0, $s1, $t0 #go to memory location
	LW $t1, 0($a0) #read data memory cell
	SW $t1, 0($s0) #save memory cell to the accumulator

.END load

# ***************************************************************************************************************************
# * Function Name: Store		                                                                                                          *
# * Description: Stores a word from s0 into a specific data memory cell.                                                                                                          *
# *                                                                                                                         *
# * Inputs: s1, s4, s5, 		                                                                                                            *
# * Outputs: memory cell	                                                                                                            *
# * Computations: none                                                                                                          *
# *                                                                                                                         *
# * Errors: none                                                                                                                *
# * Registers Preserved: s1,s4,s5                                                                                                   *
# *                                                                                                                         *
# * Preconditions: none                                                                                                         *
# * Postconditions: memory cell has accumulator value                                                                                                         *
# *                                                                                                                         *
# * Revision History: 10.15.2012                                                                                                      *
# ***************************************************************************************************************************

.ENT store
store:

	#Deterine relative memory cell locations
	SW $t0, 0($s4) #get operand
	SUB $t0, $t0, $s5 #subtract operand (location) from current location to get distance to data cell you want to store your read to) 
	
	#Navigate to the memory location and save the value from s0 into it
	SLL $t0, $t0, 2 #shift by 2 to multiply by 4 so you can shift your actual memory location
	ADD $a0, $s1, $t0 #go to memory location
	#SW $s0, $a0

.END store
#############################################################################################################################
################################################ END DATA TRANSFER INSTRUCTIONS #############################################

################################################ ARITHMETIC INSTRUCTIONS ####################################################
# ***************************************************************************************************************************
# * Function Name: ADD                                                                                                         *
# * Description: Adds a word from a cell in data memory to s0. The result is stored back into s0                                                                                                           *
# *                                                                                                                         *
# * Inputs: Data Cell		                                                                                                            *
# * Outputs: s0	                                                                                                            *
# * Computations: s0 - memory cell                                                                                                           *
# *                                                                                                                         *
# * Errors: ...                                                                                                                *
# * Registers Preserved: s1, s4, s5                                                                                               *
# *                                                                                                                         *
# * Preconditions: none                                                                                                       *
# * Postconditions: none                                                                                                        *
# *                                                                                                                         *
# * Revision History: 10.15.2012                                                                                                      *
# ***************************************************************************************************************************

.ENT addition
addition:

	#Deterine relative memory cell locations
	SW $t0, 0($s4) #get operand
	SUB $t0, $t0, $s5 #subtract operand (location) from current location to get distance to data cell you want to store your read to) 
	
	#Navigate to the memory location and save the value from s0 into it
	SLL $t0, $t0, 2 #shift by 2 to multiply by 4 so you can shift your actual memory location
	ADD $a0, $s1, $t0 #go to memory location
	ADD $s0, $s0, $a0 #add cell to accumulator and save back to accumulator

.END addition

# ***************************************************************************************************************************
# * Function Name: Subtraction                                                                                                         *
# * Description: Subtracts a word from a cell in data memory from s0. The result is stored in s0.                                                                                                           *
# *                                                                                                                         *
# * Inputs:	s1,s4, s5	                                                                                                            *
# * Outputs: s0	                                                                                                            *
# * Computations: s0 - data cell                                                                                                           *
# *                                                                                                                         *
# * Errors: ...                                                                                                                *
# * Registers Preserved: s1, s4, s5                                                                                                   *
# *                                                                                                                         *
# * Preconditions: none                                                                                                         *
# * Postconditions: none                                                                                                     *
# *                                                                                                                         *
# * Revision History: 10.15.2012                                                                                                      *
# ***************************************************************************************************************************
.ENT subtraction
subtraction:

	#Determine relative memory cell locations
	SW $t0, 0($s4) #get operand
	SUB $t0, $t0, $s5 #subtract operand (location) from current location to get distance to data cell you want to store your read to) 
	
	#Navigate to the memory location and save the value from s0 into it
	SLL $t0, $t0, 2 #shift by 2 to multiply by 4 so you can shift your actual memory location
	ADD $a0, $s1, $t0 #go to memory location
	SUB $s0, $s0, $a0 #add cell to accumulator and save back to accumulator


.END subtraction

# ***************************************************************************************************************************
# * Function Name: Multiply                                                                                                         *
# * Description: Multiples the word in s0 by a word in a specific data memory cell the result is stored in s5:s0                                                                                                          *
# *                                                                                                                         *
# * Inputs:		                                                                                                            *
# * Outputs:	                                                                                                            *
# * Computations:                                                                                                           *
# *                                                                                                                         *
# * Errors:                                                                                                                 *
# * Registers Preserved:                                                                                                    *
# *                                                                                                                         *
# * Preconditions:                                                                                                          *
# * Postconditions:                                                                                                         *
# *                                                                                                                         *
# * Revision History: 10.15.2012                                                                                                      *
# ***************************************************************************************************************************

.ENT multiply
multiply:



.END multiply
#############################################################################################################################
############################################### END OF ARITHMETIC INSTRUCTIONS ##############################################

############################################### BRANCH INSTRUCTIONS #########################################################
# ***************************************************************************************************************************
# * Function Name: Branch                                                                                                         *
# * Description: Branch to a specific address in data memory.                                                                                                        *
# *                                                                                                                         *
# * Inputs: 		                                                                                                            *
# * Outputs:	                                                                                                            *
# * Computations:                                                                                                           *
# *                                                                                                                         *
# * Errors:                                                                                                                 *
# * Registers Preserved:                                                                                                    *
# *                                                                                                                         *
# * Preconditions:                                                                                                          *
# * Postconditions:                                                                                                         *
# *                                                                                                                         *
# * Revision History: 10.15.2012                                                                                                      *
# ***************************************************************************************************************************

.ENT branch
branch:

.END branch

# ***************************************************************************************************************************
# * Function Name: Brancheq                                                                                                         *
# * Description: Branch to a specific address in data memory if s0 is zero.                                                                                                           *
# *                                                                                                                         *
# * Inputs:		                                                                                                            *
# * Outputs:	                                                                                                            *
# * Computations:                                                                                                           *
# *                                                                                                                         *
# * Errors:                                                                                                                 *
# * Registers Preserved:                                                                                                    *
# *                                                                                                                         *
# * Preconditions:                                                                                                          *
# * Postconditions:                                                                                                         *
# *                                                                                                                         *
# * Revision History: 10.15.2012                                                                                                      *
# ***************************************************************************************************************************

.ENT brancheq
brancheq:


.END brancheq

# ***************************************************************************************************************************
# * Function Name: Branchne                                                                                                          *
# * Description: Branch to a specific address in data memory is s0 is not zero.                                                                                                         *
# *                                                                                                                         *
# * Inputs:		                                                                                                            *
# * Outputs:	                                                                                                            *
# * Computations:                                                                                                           *
# *                                                                                                                         *
# * Errors:                                                                                                                 *
# * Registers Preserved:                                                                                                    *
# *                                                                                                                         *
# * Preconditions:                                                                                                          *
# * Postconditions:                                                                                                         *
# *                                                                                                                         *
# * Revision History: 10.15.2012                                                                                                      *
# ***************************************************************************************************************************

.ENT branchne
branchne:


.END branchne


# ***************************************************************************************************************************
# * Function Name: Halt                                                                                                          *
# * Description: Ends the program, the robot stops.                                                                                                          *
# *                                                                                                                         *
# * Inputs:	none	                                                                                                            *
# * Outputs: none	                                                                                                            *
# * Computations: none                                                                                                          *
# *                                                                                                                         *
# * Errors: none                                                                                                              *
# * Registers Preserved: none                                                                                                    *
# *                                                                                                                         *
# * Preconditions: Program was running.                                                                                                        *
# * Postconditions: Now it ain't magn                                                                                                        *
# *                                                                                                                         *
# * Revision History: 10.15.2012                                                                                                       *
# ***************************************************************************************************************************

.ENT halt
halt:
	#Save return address because we have subroutines
	ADDI $sp, $sp, -4
	SW $ra, 0($sp) # push
	
	JAL brake

	#reset return address
	LW $ra, 0($sp) # pop
	ADDI $sp, $sp, 4
		
.END halt

#############################################################################################################################
##################################################### END OF BRANCH INSTRUCTIONS ############################################

#################################################### ROBOT CONTROL INSTRUCTIONS (RCI) #######################################
# ***************************************************************************************************************************
# * Function Name: Left                                                                                                         *
# * Description: LD3 turns on for ~2 sec. Turn the robot left some specified number of degrees between 0:90.                                                                                                           *
# *                                                                                                                         *
# * Inputs:	none	                                                                                                            *
# * Outputs: none	                                                                                                            *
# * Computations: none                                                                                                          *
# *                                                                                                                         *
# * Errors: none                                                                                                              *
# * Registers Preserved: none                                                                                                    *
# *                                                                                                                         *
# * Preconditions: LEDs must be setup                                                                                                         *
# * Postconditions: none                                                                                                        *
# *                                                                                                                         *
# * Revision History: 10.15.2012                                                                                                      *
# ***************************************************************************************************************************

.ENT left
left:

	#Save return address because we have subroutines
	ADDI $sp, $sp, -4
	SW $ra, 0($sp) # push

	LI $t4, 0x8 #turn on pin 4 (LD3)
	
	SW $t4, (LATB) #turn on LED
	JAL delay
	
	SW $zero, (LATB)
	
	#reset return address
	LW $ra, 0($sp) # pop
	ADDI $sp, $sp, 4
	
	JR $ra

.END left


# ***************************************************************************************************************************
# * Function Name: Right                                                                                                          *
# * Description: LD0 turns on for ~2 sec                                                                                                            *
# *                                                                                                                         *
# * Inputs:	none	                                                                                                            *
# * Outputs: none                                                                                                            *
# * Computations: none                                                                                                           *
# *                                                                                                                         *
# * Errors:...                                                                                                               *
# * Registers Preserved: none                                                                                                   *
# *                                                                                                                         *
# * Preconditions: LEDs must be set up                                                                                                         *
# * Postconditions: none                                                                                                    *
# *                                                                                                                         *
# * Revision History: 10.15.2012                                                                                                       *
# ***************************************************************************************************************************

.ENT right
right:

	#Save return address because we have subroutines
	ADDI $sp, $sp, -4
	SW $ra, 0($sp) # push

	LI $t4, 0x1 #turn on pin 1 (LD0)
	
	SW $t4, (LATB) #turn on LED
	JAL delay
	
	#turn off LEDs
	SW $zero, (LATB)
	
	#reset return address
	LW $ra, 0($sp) # pop
	ADDI $sp, $sp, 4
	
	JR $ra
	
.END right

# ***************************************************************************************************************************
# * Function Name: Forward                                                                                                         *
# * Description: Move the robot forward at slow (00) medium (01) or fast (10).                                                                                                           *
# *                                                                                                                         *
# * Inputs: none 		                                                                                                            *
# * Outputs: none	                                                                                                            *
# * Computations: none                                                                                                         *
# *                                                                                                                         *
# * Errors: ...                                                                                                                *
# * Registers Preserved: none                                                                                                  *
# *                                                                                                                         *
# * Preconditions: LEDs must be set up.                                                                                                         *
# * Postconditions: none                                                                                                          *
# *                                                                                                                         *
# * Revision History: 10.15.2012                                                                                                       *
# ***************************************************************************************************************************

.ENT forward
forward:

	#Save return address because we have subroutines
	ADDI $sp, $sp, -4
	SW $ra, 0($sp) # push

	LI $t4, 0x6 #turn on pin 1&2 (LD1)
	
	####Blink twice####
	
	#turn on
	SW $t4, (LATB) #turn on LD1 & 2
	JAL delay

	#turn off LEDs
	SW $zero, (LATB) #turn on LD1 & 2
	JAL delay
	
	#turn on again
	SW $t4, (LATB) #turn on LD1 & 2
	JAL delay
	
	#turn off...
	SW $zero, (LATB)
	
	#reset return address
	LW $ra, 0($sp) # pop
	ADDI $sp, $sp, 4
	
	JR $ra
	


.END forward

# ***************************************************************************************************************************
# * Function Name: Backward                                                                                                          *
# * Description: LD1 and LD2 turn on.                                                                                                          *
# *                                                                                                                         *
# * Inputs:	none	                                                                                                            *
# * Outputs: none                                                                                                            *
# * Computations: none                                                                                                           *
# *                                                                                                                         *
# * Errors: ...                                                                                                                 *
# * Registers Preserved: none                                                                                                   *
# *                                                                                                                         *
# * Preconditions: LEDs must be setup                                                                                                          *
# * Postconditions: none                                                                                                      *
# *                                                                                                                         *
# * Revision History: 10.15.2012                                                                                                      *
# ***************************************************************************************************************************

.ENT backward
backward:

	#Save return address because we have subroutines
	ADDI $sp, $sp, -4
	SW $ra, 0($sp) # push
	
	LI $t4, 0x6 #turn on pin 1 (LD0)
	SW $t4, (LATB) #turn on LED
	
	JAL delay

	#turn off LEDs
	SW $zero, (LATB)
	
	#reset return address
	LW $ra, 0($sp) # pop
	ADDI $sp, $sp, 4
	
	JR $ra

.END backward

# ***************************************************************************************************************************
# * Function Name: Brake                                                                                                         *
# * Description:                                                                                                            *
# *                                                                                                                         *
# * Inputs:		                                                                                                            *
# * Outputs:	                                                                                                            *
# * Computations:                                                                                                           *
# *                                                                                                                         *
# * Errors:                                                                                                                 *
# * Registers Preserved:                                                                                                    *
# *                                                                                                                         *
# * Preconditions:                                                                                                          *
# * Postconditions:                                                                                                         *
# *                                                                                                                         *
# * Revision History: 10.15.2012                                                                                                     *
# ***************************************************************************************************************************

.ENT brake
brake:


.END brake

##############################################################################################################################
################################################## END OF RCI ################################################################


########################################### MISCELLANEOUS SUBROUTINES ########################################################
##############################################################################################################################
# ***************************************************************************************************************************
# * Function Name: Setup LEDs                                                                                                          *
# * Description: Enable LEDS as outputs while preserving the state of the rest of the pins on portB                                                                                                           *
# *                                                                                                                         *
# * Inputs: none		                                                                                                            *
# * Outputs: none                                                                                                            *
# * Computations: none                                                                                                          *
# *                                                                                                                         *
# * Errors: ...                                                                                                                *
# * Registers Preserved: TRISB                                                                                                    *
# *                                                                                                                         *
# * Preconditions: unknown                                                                                                          *
# * Postconditions: Pins JJ 01:04 of the Cerebot are set to outputs                                                                                                        *
# *                                                                                                                         *
# * Revision History:  9/30/2012                                                                                                     *
# ***************************************************************************************************************************

.ENT setup_LEDs	
setup_LEDs:

	# Need to set LED I/O pins to outputs;
	# Switches connected to JJ 01:04 of Cerebot;
	# LD0 - RB0, LD1 - RB1, LD2 - RB2, LD3 - RB3
	
	LW $t4, (TRISB)
	ANDI $t4, $t4, 0xFFF0 # Preserve other pins on PORTB
	SW $t4, (TRISB)

	# Return to caller
	JR $ra
	
.END setup_LEDs



# ***************************************************************************************************************************
# * Function Name: setup_switches                                                                                                         *
# * Description: Enables bits 10-13 on PORTB to set switches as inputs.                                                                                                            *
# *                                                                                                                         *
# * Inputs:	none	                                                                                                            *
# * Outputs: none                                                                                                            *
# * Computations: none                                                                                                        *
# *                                                                                                                         *
# * Errors: ...                                                                                                                *
# * Registers Preserved: TRISB                                                                                                    *
# *                                                                                                                         *
# * Preconditions: Unknown                                                                                                          *
# * Postconditions: Pins JK 01:04 of the Cerebot board are set as inputs                                                                                                        *
# *                                                                                                                         *
# * Revision History: 9/30/2012                                                                                                      *
# ***************************************************************************************************************************

.ENT setup_switches
setup_switches:

	# Need to set switch I/O pins to inputs;
	# Switches connected to JK 01:04 of Cerebot;
	# SW1 - RB10, SW2 - RB11, SW3 - RB12, SW4 - RB13
	
	LI $t4, 0x3C00
	SW $t4, (AD1PCFG) # Set the analog pins to digital

	LW $t4, (TRISB)
	ORI $t4, $t4, 0x3C00 # Only set required pins for switches on PORTB
	SW $t4, (TRISB)

	# Return to caller
	JR $ra
	
.END setup_switches


# ***************************************************************************************************************************
# * Function Name: flash_for_2                                                                                                         *
# * Description: Turns LEDs on for ~2 seconds                                                                                                           *
# *                                                                                                                         *
# * Inputs:	none	                                                                                                            *
# * Outputs: none                                                                                                            *
# * Computations: none                                                                                                           *
# *                                                                                                                         *
# * Errors: none                                                                                                                *
# * Registers Preserved: none                                                                                                   *
# *                                                                                                                         *
# * Preconditions: none                                                                                                         *
# * Postconditions: none                                                                                                       *
# *                                                                                                                         *
# * Revision History: 9/30/2012
# *                                                                                                      *
# ***************************************************************************************************************************

;.ENT flash_for_2
;flash_for_2:
;
;	LI $t5, 0x20000
;
;	LI $t4, 0xF
;	
;	count:
;	SW $t4, (LATB)
;	ADDI $t5, $t5, -1
;	
;	BEQZ $t5, out
;	J count
;
;	out:
;	
;	SW $zero, (LATB)
;	JR $ra
;
;.END flash_for_2
;




# ***************************************************************************************************************************
# * Function Name: Delay                                                                                                         *
# * Description:                                                                                                            *
# *                                                                                                                         *
# * Inputs:		                                                                                                            *
# * Outputs:	                                                                                                            *
# * Computations:                                                                                                           *
# *                                                                                                                         *
# * Errors:                                                                                                                 *
# * Registers Preserved:                                                                                                    *
# *                                                                                                                         *
# * Preconditions:                                                                                                          *
# * Postconditions:                                                                                                         *
# *                                                                                                                         *
# * Revision History:                                                                                                       *
# ***************************************************************************************************************************
.ENT delay
delay:

	LI $t5, 0x20000

	counting:
	ADDI $t5, $t5, -1
	BEQZ $t5, out
	J counting

	out:
	
	JR $ra
	
.END delay
