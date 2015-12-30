
# ***************************************************************************************************************************
# * Author: Michael Mentele                                                                                                 *
# * Course: EE 234 Microprocessor Systems - Lab 4                                                                           *
# * Project: Uhhh... Lab4                                                                                                   *
# * File: Lab4.s                                                                                                            *
# * Description: Program is for a basic calculator using the Cerebot board.                                                 *                           
# *                                                                                                                         *
# * Inputs: SW1-4                                                                                                           *
# * Outputs: LEDs 1-4                                                                                                       *
# * Computations: Addition                                                                                                  *
# *               Subtraction                                                                                               *
# *               Shift Left by 1                                                                                           *
# *               Shift Right by 1                                                                                          *
# * Revision History:                                                                                                       *
# *************************************************************************************************************************** 


# ***************************************************************************************************************************
# *                                                                                                                         *
# *                                           Include Files                                                                 *
# *                                                                                                                         *
# ***************************************************************************************************************************

# 

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

.DATA                        

OP

# ***************************************************************************************************************************
# *                                                                                                                         *
# *                                           Code Segment                                                                  *
# *                                                                                                                         *
# ***************************************************************************************************************************

.TEXT                        # The start of the code segment
	                         
.ENT main                    # Setup a main entry point
main:

JAL setup_leds
JAL setup_switches
JAL operation

	         # Embedded programs require that they run forever! So jump back to the beginning of the loop
	
.END main

# ***************************************************************************************************************************
# *                                                                                                                         *
# *                                           Subroutine Definitions                                                        *
# *                                                                                                                         *
# ***************************************************************************************************************************

# The below comment block is required for all defined subroutines!
# ***************************************************************************************************************************
# * Function Name: Setup LEDs                                                                                               *
# * Description: Sets pins 0-3 as output pins and preserves the states of the rest of the pins on PORT B                    *
# *                                                                                                                         *
# * Inputs: none                                                                                                            *
# * Outputs: none	                                                                                                        *
# * Computations: none                                                                                                      *
# *                                                                                                                         *
# * Errors: none                                                                                                            *
# * Registers Preserved: none                                                                                               *
# *                                                                                                                         *
# * Preconditions: none                                                                                                     *
# * Postconditions: Pins 0-3 will be set as output pins.                                                                    *
# *                                                                                                                         *
# * Revision History:                                                                                                       *
# ***************************************************************************************************************************

#Setup LEDs
.ENT setup_leds

LW $t0, (TRISB)
ANDI $t0, $t0, 0xFFF0
SW $t0, (TRISB)

JR $RA

.END setup_leds

# ***************************************************************************************************************************
# * Function Name: Setup LEDs                                                                                               *
# * Description: Sets pins 10-13 as input pins and preserves the states of the rest of the pins on PORT B                    *
# *                                                                                                                         *
# * Inputs: none                                                                                                            *
# * Outputs: none	                                                                                                        *
# * Computations: none                                                                                                      *
# *                                                                                                                         *
# * Errors: none                                                                                                            *
# * Registers Preserved: none                                                                                               *
# *                                                                                                                         *
# * Preconditions: none                                                                                                     *
# * Postconditions: Pins 10-13 will be set as input pins                                                                    *
# *                                                                                                                         *
# * Revision History:                                                                                                       *
# ***************************************************************************************************************************

#Setup Switches
.ENT setup_switches

LW $t0, (TRISB)
ORI $t0, $t0, 0x3C00
SW $t0, (TRISB)

JR $RA

.END setup_switches

# ***************************************************************************************************************************
# * Function Name: Delay                                                                                                    *
# * Description: ~One second delay using while loop.                                                                        *
# *                                                                                                                         *
# * Inputs: none                                                                                                            *
# * Outputs: none	                                                                                                        *
# * Computations: none                                                                                                      *
# *                                                                                                                         *
# * Errors: none                                                                                                            *
# * Registers Preserved: none                                                                                               *
# *                                                                                                                         *
# * Preconditions: none                                                                                                     *
# * Postconditions: none                                                                                                    *
# *                                                                                                                         *
# * Revision History:                                                                                                       *
# ***************************************************************************************************************************

.ENT delay

delay:

LI $t0, 0
LI $t1, 50000

	.ENT count
	count:
	
	SLT $t3, $t0, $t1
	ADDI $t0,$t0, 1
	BEQZ $t3, done
	
	J count
	
	done:
	
	JR $RA

.END delay

# ***************************************************************************************************************************
# * Function Name: Waiting sequence                                                                                         *
# * Description: Turns on lights 1 through 4 to show waiting times.                                                       *
# *                                                                                                                         *
# * Inputs: none                                                                                                            *
# * Outputs: none	                                                                                                        *
# * Computations: none                                                                                                      *
# *                                                                                                                         *
# * Errors: none                                                                                                            *
# * Registers Preserved: none                                                                                               *
# *                                                                                                                         *
# * Preconditions: none                                                                                                     *
# * Postconditions: none                                                                                                    *
# *                                                                                                                         *
# * Revision History:                                                                                                       *
# ***************************************************************************************************************************

.ENT wait_seq

wait_seq:

#Loops comparators
LI $t0, 0
LI $t1, 10000
LI $t3, 0

#LED Bits
LI $t4, 1
LI $t5, 2
LI $t6, 4
LI $t7, 8

	#play LED sequence
	.ENT while
	while:
	
	
	SLT $t3, $t0, $t1 #If t0 is less than 10000 set t3 =1
	
	ADDI $t0,$t0, 1
	
	ANDI $t4, $t4, 0xFFF0
	SW $t4, (LAT
	

	BEQZ $t3, done 	#if t0 is 0 break
	
	J while
	
	.END while
	
	done:
	
	JR $RA

.END wait_seq

# ***************************************************************************************************************************
# * Function Name: Select operator                                                                                          *
# * Description: Take the state of the buttons select addition, subtraction, shift left, and shift right  based on states.  *
# *                                                                                                                         *
# * Inputs: SW1 & 2                                                                                                         *
# * Outputs: 00, 01, 10, 11	                                                                                                *
# * Computations: none                                                                                                      *
# *                                                                                                                         *
# * Errors: none                                                                                                            *
# * Registers Preserved: none                                                                                               *
# *                                                                                                                         *
# * Preconditions: none                                                                                                     *
# * Postconditions: none                                                                                                    *
# *                                                                                                                         *
# * Revision History:                                                                                                       *
# ***************************************************************************************************************************

.ENT operation

operation:

	LW $t0, (PORTB)
	SW $t0, (OP)


.END