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

global fill_random_array

section .text

; void fill_random_array(double *array, int64_t size)
; rdi = pointer to array
; rsi = number of elements
fill_random_array:
    push    rbp
    mov     rbp, rsp
    push    rbx

    mov     rbx, 0          ; index = 0
    cmp     rsi, 100
    jg      .limit_100      ; cap array size to 100
    mov     rdx, rsi        ; rdx = size
    jmp     .start
.limit_100:
    mov     rdx, 100

.start:
.loop:
    cmp     rbx, rdx        ; if index >= size, done
    jge     .done

.try_rdrand:
    rdrand  rax
    jnc     .try_rdrand     ; try again if carry not set

    ; move rax into xmm0
    movq    xmm0, rax

    ; optional NaN check — not strictly needed but keeping it if you want:
    ucomisd xmm0, xmm0
    jp      .try_rdrand     ; NaN? retry

    ; write to array[rdi + rbx * 8]
    movsd   [rdi + rbx*8], xmm0

    inc     rbx
    jmp     .loop

.done:
    pop     rbx
    pop     rbp
    ret

