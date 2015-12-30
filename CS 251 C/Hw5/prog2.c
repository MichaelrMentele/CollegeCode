/****************************************************************************
 *Name: Mike Mentele
 *ID: 11009277
 *E-mail: mike.mentele@comcast.net
 *Date: March 1, 2009
 *Purpose: This program is used to calculate the pressure in atomispheres created by volume of gas at a constant temperature.
 *************************************************************************/

#include <stdio.h> // includes the standard i/o library  for common functions such as printf 

/***********************************************************************************
 *Name: instruct
 *returns: nothing
 *purpose: to includes instructions and improve readability
 *Description: inserts instructions anywhere instruct() is written
 *Dependencies: none
 ******************************************************************************/

void instruct (void);

/******************************************************************************
 *Name: main
 *Returns: 0 as an integer
 *Purpose: to compute the pressure created by carbon dioxide depending on a change in volume with a constant temperature
 *Description: This program first tells the user to enter the required info at the prompts and then it uses that to calculate the pressure in intervals based on user specification.
Dependencies: none
 ****************************************************************************/

int main (void)

{
  //defines constants
#define a 3.592   //constant for carbon dioxide
#define b 0.0427 //constant for carbon dioxide
#define R 0.08206 // gas constant

  //declares input variables
  double n, T, in_V, fin_V, Vol, increment, P; //n is moles of gas, T is temperature kelvin, starting volume, ending volume, volume being evaluated, incremental change in volume, and atomispheric pressure created

  int count; //counter for loop

  count = 0; // sets count to 0

  instruct(); //calls instructions

   //prompts and input assignation for the input variables
   printf( "\nQuantity of carbon dioxide (moles)>" );
   scanf( "%lf", &n );

   printf( "\nTemperature (kelvin)>" ); 
   scanf( "%lf", &T ); 

    printf( "\nInitial volume (milliliters)>" );
    scanf( "%lf", &in_V );

    printf( "\nFinal volume (milliliters)>" );
    scanf( "%lf", &fin_V );

    printf( "\nVolume increment (milliliters)>" );
    scanf( "%lf", &increment );

    //begining of the table, headers for each category
    printf("\nVolume (ml)     Pressure (atm)");

    //start of do-while loop
do 
  {
    Vol = increment * count + in_V; //volume to be evaluated
    P = ((n * R * T) / (Vol / 1000 - b * n)) - ((a * n * n) / (Vol / 1000 * Vol / 1000));//pressure created

    count = count + 1; // counter for loop
 
    printf( "\n%lf             %lf\n", Vol, P ); //data entries for the table spaced accordingly
    



  }


 while ( Vol < fin_V ); //criteria for whether to end loop or not
// end of loop

 printf( "\n" );// space so prompt isn't in a weird place in terminal

 return 0;//returns 0 to signal success for function main
}
//end of function main 


void instruct (void)
{
 //information about following prompts
   printf( "\nEnter at the following prompts the amount of moles of carbon dioxide, the temperature in Kelvin, the initial volume in milileters, the final volume and the increment volume between lines of the table.\n" );

 
}
// end of function instruct and program
