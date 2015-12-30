 
/*******************************************************************************
 * Programmer: Jonathan Quisenberry                                            *
 * Class: EE 234                                                               *
 * Programming Assignment: lab 3                                               *
 * Date: september 17, 2012                                 			       *
 *                                                                             *
 * Description: This lab uses the main as one big function really.  So I will  *
 *  	comment above the while (1) about it.                                  *            
 *                                                                             *
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
	unsigned int 	reset = 0, //declaring variables for use in main
					bit1  = 0,
					bit2  = 0,
					count_dir = 0,//a value of 1 is counting up, 2 is down and 0 is stop
					stop  = 0,
					both  = 0,
					LED_count = 1,
					count_time = 0;

	unsigned int button_states = 0;
	unsigned int time_btwn_state_change = 12000; // easy change made easy

	//numbers in hex that correspond to the bits of LEDs.  0000, 0001, 0002, ...
	unsigned int LED_Number[8] = {0x0,0x400,0x800,0xC00,0x1000,0x1400,0x1800,0x1C00};

	setup_LEDs (); // Output pins enabled
	setup_buttons (); // Input pins enabled

	PORTWrite(IOPORT_B, LED_Number[0]); //write to the zero state 

/*************************************************************
 * Function: while(1) loop                                   *
 * Date Created: September 16, 2012                          *
 * Date Last Modified: September 16, 2012                    *
 * Description: This counts up and down based on btn clicks  *
 *       also stops and resets on both clicked 1 and 2.      *              
 * Input parameters: button states                           *
 * Returns:                                                  *
 * Usages: Writen in the whole time							 *
 * Preconditions: None                                       *
 * Postconditions:None                                       *
 *************************************************************/

	while (1) // Embedded programs run forever
	{
		both = 0;
		count_time = 0;
		while (count_time < time_btwn_state_change) //clock time usage
		{	
		
		button_states = get_button_states (); // Get the state of the buttons
	
			//Released
			if(button_states == 0x0) //use bit1 and bit2 as holders
			{
				//if button one deasserts
				if((bit1 == 1) && (bit2 == 0)) //bit 1 =1 means btn 1 was hit
				{
				count_dir = 1; //Count up 
				stop = 0;
				}
				
				//if button two deasserts
				else if((bit1 == 0) && (bit2 == 1)) // bit2=1 means btn 2 was hit
				{
				count_dir = 2; //Count down
				stop = 0;
				}
				
				//if both buttons assert
				else if((bit1 == 1) && (bit2 == 1))//both bit1=bit2=1 both were hit
				{
				count_dir = 0; // both are hit so stop,
				
					if(stop == 1) //stop =1 means it was stopped, so reset
					{
					main();//reset
					}
					
				stop = 1; //count that it was stopped once and go back into looping
				
				}
				
				bit1 = 0; // they have been released cause the if is 0x0
				bit2 = 0; //same as above
		
		
			}
		
			
			if(both == 0) //if both have been hit, it should skip this
			{	//btn 1
				switch(button_states)
				{	
					case 0x00000040://hit with switch 1
						bit1 = 1;
					break;
							
					case 0x00000080://hit with switch 2
						bit2 = 1;	
					break;
								
					case 0x000000C0: //both hit, give both=1 so it can skip this if whole statement
						bit1 = 1;
						bit2 = 1;
						both = 1;	
					break;
					
					default:
					break;
				}
			}
					
			count_time++; //this counts each time, so it will keep looping
		}
		
		//count up
		
		if (count_dir == 1) //we access the array and move up or down it
		{
			LED_count++;
			if(LED_count == 9) //the array is 8 long, so when we hit 9 drop to 1
				LED_count = 1;
		}
		
		//count down
		else if (count_dir == 2)
		{	
			LED_count--;
			if(LED_count == 0)//the array is 8 long, so when we hit 0 jump to 8
				LED_count = 8;
		}
			
		else if(count_dir == 0) // when both hit, stay at array value
		{
			LED_count = LED_count;
		}
			
		PORTWrite(IOPORT_B, LED_Number[LED_count - 1]); // C has array length 8 but from 0 to 7, stupid I know
	}		
	
	return 0;
}



/*************************************************************
 * Function: setup_LEDs ()                                   *
 * Date Created: August 21, 2012                             *
 * Date Last Modified: September 17 2012                     *
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
 * Date Last Modified: September 17 2012                     *
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
 * Date Last Modified: September 17 2012                     *
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



 
 
  