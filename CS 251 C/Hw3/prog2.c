

/*********************************************************************

Name: Michael Mentele
ID: 11009277
E-mail: mike.mentele@comcast.net
Date: February 5, 2009
Purpose: The purpose of this program is to allow the user to input a depth into the earth and get outputs of temperature in the form of celsius and fahrenheit degrees. It uses the standard i/o library to provide definitions for basic functions. Also it returns a value of zero to declare success and avoid errors.

****************************************************************/

#include <stdio.h>

/*********************************************************************

Name: main
Returns: 0 as an integer
Arguments: None
Purpose: To compute depth (kilometers) into temperature in terms of celsius and fahrenheit
Description: The function first declares the variables celsius, kms, and fahrenheit. Then it provides a prompt for the user to enter an input. When the input is entered it will comput the values of the two temperature using the two formulas below and it will then print the results back out on the screen.

********************************************************************/



  int main ( void )

{

  double celsius,     /*temperature celsius*/
         kms,         /*depth kilometers*/
         fahrenheit;  /*temperature fahrenheit*/

  printf(" Enter depth in kilometers\n "); /*prompts user to enter input*/
  scanf("%lf", &kms);                      /* stores input for variable kms                                               */

  celsius = 10 * kms + 20;          /*calculates temperature for celsius*/
  fahrenheit = 1.8 * celsius +32;   /*calculates temperature for fahrenheit                                     using depth*/


printf("At the depth you entered the temperature would be %lf degrees celsius or %lf degrees fahrenheit.\n", celsius,fahrenheit);

/*Prints the results for the variables celsius and fahrenheit*/



 return (0);      /*returns 0 for the function main*/
}                 /* End of function main and program*/
