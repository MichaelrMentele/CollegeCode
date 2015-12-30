# ***************************************************************************************************************************
# * Author: Michael Mentele                                                                                      *
# * Course: EE 234 Microprocessor Systems - Lab 6                                                                       *
# * Project:                                                                                                                *
# * File: main_6_finally.S                                                                                                            *
# * Description:  Use timer1 and interrupts to make a 15 bit binary counter.                                 
# *                             
# *                                                                                                                 *                           
# *                                                                                                                         *
# * Inputs:  BTNs, SWs                                                                                                               *
# * Outputs:  LEDs                                                                                                              *
# * Computations:                                                                                                           *
# *                                                                                                                         *
# * revision History: 10/30/12                                                                                                       *
# *************************************************************************************************************************** 

# ***************************************************************************************************************************
# *                                                                                                                         *
# *                                           Include Files                                                                 *
# *                                                                                                                         *
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

.DATA                        # The start of the 

reset: .WORD 0x0
count_dir: .WORD 0x0
stop: .WORD 0x0
both: .WORD 0x0
LED_count: .WORD 0
button_states: .WORD 0x0
LED_number: .WORD 0b00, 0b01, 0b10, 0b11, 0b100, 0b101, 0b110, 0b111, 0b1000, 0b1001, 0b1010, 0b1011, 0b1100, 0b1101, 0b1110, 0b1111

# ***************************************************************************************************************************
# *                                                                                                                         *
# *                                           Code Segment                                                                  *
# *                                                                                                                         *
# ***************************************************************************************************************************

.TEXT                        # The start of the code segment
	                         
.ENT main                    # Setup a main entry point
main:

	SW zero, LED_count

	DI	# Disable system wide interrupts; don't respond to spurious interrupts

	JAL disableTimer1Int	# Ensure external Timer 1 Interrupt is disabled. Recall it's a maskable interrupt
	JAL setupPORTs	# Setup pins to switches as inputs, and pins to on-board LEDs as outputs
	JAL clearLEDs	# Flush out LEDs
	JAL setupMultiVectoredMode	# Want mult-vectored interrupts - each interrupt may have a location in interrupt vector table
	JAL setupTimer1	# Configure Timer 1
	JAL enableTimer1Int	# Allow Timer 1 to grab attention of CPU

	EI	# Enable system wide interrupts

	DI	# Disable system wide interrupts; don't respond to spurious interrupts
	
################################################################################

	JAL disableINT1	# Ensure external interrupt 1 (INT1) is disabled. Recall it's a maskable interrupt
	JAL setupINT1	# Set external interrupt 1 to trigger IRQ on rising edge; provide a priority to INT1
	JAL enableINT1	# Allow INT1 to grab attention of CPU

	EI	# Enable system wide interrupts

	loop:
		# Event loop
	JAL determine_operation #keep going here when timer is not hit to determine count direction
		
	J loop
			
		
	
.END main

# ***************************************************************************************************************************
# *                                                                                                                         *
# *                                           Subroutine Definitions                                                        *
# *                                                                                                                         *
# ***************************************************************************************************************************

# The below comment block is required for all defined subroutines!
# ***************************************************************************************************************************
# * Function Name:  setupPORTs                                                                                                        
# * Description: turn on the right ports to use for devices.  Make them input or outputs based on what they need                                                                                                           
# *                                                                                                                         
# * Inputs:		                                                                                                            
# * Outputs:	                                                                                                            
# * Computations:                                                                                                           
# *                                                                                                                         
# * Errors:                                                                                                                 
# * Registers Preserved: ra, s0                                                                                                   
# *                                                                                                                         
# * Preconditions:                                                                                                          
# * Postconditions:                                                                                                         
# *                                                                                                                         
# * revision History: 10/30/12                                                                                                       
# ***************************************************************************************************************************

.ENT setupPORTs
setupPORTs:

	# Preserve registers - push to stack
	ADDI sp, sp, -8
	SW ra, 4(sp)
	SW s0, 0(sp)
	
	LA s0, TRISB
	# LEDs LD4:1 RB13:10  ALSO set up the off board LEDS RB3:0
	LW t0, (s0)
	ANDI t0, t0, 0b1100001111110000
	SW t0, (s0)
	
	
	LA s0, TRISA
	LW t0, (s0)
	ORI t0, t0, 0b1100000011000000  #Buttons set up, also enables the INT3,INT4
	SW t0, (s0)

	
	LA s0, TRISE
	LW t0, (s0)
	ORI t0, t0, 0b100000000 #INT 1 set up
	SW t0, (s0)

	# Pop registers
	LW s0, 0(sp)
	LW ra, 4(sp)
	ADDI sp, sp, 8
	
	JR ra

.END setupPORTs

# ***************************************************************************************************************************
# * Function Name:  Clear LEDs                                                                                                        *
# * Description:  Make sure the LEDs are off                                                                                                          *
# *                                                                                                                         *
# * Inputs:		                                                                                                            *
# * Outputs:	                                                                                                            *
# * Computations:                                                                                                           *
# *                                                                                                                         *
# * Errors:                                                                                                                 *
# * Registers Preserved:  ra, s0                                                                                                  *
# *                                                                                                                         *
# * Preconditions:                                                                                                          *
# * Postconditions:                                                                                                         *
# *                                                                                                                         *
# * revision History: 10/30/12                                                                                                       *
# ***************************************************************************************************************************


.ENT clearLEDs
clearLEDs:

	# Preserve registers - push to stack
	ADDI sp, sp, -8
	SW ra, 4(sp)
	SW s0, 0(sp)
	
	LA s0, LATB
	# LEDs LD4:1 RB13:10 - clear only these bits
	LW t0, (s0)
	ANDI t0, t0, 0b1100001111110000
	SW t0, (s0)
	
	# Pop registers
	LW s0, 0(sp)
	LW ra, 4(sp)
	ADDI sp, sp, 8
	
	JR ra

.END clearLEDs

# ***************************************************************************************************************************
# * Function Name:     setupMultiVectoredMode                                                                                                     *
# * Description: sets the pin 12 on the INTCON.  Allowing for multivector mode                                                                                                           *
# *                                                                                                                         *
# * Inputs:		                                                                                                            *
# * Outputs:	                                                                                                            *
# * Computations:                                                                                                           *
# *                                                                                                                         *
# * Errors:                                                                                                                 *
# * Registers Preserved:  ra, s0                                                                                                  *
# *                                                                                                                         *
# * Preconditions:                                                                                                          *
# * Postconditions:                                                                                                         *
# *                                                                                                                         *
# * revision History: 10/30/12                                                                                                       *
# ***************************************************************************************************************************


.ENT setupMultiVectoredMode
setupMultiVectoredMode:

	# Preserve registers - push to stack
	ADDI sp, sp, -8
	SW ra, 4(sp)
	SW s0, 0(sp)
	
	# Interrupt control register
	LA s0, INTCON # Register necessary for setting multi-vectored mode
	LW t0, (s0)
	ORI t0, t0, 1 << 12 # Set for mutli-vectored mode
	#SW $t0, ($s0)
	SW t0, INTCON

	# Pop registers
	LW s0, 0(sp)
	LW ra, 4(sp)
	ADDI sp, sp, 8
	
	JR ra

.END setupMultiVectoredMode

# ***************************************************************************************************************************
# * Function Name: setupTimer1                                                                                                         *
# * Description: Gives the PR1 a value for TMR1, clears TMR1 to start with.  Also sets a T1CON value for the PBCLK divide                                                                                                           *
# *     also sets up the prioirty of the timer, this will let the timer go first or the INT1                                                                                                                    *
# * Inputs:		                                                                                                            *
# * Outputs:	                                                                                                            *
# * Computations:                                                                                                           *
# *                                                                                                                         *
# * Errors:                                                                                                                 *
# * Registers Preserved: s0, ra                                                                                                   *
# *                                                                                                                         *
# * Preconditions:                                                                                                          *
# * Postconditions:                                                                                                         *
# *                                                                                                                         *
# * revision History: 10/30/12                                                                                                       *
# ***************************************************************************************************************************


.ENT setupTimer1
setupTimer1:

	# Preserve registers - push to stack
	ADDI sp, sp, -8
	SW ra, 4(sp)
	SW s0, 0(sp)
	
	# T1CON - Control Register for Timer 1
	# Bit 15 - ON Timer On bit, 1 = timer enabled, 0 = disabled
	LA s0, T1CON 
	LI t0, 0x0 # stop Timer 1
	SW t0, (s0)

	# TMR1 register contains 16-bit current value of Timer 1
	LA s0, TMR1
	MOVE t0, zero # clear timer value
	SW t0, (s0)

	# PR1 register contains 16-bit period match value, i.e. TMR1 value == PR1 value ==> interrupt
	LA s0, PR1
	LI t0, 0x08FF # Affects how often interrupt is triggered: the smaller the number, the more often interrupt request occurs
	#LI t0, 0xFFFF # match at 65,535
	SW t0, (s0)

	# T1CON - Control Register for Timer 1
	# Bit 1 - TCS Timer Clock Source, 0 = internal peripheral clk (PBCLK)
	# Bits 5:4 - T40/CKPS Timer Clock Prescale Select bits, 11 = /256, 10 = /64, 01 = /8, 00 = /1
	# Bit 11 - TWIP Asynchronous Timer Write in Progress bit, 1 = Asynchronous write to TMR1 register in progress, 0 = write to TMR1 register complete
	# Bit 15 - ON Timer On bit, 1 = timer enabled, 0 = disabled
	
	LA s0, T1CON 
	LI t0, 0x8030 # PBCLK / 256, Timer 1 on
	SW t0, (s0)

	# Set priority
	LA s0, IPC1 # Interrupt priority register for Timer 1
	# IPC1 T1IP <4:2> for Timer 1
	LW t0, (s0)
	ORI t0, t0, 6 << 2 # priority 6, high on the list
	SW t0, (s0)

	# Pop registers
	LW s0, 0(sp)
	LW ra, 4(sp)
	ADDI sp, sp, 8
	
	JR ra

.END setupTimer1

# ***************************************************************************************************************************
# * Function Name:  enableTimer1Int                                                                                                        *
# * Description:    turning on the TMR1 INT, this allows it to be enabled                                                                                                         *
# *                                                                                                                         *
# * Inputs:		                                                                                                            *
# * Outputs:	                                                                                                            *
# * Computations:                                                                                                           *
# *                                                                                                                         *
# * Errors:                                                                                                                 *
# * Registers Preserved: s0, ra                                                                                                   *
# *                                                                                                                         *
# * Preconditions:                                                                                                          *
# * Postconditions:                                                                                                         *
# *                                                                                                                         *
# * revision History: 10/30/12                                                                                                       *
# ***************************************************************************************************************************


.ENT enableTimer1Int
enableTimer1Int:

	# Preserve registers - push to stack
	ADDI sp, sp, -8
	SW ra, 4(sp)
	SW s0, 0(sp)
	
	LA s0, IEC0 # Interrupt enable control register - our mask register
	LW t0, (s0)
	ORI t0, t0, 1 << 4 # Set corresponding mask bit to 1 to enable, 4 is T1IE (Timer 1 Interrupt Enable) position
	SW t0, (s0)

	# Pop registers
	LW s0, 0(sp)
	LW ra, 4(sp)
	ADDI sp, sp, 8
	
	JR ra
	
.END enableTimer1Int

# ***************************************************************************************************************************
# * Function Name:  enableINT1                                                                                                       *
# * Description:   turning on the INT1 by setting the IECO bit that corresponds to IECO for the INT1                                                                            *
# *                  THis will be put together with all INT setup next time.                                                *
# * Inputs:		                                                                                                            *
# * Outputs:	                                                                                                            *
# * Computations:                                                                                                           *
# *                                                                                                                         *
# * Errors:                                                                                                                 *
# * Registers Preserved: s0, ra                                                                                                   *
# *                                                                                                                         *
# * Preconditions:                                                                                                          *
# * Postconditions:                                                                                                         *
# *                                                                                                                         *
# * revision History: 10/30/12                                                                                                       *
# ***************************************************************************************************************************

.ENT enableINT1
enableINT1:

	# Preserve registers - push to stack
	ADDI sp, sp, -8
	SW ra, 4(sp)
	SW s0, 0(sp)
	
	LA s0, IEC0 # Interrupt enable control register - our mask register
	LW t0, (s0)
	LI t1, 1
	SLL t1, t1, 7 #1 << 7
	OR t0, t0, t1 # Set corresponding mask bit to 1 to enable, 7 is INT1 position
	SW t0, (s0)


	# Pop registers
	LW s0, 0(sp)
	LW ra, 4(sp)
	ADDI sp, sp, 8
	
	JR ra
	
.END enableINT1

# ***************************************************************************************************************************
# * Function Name:   setupINT1                                                                                                       
# * Description:  This turns gives the INT1 a priority and also a polarity.  The IPC1 follows the INT1 and the INTCON 1st bit
# *                 follows the INT1.  Different INTx means dif bits                                                    
# * Inputs:		                                                                                                            
# * Outputs:	                                                                                                            
# * Computations:                                                                                                           
# *                                                                                                                         
# * Errors:                                                                                                                 
# * Registers Preserved: s0, ra                                                                                             
# *                                                                                                                         
# * Preconditions:                                                                                                          
# * Postconditions:                                                                                                         
# *                                                                                                                         
# * revision History: 10/30/12                                                                                                       
# ***************************************************************************************************************************

.ENT setupINT1
setupINT1:

	# Preserve registers - push to stack
	ADDI sp, sp, -8
	SW ra, 4(sp)
	SW s0, 0(sp)
	
	# Set priority
	LA s0, IPC1 # Interrupt priority register
	# IPC4 <28:26> for INT1
	LW t0, (s0)
	LI t1, 1
	SLL t1, t1, 26  #priority level 1, lowest
	OR t0, t0, t1
	SW t0, (s0)

	# Set the polarity
	# Interrupt control register
	LA s0, INTCON # Register necessary for setting polarity of interrupt trigger
	LW t0, (s0)
	ORI t0, t0, 1 << 1 # Set INT1 rising edge trigger
	SW t0, (s0)

	# Pop registers
	LW s0, 0(sp)
	LW ra, 4(sp)
	ADDI sp, sp, 8
	
	JR ra

.END setupINT1

# ***************************************************************************************************************************
# * Function Name:     disableTimer1Int                                                                                                     
# * Description:    use CLR on IECO to turn off.  This ensures it wasnt stuck on                                                                                                        
# *                                                                                                                         
# * Inputs:		                                                                                                            
# * Outputs:	                                                                                                            
# * Computations:                                                                                                           
# *                                                                                                                         
# * Errors:                                                                                                                 
# * Registers Preserved:   ra s0                                                                                                 
# *                                                                                                                         
# * Preconditions:                                                                                                          
# * Postconditions:                                                                                                         
# *                                                                                                                         
# * revision History: 10/30/12                                                                                                       
# ***************************************************************************************************************************

.ENT disableTimer1Int
disableTimer1Int:

	# Preserve registers - push to stack
	ADDI sp, sp, -8
	SW ra, 4(sp)
	SW s0, 0(sp)
	
	LA s0, IEC0CLR # Used to clear bit to disable Timer 1 interrupt
	LI t1, 1
	SLL t1, t1, 4
	SW t1, (s0) 

	# Pop registers
	LW s0, 0(sp)
	LW ra, 4(sp)
	ADDI sp, sp, 8
	
	JR ra
	
.END disableTimer1Int
# ***************************************************************************************************************************
# * Function Name:   disableINT1                                                                                                       
# * Description:    IECOCLR the vector number bit.  This makes sure it wasnt stuck on                                                                                                        
# *                                                                                                                         
# * Inputs:		                                                                                                            
# * Outputs:	                                                                                                            
# * Computations:                                                                                                           
# *                                                                                                                         
# * Errors:                                                                                                                 
# * Registers Preserved:  s0, ra                                                                                                  
# *                                                                                                                         
# * Preconditions:                                                                                                          
# * Postconditions:                                                                                                         
# *                                                                                                                         
# * revision History: 10/30/12                                                                                                       
# ***************************************************************************************************************************
.ENT disableINT1
disableINT1:

	# Preserve registers - push to stack
	ADDI sp, sp, -8
	SW ra, 4(sp)
	SW s0, 0(sp)
	
	LA s0, IEC0CLR # Used to clear bit to disable INT1
	LI t1, 1
	SLL t1, t1, 7
	SW t1, (s0) 

	# Pop registers
	LW s0, 0(sp)
	LW ra, 4(sp)
	ADDI sp, sp, 8
	
	JR ra
	
.END disableINT1
# ***************************************************************************************************************************
# * Function Name:  determine_operation                                                                                                        
# * Description:  We need to see what buttons have been pushed and released.  So we keep checking the buttons and saving into                                                                                                           
# *             data memory what happened                                                                               
# * Inputs:		                                                                                                            
# * Outputs:	                                                                                                            
# * Computations:                                                                                                           
# *                                                                                                                         
# * Errors:                                                                                                                 
# * Registers Preserved:   NONE<<<< note that a0 is used in this, may consider not using >>>>>>>>>>a0<<<<<<<<<<<                                                                                                 
# *                                                                                                                         
# * Preconditions:                                                                                                          
# * Postconditions:                                                                                                         
# *                                                                                                                         
# * revision History: 10/30/12                                                                                                       
# ***************************************************************************************************************************

.ENT determine_operation
determine_operation:
		
		#get button states
		
		LA a0, PORTA
		LW t0, (a0)
		#ADDI t0, t0, 0xC0
		ANDI s0, t0, 0xC0
		
		#determine operation
		BEQZ s0, buttons_released
						
			#if_both aren't waiting to be deasserted then remember what was pushed
			LW t0, (both)
		BEQZ t0, buttons_pushed
						
		JR ra
		
			#change operations 
			buttons_released: 
			
			#reset variables
			SW zero, (both)
			
			#set count direction
			LI t0, 0x1
			LW t1, (button_states)
			BEQ t0, t1, store_dir1
			
			LI t0, 0x2
			LW t1, (button_states)
			BEQ t0, t1, store_dir2
		
			LI t0, 0x3
			LW t1, (button_states)
			BEQ t0, t1, store_dir3
			
			JR ra
			
			#count up
			store_dir1:
			LI t0, 0x1
			SW t0, (count_dir)
			
			LI t0, 0x0
			SW t0, (stop)
			SW zero, (button_states)
		
			JR ra
			
			#count down
			store_dir2:
			LI t0, 0x2
			SW t0, (count_dir)
			
			LI t0, 0x0
			SW t0, stop
			SW zero, (button_states)
		
			JR ra
			
			#stop
			store_dir3:
			LI t0, 0x0
			SW t0, (count_dir)
			SW zero, (button_states)
			
			LW t1, (stop)
			LI t0, 1
			BEQ t0, t1, main
		
			LI t1, 1
			SW t1, (stop)
	
		
		
			JR ra
	
					#save what buttons were pushed

					buttons_pushed:
					#button1
					LI t0, 0x40
					MOVE t1, s0
					#ADDI t1, t1, 0xC0
					BEQ t0, t1, store_button1
					
					#button2
					LI t0, 0x80
					MOVE t1, s0
					BEQ t0, t1, store_button2
					
					#both buttons
					LI t0, 0xC0
					MOVE t1, s0
					#ADDI t1, t1, 0xC0
					BEQ t0, t1, store_button3
					
					JR ra
	
	store_button1:
	LI t0, 0x1
	SW t0, (button_states)
	
	JR ra
	
	store_button2:
	LI t0, 0x2
	SW t0, (button_states)
	
	JR ra
	
	store_button3:
	LI t0, 0x3
	SW t0, (button_states)
	LI t0, 0x1
	SW t0, (both)
	
	JR ra
	
	
.END determine_operation

# ***************************************************************************************************************************
# * Function Name:  Timer1IntHandler                                                                                                        
# * Description:   This is once the timer has been triggered by a reset.  It hit PR1 and reset.
# *    			This should be as small as possible so it can get back to work...                                                                                                         
# *                                                                                                                         
# * Inputs:		                                                                                                            
# * Outputs:	                                                                                                            
# * Computations:                                                                                                           
# *                                                                                                                         
# * Errors:                                                                                                                 
# * Registers Preserved:    all that we use                                                                                                
# *                                                                                                                         
# * Preconditions:                                                                                                          
# * Postconditions:                                                                                                         
# *                                                                                                                         
# * revision History: 10/30/12                                                                                                       
# ***************************************************************************************************************************
.SECTION .vector_4, code	# Attach jump to handler in vector corresponding to INT1

   J      Timer1IntHandler 
  
   
.TEXT 

.ENT Timer1IntHandler
Timer1IntHandler:

	# We want our handlers to be as short as possible. We do want them
	# to execute in as few clock cycles as possible. We generally do
	# not want to call procedures from within these handlers.

	# Coprocessor 0 is necessary to communciate status and control between
	# software and CPU. Will uyse Coprocessor 0 registers in the handler.
	DI	# Disable system wide interrupts

	# Register preservation courtesy of section 8 interrupts ref manual p. 21, 22
	RDPGPR sp, sp
	MFC0 k0, $13	# Cause register
	MFC0 k1, $14	# EPC
	SRL k0, k0, 0xA
	ADDIU sp, sp, -76
	SW k1, 0(sp)
	MFC0 k1, $12	# Status register
	SW k1, 4(sp)
	INS k1, k0, 10, 6
	INS k1, zero, 1, 4
	MTC0 k1, $12	# Status register
	SW s8, 8(sp)
	SW a0, 12(sp)
	SW a1, 16(sp)
	SW a2, 20(sp)
	SW a3, 24(sp)
	SW v0, 28(sp)
	SW v1, 32(sp)
	SW t0, 36(sp)
	SW t1, 40(sp)
	SW t2, 44(sp)
	SW t3, 48(sp)
	SW t4, 52(sp)
	SW t5, 56(sp)
	SW t6, 60(sp)
	SW t7, 64(sp)
	SW t8, 68(sp)
	SW t9, 72(sp)
	ADDU s8, sp, zero

	# Clear Timer 1 Interrupt status flag
	LA t0, IFS0CLR
	LW t1, (t0)
	ORI t1, t1, 1 << 4 # Timer 1 bit position
	SW t1, (t0)

#*************************************************************************
	LA s1, LED_count

#check the direction of counting
	LI t0, 0x1
	LW t1, (count_dir)
	BEQ t0, t1, count_up
	
	LI t0, 0x2
	LW t1, (count_dir)
	BEQ t0, t1, count_down
	
	LI t0, 0x0
	LW t1, (count_dir)
	BEQ t0, t1, count_stop

	j skip
	
#inc/dec/stop led count
	
			count_up:
			
			LI t0, 15
			LW t1, (s1)
			SUB t0, t0, t1
			LI t2, -1
			MOVZ t1, t2, t0
			
			SW t1, (s1)
			ADDI t1, t1, 1
			SW t1, (s1)
		
		J skip
	
			count_down:
			
			LI t0, 0
			LW t1, (s1)
			SUB t0, t0, t1
			LI t2, 16
			MOVZ t1, t2, t0
			
			SW t1, (s1)
			ADDI t1, t1, -1
			SW t1, (s1)
		
		J skip
	
			count_stop:
		
			LI t0, 0x1
			LW t1, (stop)

	skip:

#	LA s1, LED_count
	LW t1, (s1)	
	SLL t0, t1, 2  #mult the LED_count by 4 (SLL 2) and add to register address of LED_number
	LA t1, LED_number
	ADD t1, t0, t1
	LW t3, (t1)
#	MOVE t0, t3
	SLL t0, t3, 10
	ANDI t0, t0, 0x3C00
		LW t3, (LATB)
		ANDI t3, t3, 0xF #making sure the last 4 bits are saved, keeping the off-board LEDs constant
		OR t0, t0, t3
	SW t0, (LATB)

#**************************************************************************

	ADDU sp, s8, zero
	LW t9, 72(sp)
	LW t8, 68(sp)
	LW t7, 64(sp)
	LW t6, 60(sp)
	LW t5, 56(sp)
	LW t4, 52(sp)
	LW t3, 48(sp)
	LW t2, 44(sp)
	LW t1, 40(sp)
	LW t0, 36(sp)
	LW v1, 32(sp)
	LW v0, 28(sp)
	LW a3, 24(sp)
	LW a2, 20(sp)
	LW a1, 16(sp)
	LW a0, 12(sp)
	LW s8, 8(sp)


	LW k0, 0(sp)
	MTC0 k0, $14	# EPC register
	LW k0, 4(sp)
	MTC0 k0, $12	# Status register

	EI	# Enable system wide interrupts

	ERET # PC = EPC

.END Timer1IntHandler

j main 

################################################################
################################################################
####################### INT1 ###################################
################################################################
################################################################
;
;# ***************************************************************************************************************************
;# * Function Name:  ExtInt1Handler                                                                                          
;# * Description:  This is once INT1 is flipped.  Make it short as can be.                                      
;# *                                                                                                                          
;# * Inputs:		                                                                                                             
;# * Outputs:	                                                                                                             
;# * Computations:                                                                                                            
;# *                                                                                                                          
;# * Errors:                                                                                                                  
;# * Registers Preserved:   all that will be used                                                                             
;# *                                                                                                                          
;# * Preconditions:                                                                                                           
;# * Postconditions:                                                                                                          
;# *                                                                                                                          
;# * revision History: 10/30/12                                                                                                        
;# ***************************************************************************************************************************
;
;



.SECTION .vector_7, code	# Attach jump to handler in vector corresponding to INT1

   J      ExtInt1Handler 
  
   
.TEXT 

.ENT ExtInt1Handler
ExtInt1Handler:

	# We want our handlers to be as short as possible. We do want them
	# to execute in as few clock cycles as possible. We generally do
	# not want to call procedures from within these handlers.

	# Coprocessor 0 is necessary to communciate status and control between
	# software and CPU. Will uyse Coprocessor 0 registers in the handler.
	DI	# Disable system wide interrupts

	# Register preservation courtesy of section 8 interrupts ref manual p. 21, 22
	RDPGPR sp, sp
	MFC0 k0, $13	# Cause register
	MFC0 k1, $14	# EPC
	SRL k0, k0, 0xA
	ADDIU sp, sp, -76
	SW k1, 0(sp)
	MFC0 k1, $12	# Status register
	SW k1, 4(sp)
	INS k1, k0, 10, 6
	INS k1, zero, 1, 4
	MTC0 k1, $12	# Status register
	SW s8, 8(sp)
	SW a0, 12(sp)
	SW a1, 16(sp)
	SW a2, 20(sp)
	SW a3, 24(sp)
	SW v0, 28(sp)
	SW v1, 32(sp)
	SW t0, 36(sp)
	SW t1, 40(sp)
	SW t2, 44(sp)
	SW t3, 48(sp)
	SW t4, 52(sp)
	SW t5, 56(sp)
	SW t6, 60(sp)
	SW t7, 64(sp)
	SW t8, 68(sp)
	SW t9, 72(sp)
	ADDU s8, sp, zero

	# Clear INT1 status flag
	LA t0, IFS0CLR
	LI t1, 1
	# Need to shift, mask too big for ANDI with other values, keep same syntax
	SLL t1, t1, 7
	SW t1, (t0)

	# Write to all on-board LEDs to show interrupt handled.
	# Toggle LEDs everytime this handler is executed
	
	LW t0, (LATB)
	SRL t2, t0, 10
		ANDI t0, t0, 0xFFF0
	#LW t1, (LATB)
	OR t0, t2, t0
	SW t0, (LATB)


	ADDU sp, s8, zero
	LW t9, 72(sp)
	LW t8, 68(sp)
	LW t7, 64(sp)
	LW t6, 60(sp)
	LW t5, 56(sp)
	LW t4, 52(sp)
	LW t3, 48(sp)
	LW t2, 44(sp)
	LW t1, 40(sp)
	LW t0, 36(sp)
	LW v1, 32(sp)
	LW v0, 28(sp)
	LW a3, 24(sp)
	LW a2, 20(sp)
	LW a1, 16(sp)
	LW a0, 12(sp)
	LW s8, 8(sp)


	LW k0, 0(sp)
	MTC0 k0, $14	# EPC register
	LW k0, 4(sp)
	MTC0 k0, $12	# Status register

	EI	# Enable system wide interrupts

	ERET # PC = EPC

.END ExtInt1Handler
