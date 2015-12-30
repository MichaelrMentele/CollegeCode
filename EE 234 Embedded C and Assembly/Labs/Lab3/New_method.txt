/*******************************************************************************
 * Programmer: Michael R. Mentele                                              *
 * Class: EE 234                                                               *
 * Programming Assignment: Lab 3.                                              *
 * Date: August 28, 2012                                                       *
 *                                                                             *
 * Description: This program reads the states of the on-board buttons of the   *
 *              Cerebot MX4cK and writes the states to the on-board LEDs       *
 *                                                                             *
 ******************************************************************************/

#include <peripheral/ports.h> // PORTSetPinsDigitalIn (), PORTSetPinsDigitalOut (), PORTRead (), PORTWrite (), BIT_XX, IOPORT_X

//SYSCLK = 80 Mhz (8 MHz Crystal/FPLLIDIV * FPLLMUL / FPLL0DIV
//PBCLK = 40 MHz 
//Primary Osc w/PLL (XT+, HS+, EC + PLL)
//WDT OFF
//For all else we don't care

#pragma config FNOSC = PRIPLL //Required
#pragma config FPLLMUL = MUL_20
#pragma config FPLLIDIV = DIV_2
#pragma config FPBDIV = DIV_2// divide sysclk by 2 ==> PBCLK
#pragma config FPLLODIV = DIV_1

// Yes, don't forget your prototypes
void setup_LEDs (void);
void setup_buttons (void);
void delay(void);
unsigned int get_button_states (void);
//void output_count_to_LEDs (unsigned int count);

int main (void)
{
	unsigned int button_states = 0;
	unsigned int counter[8] = {0,1,2,3,4,5,6,7};
	unsigned int time_btn_state_change = 1000;
	setup_LEDs (); // Output pins
	setup_buttons (); // Input pins

	while (1) // Embedded programs run forever
	{
		unsigned int reset = 0;
		unsigned count_time = 0;
		while ( count_time < time_btn_state_change)
		{	
		// Get the state of the buttons
		button_states = get_button_states ();
		reset = 0;	
		
			//which button is pressed?
			switch (button_states)
			{
				//btn 1
				case 0x00000040:
					//Is button 1 released or is button 2 pressed?
					switch(button_states)
					{	
						
						case 0x00000000:
							count_dir = 1;
						break;
						
						case 0x000000C0;
							if(button_states == 0x00000000)
							{
							count_dir = 0;
							}
							
							else if(reset == 1)
							{
							main();
							}
						break;
						
						default:
						break;
						}
				
					}	
				break;
				
				//btn 2
				case 0x00000080:
					switch(button_states)
					{	
						case 0x00000000:
							count_dir = 2;
						break;
						
						case 0x000000C0;
							if(button_states == 0x00000000)
							{
							count_dir = 0;
							}

							else if(reset == 1)
							{
							main();
							}
							
						break;
					}	
				break;
				
				default:
				break;
			
			}
		
			count_time++
			
			
		}
		
	}

	if (count_dir == 1)
	output++;
	
	else if (count_dir == 2)
	{
		output--;
	}
	
	else
	{
		output = output;
	}	
	
	// Write the state of the buttons to the LEDs
	output_count_to_LEDs (counter[);
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

void output_count_to_LEDs (unsigned int button_states)
{
	unsigned int shifted_states = button_states << 4; // Need to align BTNS to corresponding LED bit positions;
	// BTN1 -> LED1, BTN2 -> LED2 ====> PA06 -> PB10, PA07 -> PB11

	// Recall: LED1 -> PB10, LED2 -> PB11, LED3 -> PB12, LED4 -> PB13; NOTE: PB indicates PORTB
	// void	PORTWrite(IoPortId portId, unsigned int bits);
	PORTWrite (IOPORT_B, shifted_states);

}

/*************************************************************
 * Function: delay                                           *
 * Date Created: 9/4/2012                                    *
 * Date Last Modified: 9/4/2012                              *
 * Description: Sets appropriate delay period to be reused   *  
 *              for other functions such as play_sequence.   *
 * Input parameters: none                                    *
 * Returns: nothing                                          *
 * Usages: Between assertion and deassertion of LEDs         *
 * Preconditions: none                                       *
 * Postconditions: none                                      *
 *************************************************************/
 
 void delay ( void)
 {
 unsigned int i = 0;
	while (i < 500)
	{
		i++;
	}
 }
 


 
 
 