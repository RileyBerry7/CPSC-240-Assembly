#!/bin/bash
# "r.sh"
#;****************************************************************************************************************************
# - Legal Information i
#
# Copyright (C) 2025 Riley Berry
#
# This file is part of the software program "Arrays".
# Triangle is free software: you can redistribute it and/or modify it under the terms of the GNU General Public
# License version 3 as published by the Free Software Foundation.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
# of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# A copy of the GNU General Public License v3 is available at: https://www.gnu.org/licenses/
#****************************************************************************************************************************

#****************************************************************************************************************************
# - Program Information -
#
#       Name: Harmonic Mean (Midterm)
#       Programming languages: Bash, Assembly (x86-64), C
#       Date created: 3/10/25
#       Files in this program: main.c, manager.asm, input_array.asm, output_array.asm, compute_sum.asm, isfloat.asm, etc.
#
#       Purpose:
#   		This script assembles the assembly source files, compiles the C source files, links them together,
#   and then executes the program.
#****************************************************************************************************************************

# Assemble the ASM files into object files
nasm -f elf64 manager.asm -o manager.o
nasm -f elf64 input_array.asm -o input_array.o
nasm -f elf64 output_array.asm -o output_array.o
nasm -f elf64 sum_of_reciprocals.asm -o sum_of_reciprocals.o
nasm -f elf64 isfloat.asm -o isfloat.o

# Compile the C files
gcc -z noexecstack -no-pie main.c isfloat.o input_array.o output_array.o sum_of_reciprocals.o manager.o -o harmonic_mean -lc

# Run the program
./harmonic_mean

