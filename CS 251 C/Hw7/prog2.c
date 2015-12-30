/********************* CHAPTER 7 - PROJECT 6 ********************
 * This program evaluates a string of symbols for whether it
 * ends with the characters O and H with respect to that order.
 **************************************************************/

#include<stdio.h>


#define max_string_size 30 //max character length
#define TRUE 1             //return 1 as true

/*prototypes*/
int hydroxide(char chem[]);
int str_len(char chem[]);


int main(void)
{
  
        char chem[max_string_size]; //chemical name


        if(TRUE == hydroxide(chem)) //prints affirmation
        {
                printf("The chemical does end in OH.\n\n");
        }

	printf("Hope you enjoyed, have a nice day!\n\n");

        return 0;
}//end main




int hydroxide(char chem[])
{
        int num_chars; // number of characters in input

             //get the chemical name
        printf("\nEnter Chemical Data> ");
        scanf("%s", chem);
  
             //get number of character in input
        num_chars = str_len(chem);

             //evaluate input to see if it ends in OH
        if(chem[num_chars - 2] == 'O' && chem[num_chars - 1] == 'H')
        {
               return 1; // return one for true
        }
  
        else //message if chemical does not end in OH
	       printf("The chemical does not end in OH.\n\n"); 

        return 0; //returns 0 because it is false
}//end hydroxide
 



       //find num_chars
int str_len(char chem[])
{
         int i = 0;   //counter for each character

               //sentinel controlled loop
         while (chem[i] != 0)
         {
                i++;
         }

         return i;   //return number of characters
}//end str_len




