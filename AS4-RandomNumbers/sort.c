// sort.c
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
//______________________________________________________________________________________________


#include <stddef.h>  // Include the standard header for size_t and other definitions

extern void swap(double *a, double *b);

void sort(double *array, long size) {

    // Outer loop that runs through the array for sorting, starting from the first element
    for (long i = 0; i < size - 1; i++) {

        // Inner loop that performs the comparison and swap for adjacent elements
        for (long j = 0; j < size - 1 - i; j++) {

            // If the current element is greater than the next element, swap them
            if (array[j] > array[j + 1]) {

                swap(&array[j], &array[j + 1]);  // Swap the elements in memory
            }
        }
    }
}

