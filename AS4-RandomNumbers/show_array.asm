; show_array.asm
;****************************************************************************************************************************
; - Legal Information -
;
; Copyright (C) 2025 Riley Berry.
;
; This file is part of the software program "Non-Deterministic Random Numbers".
; Random Products is free software: you can redistribute it and/or modify it under the terms of the GNU General Public
; License version 3 as published by the Free Software Foundation.
; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
; of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
; A copy of the GNU General Public License v3 is available at: https://www.gnu.org/licenses/
;****************************************************************************************************************************

;____________________________________________________________________________________________________________________________
; - Author Information -
;    Author name: Riley Berry
;    Author email: rberr7@csuf.fullerton.edu
;    CWID: 885405613
;    Class: 240-5 Section 3
;
; - Program Information -
;    Program name: Non-Deterministic Random Numbers
;    Programming languages: Assembly (x86-64), C
;    Date created: 3/20/25
;    Files in this program: main.c, executive.asm, sort.c, show_array.asm, isnan.asm, 
;                           normalize_array.asm, fill_random_array.asm
;
;    Purpose:
;    This program coordinates the generation of up to 100 random 64-bit 
;    floating-point numbers using rdrand. It checks for NaN values, normalizes 
;    the numbers to a specified range, sorts them, and displays the results.
;    The executive function orchestrates the flow between the various modules 
 ;   and manages the overall execution.
;____________________________________________________________________________________________________________________________

global show_array
extern printf

section .data
    header   db "IEEE754 Scientific Decimal", 10, 0
    fmt_line db "0x%016llX %e", 10, 0  ; Format: hex + scientific

section .text
; void show_array(double *array, int64_t size)
; rdi = pointer to array
; rsi = number of elements
show_array:
    push    rbp
    mov     rbp, rsp
    push    rbx
    push    r12

    ; Print header
    lea     rdi, [header]
    xor     eax, eax
    call    printf

    xor     rbx, rbx          ; index = 0
    mov     r12, rdi          ; r12 = pointer to array
    mov     r13, rsi          ; r13 = number of elements

.loop:
    cmp     rbx, r13
    jge     .done

    ; Load double from array
    movsd   xmm0, [r12 + rbx*8]     ; load double into xmm0
    movq    rax, xmm0               ; copy bit pattern to rax for hex print

    ; Set up printf args
    lea     rdi, [fmt_line]         ; format string
    mov     rsi, rax                ; hex version
    ; xmm0 already holds float version
    xor     eax, eax
    call    printf

    inc     rbx
    jmp     .loop

.done:
    pop     r12
    pop     rbx
    pop     rbp
    ret
