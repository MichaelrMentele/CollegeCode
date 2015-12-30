/*can you use a switch statement why or why not?*/

/* For this assignment you cannont use the SWITCH statement because it is specific to an exact entry where as with the if/else statement you can dilineat a range of values that can be entered to produce a desired output.*/		    


/*****************************************************************************
Name: Michael Mentele
ID: 11009277
E-mail: mike.mentele@comcast.net
Date: February 12, 2009
Purpose: The purpose of this program is to allow the user to input a value for the richter scale and then get a description of what an earthquake of that magnitude would do. It uses the standard i/o library to provide definitions for basic functions. So as to avoid error messages the funtion main uses a return value of 0 the declare success.
******************************************************************************/

#include <stdio.h> /* includes the standard library definitions for input/ouput*/

/****************************************************************************
Name: instruct
Returns: nothing (void)
Arguments: none (void)
Purpose: To print out the instructions for the user before entering their inputs
Description: The function simply runs printf commands and has no arguments or return values.
Dependencies: none
*********************************************************************************/

void instruct ( void ); //declares instruct function

/******************************************************************************
Name: main
Returns: 0 as an integer
Arguments: none
Purpose: To display a characterization of differnt richter scale values
Description: This function has a single variable that is used to determine which characterization is to be printed. The function determines this by use of the if else statements. 
Dependencies: none
****************************************************************************/

int  main ( void ) 

{
  double           /*variable number twice as long as a floating point*/
 
    RICHTER_VALUE;  /* input on richter scale*/

  instruct();        /*runs the instruct function placing the text defined at the bottom before the prompt*/
 
  printf("\nEnter Richter Scale Number to be characterized\n"); /*prints prompt*/
  scanf("%lf", &RICHTER_VALUE);                           /*stores variable value*/

  /*for all if/else statements it evaluates RICHTER_VALUE and then depending on its value it prints a statement describing that value*/

if (RICHTER_VALUE < 0.0)    
    printf("Error -- Invalid Entry\n");

 else if ( RICHTER_VALUE < 5.0)
     printf("Little or no damage\n");

 else if (RICHTER_VALUE < 5.5)
 printf("Some damage\n");

 else if( RICHTER_VALUE < 6.5)
 printf("Serious damage: walls may crack or fall\n");

 else if( RICHTER_VALUE < 7.5 )
 printf("Diaster: houses and buildings may collapse\n");

 else if( RICHTER_VALUE >= 7.5 )
 printf("Catastrophe: most buildings destroyed\n");

 return 0; /*function main returns 0 as an integer to declare success*/

}//end of function main 

void instruct(void) /*this defines what the function instruct will do, it puts the text below above at the instruct() statement*/

{
  //prints instructions
  printf("To characterize a value on the Richter Scale in terms of destruction,\n");
  printf("enter a value that is positive (note: earthquakes most likely will range in value from 0-9 however no formal upper limit exists\n");

}

/* For this assignment you cannont use the SWITCH statement because it is specific to an exact entry wheras with the if/else statement you can dilineat a range of values that can be entered to produce a desired output.*/
