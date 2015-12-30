

#include <stdio.h>
#include <string.h>

#define MAX_LENGTH 500
void rotate (char* string, int *count);

int main (void) 

{
	char store_string[MAX_LENGTH];
	int count;
	int i;
	char store;

	printf("Enter a string> ");
	
	for( i = 0; i< 100; i++ )
	{
		scanf("%c", &store );
		if( store == '\n' )
		{
			*(store_string +i) =0;
			break;
		}
		
		else
			*(store_string + i) = store;
	}
	count = strlen(store_string);
	printf( "%s", store_string);
	rotate(store_string, &count);


	return 0;

}


void rotate (char* string, int *count)

{
	int j;
	int i;
	char temp;

	for ( i=0; i < *count; i++ )
	{
		temp = *(string + 0);
		for ( j=0; j < *count-1; j++ )
		{
			if ( *(string + j) == '\n' )
			{
				*(string +j) = NULL;
			}
			

				*(string + j) = *(string+j+1);
		}
		*(string + *count-1) = temp;
		printf("\n%s", string);

	}

}




		


	


		