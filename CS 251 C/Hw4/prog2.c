/****************************************************************************
 *Name: Michael Mentele
 *ID: 11009277
 *E-mail: mike.mentele@comcast.net
 *Date: February 12, 2009
 *Purpose: To declare where an x,y coordinate pair it on a cartesian plane either with a quadrant or axis assignment
 ************************************************************************/

#include <stdio.h> // includes standard library definitions

/*************************************************************************
 *Name: main
 *Returns: 0 as an integer
 *Arguments: none
 *Purpose: to declare where x,y are on a cartesian plane
 *Description: This function has two variables that are floating point variables. When the user inputs their values the computer uses the if/else statements to determine where on the graph that point is in terms of quadrants and axis
 *Dependencies: none
 ********************************************************************/
int main (void) 

{
  double  //floating point type variable
    x,     //x coordinate
    y;       //y coordinate

  printf("Enter a value for x");//prompts value for x
  scanf("%lf", &x);   //evaluates value of x and stores it

  printf("Enter a value for y"); //prompts value for y
  scanf("%lf", &y);     //evaluates value of y and stores it

  /* the following if/else statements use nested if statments to make a decision based on two variables they then print out the coinciding message about the location of the x,y point in terms of quadrants*/

 if
   (x < 0)
 {
   if (y < 0)

     printf("(%.lf,%.lf) is in quadrant III\n",x,y);
 }

 



  if 

     (x < 0)
 {
     if (y > 0)

     printf("(%.lf,%.lf) is in quadrant II\n",x,y);
 }


 

 if
 ( x > 0 )

{
       if (y < 0)
       
 printf("(%.lf,%.lf) is in quadrant IV\n",x,y);
 }

 
  if( x>0)
{
	 if (y>0)

 printf("(%.lf,%.lf) is in quadrant I\n", x, y);
 }

  //this if statement uses its order to determine where the x,y point is in terms of axis
if (x == 0.0 && y==0.0)
   printf("(%.lf, %.lf) is at the origin\n", x, y);

 else if (x ==0.0)
    printf("(%.lf, %.lf) is on the x axis\n", x, y);

	   else if (y==0.0)
	     printf("(%.lf, %.lf) is on the y axis\n", x, y);
 
 
 return 0; //returns 0 as an integer to declare success

}//end of program and function main
