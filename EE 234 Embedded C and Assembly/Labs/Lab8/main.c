// Michael Mentele
// Bluetooth driving
// Haha all we can do is a clockwise circle and a counter clockwise
 
#include <plib.h> // Includes all major functions and macros required to develop
                  // programs for the PIC32MX4
#include <stdlib.h>
#include <stdbool.h>//add boolean library

// Configuration Bit settings
// SYSCLK = 80 MHz (8MHz Crystal/ FPLLIDIV * FPLLMUL / FPLLODIV)
// PBCLK = 40 MHz
// Primary Osc w/PLL (XT+,HS+,EC+PLL)
// WDT OFF

//#pragma config FPLLMUL = MUL_20, FPLLIDIV = DIV_2, FPLLODIV = DIV_1, FWDTEN = OFF
//#pragma config POSCMOD = HS, FNOSC = PRIPLL, FPBDIV = DIV_1
#define SYS_FREQ 				(80000000L)
#define DESIRED_BAUDRATE    	(9600)      //BaudRate
#define PERIOD                   450		//Period Register


void delay (void);
int main(void)
{
	int	pbClk;

	// Configure the device for maximum performance but do not change the PBDIV
	// Given the options, this function will change the flash wait states, RAM
	// wait state and enable prefetch cache but will not change the PBDIV.
	// The PBDIV value is already set via the pragma FPBDIV option above..
	pbClk=SYSTEMConfig(SYS_FREQ, SYS_CFG_WAIT_STATES | SYS_CFG_PCACHE);


    INTEnableSystemMultiVectoredInt();
    OpenOC2( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE, 0, 0);
    OpenOC3( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE, 0, 0);
	
	mPORTDClearBits(BIT_1 );  
    mPORTDClearBits(BIT_7 );  //clear dir for right motor
    mPORTDClearBits(BIT_2 );
    mPORTDSetBits(BIT_6 );   //set dir for left motor
    mPORTDSetPinsDigitalOut(BIT_7 | BIT_1);
    mPORTDSetPinsDigitalOut(BIT_6 | BIT_2);
	
	// init Timer2
	OpenTimer2( T2_ON | T2_PS_1_1 | T2_SOURCE_INT, PERIOD);
	// This initialization assumes 36MHz Fpb clock. If it changes,
	// you will have to modify baud rate initializer.
	OpenUART1(UART_EN, 		                          // Module is ON
			  UART_RX_ENABLE | UART_TX_ENABLE,		 // Enable TX & RX
			  pbClk/16/DESIRED_BAUDRATE-1);	         // 9600 bps, 8-N-1

	// Configure UART1 RX Interrupt
	ConfigIntUART1(UART_INT_PR1 | UART_RX_INT_EN);

	putsUART2("Why do I need this?\n");
     
    mT2SetIntPriority( 3); 	// set Timer2 Interrupt Priority
	mT2ClearIntFlag(); 		// clear interrupt flag
	mT2IntEnable( 1);		// enable timer2 interrupts
      

	// Let interrupt handler do the work
	while (1);

	return 0;
}

// UART 1 interrupt handler
void __ISR(_UART1_VECTOR, ipl2) IntUart1Handler(void)
{
     
   char usercommand ;
       usercommand = ReadUART1();
       
	// Is this an RX interrupt?
	if(mU1RXGetIntFlag())
	{
		// Clear the RX interrupt Flag
	    mU1RXClearIntFlag();
       // Toggle LED to indicate UART activity
        //go forward
        if(usercommand == 'U')
         
        {
		   
           OpenOC2( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,0, 0);
           OpenOC3( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,0, 0);
           
           mPORTDClearBits(BIT_7 );
           mPORTDSetBits(BIT_6 );
           OpenOC2( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,320, 320);
           OpenOC3( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,320, 320);
        }

        //go backward
        if(usercommand == 'D')
         
        {	
           OpenOC2( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,0, 0);
           OpenOC3( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,0, 0);
           
           mPORTDSetBits(BIT_7 );
           mPORTDClearBits(BIT_6 );
           OpenOC2( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,320, 320);
           OpenOC3( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,320, 320);
        }   
        }
	}
	
	//stop
        if(usercommand == 'C')
         
        {
		  
           OpenOC2( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,0, 0);
           OpenOC3( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,0, 0);
        }
        
	 //Perform command
        if(usercommand == 'D')
         
        {
		 
           OpenOC2( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,0, 0);
           OpenOC3( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,0, 0);
           
           mPORTDSetBits(BIT_7 );
           mPORTDClearBits(BIT_6 );
           OpenOC2( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,320, 320);
           OpenOC3( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,320, 320);
        } 
      
           
        }

	}
			
			
		
            
	// TX interrupt
	if ( mU1TXGetIntFlag() )
	{
		mU1TXClearIntFlag();
                                
         

	}
}




void delay (void)
{
	int delaying = 0;
	
	for (delaying = 0; delaying < 1000000; delaying++);
}