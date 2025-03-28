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
;    floating-point numbers using rdrand. It checks for NaN values, normalizes 
;    the numbers to a specified range, sorts them, and displays the results.
;    The executive function orchestrates the flow between the various modules 
 ;   and manages the overall execution.
;____________________________________________________________________________________________________________________________

extern isnan

section .bss
    random_numbers resq 100              ; Reserve space for 100 64-bit random numbers (array)
    num_generated resq 1                 ; Counter to track the number of generated random numbers

section .text
    global fill_random_array

fill_random_array:
    ; Arguments: rdi - number of random numbers to generate (num_count from the user input)
    ; Returns: None, modifies random_numbers

    ; Initialize counter (rax) to 0
    xor rax, rax                        ; Clear rax (this will be used as the index in the array)

generate_loop:
    ; Check if we've generated enough random numbers
    cmp rax, rdi                         ; Compare counter with user input (num_count)
    jge .done                             ; If counter >= num_count, we're done

    ; Generate a random number using rdrand (64-bit random)
    rdrand rbx                           ; rbx = random 64-bit number

    ; Check if the number is NaN using isnan.asm (calls the isnan function)
    ; Result will be 1 if the number is NaN, 0 if not
    call isnan
    cmp rax, 0                           ; If result of isnan is 0 (not NaN)
    je .store_number                     ; If not NaN, store the number

    ; If NaN, discard and generate another number
    jmp generate_loop

.store_number:
    ; Store the valid random number in the array (random_numbers + rax*8)
    mov [random_numbers + rax*8], rbx   ; Store rbx (random number) at the array index

    ; Increment the counter
    inc rax                              ; Increment the counter (rax)

    ; Repeat the loop
    jmp generate_loop

.done:
    ret
