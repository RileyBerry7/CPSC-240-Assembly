; input_array.asm
;****************************************************************************************************************************
; - Legal Information -
;    Copyright (C) 2025 Riley Berry
;
;    This file is part of the software program "Arrays".
;    Triangle is free software: you can redistribute it and/or modify it under the terms of the GNU General Public
;    License version 3 as published by the Free Software Foundation.
;    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
;    of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
;    A copy of the GNU General Public License v3 is available at: https://www.gnu.org/licenses/
;****************************************************************************************************************************

;____________________________________________________________________________________________________________________________
; - Author Information -
;    Author: Riley Berry
;    Email: rberr7@csuf.fullerton.edu
;    CWID: 885405613
;    Course: CPSC 240-5, Section 5
;
; - Program Information -
;    Program: Harmonic Mean (Midterm)
;    Languages: Assembly (x86-64), C
;    Date Created: 3/10/25
;    Related Files: sort_array.c, main.c, input_array.asm, output_array.asm, swap.asm, compute_sum.asm, rsh.sh
;
; - Purpose: 
;    This program calculates the mean of an array of floating-point numbers input by the user. 
;    Apart from managing modules in C, the program utilizes arrays in x86 assembly for computation. 
;    The aim is to provide a hands-on experience with arrays and assembly programming.
;
; - Module Overview:
;    The 'input_array.asm' module handles the collection of user inputs for an array of floating-point numbers. 
;    It validates the inputs and stores valid floating-point numbers into an array. The input process ends when the user presses Ctrl+D.
;_____________________________________________________________________________________________________________________________

; Initializing necessary components, including external function declarations and memory space.
extern scanf
extern isfloat
global input_array

section .data
    floatform db "%lf", 0  ; Format specifier for reading floating-point numbers

; Allocating space for state backup and restore during the input process.
section .bss
    align 64
    backup resb 832  ; Reserve 832 bytes for saving the CPU state

section .text

input_array:
    ; Back up general-purpose registers (GPRs) for later restoration
    push    rbp
    mov     rbp, rsp
    push    rbx
    push    rcx
    push    rdx
    push    rsi
    push    rdi
    push    r8
    push    r9
    push    r10
    push    r11
    push    r12
    push    r13
    push    r14
    push    r15
    pushf

    ; Save the state of floating-point registers for later restoration
    mov     rax, 7
    mov     rdx, 1
    xsave   [backup]

    ; Initialize variables for array handling
    push qword  0  ; Placeholder for further use

    mov     r14, rdi    ; r14 points to the array
    mov     r15, rsi    ; r15 holds the upper limit of the array size
    xor     r13, r13    ; r13 serves as the counter for user input
    jmp     input_number  ; Start the loop for input collection

; Loop to repeatedly ask the user for floating-point numbers until input is finished (Ctrl-D)
input_number:
    ; Check if the array has reached its upper limit
    cmp     r13, r15
    jge     input_finished  ; Exit the loop if array is full

    ; Prompt the user to input a floating-point number
    mov     rax, 0
    mov     rdi, floatform
    push qword  0
    mov     rsi, rsp
    call    scanf           ; Read user input: either a valid float or Ctrl-D

    ; Check if the user has pressed Ctrl-D (end of input)
    cdqe
    cmp     rax, -1
    pop     r8
    je      input_finished  ; End input collection if Ctrl-D is pressed

    pop     rax

    ; Store the valid floating-point number into the array
    mov     [r14 + r13*8], r8
    inc     r13
    push    rax
    jmp     input_number  ; Continue requesting more input

; End of input collection; restore the previous state
input_finished:
    ; Restore the floating-point registers and other CPU states
    mov     rax, 7
    mov     rdx, 0
    xrstor  [backup]

    ; The number of elements input by the user is stored in r13
    pop     rax
    mov     rax, r13       ; Return the count of valid numbers in rax

    ; Restore the state of the GPRs
    popf
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     r11
    pop     r10
    pop     r9
    pop     r8
    pop     rdi
    pop     rsi
    pop     rdx
    pop     rcx
    pop     rbx
    pop     rbp

    ret

