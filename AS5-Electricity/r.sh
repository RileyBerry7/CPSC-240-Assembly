#!/bin/bash
# Assemble all .asm files using NASM for 32-bit ELF format
nasm -f elf32 -o electricity.o electricity.asm
nasm -f elf32 -o faraday.o faraday.asm
nasm -f elf32 -o edison.o edison.asm
nasm -f elf32 -o tesla.o tesla.asm
nasm -f elf32 -o keyboard.o Keyboard.asm
nasm -f elf32 -o atof.o atof.asm

# Link the object files into an executable named "electricity"
ld -m elf_i386 -o electricity electricity.o faraday.o edison.o tesla.o keyboard.o atof.o

# Run the executable
./electricity
