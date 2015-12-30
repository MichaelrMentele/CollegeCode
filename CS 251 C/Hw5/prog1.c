/*****************************************************************************
 *Name: Michael Mentele
 *ID: 11009277
 *E-mail: mike.mentele@comcast.net
 *Date: March 1, 2009
 *Purpose: To determine the series resistance and parallel resistance of a set of resistors.
 **************************************************************************/


#include <stdio.h> // includes the standard i/o library which provides definitions for basic functions such as printf

/******************************************************************************
 *Name: main
 *Returns: 0 as an integer to declare success
 *Arguments: none to declare success
 *Arguments: none
 *Purpose: To compute the series and parallel resistance of a set of resistors
 *Description: The function firsts delares three double variables and two integer variables and then uses a loop to calculate them, the loop only goes until the count is the same as the number of resistors. Once the loop is done looping thefunction prints the resistance values.
 *Dependencies: none
 ***********************************************************************/

int main ( void )

{//declaring variables

  double SERIES, PARALLEL, R_VALUES; //series and parallel represent the value of their corresponding resistance type and r_values is the resistors resistance in ohms.

  int COUNT,R_NUM; //used as counters

  printf( "\nEnter the number of resistors>" ); //print prompt to enter R_NUM value
  scanf( "%d", &R_NUM );// store r_num value

  COUNT = 0;     //sets variable to 0
  PARALLEL = 0;
  R_VALUES = 0;
  SERIES = 0;

  //begining of do-while loop

do

  {

    COUNT = COUNT + 1; //begins count as 1

    printf( "\nEnter the value of your resistor>" ); //prompt to enter resistor values

    scanf( "%lf", &R_VALUES ); //stores value for R_VALUES

    SERIES = SERIES + R_VALUES; //Calculates series just by adding R_VALUES

    PARALLEL = PARALLEL +  1 / R_VALUES; //partially calculates Parallel resistance value however the actual value is 1 over parallel and is done in the printf below

  }

 while( COUNT < R_NUM ); //determines whether to continue loop or not

 printf( "\nThe series resistance of all the resistors is %.2lf\n", SERIES ); //prints series resistance after end of loop

 printf( "\nThe parallel Resistance is %.2lf\n\n", 1/PARALLEL ); //completes and prints parallel resistance value

 return 0; //returns 0 as an integer to signal success for the function main


}
//end of function main and program
