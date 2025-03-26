;****************************************************************************************************************************
; - Legal Information -
;
; Copyright (C) 2025 Riley Berry.
;
; This file is part of the software program "Arrays".
; Arrays is free software: you can redistribute it and/or modify it under the terms of the GNU General Public
; License version 3 as published by the Free Software Foundation.
; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
; of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
; A copy of the GNU General Public License v3 is available at: https://www.gnu.org/licenses/
;****************************************************************************************************************************

;____________________________________________________________________________________________________________________________
; - Author Information -
;   	Author: Riley Berry
;   	Email: rberr7@csuf.fullerton.edu
;   	Class: CPSC 240 - Section 5
;
; - Program Information -
;   	Program Name: Midterm
;   	Programming Languages: x86-64 Assembly, C
;   	Created: 3/10/25
;   	Files: main.c, manager.asm, input_array.asm, output_array.asm, compute_sum.asm, isfloat.asm, sort.c, swap.asm, etc.
;
; - Purpose -
;   The manager function orchestrates the execution flow of the program by:
;     1. Displaying program instructions to the user.
;     2. Gathering an array of floating-point numbers from user input.
;     3. Printing the collected numbers.
;     4. Computing and displaying the sum and mean of the array.
;     5. Sorting and displaying the sorted array.
;     6. Returning the computed sum to the main function.
;____________________________________________________________________________________________________________________________

section .data
    initial_message       db "Welcome to Welcome to Harmonic Means.", 10, 0
    input_numbers_message db "Enter a sequence of 64-bit floats separated by spaces.", 10, \
                             "Press Enter followed by Control+D to finish input.", 10, 0
    show_numbers_message  db "Numbers received and stored in the array:", 10, 0
    reciprocal_message   db "The harmonic mean of the originally inputted numbers is: %lf", 10, 10, 0
    return_message        db "The harmonic mean will be returned to the caller function:", 10, 0
    concluding_message    db "Thank you for using the Array Management System.", 10, 0

    string_format db "%s", 0
    float_format  db "%lf", 0

section .bss
    align   64
    backup  resb 832
    array   resq 8          ; Storage for up to 8 floating-point numbers

section .text
global manager
extern printf
extern input_array
extern output_array
extern sum_of_reciprocals

manager:
    ;=========================
    ; Register Backup
    ;=========================
    push    rbp
    mov     rbp, rsp
    pushfq
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

    ;==== Save CPU State ====
    mov         rax, 18
    mov         rdx, 0
    xsave       [backup]
    ;=========================

    ;=========================
    ; Display Initial Messages
    ;=========================
    mov         rdi, string_format
    mov         rsi, initial_message
    call        printf

    mov         rdi, string_format
    mov         rsi, input_numbers_message
    call        printf

    ;=========================
    ; Get User Input
    ;=========================
    mov         rdi, array       ; Pointer to array storage
    mov         rsi, 8           ; Maximum number of elements
    call        input_array
    mov         r13, rax         ; Store actual number of elements entered

    ; Display collected numbers
    mov         rdi, string_format
    mov         rsi, show_numbers_message
    call        printf

    mov         rdi, array
    mov         rsi, r13
    call        output_array

    ;=========================
    ; Compute Sum of the Reciprocals of Array
    ;=========================
    mov         rdi, array
    mov         rsi, r13
    call        sum_of_reciprocals
    movsd       xmm15, xmm0      ; Store sum of reciprocals in xmm15

    ;=========================
    ; Compute Harmonic Mean
    ;=========================
    pxor        xmm14, xmm14     ; Clear xmm14
    cvtsi2sd    xmm14, r13       ; Convert r13 (number of elements) to double

    ; Divide number of elements by sum of reciprocals
    divsd       xmm14, xmm15     ; xmm14 = r13 / sum_of_reciprocals

    ;=========================
    ; Print Harmonic Mean
    ;=========================
    mov         rdi, reciprocal_message
    movsd       xmm0, xmm14
    call        printf

    ;=========================
    ; Display Return Message
    ;=========================
    mov         rdi, return_message
    call        printf

    ;=========================
    ; Restore CPU State
    ;=========================
    movsd       xmm0, xmm14      ; Return harmonic mean instead of sum
    mov         rax, r13         ; Return number of elements (if needed)

    ;=========================
    ; Return Harmonic Mean to Main
    ;=========================
    movsd       ;xmm0, xmm15      ; Return sum
    mov         rax, r13         ; Return number of elements (if needed)

      ;=========================
    ; Restore Registers & Exit
    ;=========================
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
    popfq
    pop     rbp
    ret
