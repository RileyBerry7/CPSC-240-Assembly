# "r.sh"
#****************************************************************************************************************************
# - Legal Information -
#
# Copyright (C) 2025 Riley Berry
#
# This file is part of the software program "Arrays".
# Arrays is free software: you can redistribute it and/or modify it under the terms of the GNU General Public
# License version 3 as published by the Free Software Foundation.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
# of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# A copy of the GNU General Public License v3 is available at: https://www.gnu.org/licenses/
#****************************************************************************************************************************

#****************************************************************************************************************************
# - Script Information -
#
#       Script name: r.sh
#       Programming languages: Bash, Assembly (x86-64), C
#       Date created: 3/20/25
#       Files in this program: main.c, executive.asm, sort.c, show_array.asm
#
#       Purpose:
#   This script assembles the assembly source files, compiles the C source files, links them together,
#   and then executes the program.
#****************************************************************************************************************************

# Assemble the ASM files into object files
nasm -f elf64 executive.asm 	    -o executive.o
nasm -f elf64 fill_random_array.asm -o fill_random_array.o
nasm -f elf64 show_array.asm 	    -o show_array.o
nasm -f elf64 normalize_array.asm   -o normalize_array.o
nasm -f elf64 isnan.asm 	    -o isnan.o
nasm -f elf64 swap.asm 	  	    -o swap.o

# Compile the C files using gcc
gcc -c main.c -o main.o
gcc -c sort.c -o sort.o

# Link everything together using gcc
gcc -z noexecstack -no-pie main.o executive.o sort.o show_array.o fill_random_array.o normalize_array.o isnan.o swap.o -o random_numbers -lc

# Run the program
./random_numbers
