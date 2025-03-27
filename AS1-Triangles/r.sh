#!/bin/bash
# "r.sh"
#****************************************************************************************************************************
# - Script Information -
#
#       Script name: r.sh
#       Programming languages: Bash, Assembly (x86-64), C
#       Date created: 2/5/25
#       Files in this program: triangles.asm, geometry.c, rsh.sh
#
#       Purpose:
#   This script assembles the assembly source file, compiles the C source file, links them together, and then executes the program.
#   It ensures that "triangle.asm" is correctly compiled into an object file and linked with "geometry.c" to produce an executable.
#
# - This file (rsh.sh) automates the build process for the Triangle program.
#****************************************************************************************************************************

#!/bin/bash

# Assemble triangle.asm into an object file
nasm -f elf64 triangle.asm -o triangle.o

# Compile geometry.c and link with triangle.o
gcc -no-pie geometry.c triangle.o -o triangle_program -lm

  # Run the program
./triangle_program
