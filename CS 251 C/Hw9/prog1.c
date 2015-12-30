/***********************************************************************************
 * Name: Michael Mentele
 * ID: 11009277
 * E-mail: mike.mentele@comcast.net
 * Date: April 15, 2009
 * Purpose: This program scans a text file and then stores that information in an array 
 *  and then prints that output in a table.
 ***********************************************************************************/
 
#include <stdio.h>
#include <math.h>
#include <stdlib.h>

#define MAX_SIZE 100    //number of chars in the name

typedef struct
{
	int id,       //number for a player
        years,    //number of years playing
		at_bats, //number of at bats
        hits;     //number of balls hit
	double career_average; //average of hits and bats over the years
} career; //structure for player 

/***********************************************************************************
 * Name: main
 * Returns: 0
 * Arguments: none
 *
 * Purpose: to store, calculate ane print baseball players stats
 *
 * Description: creates the needed arrays and then prints the career_average of each player
 *
 * Dependencies: none
 *********************************************************************************/

int main(void)

{
		FILE *stats;    //stores name of datafile
		career structure[100];  //delare array length
		int player_count=0, //length of array
			temp=0,        //temporary for storing info
			id=0,          //player id number
			i=0;           //counter
		double yr_avg=0.0;      //per year average
		char file[MAX_SIZE]; //array to hold player stats

		printf("\nEnter player's data file name> "); //prompt for input
		scanf("%s", file);  //stores file name
		stats = fopen(file, "r"); //opens in read only format
	
	                //if the file has usable data in it then
					//it calls it and compute the career average
					//and then prints that or it ends wit a error 
					//message
		if (stats != NULL) 
		{
                    //store output values to be called and printed
				while (fscanf(stats, "%d", &id)!=EOF)
				{
					structure[player_count].id=id;
					fscanf(stats, "%d", &temp);
					structure[player_count].years=temp;
								
			              
				for (i=0;i<structure[player_count].years;i++) 
				{
					fscanf(stats, "%d", &temp);
					fscanf(stats, "%d", &temp); //at_bats
					fscanf(stats, "%lf", &yr_avg); //yr avg
					structure[player_count].hits+=ceil(temp*yr_avg);//career avg
					structure[player_count].at_bats+=temp; 
				}
			
			
		structure[player_count].career_average=(double)structure[player_count].hits/(double)structure[player_count].at_bats;
			player_count++;
			
	}
        
					//closes the data file
		fclose(stats);
                      //titles for table of output
		printf("ID\tYears\tAt Bats\tHits\tAverage\n");

		for (i=0;i<player_count;i++) 
		{
                     //prints the output in the table
				printf("%d\t%d\t%d\t%d\t%0.3lf\n", structure[i].id,structure[i].years,structure[i].at_bats,
				structure[i].hits,structure[i].career_average);

		}
			//returns 0 to signal success for main
		return 0;

		} 
	       //prints error message when the input is invalid
		   //also exits back to command prompt
		else 
		{
			printf( "The data file ( %s ) was not found!!\nShutting down!\n", file );
			exit( -1 );
		}



} //end of function main

/******************************end of program **********************************************/

