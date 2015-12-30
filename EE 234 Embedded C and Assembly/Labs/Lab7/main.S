# ***************************************************************************************************************************
# * Author: Michael Mentele                                                                                                              *
# * Course: EE 234 Microprocessor Systems - Lab # 7                                                                          *
# * Project: Robomal                                                                                                               *
# * File: CodeTemplate.S                                                                                                  *
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

/* #include all necessary standard and user-defined libraries */
#include <p32xxxx.h>

/* SYSCLK = 80 MHz (8 MHz Crystal/ FPLLIDIV * FPLLMUL / FPLLODIV)
// PBCLK = 40 MHz
// Primary Osc w/PLL (XT+,HS+,EC+PLL)
// WDT OFF
// Other options are don't care */

#pragma config FNOSC	 = PRIPLL 
#pragma config FPLLMUL  = MUL_20
#pragma config FPLLIDIV  = DIV_2
#pragma config FPBDIV  = DIV_2 /* Divide SYSCLK by 2 ==> PBCLK */
#pragma config FPLLODIV  = DIV_1 

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



#programs
square: .word 0x00420002,0x00410090,0x00440003,0x00420002,0x00410090,0x00440003,0x00420002,0x00410090,0x00440003,0x00420002,0x00410090,0x00440003,0x00330000
datatest: .word 0x00100005, 0x00110004, 0x00120003, 0x00130002, 0x00330001, 0x0
arthtest: .word 0x00200004, 0x00210003, 0x00220002, 0x00330001, 0x4
branchtest: .word 0x00300004, 0x00310003, 0x00320002, 0x00330001, 0x0
rcitest: .word 0x00400090, 0x00410090, 0x00420000, 0x00430000, 0x00440003, 0x00330000


# ***************************************************************************************************************************
# *                                                                                                                         *
# *                                           Code Segment                                                                  *
# *                                                                                                                         *
# ***************************************************************************************************************************

.TEXT                        # The start of the code segment
	
		                         
.ENT main                    # Setup a main entry point
main:

	##initialize and specify program
	LA s1, arthtest #fetch the instruction
	LI s0, 0
	LI s5, 0  #set data memory location to 0
	JAL setup_LEDs #map portb pins
	
		loop:
		
		#Decode
		LW s2, 0(s1) #store the current instruction
		SRL s3, s2, 16  #zero out first 16 bits of opcode
		ANDI s4, s2, 0x0000FFFF #Preserve the operand
		
		#navigates to a subroutine that executes based on the opcode
		JAL	do
			
		#Array location
		ADDI s1, s1, 4 #move to the next instruction in your program
		ADDI s5, s5, 1 #add one to data cell counter
		
		J loop

	
end:

J end
	
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

		
		#Save return address because we have subroutines
		ADDI sp, sp, -4
		SW ra, 0(sp) # push
		
	doing:
		
		#data transfer instructions
		#READ
		BEQ s3, 0x10, read
		#WRITE
		BEQ s3, 0x11, write
		#LOAD
		BEQ s3, 0x12, load
		#STORE
		BEQ s3, 0x13, store
		
		#arithmetic instructions
		#ADDITION
		BEQ s3, 0x20, addition
		#SUBTRACTION
		BEQ s3, 0x21, subtraction
		#MULTIPLY
		BEQ s3, 0x22, multiply
		
		#Branch Instructions 
		#BRANCH
		BEQ s3, 0x30, branch
		#BRANCHEQ
		BEQ s3, 0x31, brancheq
		#BRANCHNE
		BEQ s3, 0x32, branchne
		#HALT
		BEQ s3, 0x33, halt		
		
		#Robot Control Instructions (RCI)
		#LEFT
		BEQ s3, 0x40, left
		#RIGHT
		BEQ s3, 0x41, right
		#FORWARD
		BEQ s3, 0x42, forward
		#BACKWARD
		BEQ s3, 0x43, backward
		#BRAKE
		BEQ s3, 0x44, brake
		
		done:
			
		#reset return address
		LW ra, 0(sp) # pop
		ADDI sp, sp, 4
	
		JR ra

.END do
#############################################################################################################################
############################################### End of DO ###################################################################


####################################DATA TRANSFER INSTRUCTIONS ##############################################################
# ***************************************************************************************************************************
# * Function Name: READ                                                                                                          *
# * Description: Read PORTE 7:0 and store it into a specific data memory cell.                                                                                                          *
# *                                                                                                                         *
# * Inputs:	s1, s4, s5	                                                                                                            *
# * Outputs: n/a	                                                                                                            *
# * Computations: none                                                                                                         *
# *                                                                                                                         *
# * Errors: n/a                                                                                                                *
# * Registers Preserved: s1, s4, s5                                                                                                   *
# *                                                                                                                         *
# * Preconditions: none                                                                                                          *
# * Postconditions: PORTE is saved to a specific location                                                                                                        *
# *                                                                                                                         *
# * Revision History: 10.14.2012                                                                                                      *
# ***************************************************************************************************************************

;{.ENT read
read:
	
	#Set pins 0-7 to inputs preserve other pins
	LW t0, (TRISE)
	ORI t0, t0, 0x00FF
	SW t0, (TRISE)

	#Deterine relative memory cell locations
	MOVE t0, s4 #get operand
	SUB t0, t0, s5 #subtract current location from  the operand (desired location)to get distance to the data cell you want to store your read to) 
	
	#Navigate to and save porte at memory location
	SLL t0, t0, 2 #shift by 2 to multiply by 4 so you can shift your actual memory location
	LW t1, (PORTE) #read port E
	ADD a0, s1, t0 #go to memory location
	SW t1, (a0) #save PORTE into the specific memory location

	J done


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
	LW t0, (TRISE)
	ANDI t0, t0, 0xFF00
	SW t0, (TRISE)
	
	#Deterine relative memory cell locations
	MOVE t0, s4 #get operand
	SUB t0, t0, s5 #subtract operand (location) from current location to get distance to data cell you want to store your read to) 
	
	#Navigate to memory location and save the value to porte
	SLL t0, t0, 2 #shift by 2 to multiply by 4 so you can shift your actual memory location
	ADD a0, s1, t0 #go to memory location
	LW t1, 0(a0) #read data memory cell
	SW t1, (LATE) #save memory cell to portE
	
	J done

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
	MOVE t0, s4 #get operand
	SUB t0, t0, s5 #subtract operand (location) from current location to get distance to data cell you want to store your read to) 
	
	#Navigate to memory location and save the value to s0
	SLL t0, t0, 2 #shift by 2 to multiply by 4 so you can shift your actual memory location
	ADD a0, s1, t0 #go to memory location
	LW t1, 0(a0) #read data memory cell
	MOVE t1, s0 #save memory cell to the accumulator
	
	j done

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
	MOVE t0, s4 #get operand
	SUB t0, t0, s5 #subtract operand (location) from current location to get distance to data cell you want to store your read to) 
	
	#Navigate to the memory location and save the value from s0 into it
	SLL t0, t0, 2 #shift by 2 to multiply by 4 so you can shift your actual memory location
	ADD a0, s1, t0 #go to memory location
	SW s0, (a0)

	J done

.END store;}
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

;{.ENT addition
addition:

	#Deterine relative memory cell locations
	MOVE t0, s4 #get operand
	SUB t0, t0, s5 #subtract operand (location) from current location to get distance to data cell you want to store your read to) 
	
	#Navigate to the memory location and save the value from s0 into it
	SLL t0, t0, 2 #shift by 2 to multiply by 4 so you can shift your actual memory location
	ADD a0, s1, t0 #go to memory location
	LW t0, (a0)
	ADD s0, s0, t0 #add cell to accumulator and save back to accumulator
	
	J done

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
	MOVE t0, s4 #get operand
	SUB t0, t0, s5 #subtract operand (location) from current location to get distance to data cell you want to store your read to) 
	
	#Navigate to the memory location and save the value from s0 into it
	SLL t0, t0, 2 #shift by 2 to multiply by 4 so you can shift your actual memory location
	ADD a0, s1, t0 #go to memory location
	LW t1, (a0)
	SUB s0, s0, t1 #add cell to accumulator and save back to accumulator

	J done

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
# * Registers Preserved: s4,s5,s1,s6                                                                                                    *
# *                                                                                                                         *
# * Preconditions:                                                                                                          *
# * Postconditions:                                                                                                         *
# *                                                                                                                         *
# * Revision History: 10.15.2012                                                                                                      *
# ***************************************************************************************************************************

.ENT multiply
multiply:

	#Determine relative memory cell locations
	MOVE t0, s4 #get operand
	SUB t0, t0, s5 #subtract operand (location) from current location to get distance to data cell you want to store your read to) 
	
	#Navigate to the memory location and save the value from s0 into it
	SLL t0, t0, 2 #shift by 2 to multiply by 4 so you can shift your actual memory location
	ADD a0, s1, t0 #go to memory location
	
	#multiply by splitting s0 into two parts
	LW t1, (a0)
	ANDI t2, s0, 0xFFFF #start of s0
	SRL t3, s0, 16
	
	MUL s0, t1, t2
	MUL s6, t1, t3
	

	J done

.END multiply;}
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
# * Registers Preserved: s1, s5                                                                                                    *
# *                                                                                                                         *
# * Preconditions:                                                                                                          *
# * Postconditions:                                                                                                         *
# *                                                                                                                         *
# * Revision History: 10.15.2012                                                                                                      *
# ***************************************************************************************************************************

;{.ENT branch
branch:
	
	#Determine relative memory cell locations
	MOVE t0, s4 #get operand
	SUB t0, t0, s5 #subtract operand (location) from current location to get distance to data cell you want to store your read to) 
	
	#Navigate to the memory location and save the value from s0 into it
	SLL t0, t0, 2 #shift by 2 to multiply by 4 so you can shift your actual memory location
	ADD a0, s1, t0 #get memory location
	MOVE s5, s4 #set current location
	MOVE s1, a0 #jump to new instruction cell

	J done

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

	#Determine relative memory cell locations
	MOVE t0, s4 #get operand
	SUB t0, t0, s5 #subtract operand (location) from current location to get distance to data cell you want to store your read to) 
	
	#Navigate to the memory location and save the value from s0 into it
	SLL t0, t0, 2 #shift by 2 to multiply by 4 so you can shift your actual memory location
	ADD a0, s1, t0 #get memory location
	
	BEQZ s0, jumpeq
	
	J done
	
	jumpeq:
	
	MOVE s5, s4 #set current location
	MOVE s1, a0 #jump to new instruction cell

	J done

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

#Determine relative memory cell locations
	MOVE t0, s4 #get operand
	SUB t0, t0, s5 #subtract operand (location) from current location to get distance to data cell you want to store your read to) 
	
	#Navigate to the memory location and save the value from s0 into it
	SLL t0, t0, 2 #shift by 2 to multiply by 4 so you can shift your actual memory location
	ADD a0, s1, t0 #get memory location
	
	BNEZ s0, jumpne
	
	J done
	
	jumpne:
	
	MOVE s5, s4 #set current location
	MOVE s1, a0 #jump to new instruction cell

	J done


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
	
	J end
		
.END halt;}

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
	ADDI sp, sp, -4
	SW ra, 0(sp) # push



	#reset return address
	LW ra, 0(sp) # pop
	ADDI sp, sp, 4
	
	J done

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
	ADDI sp, sp, -4
	SW ra, 0(sp) # push

	LI t4, 0x1 #turn on pin 1 (LD0)
	
	SW t4, (LATB) #turn on LED
	JAL delay
	
	#turn off LEDs
	SW zero, (LATB)
	
	#reset return address
	LW ra, 0(sp) # pop
	ADDI sp, sp, 4
	
	J done
	
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
	ADDI sp, sp, -4
	SW ra, 0(sp) # push

	LI t4, 0x6 #turn on pin 1&2 (LD1)
	
	####Blink twice####
	
	#turn on
	SW t4, (LATB) #turn on LD1 & 2
	JAL delay

	#turn off LEDs
	SW zero, (LATB) #turn on LD1 & 2
	JAL delay
	
	#turn on again
	SW t4, (LATB) #turn on LD1 & 2
	JAL delay
	
	#turn off...
	SW zero, (LATB)
	
	#reset return address
	LW ra, 0(sp) # pop
	ADDI sp, sp, 4
	
	JAL delay
	
	J done
	


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
	ADDI sp, sp, -4
	SW ra, 0(sp) # push
	
	LI t4, 0x6 #turn on pin 1 (LD0)
	SW t4, (LATB) #turn on LED
	
	JAL delay

	#turn off LEDs
	SW zero, (LATB)
	
	#reset return address
	LW ra, 0(sp) # pop
	ADDI sp, sp, 4
	
	J done

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

J done

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
	SW zero, (LATB)
	
	LW t4, (TRISB)
	ANDI t4, t4, 0xFFF0 # Preserve other pins on PORTB
	SW t4, (TRISB)

	# Return to caller
	JR ra
	
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
	
	LI t4, 0x3C00
	SW t4, (AD1PCFG) # Set the analog pins to digital

	LW t4, (TRISB)
	ORI t4, t4, 0x3C00 # Only set required pins for switches on PORTB
	SW t4, (TRISB)

	# Return to caller
	JR ra
	
.END setup_switches

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

	LI t5, 0x10000

	counting:
	ADDI t5, t5, -1
	BEQZ t5, out
	J counting

	out:
	
	JR ra
	
.END delay
