// main.c
//****************************************************************************************************************************
// - Legal Information -
//
// Copyright (C) 2025 Riley Berry.
//
// This file is part of the software program "Non-Deterministic Random Numbers".
// Random Products is free software: you can redistribute it and/or modify it under the terms of the GNU General Public
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
//    Class: 240-5 Section 3
//
// - Program Information -
//    Program name: Non-Deterministic Random Numbers
//    Programming languages: C, Assembly (x86-64)
//    Date created: 3/20/25
//    Files in this program: main.c, executive.asm, sort.c, show_array.asm, isnan.asm, normalize_array.asm, 
//                           fill_random_array.asm
//
//    Purpose:
//    This program generates up to 100 random 64-bit floating-point numbers using a non-deterministic random number 
//    generator. The numbers are then normalized to a specific range, checked for NaN values, sorted, and displayed.
//    The program is structured with multiple assembly and C modules, orchestrated by the executive function.
//____________________________________________________________________________________________________________________________

#include <stdio.h>

extern char* executive(void);  // executive returns a floating-point sum in xmm0

int main() {
    printf("\n================================================================================================"
           "==========================\n"
           "Welcome to Random Products, LLC.\n"
           "This software is maintained by Riley Berry\n\n");

char* name = executive();  // Call the assembly function and get the name pointer

    printf("\n\nOh, %s. We hope you enjoyed your arrays. Do come again."
           "\nA zero will be returned to the operating system.\n"
           "=================================================================================================="
           "========================\n", name);

    return 0;
}

