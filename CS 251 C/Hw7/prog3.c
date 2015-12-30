/********************* CHAPTER 7 - PROJECT 8 ********************
 * Name: Mike Mentele
 * ID: 11009277
 * E-mail: mike.mentele@comcast.net
 * Date: May 31, 2009
 * Purpose: To search through input lists and see whether a number 
 * you choose is within that list.
 **************************************************************/

#include<stdio.h>

#define max_string_size 21  //constants
#define TRUE 1
#define FALSE 0

/*prototypes*/
void store_list(double list[max_string_size], int *list_len);
int binary_srch(double list[max_string_size]);

int main(void)
{
        double list[max_string_size]; //list of entered values

               //prints answer to query
	if(TRUE == binary_srch(list))
        {
               printf("\nYour number was found\n");
        }
	else
        {
               printf("\nYour number was not found\n");
        }

	return 0;//signals success
}//end main

int binary_srch(double list[max_string_size])
{
        int bottom, //bottom element placeholder
        top,        //top element placeholder
        middle,    //possible answer
	list_len, //number of elements
	found;    //signals success or failure

	double target; //number searching for

	store_list(list, &list_len); //call to function


	bottom = list[0];    //initializes it as first value in array
	top = list_len;    //initializes as last value in array
	found = FALSE;    //in case answer isnt found

	           //gets target
	printf("\nEnter a number between elements 0 and 20 that you wish");
	printf(" to find> ");
	scanf("%lf", &target);
  
	           //checks if target is within list
	while((bottom <= top) && (middle != target))
	{  
                      //center middle between top & bottom
	        middle = (bottom + list_len) / 2;
		

		//signals success
	        if(middle == target)
		{
		        found = TRUE;
                       
                }

	        else if(target < middle)
		{
		        top = middle - 1;
                        list_len = list_len / 2;
	       	}
		
		else
		{
		        bottom = middle + 1;
			list_len = list_len / 2;
		}

   
        }
	//signals completion
	return found;
	

}

void store_list(double list[max_string_size], int *list_len)
{
       double data; //value of elements

       int n;  //element place holder

                 //sets values for elements of list
       for(n = 0; n != max_string_size && data != -99; n++ )
       {
      
               printf("\nEnter list values");
	       scanf("%lf", &data);
	       list[n] = data;
	       *list_len = n;
       }
       
      
}

/* Binary Search is faster than a linear search with a large number of values
 * because it does evaluate every value and cut the possibilities in half
 * again and again until it gets the right answer
 */
