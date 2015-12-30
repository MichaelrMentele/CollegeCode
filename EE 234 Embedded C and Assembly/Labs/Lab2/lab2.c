/*******************************************************************************
 * Programmer: Michael R. Mentele                                              *
 * Class: EE 234_2                                                             *
 * Lab Project: Lab 2                                                          *
 * Date: 09/04/2012                                                            *
 *                                                                             *
 * Description: This program runs Symon Says                                                               *
 *                                                                             *
 ******************************************************************************/

// #include all necessary standard and user-defined libraries
#include <plib.h> // Includes all major functions and macros required to develop
                  // programs for the PIC32MX4

// Place your #pragma statements here, or in another .h file;
// #pragma statements are used to set your operating clock frequency

// Place your #define constants and macros here, or in another .h file

// Yes, don't forget your prototypes
// Prototypes go here, or in a .h file, which you would also need to #include
 void setup_LEDs (void);
 void setup_switches (void);
 void delay (void);
 void play_sequence (void);
 //unsigned int get_switch_states (void);
 //void output_switches_to_LEDs (unsigned int switch_states);


int main (void)
{
	// Variable declarations
	unsigned int switch_states = 0;

	// Setup/initialize ports
	setup_LEDs ();//outputs
	setup_switches();//inputs
	play_sequence();//symon says...
	// Setup/initialize devices

	while (1) // Embedded programs run forever
	{
		// Event loop
		//Get State of the buttons
		//switch_states = get_switch_states();
		//Write States
		//output_switches_to_LEDs (switch_states);
	}

	return 0;
}

/*************************************************************
 * Function: setup_LEDs                                      *
 * Date Created: 9/4/12                                      *
 * Date Last Modified: 9/4/12                                *
 * Description: Enable LED pins as outputs                   *              
 * Input parameters: None                                    *
 * Returns: Nothing                                          *
 * Usages: must be called once before writing to LEDs        *
 * Preconditions: None                                       *
 * Postconditions: Pins to the LEDs are output pins          *
 *************************************************************/
void setup_LEDs (void)
{
	// Setup the four periphial LEDs for write; output pins
	// According to the Digilent Cerebot MX4cK Reference Manual
	// LED1 -> PB0, LED2 -> PB1, LED3 -> PB2, LED4 -> PB3; NOTE: PB indicates PORTB

	PORTSetPinsDigitalOut (IOPORT_B, BIT_0 | BIT_2 | BIT_3 | BIT_4);
}
 
 
 /*************************************************************
 * Function: setup_switches                                   *
 * Date Created: 9/4/12                                       *
 * Date Last Modified: 9/4/12                                 *
 * Description: Maps the inputs to switches                   *              
 * Input parameters: none                                     *
 * Returns: nothing                                           *
 * Usages: use once before reading from switches              *
 * Preconditions: none                                        *
 * Postconditions: Pins to the switches are no input pins     *
 *************************************************************/
 
 void setup_switches (void)
{
	// Setup the two on-board buttons for read; input pins
	// According to the Digilent Cerebot MX4cK Reference Manual
	// SW1 -> PB10, SW2 -> PB11, SW3-> PB12, SW4 -> PB13; NOTE: PB indicates PORTB

	PORTSetPinsDigitalIn (IOPORT_B, BIT_10 | BIT_11 | BIT_12 | BIT_13);
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
 
 void delay (void)
 {
 unsigned int count = 0;
	while (count < 1000000)
	{
		count++;
	};
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
 void play_sequence (void)
 {
 
	delay();
	 
	PORTWrite (IOPORT_B, BIT_0);
	
	delay();
	 
	PORTWrite (IOPORT_B, BIT_1);
	
	delay();
	 
	PORTWrite (IOPORT_B, BIT_2);
	
	delay();
	 
	PORTWrite (IOPORT_B, BIT_3);
	
	delay();
	 
	PORTWrite (IOPORT_B, BIT_0);
	
	delay();
	 
	PORTWrite (IOPORT_B, BIT_1);
	
	delay();
	 
	PORTWrite (IOPORT_B, BIT_2);
	
	delay();
	 
	PORTWrite (IOPORT_B, BIT_3);
	
 }
 
 /*************************************************************
 * Function: get_switch_states                               *
 * Date Created: 9/4/12                                      *
 * Date Last Modified: 9/4/12                             *
 * Description: Reads the switch states                    *              
 * Input parameters: none                                    *
 * Returns:                                                 *
 * Usages:                                                   *
 * Preconditions:                                            *
 * Postconditions:                                           *
 *************************************************************/
 
 
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
// Put other function definitions below main (), or they
// may go in another .c source file; Functions most likely
// will include port and device setups/initalizations;
// Be sure to comment all functions with the above block