// "geometry.c"
//****************************************************************************************************************************
// - Legal Information -
//
// Copyright (C) 2025 Riley Berry.
//
// This file is part of the software program "Triangle".
// Triangle is free software: you can redistribute it and/or modify it under the terms of the GNU General Public
// License version 3 as published by the Free Software Foundation.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
// A copy of the GNU General Public License v3 is available at: https://www.gnu.org/licenses/
//****************************************************************************************************************************

//____________________________________________________________________________________________________________________________
// - Author Information -
//       Author name: Riley Berry
//       Author email: rberr7@csuf.fullerton.edu
//       CWID: 885405613
//       Class: 240-5 Section 5
//
// - Program Information -
//       Program name: Triangle
//       Programming languages: Assembly (x86-64), C
//       Date created: 2/5/25
//       Files in this program: triangles.asm, geometry.c, rsh.sh
//
//       Purpose:
//   This program calculates the third side of a triangle based on the user's input for the other two sides and
//   the angle between them. Specifically, it uses the law of cosines to find the unknown side length.
//
// - This file contains the C module that handles the Introductory output and assembly function call.
//____________________________________________________________________________________________________________________________
// LIBRARY DECLERATIONS & "triangles.asm" DECLERATION

#include <stdio.h>

// Declare the assembly function (implemented in triangle.asm)
extern double triangle(void);

//---------------------------------------------------------------------------------------------------------------------------------------
// EXECUTEABLE CODE BEGINS HERE

int main() {
    double calculatedSideLength; // stores the calulated length of uknown triangle side

    // Output - Introductory message
    printf("\nWelcome to the Triangle Program maintained by Riley Berry.\n");
    printf("If errors are discovered, please report them to Riley Berry at rberry7@csu.fullerton.edu for a quick fix.\n");
    printf("In CPSC-240, the customer comes first.\n\n");

    // Fucntion Call - assembly function to compute third side from "triangles.asm"
    calculatedSideLength = triangle();

    // Goodbye message
    printf("\nThe main function returned %.9f and plans to keep it until needed.\n", calculatedSideLength);
    printf("A 0 will be returned to the os.\n Bye.\n");
    printf("\n-------------------------------------------------------------------------------------------------------------------\n");
//-----------------------------------------------------------------------------------------------------------------------------------------
    return 0;
}

