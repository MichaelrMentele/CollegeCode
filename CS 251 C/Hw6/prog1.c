/****************************************************************
 * Name: Mike Mentele
 * ID: 11009277
 * E-mail: mike.mentele@comcast.net
 * Date: March 12, 2009
 * Purpose: The program assignment is to create a program that
 *            factors an input number into its prime factors
 ***************************************************************/

                 /*includes standard input output definitions for
                   basic functions like printf*/
#include <stdio.h>


                 /*Prototype of driver function*/
int factor (int NUM, int FAC);


/***************************************************************
 * Name: main
 * Returns: 0 as an integer
 * Arguments: none
 * 
 * Purpose: To prompt user to enter input variable and call to 
 *          function factor to do calculations
 *
 * Description: declares variables and then calls to "factor" to 
 *              do calculations and finally returns 0 for completion
 *
 * Dependencies: None, answer is printed within factor
 **************************************************************/

int main (void)

{          //input variable
  int NUM,
      FAC; //variable that stores factor           

   
                       //prompt to enter input variable NUM
  printf("\nEnter integer to be factored> ");

                       //stores value of input
  scanf("%d", &NUM);

  factor( NUM, FAC);   //runs calculation and prints answer
 

  return 0;            // returns 0 to signal success

} /*********************** END OF MAIN *************************/



/****************************************************************
 * Name: factor
 * Returns: 0 as an integer
 * Arguments: int NUM - input variable to be factored
 *            int FAC - variable used to store factors before 
 *                         printing 
 *                    
 * Purpose: to compute and print the factors of NUM
 *
 * Description: the function uses a do-while loop and nested if
 *              statements to calculate factors. It does this by
 *              testing what number divide into the input without
 *              leaving a remainder and then further diving them 
 *              until they are prime.
 *
 * Dependencies: NONE
 ***************************************************************/

int factor (int NUM, int FAC)

{
                     //div is the divisor
                     //A_CNT is array length but it was only used
                     //in original program is useless now
                     
  int div; 

  
  div = 2;           //sets divisor to 2 to check if its even

  

  

  printf("%d =", NUM); //prints original number 


     //start of loop, it will keep checking if values divide with no 
     //remainder until it finds all prime factors
    do

 {
   if (NUM % div == 0)  //checks if div is a factor

     {
      FAC = div; //stores factor
     
      printf(" %.d ", FAC); //prints factor

        if(NUM == div) //this puts a break in to prevent printing an extra "x"

	{
	  printf("\n"); //space to look good
	  break;        //breaks out of loop
	}

      printf("x");      //prints multiply sign like in book
      
      NUM = NUM / div;  //factors out a factor
      
     
     }
   else div = div + 1;  //adds 1 to divisor if it wasn't a factor
      
 }  

  while (NUM >= div);   //stops loop if there are no factors except for itself

  


  return 0; //signals completion

}/*********************** END OF FACTOR *******************************/

/***********************************************************************
 *                         END OF PROGRAM                                  *
 **********************************************************************/
