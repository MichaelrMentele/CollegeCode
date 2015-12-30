/******************************************************************************
Name: Mike Mentele
ID: 11009277
E-mail: Mike.mentele@comcast.net
Date: January 27, 2009

Purpose: To display on the monitor the message "Hello, World of C! I am Mike Mentele, C Programmer. It is Spring semester 2009. My EECS account name is: mmentel1 My major is: Electrical Engineering"
*******************************************************************************/
/*
 include<> -> Includes stdio.h file, which means standard input/output header,because it contains definitions of standard input output operations.
*/
#include<stdio.h>
/******************************************************************************
Name: main
Returns: int 0 when program runs successfully
Arguments: none
Purpose: To print a brief message on the terminal screen.
Dependencies: function printf
*******************************************************************************/
int main( void )
{//printf -> prints the message
  printf( "\nHello, World of C!\n");
  printf( "I am < Mike Mentele>, C Programmer.\n");
  printf( "It is Spring semester 2009.\n");
  printf( "My EECS account name is:< mmentel1>\n");
printf( "My major is:< Electrical Engineering>\n");
 return 0;
 //return -> returns success
 }
/* end function main( void )*/
//end of program
