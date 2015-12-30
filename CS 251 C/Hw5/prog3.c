/***********************************************************************************
 *Name: Mike Mentele
 *ID: 11009277
 *E-mail: mike.mentele@comcast.net
 *Date: March 1, 2009
 *Purpose: this program evaluates guesses on depth of water in the channel as to how close that would mean the flow rate was to 1000 cubic feet per second
 ********************************************************************************/


#include <stdio.h> //includes basic library definitions for functions like printf
#include <math.h> //includes basic math definitons for things like squarre root

//defines constants
#define WIDTH 15.00
#define SLOPE 0.0015
#define R_CO  0.014

/*********************************************************************************
 *Name: instruct
 *returns: nothing
 *Arguments: none
 *Purpose: to improve readability
 *Description: text at the bottom where the funtion is defined will be included where the function is named
 ********************************************************************************/

void instruct (void);

/***********************************************************************************
 *Name: main
 *Returns: returns 0 as an integer 
 *Arguments: none
 *Purpose: evaluates guesses by the user as to the depth of the water in the channel and then tells them how close they are to 1000 cfs
 *Description: First it tells the user that they are supposed to guess the depth and then everytime the user guesses it displays how close they were to the target flow rate and the loop doesn't end until they are within .1 percent of it
 *Dependencies: none
 ********************************************************************************/

int main(void)
{
  //declaring variables
  double DEPTH, FLOW, W_AREA, H_RAD, DIFF, ERR;//depth is major variable the rest are dependent on depth, flow is the cfs, W_area is the "wet" area, H_Rad is the hydraulic radius, diff is the difference between the guess and the target, and err is how close the guess is in percentage to the target

  //inserts instructions
  instruct();
 
  // start of do-while loop
do
  {
    //prompt for guess
    printf("\nWhat is your guess?");
    scanf("%lf", &DEPTH); //scans for DEPTH

    
    W_AREA = DEPTH * WIDTH; //vertical area (like a screen moving down the channel)

    H_RAD = (DEPTH * WIDTH) / (2.0 * DEPTH + WIDTH);//calculates hydraulic radius

    H_RAD = pow(H_RAD, 2.0/3.0); //uses the exponent so equation is simplified

    FLOW = (1.486 / R_CO) * W_AREA * H_RAD * sqrt(SLOPE);//calculates cfs

    DIFF = 1000 - FLOW;//show difference between target and current flow

    ERR = DIFF *  0.1;// same as diff but as a percentage
   
    //displays their guess and the info pertinent to it
    printf("Depth: %lf ft Flow: %lf cfs Target: 1000 cfs\n", DEPTH, FLOW);
    printf("Difference: %lf cfs Error: %lf percent\n", DIFF, ERR);
   
   
    
  }

 while(ERR < -.1 || ERR > .1  );//end of loop and also provides criteria to continue or end the loop


  return 0;//returns 0 as an integer to signal success for the function main
}

void instruct (void) //instructions function
{

 //info explaining the reason a startin point is given  
  printf("At an unknown depth in feet the water flow is 1000 cubic feet per second, at the prompt please guess the depth. An example is given to provide a starting point.\n");

  //starting point so people have a place to guess from
  printf("\nAt a depth of 5 feet, the flow is 641.3255 cubic feet per second.\n");
  
}//end of function instruct and program
