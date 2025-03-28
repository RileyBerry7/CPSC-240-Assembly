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
extern random_numbers
extern num_count

section .data
    header   db "IEEE754 Scientific Decimal", 10, 0
    ; Format: a 64-bit hexadecimal number with "0x" prefix and 16 digits,
    ; a space, then a double in scientific notation, and a newline.
    fmt_line db "%#016llx %e", 10, 0

section .text
show_array:
    push    rbp
    mov     rbp, rsp
    push    rbx        ; loop counter
    push    r12        ; offset into random_numbers

    ; Print header
    lea     rdi, [rel header]
    xor     eax, eax
    call    printf

    ; Load the element count from num_count (a 32-bit integer)
    mov     ecx, [num_count]

    ; Start offset at 0
    xor     r12, r12

.loop:
    cmp     ecx, 0
    je      .done

    ; Load the 64-bit value (bit pattern for the double) from random_numbers.
    mov     rax, [random_numbers + r12]

    ; Pass the 64-bit integer for the hex conversion.
    mov     rsi, rax

    ; Pass the same 64-bit bit pattern for the double conversion.
    mov     rdx, rax

    ; Call printf with our format line.
    lea     rdi, [rel fmt_line]
    xor     eax, eax
    call    printf

    ; Advance the offset (8 bytes per double)
    add     r12, 8
    dec     ecx
    jmp     .loop

.done:
    pop     r12
    pop     rbx
    pop     rbp
    ret

