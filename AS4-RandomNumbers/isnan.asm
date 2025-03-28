; isnan.asm
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
;                           normalize_array.asm, normalize_array.asm
;
;    Purpose:
;    This program coordinates the generation of up to 100 random 64-bit 
;    floating-point numbers using rdrand. It checks for NaN values, normalizes 
;    the numbers to a specified range, sorts them, and displays the results.
;    The executive function orchestrates the flow between the various modules 
 ;   and manages the overall execution.
;____________________________________________________________________________________________________________________________


section .text
    global isnan

isnan:
    ; Input: rbx = 64-bit floating point number to check
    ; Output: rax = 1 if NaN, 0 if not NaN

    ; Extract the exponent and the fraction part from the IEEE 754 representation
    ; We do this by masking the number to isolate the exponent and fraction

    ; Mask for exponent (bits 52-62) and fraction (bits 0-51)
    mov rdx, rbx                   ; Copy rbx to rdx
    shr rdx, 52                     ; Shift right by 52 to isolate exponent (11 bits)
    and rdx, 0x7FF                  ; Mask the exponent (to get the 11 bits of the exponent)

    ; Check if the exponent is all 1s (which means it’s an invalid number for normal floats)
    cmp rdx, 0x7FF                  ; Compare exponent with all 1s (0x7FF)
    jne .not_nan                    ; If exponent is not all 1s, it's not NaN

    ; Now, check if the fraction part is non-zero (indicating a NaN)
    mov rdx, rbx                    ; Copy rbx back to rdx
    and rdx, 0xFFFFFFFFFFFFF        ; Mask out the exponent (keep the fraction part)
    cmp rdx, 0                       ; Compare fraction with 0
    je .not_nan                      ; If fraction is 0, it’s infinity (not NaN)

    ; If exponent is all 1s and fraction is non-zero, it’s a NaN
    mov rax, 1                       ; Set rax to 1 to indicate NaN
    ret

.not_nan:
    mov rax, 0                       ; Set rax to 0 to indicate not NaN
    ret
