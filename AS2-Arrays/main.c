//****************************************************************************************************************************
// - Legal Information -
//
// Copyright (C) 2025 Riley Berry.
//
// This file is part of the software program "Arrays".
// Arrays Program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public
// License version 3 as published by the Free Software Foundation.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
// A copy of the GNU General Public License v3 is available at: https://www.gnu.org/licenses/
//****************************************************************************************************************************

//____________________________________________________________________________________________________________________________
// - Author Information -
//    Author name: Riley Berry
//    Author email: rberr7@csuf.fullerton.edu
//    CWID: 885405613
//    Class: 240-5 Section 5
//
// - Program Information -
//    Program name: Arrays Program
//    Programming languages: C, Assembly (x86-64)
//    Date created: 2/18/25
//    Files in this program: main.c, manager.asm, input_array.asm, output_array.asm, compute_sum.asm, isfloat.asm, sort.c, swap.asm, etc.
//
//    Purpose:
//    This program manages an array of floating-point numbers. It performs several operations, including:
//    - Receiving user input
//    - Sorting the array
//    - Computing the sum
//    - Displaying the results
//
//    The program is structured with multiple assembly and C modules, orchestrated by the manager function.
//____________________________________________________________________________________________________________________________

#include <stdio.h>

extern double manager(void);  // manager returns a floating-point sum in xmm0

int main() {
    printf("\n=========================================================================================================================================\n"
           "Welcome to Arrays of floating-point numbers.\n"
           "Brought to you by Riley Berry\n\n");

    double sum = manager();  // Call manager and store the returned sum

    printf("\nMain received %lf, and will keep it for future use.\n"
           "Main will return 0 to the operating system. Bye.\n"
           "=========================================================================================================================================\n",
           sum);

    return 0;
}

