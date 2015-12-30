/*******************************************************************************
 * Programmer: AO                                                              *
 * Class: EE 234                                                               *
 * Lab Project: 2                                                              *
 * Date:                                                                       *
 *                                                                             *
 * Description: Simon Says is a classic electronic game that uses tones and    *
 * lights to help strengthen and test memory skills. The computer plays a      *
 * series of tones and lights up colored buttons. You must use your memory     *
 * to recall the same sequence of buttons lit up by the computer. The game     *
 * progresses with a new tone and button lighting up every turn. The game      *
 * is over once the player incorrectly recalls the sequence of buttons.        *
 * This lab project provides a basic implementation for Simon Says.            *
 *                                                                             *
 * We use Digilent peripheral modules to represent the Simon Says              *
 * game controls, including the buttons (represented by switches)              *    
 * and lights (LEDs). However, in this lab we did not implement the tone       *
 * controls. We interface with the peripherals via input/output (I/O)          *
 * ports.                                                                      *
 *                                                                             *
 ******************************************************************************/

// #include all necessary standard and user-defined libraries
#include <plib.h> // Includes all major functions and macros required to develop
                  // programs for the PIC32MX4
#include <stdlib.h>

// Place your #pragma statements here, or in another .h file;
// #pragma statements are used to set your operating clock frequency

// SYSCLK = 80 MHz (8 MHz Crystal/ FPLLIDIV * FPLLMUL / FPLLODIV)
// PBCLK = 40 MHz
// Primary Osc w/PLL (XT+,HS+,EC+PLL)
// WDT OFF
// Other options are don't care

#pragma config FNOSC	 = PRIPLL // Required
#pragma config FPLLMUL  = MUL_20
#pragma config FPLLIDIV  = DIV_2
#pragma config FPBDIV  = DIV_2 // Divide SYSCLK by 2 ==> PBCLK
#pragma config FPLLODIV  = DIV_1 

// Place your #define constants and macros here, or in another .h file

// Yes, don't forget your prototypes
// Prototypes go here, or in a .h file, which you would also need to #include

void setup_switches (void);
void setup_LEDs (void);
unsigned int get_switch_states (void);
void output_SWTs_to_LEDs (unsigned int button_states);
void output_to_LEDs (unsigned int output);
void my_delay (void);

int main (void)
{
	// Variable declarations
	unsigned int switch_states = 0;

	// Setup/initialize ports
	// Setup/initialize devices
	
	setup_switches ();
	setup_LEDs ();
	
	while (1) // Embedded programs run forever
	{
		// Event loop
		
		for (count = 0; ((count < 8) && (game_over != 1)); count++)
		{
			do
			{
				switch_states = get_switch_states ();
			} while (switch_states == 0); // Switches have not been flipped
				
			output_SWTs_to_LEDs (switch_states);
			
			switch (switch_states) // Align switch state with LEDs
			{
				case BIT_10: switch_sequence_array[count] = 0;
				             break;
				case BIT_11: switch_sequence_array[count] = 1;
				             break;
				case BIT_12: switch_sequence_array[count] = 2;
				             break;
				case BIT_13: switch_sequence_array[count] = 3;
				             break;
			}
				
			do
			{
				switch_states = get_switch_states ();
			} while (switch_states != 0); // Switches have been flipped
			
			output_to_LEDs (0);
			
			if (switch_sequence_array[count] != LED_sequence_array[count]) // Does the switch match order of LEDs?
			{
				output_to_LEDs (15); // Turn on all LEDs
				game_over = 1; // Player lost
			}
		}	
		
		if (game_over != 1) // Player won
		{
			while (1)
			{
				for (count = 0; count < 4; count++)
				{
					output_to_LEDs (1 << count);
					my_delay ();
					output_to_LEDs (0);
					my_delay ();
				}
			}	
		}
	}

	return 0;
}

/*************************************************************
 * Function: setup_switches ()                               *
 * Date Created:                                             *
 * Date Last Modified:                                       *
 * Description: This function sets up the pins to the        *
 *              peripheral switches as input pins            *              
 * Input parameters: None                                    *
 * Returns: Nothing                                          *
 * Usages: Must be called once, before you read from SWTs    *
 * Preconditions: None                                       *
 * Postconditions: Pins to SWTs are input pins               *
 *************************************************************/

void setup_switches (void)
{
	// SW1 -> RB10, SW2 -> RB11, SW3 -> RB12, SW4 -> RB13 -- PortB
	// Connected to Cerebot pins JK-01:JK-04
	
	PORTSetPinsDigitalIn (IOPORT_B, BIT_10 | BIT_11 | BIT_12 | BIT_13);
}

/*************************************************************
 * Function: setup_LEDs ()                                   *
 * Date Created:                                             *
 * Date Last Modified:                                       *
 * Description: This function sets up the pins to the        *
 *              peripheral LEDs as output pins               *              
 * Input parameters: None                                    *
 * Returns: Nothing                                          *
 * Usages: Must be called once, before you write to LEDs     *
 * Preconditions: None                                       *
 * Postconditions: Pins to LEDs are output pins              *
 *************************************************************/

void setup_LEDs (void)
{
	// LD0 -> RB0, LD1 -> RB1, LD2 -> RB2, LD3 -> RB3 -- PortB
	// Connected to Cerebot pins JJ-01:JJ-04

	PORTSetPinsDigitalOut (IOPORT_B, BIT_0 | BIT_1 | BIT_2 | BIT_3);
}

/*************************************************************
 * Function: get_switch_states ()                            *
 * Date Created:                                             *
 * Date Last Modified:                                       *
 * Description: This function reads the state of the         * 
 *              peripheral switches. 1 - indicates switch    *
 *              is on, 0 - otherwise                         *       
 * Input parameters: None                                    *
 * Returns: Values of SWTs                                   *
 * Usages: Must be called after SWTs have been set to output *
 * Preconditions: None                                       *
 * Postconditions: Masked state of switches                  *
 *************************************************************/

unsigned int get_switch_states (void)
{
	unsigned int switch_states = 0;

	// Read the entire 32-bit PORTB to get the state of the switches
	// Mask the PORT bits so that the corresponding switch bits are isolated; 
	// We do not care about the other 28-bits of PORTB
	// Little Endian is used: bit31 bit30 bit29 ... bit02 bit01 bit00
	// 1 hex digit = 1 nibble = 4 bits
	
	// unsigned int	PORTRead(IoPortId portId);
	switch_states = PORTRead (IOPORT_B) & 0x00003C00; // SW1 -> RB10, SW2 -> RB11, SW3 -> RB12, SW4 -> RB13

	return switch_states;
}

/*************************************************************
 * Function: output_SWTs_to_LEDs ()                          *
 * Date Created:                                             *
 * Date Last Modified:                                       *
 * Description: This function writes the state of the SWTs   *    
 *              to the LEDs. If SWT is on, then LED          *
 *              turns on. SW1 -> LD0, SW2 -> LD1, SW3 -> LD2 *   
 *                        SW4 -> LD3                         *       
 * Input parameters: Values of SWTs                          *
 * Returns: Nothing                                          *
 * Usages: Must be called after SWTs are read                *
 * Preconditions: SWTs must be masked                        *
 * Postconditions: LEDs contain state of switches            *
 *************************************************************/

void output_SWTs_to_LEDs (unsigned int switch_states)
{
	unsigned int shifted_states = switch_states >> 10; // Need to align SWTs to corresponding LED bit positions; shift by 10 positions
	// SW1 -> LD0, SW2 -> LD1, SW3 -> LD2, SW4 -> LD3 ====> RB10 -> RB0, RB11 -> RB1, RB12 -> RB2, RB13 -> RB3

	// void	PORTWrite(IoPortId portId, unsigned int bits);
	output_to_LEDs (shifted_states);
}

/*************************************************************
 * Function:                                                 *
 * Date Created:                                             *
 * Date Last Modified:                                       *
 * Description:                                              *              
 * Input parameters:                                         *
 * Returns:                                                  *
 * Usages:                                                   *
 * Preconditions:                                            *
 * Postconditions:                                           *
 *************************************************************/
 
void generate_simon_says_LED_sequence (unsigned int LED_sequence_array[8])
{
	unsigned int count = 0;
	
	// Generate 8 LED sequence
	for (count = 0; count < 8; count++)
	{
		LED_sequence_array[count] = rand () % 4; // Store the sequence so we can compare out switches to it later
		output_to_LEDs (1 << LED_sequence_array[count]);
		my_delay ();
		output_to_LEDs (0);
		my_delay ();
	}
}

/*************************************************************
 * Function:                                                 *
 * Date Created:                                             *
 * Date Last Modified:                                       *
 * Description:                                              *              
 * Input parameters:                                         *
 * Returns:                                                  *
 * Usages:                                                   *
 * Preconditions:                                            *
 * Postconditions:                                           *
 *************************************************************/
 
void output_to_LEDs (unsigned int output)
{
	PORTWrite (IOPORT_B, output);
}

/*************************************************************
 * Function:                                                 *
 * Date Created:                                             *
 * Date Last Modified:                                       *
 * Description:                                              *              
 * Input parameters:                                         *
 * Returns:                                                  *
 * Usages:                                                   *
 * Preconditions:                                            *
 * Postconditions:                                           *
 *************************************************************/
 
void my_delay (void)
{
	int inner = 0, outter = 0;
	
	for (outter = 0; outter < 10000; outter++);
		for (inner = 0; inner < 100000; inner++);
}