/************************************************
 * Name: Mike Mentele
 * ID: 11009277
 * E-mail: mike.mentele@comcast.net
 * Date: March 12, 2009
 * Purpose: Program assignment is to create a program 
 *         that approximates the square root of a number 
 *         using a linear formula.
 ************************************************/

    //includes standard input output library that provides
    //basic definitions for functions like printf
#include <stdio.h>




double sqrt_n( double NUM, double NG, double LG); //prototype driver function


/*************************************************
 * Name: main
 * Returns: 0 as an integer
 * Arguments: None
 *
 * Purpose: to provide a place for the driver function to work.
 *
 * Description: First the return type int is given to tell main
 *             what to return to signal completion and then it 
 *             declares all the variables to be used as 
 *             arguments in sqrt_n. Then after th driver function
 *             runs it returns 0 to signal completion.
 *
 * Dependencies: sqrt_n has to run before main can end
 ************************************************/


int main( void ) 
{
                      //NUM is what we are solving for
                      //LG stands for last guess
                      //NG stands for New guess
  double NUM, NG, LG;


                       //prompts the user to enter the NUM
                       //variable to be square rooted
  printf("\nPlease enter the number you want to be square rooted>");

                       //scans for and stores variable NUM
  scanf("%lf", &NUM);


                       /* calls to the driver function
                          sqrt_n to do the calculations and
                          stores that value for NG */
  NG = sqrt_n(NUM, NG, LG);
  

                        //Prints out the square root of input
                        //number NUM both + and -
  printf("\nThe possible square roots of %.3f are -%.3f and %.3f.\n",
          NUM, NG, NG); 

   
  return 0; //returns 0 to signal completion of function main


} /******************** END MAIN *********************/



/*****************************************************
 * Name: sqrt_n
 * Returns: NG as a double
 * Arguments: double NUM - the number to be square rooted
 *           double NG - the variable that stores the 
 *                       potential output
 *           double LG - intial variable and variable that
 *                       is stored as the new guess everytime
 *                       the function loops
 *
 * Purpose: to compute the square root of the input variable 
 *         NUM.
 *
 * Description: the function uses a do-while loop and compares the 
 *              difference between NG and LG and then breaks out of
 *              the loop when it is within .005. Without the break
 *              the loop would continue infinitely because the 
 *              criteria within while has no variable and so 1 will
 *              always be less than 2
 *
 * Dependencies: None
 *
 ****************************************************/

double sqrt_n( double NUM, double NG, double LG )

{
  
         //sets initial guess to 1
  LG = 1; 
  
  

         //start of do loop used to get closer and closer to the square
         //root of input NUM, also contains all calculations
  do
    {
      NG = .5 * (LG + NUM / LG); //square root approx. formula
                      
                                 //check to see if approx. is within
                                 //desired range
      if (-.005 < NG - LG  &&  NG - LG < .005)
        {
	  break;  //breaks out of the loop
	}

      LG = NG;    //stores new value to calulate a NG within range
      

    }

  while( 1 < 2 );  //continues loop



 
  return NG; //returns NG for this entire function so it can be printed

}/***************************** END OF SQRT_N ********************/


/********************************************************************
 *                           END OF PROGRAM                         *
 *******************************************************************/
