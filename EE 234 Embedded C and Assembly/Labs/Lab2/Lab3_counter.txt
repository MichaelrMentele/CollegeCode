/*******************************************************************************
 * Programmer: Michael R. Mentele                                              *
 * Class: EE 234                                                               *
 * Programming Assignment: Lab 1.                                              *
 * Date: August 28, 2012                                                       *
 *                                                                             *
 * Description: This program reads the states of the on-board buttons of the   *
 *              Cerebot MX4cK and writes the states to the on-board LEDs       *
 *                                                                             *
 ******************************************************************************/

#include <peripheral/ports.h> // PORTSetPinsDigitalIn (), PORTSetPinsDigitalOut (), PORTRead (), PORTWrite (), BIT_XX, IOPORT_X

// Yes, don't forget your prototypes
void setup_LEDs (void);
void setup_buttons (void);
unsigned int get_button_states (void);
void output_BTNs_to_LEDs (unsigned int button_states);

int main (void)
{
	unsigned int button_states = 0;

	setup_LEDs (); // Output pins
	setup_buttons (); // Input pins

	while (1) // Embedded programs run forever
	{
		// Get the state of the buttons
		button_states = get_button_states ();
		// Write the state of the buttons to the LEDs
		output_BTNs_to_LEDs (button_states);
	}

	return 0;
}

/*************************************************************
 * Function: setup_LEDs ()                                   *
 * Date Created: August 21, 2012                             *
 * Date Last Modified: August 21, 2012                       *
 * Description: This function sets up the pins to the        *
 *              on-board LEDs as output pins                 *              
 * Input parameters: None                                    *
 * Returns: Nothing                                          *
 * Usages: Must be called once, before you write to LEDs     *
 * Preconditions: None                                       *
 * Postconditions: Pins to LEDs are output pins              *
 *************************************************************/

void setup_LEDs (void)
{
	// Setup the four on-board LEDs for write; output pins
	// According to the Digilent Cerebot MX4cK Reference Manual
	// LED1 -> PB10, LED2 -> PB11, LED3 -> PB12, LED4 -> PB13; NOTE: PB indicates PORTB

	// Prototype for necessary function as provided in <peripheral/ports.h>
	// void	PORTSetPinsDigitalOut(IoPortId portId, unsigned int outputs);
	// IOPORT_B and BIT_XX are defined in <peripheral/ports.h>
	PORTSetPinsDigitalOut (IOPORT_B, BIT_10 | BIT_11 | BIT_12 | BIT_13);
}

/*************************************************************
 * Function: setup_buttons ()                                *
 * Date Created: August 21, 2012                             *
 * Date Last Modified: August 21, 2012                       *
 * Description: This function sets up the pins to the        *
 *              on-board BTNs as input pins                  *              
 * Input parameters: None                                    *
 * Returns: Nothing                                          *
 * Usages: Must be called once, before you read from BTNs    *
 * Preconditions: None                                       *
 * Postconditions: Pins to BTNs are input pins               *
 *************************************************************/

void setup_buttons (void)
{
	// Setup the two on-board buttons for read; input pins
	// According to the Digilent Cerebot MX4cK Reference Manual
	// BTN1 -> PA06, BTN2 -> PA07; NOTE: PA indicates PORTA

	// Prototype for necessary function as provided in <peripheral/ports.h>
	// void	PORTSetPinsDigitalIn(IoPortId portId, unsigned int inputs);
	// IOPORT_A and BIT_XX are defined in <peripheral/ports.h>
	PORTSetPinsDigitalIn (IOPORT_A, BIT_6 | BIT_7);
}

/*************************************************************
 * Function: get_button_states ()                            *
 * Date Created: August 21, 2012                             *
 * Date Last Modified: August 21, 2012                       *
 * Description: This function reads the state of the         * 
 *              on-board buttons. 1 - indicates button       *
 *              is pressed, 0 - otherwise                    *       
 * Input parameters: None                                    *
 * Returns: Values of BTNs                                   *
 * Usages: Must be called after BTNs have been set to output *
 * Preconditions: None                                       *
 * Postconditions: Masked state of buttons                   *
 *************************************************************/

unsigned int get_button_states (void)
{
	unsigned int button_states = 0;

	// Read the entire 32-bit PORTA to get the state of the on-board buttons
	// Mask the PORT bits so that the corresponding buttons bits are isolated; 
	// We do not care about the other 30-bits of PORTA; Recall: BTN1 -> PA06, BTN2 -> PA07
	// Little Endian is used: bit31 bit30 bit29 ... bit02 bit01 bit00
	// 1 hex digit = 1 nibble = 4 bits
	// unsigned int	PORTRead(IoPortId portId);
	button_states = PORTRead (IOPORT_A) & 0x000000C0; // BTN1 -> PA06, BTN2 -> PA07

	return button_states;
}

/*************************************************************
 * Function: output_BTNs_to_LEDs ()                          *
 * Date Created: August 21, 2012                             *
 * Date Last Modified: August 21, 2012                       *
 * Description: This function writes the state of the BTNs   *    
 *              to the LEDs. If BTN is pressed, then LED     *
 *              turns on. BTN1 -> LED1, BTN2 -> LED2         *          
 * Input parameters: Values of BTNs                          *
 * Returns: Nothing                                          *
 * Usages: Must be called after BTNs are read                *
 * Preconditions: BTNs must be masked                        *
 * Postconditions: LEDs contain state of buttons             *
 *************************************************************/

void output_BTNs_to_LEDs (unsigned int button_states)
{
	unsigned int shifted_states = button_states << 4; // Need to align BTNS to corresponding LED bit positions;
	// BTN1 -> LED1, BTN2 -> LED2 ====> PA06 -> PB10, PA07 -> PB11

	// Recall: LED1 -> PB10, LED2 -> PB11, LED3 -> PB12, LED4 -> PB13; NOTE: PB indicates PORTB
	// void	PORTWrite(IoPortId portId, unsigned int bits);
	PORTWrite (IOPORT_B, shifted_states);
}