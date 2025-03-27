/* sort_array.c */
/* **********************************************************************************************************************
 * - Legal Information -
 * Copyright (C) 2025 Riley Berry.
 * This file is part of the software program "Arrays".
 * Arrays Program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public
 * License version 3 as published by the Free Software Foundation.
 * **********************************************************************************************************************
 * - Author Information -
 * Author name: Riley Berry
 * Author email: rberr7@csuf.fullerton.edu
 * CWID: 885405613
 * Class: 240-5 Section 5
 *
 * - Program information -
 * Program name: Arrays Program
 * Programming languages: x86, C
 * Date created: 2/22/25
 *
 * Purpose:
 * This file (sort.c) implements a bubble sort algorithm to order an array of 64-bit floating point numbers in ascending order.
 * The algorithm works by repeatedly stepping through the list, comparing adjacent items and swapping them if they are in the 
 * wrong order. This continues until the array is sorted.
 * The swapping of elements is done using the swap function, which is declared externally and implemented in swap.asm.
 * **********************************************************************************************************************/

#include <stddef.h>  // Include the standard header for size_t and other definitions

// Externally declared swap function to exchange values at the memory addresses of two floating-point variables
extern void swap(double *a, double *b);

/* 
 * Function: sort_array
 * --------------------
 * This function sorts an array of double-precision floating point numbers in ascending order 
 * using the bubble sort algorithm. It operates in-place, modifying the input array.
 * 
 * Parameters:
 *   array: A pointer to the first element of the array of doubles.
 *   size: The number of elements in the array.
 *
 * Returns:
 *   This function does not return any value. The input array is sorted in-place.
 */
void sort_array(double *array, long size) {
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

