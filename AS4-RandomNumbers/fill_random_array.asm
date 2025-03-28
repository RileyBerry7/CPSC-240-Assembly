; fill_random_array.asm
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
;    floating-point numbers using RDRAND. It checks for NaN values, normalizes 
;    the numbers to a specified range, sorts them, and displays the results.
;    The executive function orchestrates the flow between the various modules 
;    and manages the overall execution.
;____________________________________________________________________________________________________________________________

extern isnan
extern random_numbers
extern num_count

global fill_random_array

section .text
fill_random_array:
    push    rbp
    mov     rbp, rsp
    push    rbx            ; Loop counter/index
    push    r8             ; Offset into random_numbers
    push    r9             ; Temporary storage for random value

    ; Save the requested count in rbx and store it into num_count.
    mov     rbx, rdi               ; rbx = count
    mov     dword [num_count], edi

    xor     r8, r8                 ; offset = 0

.fill_loop:
    cmp     rbx, 0                 ; If count is 0, we're done
    je      .done

.generate_random:
    ; Generate 64 random bits using RDRAND.
    rdrand  rax
    jnc     .generate_random       ; Retry if RDRAND fails

    ; Preserve the random value in r9.
    mov     r9, rax

    ; Move the value into XMM0 to test for NaN.
    movq    xmm0, r9
    call    isnan
    cmp     rax, 0
    jne     .generate_random       ; If isnan returns nonzero, generate a new value

    ; Store the raw random 64-bit value into the global array.
    mov     [random_numbers + r8], r9

    ; Advance the offset by 8 bytes (size of a double)
    add     r8, 8

    ; Decrement count and repeat the loop.
    dec     rbx
    jmp     .fill_loop

.done:
    pop     r9
    pop     r8
    pop     rbx
    pop     rbp
    ret
