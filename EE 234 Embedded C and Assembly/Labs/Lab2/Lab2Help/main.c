/*******************************************************************************
 * Programmer:                                                                 *
 * Class: EE 234                                                               *
 * Lab Project:                                                                *
 * Date:                                                                       *
 *                                                                             *
 * Description:                                                                *
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

void setup_switches (void);
void setup_LEDs (void);
void LEDsWrite (void);

int main (void)
{
	// Variable declarations

	// Setup/initialize ports
	// Setup/initialize devices
	setup_switches ();
	setup_LEDs ();
	LEDsWrite ();

	while (1) // Embedded programs run forever
	{
		// Event loop
	}

	return 0;
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

// Put other function definitions below main (), or they
// may go in another .c source file; Functions most likely
// will include port and device setups/initalizations;
// Be sure to comment all functions with the above block

void setup_switches (void)
{
	PORTSetPinsDigitalIn(IOPORT_B, BIT_0 | BIT_1 | BIT_2 | BIT_3);
}

void setup_LEDs (void)
{
	PORTSetPinsDigitalOut(IOPORT_B, BIT_10 | BIT_11 | BIT_12 | BIT_13);
}

void LEDsWrite (void)
{
	int count = 0;

	PORTWrite (IOPORT_B, BIT_10);
	
	for (count = 0; count < 100000; count++)
	{
	}

	PORTWrite (IOPORT_B, BIT_11);

	for (count = 0; count < 100000; count++)
	{
	}

	// delay
	PORTWrite (IOPORT_B, BIT_12);
	// delay
	for (count = 0; count < 100000; count++)
	{
	}

	PORTWrite (IOPORT_B, BIT_13);
	// delay
	for (count = 0; count < 100000; count++)
	{
	}
}