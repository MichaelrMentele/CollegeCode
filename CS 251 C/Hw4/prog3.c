/****************************************************************************
 *Name: Michael Mentele
 *ID: 11009277
 *E-mail: mike.mentele@comcast.net
 *Date: February 12, 2009
 *Purpose: To declare what chemical gas cylinders carry based on their color
 ************************************************************************/


#include <stdio.h>

/*************************************************************************
 *Name: main
 *Returns: 0 as an integer
 *Arguments: none
 *Purpose: to declare what chemical is within gas cylinders based on the first letter of the color of the cylinders
 *Description: This function has a single variable to store the input of the user. When the user enters their input then the function main uses switch to print out information based on what the input was. This function uses the standard i/o library for definitions and returns 0 as an integer.
 ********************************************************************/

int main (void)//body function that uses switch to choose to print info

{
  char          //letter variable
    letter;      //single variable representing what the user types

  printf("Enter first letter of the color of the gas cylinder\n");//prompts user to enter the input
 scanf("%c", &letter); //stores a character for "letter"
 
 switch (letter) //a command used to differentiate between various possibilities of input or "cases"


   //there are two cases that correspond to 4 separate colors for a total of 8 possible inputs. for each color and the two inputs information is printed telling the user what kind of gas is within that color cylinder
{
 case 'o':
 case 'O':
   printf("The gas cylinder contains ammonia\n");
  break;

 case 'b':
 case 'B':
   printf("The gas cylinder contains carbon monoxide\n");
  break;

 case 'Y':
 case 'y':
   printf("The gas cylinder contains hydrogen\n");
  break;

 case 'g':
 case 'G':
   printf("the gas cylinder contains oxygen\n");
  break;

 default: 
   printf("Invalid Entry\n"); //if there is no reconizable case then the function simply defaults to this and prints invalid entry

 }//end of switch
 
 return 0;//returns 0 as an integer to single success for main
}// end of program and main
