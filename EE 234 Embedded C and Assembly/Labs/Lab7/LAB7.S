# ***************************************************************************************************************************
# * Author: Michael Mentele                                                                                                            
# * Course: EE 234 Microprocessor Systems - Lab # 7                                                                         
# * Project: Robomal part2                                                                                                              
# * File: CodeTemplate.s                                                                                                    
# * Description:                                                    
# *                                                                                                                         
# * Inputs:                                                                                                                 
# * Outputs:                                                                                                                
# * Computations:                                                                                                           
# *                                                                                                                         
# * Revision History:   October 16                                                                                                    
# *************************************************************************************************************************** 

/* #include all necessary standard and user-defined libraries */
#include <p32xxxx.h> /* Includes all major functions and macros required to develop
                        programs for the PIC32MX4 */


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

square: .word 0x00421010,0x00410090, 0x00440003,0x00425050,0x00410090,0x00442060,0x00421010,0x00410090,0x00440003,0x00420002,0x00410090,0x00440003,0x00330000
datatest: .word 0x00100005, 0x00110004, 0x00120003, 0x00130002, 0x00330001, 0x0
foward: .word 0x00423030
# arthtest: .word 0x00200004, 0x00210003, 0x00220002, 0x00330001, 0x4
# branchtest: .word 0x00300004, 0x00310003, 0x00320002, 0x00330001, 0x0
# rcitest: .word 0x00400090, 0x00410090, 0x00420000, 0x00430000, 0x00440003, 0x00330000


# ***************************************************************************************************************************
# *                                                                                                                         *
# *                                           Code Segment                                                                  *
# *                                                                                                                         *
# ***************************************************************************************************************************

.TEXT                        # The start of the code segment
	
		                         
.ENT main                    # Setup a main entry point
main:

	DI	# Disable system wide interrupts; don't respond to spurious interrupts
	
	JAL setupTimer2	# Configure Timer 1
	JAL setupPORTs	# 
	#jal jon
	JAL setupMultiVectoredMode	# Want mult-vectored interrupts - each interrupt may have a location in interrupt vector table
	JAL setupOC2_3Module

	EI

	##initialize and specify program
	LA s1, square #fetch the instruction must change manually
	LI s0, 0
	LI s5, 0  #data memory location 0
	JAL setup_LEDs #map portb pins
	
		loop:
		
		#Decode
		LW s2, 0(s1) #store the current instruction
		SRL s3, s2, 16  #zero out first 16 bits of opcode
		ANDI s4, s2, 0x0000FFFF #Preserve the operand
		
		#navigates to a subroutine based on the opcode
		JAL	do
			
		#Array location
		ADDI s1, s1, 4 #move to the next instruction to next
		ADDI s5, s5, 1 #cell counter++
		
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
#Read, Write, Store, Load

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
	SUB t0, t0, s5 #subtract current location from  the operand  
	
	#Navigate to and save porte at memory location
	SLL t0, t0, 2 #shift by 2 to multiply by 4 o use for memory location shift
	LW t1, (PORTE) #read port E
	ADD a0, s1, t0 #go to memory location
	SW t1, (a0) #save PORTE memory location

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
	SUB t0, t0, s5 #subtract operand (location) from current location 
	
	#Navigate to memory location and save the value to porte
	SLL t0, t0, 2 #shift by 2 to multiply by 4 o use for memory location shift
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
	SLL t0, t0, 2 #shift by 2 to multiply by 4 o use for memory location shift
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
	SLL t0, t0, 2 #shift by 2 to multiply by 4 o use for memory location shift
	ADD a0, s1, t0 #go to memory location
	SW s0, (a0)

	J done

.END store
;}
#############################################################################################################################

################################################ ARITHMETIC INSTRUCTIONS ####################################################
#add, sub, multi, 
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
	SLL t0, t0, 2 #shift by 2 to multiply by 4 o use for memory location shift
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
	SLL t0, t0, 2 #shift by 2 to multiply by 4 o use for memory location shift
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
	SLL t0, t0, 2 #shift by 2 to multiply by 4 o use for memory location shift
	ADD a0, s1, t0 #go to memory location
	
	#multiply by splitting s0 into two parts
	LW t1, (a0)
	ANDI t2, s0, 0xFFFF #start of s0
	SRL t3, s0, 16
	
	MUL s0, t1, t2
	MUL s6, t1, t3
	

	J done

.END multiply
#############################################################################################################################


############################################### BRANCH INSTRUCTIONS #########################################################
#branch, brancheq, branchNEQ, HALT
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

.ENT branch
branch:
	
	#Determine relative memory cell locations
	MOVE t0, s4 #get operand
	SUB t0, t0, s5 #subtract operand (location) from current location to get distance to data cell you want to store your read to) 
	
	#Navigate to the memory location and save the value from s0 into it
	SLL t0, t0, 2 #shift by 2 to multiply by 4 o use for memory location shift
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
	SLL t0, t0, 2 #shift by 2 to multiply by 4 o use for memory location shift
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
	SLL t0, t0, 2 #shift by 2 to multiply by 4 o use for memory location shift
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
		
.END halt
;}
#############################################################################################################################

##################################################### END OF BRANCH INSTRUCTIONS ############################################

#################################################### ROBOT CONTROL INSTRUCTIONS (RCI) #######################################
#left, right, forward, back, brake
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

		# Preserve registers - push to stack
	ADDI sp, sp, -8
	SW ra, 4(sp)
	SW s0, 0(sp)
	
		# Bit 15 - ON Timer On bit, 1 = timer enabled, 0 = disabled
		LA s0, T2CON 
		LI t0, 0x0 # stop Timer 2
		SW t0, (s0)
	
		#turn output into input for DIR
		LI t0, 3 << 6 
		SW t0, TRISDSET
		
		#write 0 to LATD
		LI t0, 0xC6  #Clear DIR/EN pins
		SW t0, LATDCLR
		
				####CHANGED FROM FORWARD#######
				#setting duty cycle for turning
				LI t1, 35 
				LI t2, 35
				####CHANGED FROM FORWARD#######
			
				#Operations are performed assuming PR2 == 100	
				LA s0, OC2RS
				SW t1, (s0)
				LA s0, OC3RS
				SW t2, (s0)
			
		#turn back into output
		LI t0, 3 << 6  #set back to output pins
		LW t0, TRISDCLR
		
		####CHANGED FROM FORWARD#######
		LI t0, 0x06 #wheel need to go in opposite directions
		LW t0, LATDSET
		####CHANGED FROM FORWARD#######
	
		# T2CON T3CON - Control Register for Timer 2 - can combine with Timer 3 to form 32-bit timer!
		# Bit 1 - TCS Timer Clock Source, 0 = internal peripheral clk (PBCLK)
		# Bit 3 - 1 = 32-bit timer, 0 = 16-bit timer
		# Bits 6:4 - TCKPS Timer Clock Prescale Select bits, these are slightly different than with Timer 1; 100 = /16
		# Bit 15 - ON Timer On bit, 1 = timer enabled, 0 = disabled
		LA s0, T2CON 
		LI t0, 0x8050 # PBCLK / 16, Timer 2 on, 16-bit timer mode, use PBCLK
		SW t0, (s0)
		
		JAL delay

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

	# Preserve registers - push to stack
	ADDI sp, sp, -8
	SW ra, 4(sp)
	SW s0, 0(sp)
	
		# Bit 15 - ON Timer On bit, 1 = timer enabled, 0 = disabled
		LA s0, T2CON 
		LI t0, 0x0 # stop Timer 2
		SW t0, (s0)
	
		#turn output into input for DIR
		LI t0, 3 << 6 
		SW t0, TRISDSET
		
		#write 0 to LATD
		LI t0, 0xC6  #Clear DIR/EN pins
		SW t0, LATDCLR
		
				####CHANGED FROM FORWARD#######
				#setting duty cycle for turning
				LI t1, 35 
				LI t2, 35
				####CHANGED FROM FORWARD#######
			
				#Operations are performed assuming PR2 == 100	
				LA s0, OC2RS
				SW t1, (s0)
				LA s0, OC3RS
				SW t2, (s0)
			
		#turn back into output
		LI t0, 3 << 6  #set back to output pins
		LW t0, TRISDCLR
		
		####CHANGED FROM FORWARD#######
		LI t0, 0xC6 #wheel need to go in opposite directions
		LW t0, LATDSET
		####CHANGED FROM FORWARD#######
	
		# T2CON T3CON - Control Register for Timer 2 - can combine with Timer 3 to form 32-bit timer!
		# Bit 1 - TCS Timer Clock Source, 0 = internal peripheral clk (PBCLK)
		# Bit 3 - 1 = 32-bit timer, 0 = 16-bit timer
		# Bits 6:4 - TCKPS Timer Clock Prescale Select bits, these are slightly different than with Timer 1; 100 = /16
		# Bit 15 - ON Timer On bit, 1 = timer enabled, 0 = disabled
		LA s0, T2CON 
		LI t0, 0x8050 # PBCLK / 16, Timer 2 on, 16-bit timer mode, use PBCLK
		SW t0, (s0)
		
		JAL delay
	
	# Pop registers
	LW s0, 0(sp)
	LW ra, 4(sp)
	ADDI sp, sp, 8

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

	# Preserve registers - push to stack
	ADDI sp, sp, -8
	SW ra, 4(sp)
	SW s0, 0(sp)
	
		# Bit 15 - ON Timer On bit, 1 = timer enabled, 0 = disabled
		LA s0, T2CON 
		LI t0, 0x0 # stop Timer 2
		SW t0, (s0)
	
		#turn output into input for DIR
		LI t0, 3 << 6 
		SW t0, TRISDSET
		
		#write 0 to LATD
		LI t0, 0xC6  #Clear DIR/EN pins
		SW t0, LATDCLR
		
				#get operands
				MOVE t0, s4 #grab operand
				SRL t1, t0, 2 #look at motor 1 (left bits for speed value)
				LI t2, 3
				AND t2, t2, t0 #get motor 2 (right bits for speed value)
			
				#Operations are performed assuming PR2 == 100	
				LA s0, OC2RS
				SW t1, (s0)
				LA s0, OC3RS
				SW t2, (s0)
			
		#turn back into output
		LI t0, 3 << 6  #set back to output pins
		LW t0, TRISDCLR

		LI t0, 0x86
		LW t0, LATDSET
	
		# T2CON T3CON - Control Register for Timer 2 - can combine with Timer 3 to form 32-bit timer!
		# Bit 1 - TCS Timer Clock Source, 0 = internal peripheral clk (PBCLK)
		# Bit 3 - 1 = 32-bit timer, 0 = 16-bit timer
		# Bits 6:4 - TCKPS Timer Clock Prescale Select bits, these are slightly different than with Timer 1; 100 = /16
		# Bit 15 - ON Timer On bit, 1 = timer enabled, 0 = disabled
		LA s0, T2CON 
		LI t0, 0x8050 # PBCLK / 16, Timer 2 on, 16-bit timer mode, use PBCLK
		SW t0, (s0)
		
		JAL delay
	
	# Pop registers
	LW s0, 0(sp)
	LW ra, 4(sp)
	ADDI sp, sp, 8

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

;{.ENT backward
backward:

	# Preserve registers - push to stack
	ADDI sp, sp, -8
	SW ra, 4(sp)
	SW s0, 0(sp)
	
		# Bit 15 - ON Timer On bit, 1 = timer enabled, 0 = disabled
		LA s0, T2CON 
		LI t0, 0x0 # stop Timer 2
		SW t0, (s0)
	
		#turn output into input for DIR
		LI t0, 3 << 6 
		SW t0, TRISDSET
		
		#write 0 to LATD
		LI t0, 0xC6  #Clear DIR/EN pins
		SW t0, LATDCLR
		
				#get operands
				MOVE t0, s4 #grab operand
				SRL t1, t0, 2 #look at motor 1 (left bits for speed value)
				LI t2, 3
				AND t2, t2, t0 #get motor 2 (right bits for speed value)
			
				#Operations are performed assuming PR2 == 100	
				LA s0, OC2RS
				SW t1, (s0)
				LA s0, OC3RS
				SW t2, (s0)
			
		#turn back into output
		LI t0, 3 << 6  #set back to output pins
		LW t0, TRISDCLR

		####CHANGED FROM FORWARD#######
		#Pin directions must be opposite for backwards 
		LI t0, 0x46
		LW t0, LATDSET
		####CHANGED FROM FORWARD#######
	
		# T2CON T3CON - Control Register for Timer 2 - can combine with Timer 3 to form 32-bit timer!
		# Bit 1 - TCS Timer Clock Source, 0 = internal peripheral clk (PBCLK)
		# Bit 3 - 1 = 32-bit timer, 0 = 16-bit timer
		# Bits 6:4 - TCKPS Timer Clock Prescale Select bits, these are slightly different than with Timer 1; 100 = /16
		# Bit 15 - ON Timer On bit, 1 = timer enabled, 0 = disabled
		LA s0, T2CON 
		LI t0, 0x8050 # PBCLK / 16, Timer 2 on, 16-bit timer mode, use PBCLK
		SW t0, (s0)
		
		JAL delay
	
	# Pop registers
	LW s0, 0(sp)
	LW ra, 4(sp)
	ADDI sp, sp, 8

	J done
	

.END backward
;}
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

;{.ENT brake
brake:

	# Bit 15 - ON Timer On bit, 1 = timer enabled, 0 = disabled
		LA s0, T2CON 
		LI t0, 0x0 # stop Timer 2
		SW t0, (s0)
	
		#turn output into input for DIR
		LI t0, 3 << 6 
		SW t0, TRISDSET
		
		#write 0 to LATD
		LI t0, 0xC6  #Clear DIR/EN pins
		SW t0, LATDCLR
		
J done

.END brake
;}
##############################################################################################################################


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
;{
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

;}

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
;{
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
;}
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
.ent delay
delay:

	LI t5, 0x100
	MUL t5, s4, t5
	
	counting:
	addi t5, t5, -1
	beqz t5, out
	j counting

	out:
	
	jr ra
	
.end delay
;}




#

# ***************************************************************************************************************************
# * Function Name: Setup Ports                                                                                                       *
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
# * Revision History: 11.13.2012                                                                                                     *
# ***************************************************************************************************************************

;{.ENT setupPORTs
setupPORTs:

	# Preserve registers - push to stack
	ADDI sp, sp, -8
	SW ra, 4(sp)
	SW s0, 0(sp)
	
	#write 0 to LATD
	LI t0, 0xC6  #Clear DIR/EN pins
	SW t0, LATDCLR

	# H-bridge OC3 - Enable controlled by OC 3
	# Set these two pins to outputs
	LI t0, 1 << 6  #DIR - JD-07, RD06;
	SW t0, TRISDCLR
	LI t0, 1 << 2  #EN - JD-08, RD02,
	SW t0, TRISDCLR

	# H-bridge OC2 - Enable controlled by OC 2
	# Set these two pins to outputs

	LI t0, 1 << 7 # DIR - JD-01, RD07
	SW t0, TRISDCLR
	LI t0, 1 << 1 #EN - JD-02, RD01
	SW t0, TRISDCLR

	# Pop registers
	LW s0, 0(sp)
	LW ra, 4(sp)
	ADDI sp, sp, 8
	
	JR ra

.END setupPORTs
;}
# ***************************************************************************************************************************
# * Function Name: setupOC2_3Module                                                                                                        *
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
# * Revision History: 11.13.2012                                                                                                     *
# ***************************************************************************************************************************

;{.ENT setupOC2_3Module
setupOC2_3Module:

	# Preserve registers - push to stack
	ADDI sp, sp, -8
	SW ra, 4(sp)
	SW s0, 0(sp)
	
	# Ensure OC2 is off while setting up module 2
	LA s0, OC2CON # Output compare 2 control register
	MOVE t1, zero
	SW t1, (s0)

	LA s0, OC3CON #OC3
	SW t1, (s0)
	
	# Initialize the OC2R register before the output compare module, this register determins duty cycle
	LA s0, OC2R
	LI t0, 0x00
	SW t0, (s0)

	LA s0, OC3R	#OC3
	SW t0, (s0)

	# The OC2RS secondary output compare register will contain the actual duty cycle
	LA s0, OC2RS
	SW t0, (s0)

	LA s0, OC3RS  #OC3
	SW t0, (s0)

	# Now configure the compare module using OC2CON
	# Bits 2:0 - 110 = PWM mode on OC2, 011 = compare event toggles OC2 pin
	# Bit 3 -> 1 = Timer 3 clk src, 0 = Timer 2 clk src
	# Bit 5 -> 1 = 32-bit comparisons, 0 = 16-bit comparisons
	# Bit 15 -> 1 = enable output compare, 0 = disabled, not drawing current
	
	LA s0, OC2CON
	MOVE t0, zero
	ORI t0, t0, 6 # PWM mode
	ORI t0, t0, 1 << 15 # Enable output compare module
	SW t0, (s0)
	
	LA s0, OC3CON #OC3
	SW t0, (s0)
	
	# Set priority of compare match interrupt IPC2<20:18>
	LA s0, IPC2SET
	LI t0, 5 # priority 5
	SLL t0, t0, 18
	SW t0, (s0)

	LA s0, IPC3SET #OC3
	SW t0, (s0)

	# Pop registers
	LW s0, 0(sp)
	LW ra, 4(sp)
	ADDI sp, sp, 8

	JR ra

.END setupOC2_3Module
;}
# ***************************************************************************************************************************
# * Function Name: setuptimer2                                                                                                         *
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
# * Revision History: 11.13.2012                                                                                                     *
# ***************************************************************************************************************************

;{
.ENT setupTimer2
setupTimer2:

	# Preserve registers - push to stack
	ADDI sp, sp, -8
	SW ra, 4(sp)
	SW s0, 0(sp)
	
	#RUN both OC2 and OC3 off Timer2	
	
# T2CON - Control Register for Timer 2
	# Bit 15 - ON Timer On bit, 1 = timer enabled, 0 = disabled
	LA s0, T2CON 
	LI t0, 0x0 # stop Timer 2
	SW t0, (s0)
		

	# TMR2_3 register contains 16-bit current value of Timer 2_3
	LA s0, TMR2
	MOVE t0, zero # clear timer value
	SW t0, (s0)


	# PR2 register contains 16-bit period match value, i.e. TMR2 value == PR2 value ==> timer resets
	LA s0, PR2
	LI t0, 0x64 # Affects how often the timer is reset! 
	SW t0, (s0)


	# T2CON T3CON - Control Register for Timer 2 - can combine with Timer 3 to form 32-bit timer!
	# Bit 1 - TCS Timer Clock Source, 0 = internal peripheral clk (PBCLK)
	# Bit 3 - 1 = 32-bit timer, 0 = 16-bit timer
	# Bits 6:4 - TCKPS Timer Clock Prescale Select bits, these are slightly different than with Timer 1; 100 = /16
	# Bit 15 - ON Timer On bit, 1 = timer enabled, 0 = disabled
	LA s0, T2CON 
	LI t0, 0x8050 # PBCLK / 16, Timer 2 on, 16-bit timer mode, use PBCLK
	SW t0, (s0)


	# Pop registers
	LW s0, 0(sp)
	LW ra, 4(sp)
	ADDI sp, sp, 8
	
	JR ra
.END setupTimer2
;}

.ENT setupMultiVectoredMode
setupMultiVectoredMode:

	# Interrupt control register
	LA s0, INTCON # Register necessary for setting multi-vectored mode
	LW t0, (s0)
	ORI t0, t0, 1 << 12 # Set for mutli-vectored mode
	#SW $t0, ($s0)
	SW t0, INTCON

	JR ra

.END setupMultiVectoredMode






.ent jon
jon:

#disable timer2
	
#	LA s0, IEC0CLR # Used to clear bit to disable Timer 2 interrupt
#	LI t1, 1
#	SLL t1, t1, 8
#	SW t1, (s0) 

#write 0 to LATD
LI t0, 0xC6  #Clear DIR/EN pins
SW t0, LATDCLR

#turn output into input

LI t0, 0xC6  #Clear DIR pins
LW t1, (TRISD)
OR t0, t1, t0 
SW t0, TRISD

##########FORWARD############

#	LA s0, IEC0SET # Used to set bit to disable Timer 2 interrupt
#	LI t1, 1
#	SLL t1, t1, 8
#	SW t1, (s0) 

#turn output into input

LI t0, 0xC6  #Clear DIR pins
LW t0, TRISDCLR


jr ra
.end jon








