#!/bin/bash

#****************************************************************************************************************************
# r.sh — Build and run script for the "Electricity" assembly program
#
# Copyright (C) 2025 Riley Berry
#
# This file is part of the software program "Electricity".
# Distributed under GNU GPL v3: https://www.gnu.org/licenses/
#****************************************************************************************************************************

#____________________________________________________________________________________________________________________________
# Author:       Riley Berry
# Email:        rberr7@csu.fullerton.edu
# CWID:         885405613
# Course:       CPSC 240-3 Section 3
#
# Script Purpose:
#   - Compiles each .asm source file into 32-bit ELF object files using NASM
#   - Links all object files into a single executable named "electricity"
#   - Executes the resulting program
#
# Date:         04/05/25
#____________________________________________________________________________________________________________________________

#****************************************************************************************************
# Assemble Source Files
#****************************************************************************************************

nasm -f elf32 -o faraday.o  faraday.asm
nasm -f elf32 -o edison.o   edison.asm
nasm -f elf32 -o tesla.o    tesla.asm
nasm -f elf32 -o atof.o     atof.asm
nasm -f elf32 -o ftoa.o     ftoa.asm
nasm -f elf32 -o strlen.o   strlen.asm
nasm -f elf32 -o scanf.o    scanf.asm

#****************************************************************************************************
# Link Object Files into Executable
#****************************************************************************************************

ld -m elf_i386 -o electricity \
    faraday.o edison.o tesla.o \
    ftoa.o atof.o strlen.o scanf.o

#****************************************************************************************************
# Run the Program
#****************************************************************************************************

./electricity
