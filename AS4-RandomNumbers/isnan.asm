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

; isnan.asm
;-----------------------------------------------------------
; This routine checks if the double value in XMM0 is NaN.
; It uses the property that NaN is not equal to itself.
;
; Input: XMM0 contains the double value.
; Output: RAX = 1 if NaN, 0 otherwise.
;
; Author: Riley Berry
; Date: 3/20/25

global isnan

section .text
isnan:
    ; Compare the value with itself.
    ucomisd xmm0, xmm0
    ; If the comparison is unordered (i.e. value is NaN),
    ; the PF flag will be set. Use 'jp' to jump if parity.
    jp      .nan

    ; Otherwise, value is not NaN.
    mov     rax, 0
    ret

.nan:
    mov     rax, 1
    ret

