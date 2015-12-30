/*******************************************************************************
 * Programmer: Michael R. Mentele                                              *
 * Class: EE 234                                                               *
 * Programming Assignment: Lab 3.                                              *
 * Date: Sep 16, 2012                                                       *
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


int main (void)
{
	unsigned int 	reset = 0,//If it is 1 in loop go back to begining of main
					bit1  = 0,//Save whether btn1 was pushed
					bit2  = 0,//Save whether btn2 was pushed
				count_dir = 0,//a value of 1 is counting up, 2 is down and 0 is stop
					stop  = 0,//If stop == 1 (btn1 & 2 were pushed) and btns 1 & 2 are pushed again set rest = 0
					both  = 0,//We use this so it waits till both are deasserted before doing anything
					LED_count = 1,//Initialize to 1 to avoid counting to a negative number
					count_time = 0;//Variable to hold time
	unsigned int button_states = 0;//Holds the return of get_button_states
	unsigned int time_btwn_state_change = 12000;//Time between LED changes
	unsigned int LED_Number[8] = {0x0,0x400,0x800,0xC00,0x1000,0x1400,0x1800,0x1C00};//LED display values
	setup_LEDs (); // Output pins
	setup_buttons (); // Input pins
	PORTWrite(IOPORT_B, LED_Number[0]);//Turn all LEDs off
	
	while (1) // Embedded programs run forever
	{
		//Reset variables after cycle
		both = 0;
		count_time = 0;
		
		//Determine count direction
		while (count_time < time_btwn_state_change)//time for about a second
		{	
		// Get the state of the buttons
		button_states = get_button_states ();
	
			//Buttons Released
			if(button_states == 0x00000000)
			{
				//if button one was pressed
				if((bit1 == 1) && (bit2 == 0))
				{
				count_dir = 1;//count up at end of cycle
				stop = 0;//reset stop
				}
				
				//if button two was pressed
				else if((bit1 == 0) && (bit2 == 1))
				{
				count_dir = 2;//count down at end of cycle
				stop = 0;//reset stop
				}
				
				//if both buttons were pressed
				else if((bit1 == 1) && (bit2 == 1))
				{
				count_dir = 0;//Do not count at end of cycle
				
					//reset?
					if(stop == 1)//If both have been pushed twice in a row then reset
					{
					main();//reset
					}
					
				stop = 1;
				
				}
				
				//remember btn states
				bit1 = 0;
				bit2 = 0;
		
		
			}
		
			//if both aren't waiting to be deasserted then remember what was pushed
			if(both == 0)
			{	
				//What buttons are pushed
				switch(button_states)
				{	
					//btn 1
					case 0x00000040:
						bit1 = 1;//remember
					break;
					
					//btn 2
					case 0x00000080:
						bit2 = 1;//remember						
					break;
					
					//both
					case 0x000000C0:
						bit1 = 1;//remember
						bit2 = 1;//remember
						both = 1;//remember to wait for both to deassert!!	
					break;
					
					default:
					break;
				}
			}
					
			count_time++;//Increment time
		}
		
		//count up
		
		if (count_dir == 1)
		{
			LED_count++;
			if(LED_count == 9)
				LED_count = 1;
		}
		
		//count down
		else if (count_dir == 2)
		{	
			LED_count--;
			if(LED_count == 0)
				LED_count = 8;
		}
			
		else if(count_dir == 0)
		{
			LED_count = LED_count;
		}
			
		//Output count in binary to LEDs
		PORTWrite(IOPORT_B, LED_Number[LED_count - 1]);
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



 
 
 