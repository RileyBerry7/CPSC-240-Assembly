; swap.asm
; **********************************************************************************************************************
; - Legal Information -
; Copyright (C) 2025 Riley Berry.
; This file is part of the software program "Arrays".
; Arrays Program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public
; License version 3 as published by the Free Software Foundation.
; **********************************************************************************************************************
; - Author Information -
; Author name: Riley Berry
; Author email: rberr7@csuf.fullerton.edu
; CWID: 885405613
; Class: 240-5 Section 5
;
; - Program information -
; Program name: Arrays Program
; Programming languages: Assembly (x86-64), C
; Date created: 2/18/25
;
; Purpose:
; This file (swap.asm) swaps two 64-bit floating point numbers in memory.
; It is used by other parts of the program to interchange values in the array while sorting.
; **********************************************************************************************************************

section .text  ; Start of the text section where the executable code resides

global swap  ; Make the swap function available for use in other files

; Function: swap
; --------------------
; This function swaps the values of two 64-bit floating-point numbers in memory.
;
; Parameters:
;   rdi: Address of the first double-precision floating point number
;   rsi: Address of the second double-precision floating point number
;
; Returns:
;   No return value; the two numbers at the addresses provided are swapped in-place.
swap:
    push    rbp            ; Save the base pointer to the stack for proper function call structure
    mov     rbp, rsp       ; Set up the stack frame

    ; Move the addresses of the two numbers to registers for easy access
    mov     rax, rdi       ; rax will hold the address of the first number
    mov     rdx, rsi       ; rdx will hold the address of the second number

    ; Load the 64-bit floating point numbers into xmm registers
    movq    xmm0, [rax]    ; xmm0 holds the value at the address pointed to by rax
    movq    xmm1, [rdx]    ; xmm1 holds the value at the address pointed to by rdx

    ; Swap the values in xmm0 and xmm1
    movq    [rax], xmm1    ; Store the value from xmm1 (second number) into the address of the first number
    movq    [rdx], xmm0    ; Store the value from xmm0 (first number) into the address of the second number

    pop     rbp            ; Restore the base pointer from the stack
    ret                    ; Return from the swap function

