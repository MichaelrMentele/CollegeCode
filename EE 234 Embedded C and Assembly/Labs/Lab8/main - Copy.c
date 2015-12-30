
 
#include <plib.h> // Includes all major functions and macros required to develop
                  // programs for the PIC32MX4
#include <stdlib.h>
#include <stdbool.h>

// Configuration Bit settings
// SYSCLK = 80 MHz (8MHz Crystal/ FPLLIDIV * FPLLMUL / FPLLODIV)
// PBCLK = 40 MHz
// Primary Osc w/PLL (XT+,HS+,EC+PLL)
// WDT OFF
// Other options are don't care
//
#pragma config FPLLMUL = MUL_20, FPLLIDIV = DIV_2, FPLLODIV = DIV_1, FWDTEN = OFF
#pragma config POSCMOD = HS, FNOSC = PRIPLL, FPBDIV = DIV_1

#define SYS_FREQ 				(80000000L)

#define DESIRED_BAUDRATE    	(9600)      //The standard BaudRate
#define PERIOD                   500


void my_delay (void);
int main(void)
{
	int	pbClk;

	// Configure the device for maximum performance but do not change the PBDIV
	// Given the options, this function will change the flash wait states, RAM
	// wait state and enable prefetch cache but will not change the PBDIV.
	// The PBDIV value is already set via the pragma FPBDIV option above..
	pbClk=SYSTEMConfig(SYS_FREQ, SYS_CFG_WAIT_STATES | SYS_CFG_PCACHE);

	 		
    // clears output Bits for LEDs from bit10 to bit13.
    mPORTBClearBits(BIT_10);
    mPORTBClearBits(BIT_11);
    mPORTBClearBits(BIT_12);
    mPORTBClearBits(BIT_13);
	mPORTBSetPinsDigitalOut(BIT_10 | BIT_11 | BIT_12 | BIT_13);	// Make RB10, RB11, RB12, RB13 as output.

    mPORTDClearBits(BIT_1 );  
    mPORTDClearBits(BIT_7 );  //clear dir for right motor
    mPORTDClearBits(BIT_2 );
    mPORTDSetBits(BIT_6 );   //set dir for left motor
    mPORTDSetPinsDigitalOut(BIT_7 | BIT_1);
    mPORTDSetPinsDigitalOut(BIT_6 | BIT_2);


    INTEnableSystemMultiVectoredInt();
    OpenOC2( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE, 0, 0);
    OpenOC3( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE, 0, 0);
	
	// init Timer2
	OpenTimer2( T2_ON | T2_PS_1_1 | T2_SOURCE_INT, PERIOD);
	// This initialization assumes 36MHz Fpb clock. If it changes,
	// you will have to modify baud rate initializer.
	OpenUART1(UART_EN, 		                          // Module is ON
			  UART_RX_ENABLE | UART_TX_ENABLE,		 // Enable TX & RX
			  pbClk/16/DESIRED_BAUDRATE-1);	         // 9600 bps, 8-N-1

	// Configure UART1 RX Interrupt
	ConfigIntUART1(UART_INT_PR1 | UART_RX_INT_EN);

	putsUART2("Hello Cool World\n");
    putsUART2("I love this!\n");

    
   
    mT2SetIntPriority( 7); 	// set Timer2 Interrupt Priority
	mT2ClearIntFlag(); 		// clear interrupt flag
	mT2IntEnable( 1);		// enable timer2 interrupts
      

	// Let interrupt handler do the work
	while (1);

	return 0;
}

// UART 1 interrupt handler
// it is set at priority level 2
void __ISR(_UART1_VECTOR, ipl2) IntUart1Handler(void)
{
   
   char Receivebyte ;
       Receivebyte = ReadUART1();
       
	// Is this an RX interrupt?
	if(mU1RXGetIntFlag())
	{
		// Clear the RX interrupt Flag
	    mU1RXClearIntFlag();
       // Toggle LED to indicate UART activity
        //go forward
        if(Receivebyte == 'U')
         
        {
		   mPORTBSetBits(BIT_10);
           mPORTBClearBits(BIT_11 );
           mPORTBClearBits(BIT_12);
           mPORTBClearBits(BIT_13 );
           mPORTDClearBits(BIT_7 );
           mPORTDSetBits(BIT_6 );
           OpenOC2( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,300, 300);
           OpenOC3( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,300, 300);
        }

        //go backward
        if(Receivebyte == 'D')
         
        {
		   mPORTBClearBits(BIT_10);
           mPORTBSetBits(BIT_11 );
           mPORTBClearBits(BIT_12);
           mPORTBClearBits(BIT_13 );
           mPORTDSetBits(BIT_7 );
           mPORTDClearBits(BIT_6 );
           OpenOC2( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,300, 300);
           OpenOC3( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,300, 300);
        } 
        //turn right
        if(Receivebyte == 'R')
         
        {
		   mPORTBClearBits(BIT_10);
           mPORTBClearBits(BIT_11 );
           mPORTBSetBits(BIT_12);
           mPORTBClearBits(BIT_13 );
           mPORTDSetBits(BIT_7 );
           mPORTDSetBits(BIT_6 );
           OpenOC2( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,300, 300);
           OpenOC3( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,300, 300);
           my_delay();
           my_delay();
           
        } 
        //turn left
        if(Receivebyte == 'L')
         
        {
		   mPORTBClearBits(BIT_10);
           mPORTBClearBits(BIT_11 );
           mPORTBClearBits(BIT_12);
           mPORTBSetBits(BIT_13 );
           mPORTDClearBits(BIT_7 );
           mPORTDClearBits(BIT_6 );
           OpenOC2( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,300, 300);
           OpenOC3( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,300, 300);
        } 

        //stop
        if(Receivebyte == 'C')
         
        {
		   mPORTBToggleBits(BIT_10);
           mPORTBToggleBits(BIT_11);
           mPORTBToggleBits(BIT_12);
           mPORTBToggleBits(BIT_13);
           OpenOC2( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,0, 0);
           OpenOC3( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,0, 0);
        }
        //go forward 400
        if(Receivebyte == 'f')
         
        {
		   mPORTBSetBits(BIT_10);
           mPORTBClearBits(BIT_11 );
           mPORTBClearBits(BIT_12);
           mPORTBClearBits(BIT_13 );
           mPORTDClearBits(BIT_7 );
           mPORTDSetBits(BIT_6 );
           OpenOC2( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,400, 400);
           OpenOC3( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,400, 400);
        } 
        //go backward 400
        
        if(Receivebyte == 'c')
         
        {
		   mPORTBClearBits(BIT_10);
           mPORTBSetBits(BIT_11 );
           mPORTBClearBits(BIT_12);
           mPORTBClearBits(BIT_13 );
           mPORTDSetBits(BIT_7 );
           mPORTDClearBits(BIT_6 );
           OpenOC2( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,400, 400);
           OpenOC3( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,400, 400);
        } 
        //Turn right_forward
        if(Receivebyte == 'e')
        {
           mPORTDSetBits(BIT_7 );
           mPORTDSetBits(BIT_6 );
           OpenOC2( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,300, 300);
           OpenOC3( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,300, 300);
           my_delay();
           my_delay();
           my_delay();
           mPORTDClearBits(BIT_7 );
           mPORTDSetBits(BIT_6 );
           OpenOC2( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,300, 300);
           OpenOC3( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,300, 300);
        }
        //Turn left_forward
        if(Receivebyte == 'a')
        {
           mPORTDClearBits(BIT_7 );
           mPORTDClearBits(BIT_6 );
           OpenOC2( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,300, 300);
           OpenOC3( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,300, 300);
           my_delay();
           my_delay();
           my_delay();
           mPORTDClearBits(BIT_7 );
           mPORTDSetBits(BIT_6 );
           OpenOC2( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,300, 300);
           OpenOC3( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,300, 300);
        }
        //right_backward
        if(Receivebyte == 'g')
        {
           mPORTDSetBits(BIT_7 );
           mPORTDSetBits(BIT_6 );
           OpenOC2( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,300, 300);
           OpenOC3( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,300, 300);
           my_delay();
           my_delay();
           my_delay();
           mPORTDSetBits(BIT_7 );
           mPORTDClearBits(BIT_6 );
           OpenOC2( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,300, 300);
           OpenOC3( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,300, 300);
           
           
           
        }
        //left_backward
        if(Receivebyte == 'd')
        {
           mPORTDClearBits(BIT_7 );
           mPORTDClearBits(BIT_6 );
           OpenOC2( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,300, 300);
           OpenOC3( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,300, 300);
           my_delay();
           my_delay();
           my_delay();
           mPORTDSetBits(BIT_7 );
           mPORTDClearBits(BIT_6 );
           OpenOC2( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,300, 300);
           OpenOC3( OC_ON | OC_TIMER2_SRC | OC_PWM_FAULT_PIN_DISABLE,300, 300);
           
           
        }

	}

	// TX interrupt
	if ( mU1TXGetIntFlag() )
	{
		mU1TXClearIntFlag();
                                
         

	}
}




void my_delay (void)
{
	int outter = 0;
	
	for (outter = 0; outter < 1000000; outter++);
}