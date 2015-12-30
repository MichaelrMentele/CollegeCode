# ***************************************************************************************************************************
# * Author: Michael Mentele                                                                                                 *
# * Course: EE 234 Microprocessor Systems                                                                                   *
# * Project: Lab 4                                                                                                          *
# * File: lab4.s                                                                                                            *
# * Description: Using basic bit operations we will create a 4-operation calculator using four numbers                      *
# *                                                                                                                         *
# *                                                                                                                         *                           
# *                                                                                                                         *
# * Inputs:  Switch States                                                                                                  *
# * Outputs: 4-bit binary number on the on-board LEDs                                                                       *
# * Computations: Addition/Subtraction/Shifting                                                                             *
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

operands: .WORD 0x4, 0x5, 0x6, 0x7 #not used

# ***************************************************************************************************************************
# *                                                                                                                         *
# *                                           Code Segment                                                                  *
# *                                                                                                                         *
# ***************************************************************************************************************************

.TEXT                        # The start of the code segment
	                         
.ENT main                    # Setup a main entry point
main:
 #LA $a0, operands

	JAL reset                # JAL instruction ensures address of return point is stored in register ra
	JAL setup_switches       # setup pins to read on port B
	JAL setup_LEDs           # setup pins to be written to on port B
	JAL store_numbers 
	JAL flash_for_2          # Flash to signify end of state
	JAL switch1_2            # retrieve state of switches 1 & 2 to choose operator
	JAL flash_for_2		     # Flash to signify end of state
	JAL switch3              # First operand
	JAL sll_srl              # Shift if operation was set to shift
	JAL switch4              # Second operand
	JAL add_sub              # Perform arithmetic

	#loop:
		# Event loop
	

#	end:	
	#	J loop               # Embedded programs require that they run forever! So jump back to the beginning of the loop
	
.END main

# ***************************************************************************************************************************
# *                                                                                                                         *
# *                                           Subroutine Definitions                                                        *
# *                                                                                                                         *
# ***************************************************************************************************************************


# ***************************************************************************************************************************
# * Function Name:  flash_for_2                                                                                              
# * Description: Display LEDs to show end of current state for about 2 seconds                                                                                                            
# *                                                                                                                         
# * Inputs:	none                                                                                                            
# * Outputs: none                                   	                                                                        	
# * Computations: none                                                                                                          
# *                                                                                                                         
# * Errors: none                                                                                                                
# * Registers Preserved:  none                                                                                                  
# *                                                                                                                         
# * Preconditions: none                                                                                                         
# * Postconditions:  none                                                                                                      
# *                                                                                                                         
# * Revision History:  9/30/12                                                                                              
# ***************************************************************************************************************************
	
.ENT flash_for_2
flash_for_2:

	LI $t5, 0x20000

	LI $t4, 0xF
	
	count:
	SW $t4, (LATB)
	ADDI $t5, $t5, -1
	
	BEQZ $t5, out
	J count

	out:
	
	SW $zero, (LATB)
	JR $ra

.END flash_for_2
	


# ***************************************************************************************************************************
# * Function Name:  switch1_2                                                                                               
# * Description: Choose operation.                                                                                                           
# *                                                                                                                         
# * Inputs:	none                                                                                                            
# * Outputs: none                                  	                                                                        	
# * Computations: none                                                                                                          
# *                                                                                                                         
# * Errors:                                                                                                                 
# * Registers Preserved:                                                                                                    
# *                                                                                                                         
# * Preconditions:                                                                                                          
# * Postconditions:                                                                                                         
# *                                                                                                                         
# * Revision History:  9/30/12                                                                                              
# ***************************************************************************************************************************


.ENT switch1_2
switch1_2:
	
	LI $t4, 0x20000
	while:
	
	LW $a0, (PORTB) #only
	ANDI $a0, $a0, 0xC00
	SW $a0, (PORTB)
	
	ADDI $t4, $t4, -1
	
	BEQZ $t4, done
	J while

done:	

	JR $ra
.END switch1_2
	


# ***************************************************************************************************************************
# * Function Name:  switch3                                                                                               
# * Description:                                                                                                            
# *                                                                                                                         
# * Inputs:	none                                                                                                            
# * Outputs:                                   	                                                                        	
# * Computations:                                                                                                           
# *                                                                                                                         
# * Errors:                                                                                                                 
# * Registers Preserved:                                                                                                    
# *                                                                                                                         
# * Preconditions:                                                                                                          
# * Postconditions:                                                                                                         
# *                                                                                                                         
# * Revision History:  9/30/12                                                                                              
# ***************************************************************************************************************************

.ENT switch3
switch3:

LI $t4, 0x40000
	while2:
	LW $s0, (PORTB)
	ANDI $s0, $s0, 0x3000 
#	SW $s0, ($t7)
	ADDI $t4, $t4, -1
	
	BEQZ $t4, doner
	J while2

doner:	

	BEQ $s0,0x0, sw_t0        # operand is: 4
	BEQ $s0,0x1000, sw_t1     #             5
	BEQ $s0,0x2000, sw_t2     #             6
	BEQ $s0,0x3000, sw_t3     #             7

		#Display Operand(s) in binary
		sw_t0:                
		MOVE $s0, $t0
		SW $t0, (LATB)
		
		B sw3_set
		
		sw_t1:
		MOVE $s0, $t1
		SW $t1, (LATB)
		B sw3_set
		
		sw_t2:
		MOVE $s0, $t2
		SW $t2, (LATB)
		B sw3_set
		
		sw_t3:
		MOVE $s0, $t3
		SW $t3, (LATB)

sw3_set:

	LI $t5, 0x20000
	counter:

	ADDI $t5, $t5, -1
	
	BEQZ $t5, out2
	J counter

	out2:
	
	SW $zero, (LATB)


JR $ra
.END switch3

# ***************************************************************************************************************************
# * Function Name:  sll_srl                                                                                               
# * Description: Shift left and right by no more than 1.                                                                                                            
# *                                                                                                                         
# * Inputs:	$a0                                                                                                            
# * Outputs: $a0                                  	                                                                        	
# * Computations: shift bit by one                                                                                                           
# *                                                                                                                         
# * Errors: none                                                                                                                
# * Registers Preserved: none                                                                                                    
# *                                                                                                                         
# * Preconditions: none                                                                                                         
# * Postconditions: none                                                                                                        
# *                                                                                                                         
# * Revision History:  9/30/12                                                                                              
# ***************************************************************************************************************************

.ENT sll_srl
sll_srl:

		
#	BEQ $a0, 0x0, addition
#	BEQ $a0, 0x800, addition
	BEQ $a0, 0x400, shift_left
	BEQ $a0, 0xC00, shift_right

JR $ra

	shift_left:
	
	SLL $t7, $s0, 1
	
	SW $t7, (LATB)
loop1:
j loop1

shift_right:
	
	SRL $t7, $s0, 1
	
	SW $t7, (LATB)
loop12:
j loop12
	
JR $ra
.END sll_srl
	
# ***************************************************************************************************************************
# * Function Name:  switch4                                                                                                
# * Description: Select operand 2.                                                                                                          
# *                                                                                                                         
# * Inputs:	none                                                                                                            
# * Outputs: none                                   	                                                                        
# * Computations: none                                                                                                           
# *                                                                                                                         
# * Errors: none                                                                                                                
# * Registers Preserved: none                                                                                                   
# *                                                                                                                         
# * Preconditions: none                                                                                                        
# * Postconditions: none                                                                                                        
# *                                                                                                                         
# * Revision History:  9/30/12                                                                                              
# ***************************************************************************************************************************

.ENT switch4
switch4:

LI $t4, 0x40000
	while3:
	LW $s1, (PORTB)
	ANDI $s1, $s1, 0x3000 
#	SW $s1, ($t7)
	ADDI $t4, $t4, -1
	
	BEQZ $t4, d
	J while3

d:	

#**********************>>>>>>>
	BEQ $s1,0x0, s_t0
	BEQ $s1,0x1000, s_t1
	BEQ $s1,0x2000, s_t2
	BEQ $s1,0x3000, s_t3

		s_t0:
		MOVE $s1, $t0
		SW $t0, (LATB)
		
		B sw4_set
		
		s_t1:
		MOVE $s1, $t1
		SW $t1, (LATB)
		B sw4_set
		
		s_t2:
		MOVE $s1, $t2
		SW $t2, (LATB)
		B sw4_set
		
		s_t3:
		MOVE $s1, $t3
		SW $t3, (LATB)

sw4_set:

	LI $t5, 0x20000
	counter1:
#	LW $t6, (PORTB)
#	ANDI $t6, $t6, 0x3000
#	SW $t6, (LATB)
	ADDI $t5, $t5, -1
	
	BEQZ $t5, out3
	J counter1

	out3:
	
	SW $zero, (LATB)

JR $ra

.END switch4


#*******************************************************************************

# ***************************************************************************************************************************
# * Function Name:  add_sub                                                                                                 *
# * Description:   reads the sw1 and sw2 input and adds or sub the sw3 and sw4                                              *
# *                                                                                                                         *
# * Inputs:	none                                                                                                            *
# * Outputs:                                  		                                                                        *
# * Computations:                                                                                                           *
# *                                                                                                                         *
# * Errors:                                                                                                                 *
# * Registers Preserved:                                                                                                    *
# *                                                                                                                         *
# * Preconditions:                                                                                                          *
# * Postconditions:                                                                                                         *
# *                                                                                                                         *
# * Revision History:  9/30/12                                                                                              *
# ***************************************************************************************************************************


.ENT add_sub
add_sub:

		
	BEQ $a0, 0x0, addition #if no switches are on ADD
	BEQ $a0, 0x800, subtract #if only switch 2 is on subtract

JR $ra

	#perform addition
	addition:
	
	ADD $t7, $s0, $s1
	
	SW $t7, (LATB)
loop123:
j loop123

	#perform subtraction
	subtract:
	
	SUB $t7, $s0, $s1
	
	SW $t7, (LATB)
	
	#your stuck now cuz your done
	loop1234:
	j loop1234

JR $ra
.END add_sub


	


# ***************************************************************************************************************************
# * Function Name:  reset                                                                                                   *
# * Description:   lets make sure the read port latn is zero                                                                *
# *                                                                                                                         *
# * Inputs:	none                                                                                                            *
# * Outputs: latn will have zeros writen in it		                                                                        *
# * Computations: none                                                                                                           *
# *                                                                                                                         *
# * Errors: none                                                                                                                 *
# * Registers Preserved: none                                                                                                   *
# *                                                                                                                         *
# * Preconditions: none                                                                                                          *
# * Postconditions: none                                                                                                         *
# *                                                                                                                         *
# * Revision History:  9/27/12                                                                                              *
# ***************************************************************************************************************************

.ENT reset
reset:

	# Clear pins connected to PORTB, so LEDs don't always turn on
	MOVE $t4, $zero
	SW $t4, (LATB)
	
	# Return to caller
	JR $ra
	
.END reset



# ***************************************************************************************************************************
# * Function Name: setup_switches                                                                                           *
# * Description: Or the bits needed to use the switches, this makes them have a 1 for input                                 *
# *                   Also set the switch to digital pins from analog                                                       *
# * Inputs:	trisb                                                                                                        *
# * Outputs: trisb                                                                                                       *
# * Computations: or trisb to change bits needed to be 1, inputs                                                            *
# *                                                                                                                         *
# * Errors: none                                                                                                                *
# * Registers Preserved: none                                                                                                    *
# *                                                                                                                         *
# * Preconditions:  none                                                                                                        *
# * Postconditions: none                                                                                                        *
# *                                                                                                                         *
# * Revision History: 9/27/12                                                                                               *
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


# The below comment block is required for all defined subroutines!
# ***************************************************************************************************************************
# * Function Name: setup_LEDs                                                                                               *
# * Description: ands the bits needed with 0 to make sure they are set as outputs                                           *
# *                                                                                                                         *
# * Inputs:	none                                                                                                         *
# * Outputs: trisb gets value                                                                                            *
# * Computations: anding trisb with value                                                                                   *
# *                                                                                                                         *
# * Errors: none                                                                                                                 *
# * Registers Preserved: trisb                                                                                              *
# *                                                                                                                         *
# * Preconditions:  none                                                                                                        *
# * Postconditions:   none                                                                                                      *
# *                                                                                                                         *
# * Revision History:  9/27/12                                                                                              *
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
# * Function Name: store numbers                                                                               *
# * Description: lets you change the $to0-$t3 all in one place                                                              *
# *                                                                                                                         *
# * Inputs:	none                                                                                                         *
# * Outputs: sets the $t0-3 to values and holds them, bad idea?                                                          *
# * Computations:                                                                                                           *
# *                                                                                                                         *
# * Errors:   none                                                                                                              *
# * Registers Preserved: none                                                                                                   *
# *                                                                                                                         *
# * Preconditions:   none                                                                                                       *
# * Postconditions:  none                                                                                                       *
# *                                                                                                                         *
# * Revision History:  9/27/12                                                                                              *
# ***************************************************************************************************************************


.ENT store_numbers
store_numbers:

	#give the $t0-$t3 values, and do not use in code again!!

	LI $t0, 0x4
	LI $t1, 0x5
	LI $t2, 0x6
	LI $t3, 0x7


JR $ra

.END store_numbers
	

