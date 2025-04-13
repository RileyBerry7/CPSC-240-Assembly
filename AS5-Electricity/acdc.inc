; acdc.inc
;****************************************************************************************************************************
; - Legal Information -
;
; Copyright (C) 2025 Riley Berry.
;
; This file is part of the software program "Electricity".
; Electricity is free software: you can redistribute it and/or modify it under the terms of the GNU General Public
; License version 3 as published by the Free Software Foundation.
; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
; of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
; A copy of the GNU General Public License v3 is available at: https://www.gnu.org/licenses/
;****************************************************************************************************************************

;____________________________________________________________________________________________________________________________
; - Author Information -
;    Author name: Riley Berry
;    Author email: rberr7@csu.fullerton.edu
;    CWID: 885405613
;    Class: 240-5 Section 3
;
; - Program Information -
;    Program name: Electricity
;    Programming languages: Assembly (x86, 32-bit)
;    Date created: 4/05/25
;    Files in this program: faraday.asm, edison.asm, tesla.asm, atof.asm, ftoa.asm, acdc.inc, r.sh
;
;    Purpose:
;    This program models a basic electrical circuit with three sub-circuits. It prompts the user to input resistance values 
;    for each branch and calculates the total resistance using parallel resistance equations. It then accepts the EMF value 
;    for the circuit and computes the current using Ohm's Law. The final values are formatted and printed for the user.
;
;    The Edison module manages user input and output.
;    The Tesla module performs the resistance computation.
;    Additional helper modules (such as atof, ftoa, and acdc.inc) assist with parsing and formatting data.
;____________________________________________________________________________________________________________________________

section .text

; -----------------------------
; Get float resistance from stdin into ST(0)
; -----------------------------
global get_resistance
get_resistance:
    mov edx, 64                ; Read up to 64 bytes
    mov ecx, resist_input      ; Buffer for input
    call read_line             ; Use syscall to read
    call strip_newline         ; Remove newline
    mov esi, resist_input      ; Prepare buffer for atof
    call atof                  ; Convert to float → ST(0)
    ret

; -----------------------------
; Strip newline from string at ECX
; -----------------------------
global strip_newline
strip_newline:
    push edi
    xor edi, edi
.strip_loop:
    cmp byte [ecx + edi], 10
    je .found
    cmp byte [ecx + edi], 0
    je .done
    inc edi
    jmp .strip_loop
.found:
    mov byte [ecx + edi], 0
.done:
    pop edi
    ret

