

 #include <stdio.h>

 void max_Value( int image[10][10], int (*xp)[], int (*yp)[], int *maxp );



int main ( void )
{

	int i, j;

	/* initializes the array */
	int array[10][10];

	for(i=0 ; i<10 ; i++)
	{
	    for(j=0 ; j<10 ; j++)
	    {
	      array[i][j] = i * 10 + j;
	    }
	}

	/* initializes local variables froax_Value */
	int max;
	int x[100];
		for( i = 0; i < 100; i++)
		{
			x[i] = 0;
		}

	int y[100];
		for( i = 0; i < 100; i++)
		{
			y[i] = 0;
		}
	/* calls function max_value */
	max_Value( array, &x, &y, &max );

	/* prints the brightest pixel(s) in the image and the x-y coordinates */
    printf( "\nThe value of the brightest pixel is %d", max );
	printf( "\nThe coordinates are:" );
	for( i = 0; i < 100; i++ )
	{
		if( x[i] != 0 )
		{
			printf( "\n(%d,%d)" , x[i], y[i] );
		}
	}


	/* returns 0 for success */
	return 0;

} /* end main ***********************************************************/

/*****************************************************************************
  * Name: max_Value
  * Returns: none
  * Arguments: image[][], *xp, *yp, *maxp
  * Purpose: to find the brightest pixel(s) in the sky and the corresponding
  * x-y coordinates. Returns more than 1 result if there are duplicate max values
  *
  * Description: the function first sets the length of the array to 10 and
  * initialzes the varables to be used in the for loop. Then, using a loop, it
  * stores the maximum value found and its associated x-y coordinates as output
  * variables.
  *
  * Dependencies: stdio functions for, if, int
 *****************************************************************************/

void max_Value( int image[10][10], int (*xp)[], int (*yp)[], int *maxp )
{
	/* initalizes variables used in for loop */
	int i, j;
	int k = 0;

	/* establishes size of array */
	int length = 10;

	/* intializes maxp to the first element */
    *maxp = image[0][0];
    (*xp)[k] = 1;
    (*yp)[k] = 1;

	/* loops through the array to find the largest value */
    for( i = 0; i < length; i++ )
    {
		for( j = 0; j < length; j++ )
        {
			if( image[i][j] > *maxp )
			{
				(*xp)[k] = i + 1;
				(*yp)[k] = j + 1;
				*maxp = image[i][j];
			}


		}
    }

	/* loops through the array to see if there are any duplicates and adds the
	coordinates to the x and y arrays */
    for( i = 0; i < length; i++ )
    {
		for( j = 0; j < length; j++)
		{
			if( image[i][j] == *maxp )
			{
				if( (*xp)[0] != (*xp)[i+1] && (*yp)[0] != (*yp)[j+1] )
				{
					k++;
					(*xp)[k] = i + 1;
					(*yp)[k] = j + 1;
				}
			}
		}
	}
} /* end max_Value ********************************************************/
