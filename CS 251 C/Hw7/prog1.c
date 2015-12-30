/********************** Chapter 7 - Project 2 **********************************
 * Name: Mike Mentele
 * ID: 11009277
 * E-mail: mike.mentele@comcast.net
 * Date: May 31, 2009
 * Purpose: This program takes two lists entered by a user and prints a table
 * with three lists. The third being the product of the corresponding elements
 * in the first two lists. Then it also prints the square root of the sum
 * of the elements in the third list.
 *****************************************************************************/


#include<stdio.h>
#include<math.h>  //to use sqrt() function

       /*Prototypes*/
void store_x(double x[20], int *x_len);
void store_y(double y[20], int x_len);
void str_calc_z(double z[20]);


int main(void)
{ 
       double z[20]; //product list of x and y lists

       str_calc_z(z); //calculates z and sqrt_z as well as stores x and y

       return 0;
}//end main


void str_calc_z(double z[20])
{
       double x[20], //holds x list
              y[20],  //holds y list
              sqrt_z, //hold sqrt of the sum of z's parts
	      sum_z; //place holder to calculate sqrt_z

       int n,  //array element
	   x_len; //number of elements
            
       //initializes variables
       sqrt_z = 0;
       sum_z = 0;

       store_x(x, &x_len); //stores x list
       store_y(y, x_len); //stores y list
  
       printf("X_________Y_________Z"); //table header
  

                      //calculates sum_z, z_list and prints z list
       for(n = 0; n != x_len; n++)
	 {            //calculates z list
	      z[n] = x[n] * y[n];
	              //prints x y and z table
	      printf("%.lf   %.lf   %.lf \n", x[n], y[n], z[n]);
	      sum_z = sum_z + z[n];
      
       }

              //calculates sqrt
       sqrt_z = sqrt(sum_z);

              //prints sqrt
       printf("The square root of the sum of the elements in z");
       printf(" is %.2lf", sqrt_z);  
  
    
}//end str_calc_z


void store_x(double x[20], int *x_len)
{
  double data; //element value

       int n; //array element

                  //stores x list values
       for(n = 0; n != 20 && data != -99; n++ )
       {
                    
              printf("Enter X values");
	      scanf("%lf", &data);
	      x[n] = data;
	      *x_len = n;
       }

       
}//end store_x


void store_y(double y[20], int x_len)
{
       double data; //array element value
 
       int n; // array element

      
              //stores y list values
       for(n = 0; n != x_len; n++)
       {
              printf("Enter Y values");
	      scanf("%lf", &data);
	      y[n] = data;
      
       }
  
}//end store_y
