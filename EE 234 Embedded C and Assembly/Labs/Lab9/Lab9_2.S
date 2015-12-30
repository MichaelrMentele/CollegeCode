# ***************************************************************************************************************************
# * Author: Michael Mentele                                                                                                             
# * Course: EE 234 Microprocessor Systems - Lab # 9                                                                         
# * Project: Robomal part2                                                                                                              
# * File: CodeTemplate.s                                                                                                    
# * Description:                                                    
# *                                                                                                                         
# * Inputs:                                                                                                                 
# * Outputs:                                                                                                                
# * Computations:                                                                                                           
# *                                                                                                                         
# * Revision History: 11/13/12                                                                                                   
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
	JAL setupMultiVectoredMode	# Want mult-vectored interrupts - each interrupt may have a location in interrupt vector table
	JAL setupOC2_3Module

	EI


	loop:

	LW t0, (PORTB)
	SRL t0, t0, 10
	ANDI t0, 0xF
	MOVE s3, t0
	
		#navigates to a subroutine based on the opcode
		JAL	do
			
	
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
# * Revision History: 11/13/12                                                                                                      *
# ***************************************************************************************************************************

.ENT do
do:

		
		#Save return address because we have subroutines
		ADDI sp, sp, -4
		SW ra, 0(sp) # push
				
		#Robot Control Instructions (RCI)
		#LEFT
		BEQ s3, 0b01, left
		#RIGHT
		BEQ s3, 0b10, right
		#FORWARD
		BEQ s3, 0b11, forward
		#brake
		BEQ s3, 0b00, brake
		
		done:
			
		#reset return address
		LW ra, 0(sp) # pop
		ADDI sp, sp, 4
	
		JR ra

.END do
#############################################################################################################################
############################################### End of DO ###################################################################


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
# * Revision History: 11/13/12                                                                                                     *
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
		
		#write 0 to LATD
		LI t0, 0xC6  #Clear DIR/EN pins
		SW t0, LATDCLR
		
		#turn output into input for DIR
		LI t0, 0xC0
		SW t0, TRISDSET
		
				####CHANGED FROM FORWARD#######
				#setting duty cycle for turning
				LI t1, 40
				LI t2, 40
				####CHANGED FROM FORWARD#######
			
				#Operations are performed assuming PR2 == 100	
				LA s0, OC3RS
				SW t1, (s0)
				LA s0, OC2RS
				SW t2, (s0)
			
		#turn back into output
		LI t0, 3 << 6  #set back to output pins
		SW t0, TRISDCLR
		
		####CHANGED FROM FORWARD#######
		LI t0, 0x06 #wheel need to go in opposite directions
		SW t0, LATDSET
		####CHANGED FROM FORWARD#######
	
		# T2CON T3CON - Control Register for Timer 2 - can combine with Timer 3 to form 32-bit timer!
		# Bit 1 - TCS Timer Clock Source, 0 = internal peripheral clk (PBCLK)
		# Bit 3 - 1 = 32-bit timer, 0 = 16-bit timer
		# Bits 6:4 - TCKPS Timer Clock Prescale Select bits, these are slightly different than with Timer 1; 100 = /16
		# Bit 15 - ON Timer On bit, 1 = timer enabled, 0 = disabled
		LA s0, T2CON 
		LI t0, 0x8050 # PBCLK / 16, Timer 2 on, 16-bit timer mode, use PBCLK
		SW t0, (s0)
		
		JAL delay2

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
# * Revision History: 11/13/12                                                                                                      *
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
		
		#write 0 to LATD
		LI t0, 0xC6  #Clear DIR/EN pins
		SW t0, LATDCLR
		
		#turn output into input for DIR
		LI t0, 0xC0
		SW t0, TRISDSET
		
				####CHANGED FROM FORWARD#######
				#setting duty cycle for turning
				LI t1, 40
				LI t2, 40
				####CHANGED FROM FORWARD#######
			
				#Operations are performed assuming PR2 == 100		
				LA s0, OC3RS
				SW t1, (s0)
				LA s0, OC2RS
				SW t2, (s0)
			
		#turn back into output
		LI t0, 3 << 6  #set back to output pins
		SW t0, TRISDCLR
		
		####CHANGED FROM FORWARD#######
		LI t0, 0xC6 #wheel need to go in opposite directions
		SW t0, LATDSET
		####CHANGED FROM FORWARD#######
	
		# T2CON T3CON - Control Register for Timer 2 - can combine with Timer 3 to form 32-bit timer!
		# Bit 1 - TCS Timer Clock Source, 0 = internal peripheral clk (PBCLK)
		# Bit 3 - 1 = 32-bit timer, 0 = 16-bit timer
		# Bits 6:4 - TCKPS Timer Clock Prescale Select bits, these are slightly different than with Timer 1; 100 = /16
		# Bit 15 - ON Timer On bit, 1 = timer enabled, 0 = disabled
		LA s0, T2CON 
		LI t0, 0x8050 # PBCLK / 16, Timer 2 on, 16-bit timer mode, use PBCLK
		SW t0, (s0)
		
		JAL delay2
	
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
# * Revision History: 11/13/12                                                                                                      *
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
		
		#write 0 to LATD
		LI t0, 0xC6  #Clear DIR/EN pins
		SW t0, LATDCLR
		
		#turn output into input for DIR
		LI t0, 0xC0
		SW t0, TRISDSET
		
				LI t1, 25
				LI t2, 25
			
				#Operations are performed assuming PR2 == 100	
				LA s0, OC3RS
				SW t1, (s0)
				LA s0, OC2RS
				SW t2, (s0)
			
		#turn back into output
		LI t0, 0xC0  #set back to output pins
		SW t0, TRISDCLR

		LI t0, 0x46  #set direction
		SW t0, LATDSET
	
		# T2CON T3CON - Control Register for Timer 2 - can combine with Timer 3 to form 32-bit timer!
		# Bit 1 - TCS Timer Clock Source, 0 = internal peripheral clk (PBCLK)
		# Bit 3 - 1 = 32-bit timer, 0 = 16-bit timer
		# Bits 6:4 - TCKPS Timer Clock Prescale Select bits, these are slightly different than with Timer 1; 100 = /16
		# Bit 15 - ON Timer On bit, 1 = timer enabled, 0 = disabled
		LA s0, T2CON 
		LI t0, 0x8050 # PBCLK / 16, Timer 2 on, 16-bit timer mode, use PBCLK
		SW t0, (s0)
		
		JAL delay2
	
	# Pop registers
	LW s0, 0(sp)
	LW ra, 4(sp)
	ADDI sp, sp, 8

	JR ra
	

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
# * Revision History: 11/13/12                                                                                                     *
# ***************************************************************************************************************************

.ENT backward
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
				SRL t1, t0, 8 #look at motor 1 (left bits for speed value)
				AND t2, t0, 0xFF #get motor 2 (right bits for speed value)
			
				#Operations are performed assuming PR2 == 100	
				LA s0, OC3RS
				SW t1, (s0)
				LA s0, OC2RS
				SW t2, (s0)
			
		#turn back into output
		LI t0, 3 << 6  #set back to output pins
		SW t0, TRISDCLR

		####CHANGED FROM FORWARD#######
		#Pin directions must be opposite for backwards 
		LI t0, 0x86
		SW t0, LATDSET
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
# * Revision History: 11/13/12                                                                                                    *
# ***************************************************************************************************************************

.ENT brake
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
# * Revision History: 11/13/12                                                                                                    *
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
# * Revision History: 11/13/12                                                                                                      *
# ***************************************************************************************************************************
.ent delay
delay:

	LI t5, 0x15000
#	MUL t5, s4, t5
	
	counting:
	addi t5, t5, -1
	beqz t5, out
	j counting

	out:
	
	jr ra
	
.end delay


# ***************************************************************************************************************************
# * Function Name: Delay2                                                                                                         *
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
# * Revision History: 11/13/12                                                                                                      *
# ***************************************************************************************************************************
.ent delay2
delay2:

	
#	LI t5, 350
	LI t5, 0x80
	MUL t5, s4, t5
	
	counting2:
	addi t5, t5, -1
	beqz t5, out2
	j counting2

	out2:
	
	jr ra
	
.end delay2


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

.ENT setupPORTs
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

	# Need to set switch I/O pins to inputs;
	# Switches connected to JK 01:04 of Cerebot;
	# SW1 - RB10, SW2 - RB11, SW3 - RB12, SW4 - RB13
	
	LI t4, 0x3C00
	SW t4, (AD1PCFG) # Set the analog pins to digital

	LW t4, (TRISB)
	ORI t4, t4, 0x3C00 # Only set required pins for switches on PORTB
	SW t4, (TRISB)


	# Pop registers
	LW s0, 0(sp)
	LW ra, 4(sp)
	ADDI sp, sp, 8
	
	JR ra

.END setupPORTs

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

.ENT setupOC2_3Module
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








