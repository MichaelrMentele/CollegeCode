# ***************************************************************************************************************************
# * Author:                                                                                                                 *
# * Course: EE 234 Microprocessor Systems - Lab #                                                                           *
# * Project:                                                                                                                *
# * File: CodeTemplate.s                                                                                                    *
# * Description: This file is provided to help you get started with MIPS32 (.s) assembly programs.                          *
# *              You may use this template for getting started with .S files also, in which preprocessor directives         *
# *              are allowed.                                                                                               *                           
# *                                                                                                                         *
# * Inputs:                                                                                                                 *
# * Outputs:                                                                                                                *
# * Computations:                                                                                                           *
# *                                                                                                                         *
# * Revision History:                                                                                                       *
# *************************************************************************************************************************** 


# ***************************************************************************************************************************
# *                                                                                                                         *
# *                                           Include Files                                                                 *
# *                                                                                                                         *
# ***************************************************************************************************************************


# ***************************************************************************************************************************
# *                                                                                                                         *
# *                                           Global Symbols                                                                *
# *                                                                                                                         *
# ***************************************************************************************************************************

.GLOBAL main

# ***************************************************************************************************************************
# *                                                                                                                         *
# *                                           Data Segment                                                                  *
# *                                                                                                                         *
# ***************************************************************************************************************************

# This is where all variables are defined.
# We generally assign pointer/address registers to these variables and access them indirectly via these registers.

.DATA                        # The start of the data segment
str1: .WORD 'a', 'b', 'c', 'd', 0

# ***************************************************************************************************************************
# *                                                                                                                         *
# *                                           Code Segment                                                                  *
# *                                                                                                                         *
# ***************************************************************************************************************************

.TEXT                        # The start of the code segment

	                         
.ENT main                    # Setup a main entry point
main:

	LA $a0, str1
	JAL strLength # 1

	loop:
		# Event loop
		
		J loop    #2           # Embedded programs require that they run forever! So jump back to the beginning of the loop
	
.END main

# ***************************************************************************************************************************
# *                                                                                                                         *
# *                                           Subroutine Definitions                                                        *
# *                                                                                                                         *
# ***************************************************************************************************************************

# The below comment block is required for all defined subroutines!
# ***************************************************************************************************************************
# * Function Name:                                                                                                          *
# * Description:                                                                                                            *
# *                                                                                                                         *
# * Inputs:		                                                                                                            *
# * Outputs:	                                                                                                            *
# * Computations:                                                                                                           *
# *                                                                                                                         *
# * Errors:                                                                                                                 *
# * Registers Preserved:                                                                                                    *
# *                                                                                                                         *
# * Preconditions:                                                                                                          *
# * Postconditions:                                                                                                         *
# *                                                                                                                         *
# * Revision History:                                                                                                       *
# ***************************************************************************************************************************

# This subroutine is not complete!
.ENT strLength
strLength:
	ADDI $sp, $sp, -4
	SW $ra, 0($sp) # push

	count:
		LW $t0, ($a0)
		ADDI $a0, $a0, 4
		
		BEQZ $t0, done
		
	J count
	#JAL strLength2 # 3
	
	done:
	LW $ra, 0($sp) # pop
	ADDI $sp, $sp, 4

	JR $ra

.END strLength

.ENT strLength2
strLength2:
	# ra = 3

	
	JR $ra

.END strLength2
