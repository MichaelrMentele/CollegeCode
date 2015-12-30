/*******************************************************************************
 * Programmer: Michael R. Mentele                                              *
 * Class: EE 234_2                                                             *
 * Lab Project: Lab 2                                                          *
 * Date: 09/04/2012                                                            *
 *                                                                             *
 * Description: This program runs a simple Symon Says game                     *
 *                                                                             *
 ******************************************************************************/

// #include all necessary standard and user-defined libraries
#include <plib.h> // Includes all major functions and macros required to develop
                  // programs for the PIC32MX4



// Yes, don't forget your prototypes
// Prototypes go here, or in a .h file, which you would also need to #include
 void setup_LEDs (void);
 void setup_switches (void);
 void delay (void);
 void play_sequence (void);
 void error (void);
 void success (void);

 //First two loops are repeated eight times. Checks for ON followed by OFF until it reaches the 16th check where if correct plays the "success" sequence.
int main (void)//check sequence
{
	//initiate variables
	unsigned int switch_states = 0;
	unsigned int iteration = 0;//Place in loop so it knows when to end

setup_LEDs();
setup_switches();
play_sequence();

	
	while (iteration < 16)
	{
		
//***************************************************************
		while (1) //wait for user to turn a switch on
		{
			switch_states = PORTRead(IOPORT_B) & 0x00003C00;//get switch states
			
			//Is the right switch on?
			if (switch_states == 0x00000400)//Yes so turn LED on
			{
				PORTWrite (IOPORT_B, switch_states>>10);//Pass SW value to LED (ON)
				iteration++;//track place
				break;//next loop
			}
			else if (switch_states != 0)//No so return error!
			{
			error();//play error light sequence
		
			}
		}
//****************************************************************		
		while (1) 
		{
			switch_states = PORTRead(IOPORT_B) & 0x00003C00;//get switch states
	
			//Did the switch that got turned on get turned off?
			if (switch_states == 0x00000000)//Yes so turn LED off
			{
				PORTWrite (IOPORT_B, 0);//Turn LED (OFF)
				iteration++;//track place
				break;//next loop
			}
			else if (switch_states != 0x00000400)//No they turned someother switch on
			{
			error();//play error sequence
		
			}
			
			
		}
		
//****************************************************************
		
//***************************************************************
		while (1) 
		{
			switch_states = PORTRead(IOPORT_B) & 0x00003C00;
		
			if (switch_states == 0x00000800)
			{
				PORTWrite (IOPORT_B, switch_states>>10);
				iteration++;
				break;
			}
			else if (switch_states != 0)
			{
			error();
	
			}
			
		}
//****************************************************************		
		while (1) 
		{
			switch_states = PORTRead(IOPORT_B) & 0x00003C00;
	
			if (switch_states == 0x00000000)
			{
				PORTWrite (IOPORT_B, 0);
				iteration++;
				break;
			}
			else if (switch_states != 0x00000800)
			{
			error();
		
			}
			
			
		}
		
//****************************************************************
//***************************************************************
		while (1) 
		{
			switch_states = PORTRead(IOPORT_B) & 0x00003C00;
		
			if (switch_states == 0x00001000)
			{
				PORTWrite (IOPORT_B, switch_states>>10);
				iteration++;
				break;
			}
			else if (switch_states != 0)
			{
			error();
		
			}
			
		}
//****************************************************************		
		while (1) 
		{
			switch_states = PORTRead(IOPORT_B) & 0x00003C00;
	
			if (switch_states == 0x00000000)
			{
				PORTWrite (IOPORT_B, 0);
				iteration++;
				break;
			}
			else if (switch_states != 0x00001000)
			{
			error();
		
			}
			
			
		}
		
//****************************************************************
//***************************************************************
		while (1) 
		{
			switch_states = PORTRead(IOPORT_B) & 0x00003C00;
		
			if (switch_states == 0x00002000)
			{
				PORTWrite (IOPORT_B, switch_states>>10);
				iteration++;
				break;
			}
			else if (switch_states != 0)
			{
			error();
		
			}
			
		}
//****************************************************************		
		while (1) 
		{
			switch_states = PORTRead(IOPORT_B) & 0x00003C00;
	
			if (switch_states == 0x00000000)
			{
				PORTWrite (IOPORT_B, 0);
				iteration++;
				break;
			}
			else if (switch_states != 0x00002000)
			{
			error();
		
			}
			
			
		}
		
//****************************************************************
//***************************************************************
		while (1) 
		{
			switch_states = PORTRead(IOPORT_B) & 0x00003C00;
		
			if (switch_states == 0x00000400)
			{
				PORTWrite (IOPORT_B, switch_states>>10);
				iteration++;
				break;
			}
			else if (switch_states != 0)
			{
			error();
			
			}
		}
//****************************************************************		
		while (1) 
		{
			switch_states = PORTRead(IOPORT_B) & 0x00003C00;
	
			if (switch_states == 0x00000000)
			{
				PORTWrite (IOPORT_B, 0);
				iteration++;
				break;
			}
			else if (switch_states != 0x00000400)
			{
			error();
		
			}
			
			
		}
		
//****************************************************************
		
//***************************************************************
		while (1) 
		{
			switch_states = PORTRead(IOPORT_B) & 0x00003C00;
		
			if (switch_states == 0x00000800)
			{
				PORTWrite (IOPORT_B, switch_states>>10);
				iteration++;
				break;
			}
			else if (switch_states != 0)
			{
			error();
		
			}
			
		}
//****************************************************************		
		while (1) 
		{
			switch_states = PORTRead(IOPORT_B) & 0x00003C00;
	
			if (switch_states == 0x00000000)
			{
				PORTWrite (IOPORT_B, 0);
				iteration++;
				break;
			}
			else if (switch_states != 0x00000800)
			{
			error();
			
			}
			
			
		}
		
//****************************************************************
//***************************************************************
		while (1) 
		{
			switch_states = PORTRead(IOPORT_B) & 0x00003C00;
		
			if (switch_states == 0x00001000)
			{
				PORTWrite (IOPORT_B, switch_states>>10);
				iteration++;
				break;
			}
			else if (switch_states != 0)
			{
			error();
		
			}
			
		}
//****************************************************************		
		while (1) 
		{
			switch_states = PORTRead(IOPORT_B) & 0x00003C00;
	
			if (switch_states == 0x00000000)
			{
				PORTWrite (IOPORT_B, 0);
				iteration++;
				break;
			}
			else if (switch_states != 0x00001000)
			{
			error();
			
			}
			
			
		}
		
//****************************************************************
//***************************************************************
		while (1) 
		{
			switch_states = PORTRead(IOPORT_B) & 0x00003C00;
		
			if (switch_states == 0x00002000)
			{
				PORTWrite (IOPORT_B, switch_states>>10);
				iteration++;
				break;
			}
			else if (switch_states != 0)
			{
			error();
			
			}
			
		}
//****************************************************************		
		while (1) 
		{
			switch_states = PORTRead(IOPORT_B) & 0x00003C00;
	
			if (switch_states == 0x00000000)
			{
				PORTWrite (IOPORT_B, 0);
				iteration++;
				success();//You made it to the last iteration huzzah!
				break;
			}
			else if (switch_states != 0x00002000)
			{
			error();
			
			}
			
			
		}
		
//****************************************************************

	}
	while(1)
	{
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

	PORTSetPinsDigitalOut (IOPORT_B, BIT_0 | BIT_1 | BIT_2 | BIT_3);
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
 * Postconditions: Pins for the switches are input pins      *
 *************************************************************/
 
 void setup_switches (void)
{
	// Setup the two on-board buttons for read; input pins
	// According to the Digilent Cerebot MX4cK Reference Manual
	// SW1 -> PB10, SW2 -> PB11, SW3-> PB12, SW4 -> PB13; NOTE: PB indicates PORTB

	PORTSetPinsDigitalIn (IOPORT_B, BIT_10 | BIT_11 | BIT_12 | BIT_13);
}
 
 
 /*************************************************************
 * Function:  play_sequence                                  *
 * Date Created:9/4/2012                                     *
 * Date Last Modified: 9/4/2012                              *
 * Description: Plays LED sequence to be replicated by user. *              
 * Input parameters: none                                    *
 * Returns: nothing                                          *
 * Usages: use once before checking user sequence            *
 * Preconditions: LEDs are set up                            *
 * Postconditions: none                                      *
 *************************************************************/
 void play_sequence (void)
 {
 

	 // sequence is 1,2,3,4,1,2,3,4 corresponding to bits 0-3 and LEDs 0-3
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

	delay();
	
	PORTWrite (IOPORT_B, 0);
	
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
 
 void delay (void)
 {
 unsigned int count = 0;
	while (count < 40000)
	{
		count++;
	}
 }
 
 /*************************************************************
 * Function: error                                           *
 * Date Created: 9/4/2012                                    *
 * Date Last Modified: 9/4/2012                              *
 * Description: Plays "error" sequence (All LEDs flash 4 times)*          
 * Input parameters: none                                    *
 * Returns: nothing                                          *
 * Usages: Play when user input is incorrect                 *
 * Preconditions: setup LEDs                                 *
 * Postconditions: none                                      *
 *************************************************************/
// Put other function definitions below main (), or they
// may go in another .c source file; Functions most likely
// will include port and device setups/initalizations;
// Be sure to comment all functions with the above block



void error(void)
{
	PORTWrite (IOPORT_B, BIT_0 | BIT_1 | BIT_2 | BIT_3);
	
	delay();
	 
	PORTWrite (IOPORT_B, BIT_0 & BIT_1 & BIT_2 & BIT_3);
	
	delay();

	PORTWrite (IOPORT_B, BIT_0 | BIT_1 | BIT_2 | BIT_3);
	
	delay();
	 
	PORTWrite (IOPORT_B, BIT_0 & BIT_1 & BIT_2 & BIT_3);
	
	delay();
	
	PORTWrite (IOPORT_B, BIT_0 | BIT_1 | BIT_2 | BIT_3);
	
	delay();
	 
	PORTWrite (IOPORT_B, BIT_0 & BIT_1 & BIT_2 & BIT_3);
	
	delay();
	
	main(); //returns to begining
	
	
	 
	
}


 /*************************************************************
 * Function: success                                         *
 * Date Created:9/4/2012                                     *
 * Date Last Modified:9/4/2012                               *
 * Description:Plays "success" sequence 0&2,1&3,1,2,3,4      *              
 * Input parameters: none                                    *
 * Returns: nothing                                          *
 * Usages: Play if last the loop is reached and passes       *
 * Preconditions: Setup leds                                 *
 * Postconditions: none                                      *
 *************************************************************/
// Put other function definitions below main (), or they
// may go in another .c source file; Functions most likely
// will include port and device setups/initalizations;
// Be sure to comment all functions with the above block



void success(void)
{
	PORTWrite (IOPORT_B, BIT_0 | BIT_2);
	
	delay();
	 
	PORTWrite (IOPORT_B, BIT_1 | BIT_3);
	
	delay();

	PORTWrite (IOPORT_B, BIT_0 | BIT_2);
	
	delay();
	 
	PORTWrite (IOPORT_B, BIT_1 | BIT_3);
	
	delay();

	PORTWrite (IOPORT_B, BIT_0);
	
	delay();
	 
	PORTWrite (IOPORT_B, BIT_1);
	
	delay();
	
	PORTWrite (IOPORT_B, BIT_2);
	
	delay();
	
	PORTWrite (IOPORT_B, BIT_3);
	
	delay();
	
	PORTWrite (IOPORT_B, 0);
	
	delay();

}