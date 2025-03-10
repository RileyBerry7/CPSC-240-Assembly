# "r.sh"
#****************************************************************************************************************************
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
# - Script Information -
#
#       Script name: r.sh
#       Programming languages: Bash, Assembly (x86-64), C
#       Date created: 3/3/25
#       Files in this program: main.c, manager.asm, #
#
#       Purpose:
#   This script assembles the assembly source files, compiles the C source files, links them together,
#   and then executes the program.
#****************************************************************************************************************************

# Assemble the ASM files into object files
nasm -f elf64 manager.asm    -o manager.o
nasm -f elf64 istriangle.asm -o istriangle.o

# Compile the C++ files using g++ (since they involve C++ standard library)
g++ -c triangle.cpp -o triangle.o

# Link everything together using g++ (this ensures C++ standard libraries are included)
g++ -z noexecstack -no-pie triangle.o manager.o istriangle.o -o hurons_triangles -lc

# Run the program
./hurons_triangles

