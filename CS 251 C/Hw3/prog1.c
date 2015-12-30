/*********************************************************************
Name: Michael Mentele
ID: 11009277
E-mail: mike.mentele@comcast.net
Date: February 5, 2009
Purpose: The purpose of this program is to allow the user to input a volume in millileters and get an output expressed in terms of fluid ounces. It used the standard i/o library to provide basic functions. So as to avoid error messages this program uses a return value of 0 to declare success.
*********************************************************************/

#include <stdio.h>       /*includes standard library definitions for input/output*/

#define fl_per_ml 0.034      /*conversion constant used to calculate fl_oz*/

/****************************************************************
  Name: main
  Returns: 0 as an integer
  Arguments: None
  Purpose: To compute ml into fluid ounces
  Description: The funtion first declares the variables ml and fl_oz. Then it provides a prompt to the user to enter input. When the input is entered it computes it using the conversion constant above and then prints the result out on the screen.
  Dependencies: None
*******************************************************************/



int main(void)
{
  double ml, /*volume milliters*/
    fl_oz; /* volume in fluid oz*/
 
  printf("Enter volume in milliliters \n");/*get volume in ml*/
  scanf("%lf", &ml);

  /*convert ml to fl_oz*/
  fl_oz = fl_per_ml * ml;

  /*Display the volume in fluid ounces*/
  printf("That is equal to %lf fluid ounces.\n", fl_oz);

  return (0);
}/*end of function main and program */
