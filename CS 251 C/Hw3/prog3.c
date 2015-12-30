/*********************************************************************
Name: Michael Mentele
ID: 11009277
E-mail: mike.mentele@comcast.net
Date: February 5, 2009
Purpose: The purpose of this program is to allow the user to input a desired grade, what the grade is worth percentage wise, what their current grade is, how the grade is weighted, and from all of this information get out what grade they need on a test to get the desired grade. Also this program uses the standard i/o library to provide definitions for basic functions. Also it returns a value of zero to declare success and therefore avoid errors.
*********************************************************************/


#include <stdio.h> /*lets the program use definitions of printf and scanf*/

/********************************************************************
Name: main
Returns: 0 as an integer
Arguments: none
Purpose: To compute what score on a final exam/test will give you the desired grade.
Description: The function first declares its variables, there are two type: characters and numbers. Then it provides prompts for each of the input variables which are grade (grade is not used in the calculation), rq_avg, cur_avg, and final_wt. The once it has the inputs it uses them in a formula to produce the output scr_nd. Then it prints the needed score for the desired grade onto the screen.
******************************************************************/


int main ( void )
{

  char      
    grade;         /* desired letter grade*/

  double 
    rq_avg,        /* grade percentage required to get letter grade*/
    cur_avg,       /* current grade percentage*/
    final_wt,      /* what the exam is worth in terms of the final grade*/
    scr_nd;        /* score on exam needed to get desired letter grade*/
    
  printf("Enter desired grade> "); /*prompt to enter desired letter grade*/
  scanf("%c",&grade);               /*stores character as "grade"*/

  printf("Enter minimum average required> ");  /* prompt to enter required average*/
  scanf("%lf", &rq_avg);                       /* stores input for variable rq_avg*/

  printf("Enter current average in course> "); /* prompt to enter input for current grade*/
  scanf("%lf", &cur_avg);                      /* store input for variable cur_avg*/

  printf("Enter how much the final counts as a percentage of the course grade> "); /*prompt to enter input for exam weight*/

  scanf("%lf",& final_wt);                                                         /*store input for variable final_wt*/ 

  printf("\n"); /*creates a space so that my prompts look exactly like those in the book*/

  scr_nd = ((rq_avg * 100) - (cur_avg * (100 - final_wt))) / final_wt; /* formula used to calculate the grade needed on the exam to get desired grade*/

  printf("You need a score of %lf on the final to get a %c\n", scr_nd,grade); /*print on screen giving user the output*/
  
  return (0); /* returns 0 to signal success*/
}/* end of function main and program*/

