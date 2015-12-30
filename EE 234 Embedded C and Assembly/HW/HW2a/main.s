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

count: .WORD 1               # May satisfy step 1 of 2(a)
sum: .WORD 12                 # May satisfy step 2 of 2(a)
 
# ***************************************************************************************************************************
# *                                                                                                                         *
# *                                           Code Segment                                                                  *
# *                                                                                                                         *
# ***************************************************************************************************************************

.TEXT                        # The start of the code segment

	                         
.ENT main                    # Setup a main entry point
main:

	JAL fragment_2a

	loop:
		# Event loop
		
		J loop               # Embedded programs require that they run forever! So jump back to the beginning of the loop
	
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

.ENT fragment_2a
fragment_2a:
	# Represents fragment; will not preserve registers

	# 1. Set the value of count to 1
 	LA $s0, count # Using a pointer
 	LI $t0, 1
 	SW $t0, ($s0)
 	
 	# 1. Alternate solution to "Set the value of count to 1"
 	LI $t0, 1
 	SW $t0, count
 	
 	# 2. Set the value of sum to 0
 	SW $zero, sum # Yes, you can use pointers here as well
 	
 	# Store 100 into a register
 	LI $t0, 100
 	# 3. While (count <= 100) do steps 4 and 5
 	while:
 		# Create condition for while ()
 		# count <= 100?
 		LW $t1, count
 		SUB $t1, $t0, $t1
 		BLTZ $t1, done
 		
 		# 4. Set sum to count plus sum
 		LW $t1, count
 		LW $t2, sum
 		ADD $t2, $t1, $t2
 		SW $t2, sum
 		
 		# 5. Add 1 to count
 		LI $t1, 1
 		LW $t2, count
 		ADD $t2, $t2, $t1
 		SW $t2, count
 	
 		# Yes, steps 4 & 5 can be greatly reduced by
 		# designating registers for count and sum;
 		# however, I'm providing you a solution with the most
 		# literal interpretation of the provided C fragment
 	
 		J while # End while
 	
 	done:
 	
 	JR $ra

.END fragment_2a
