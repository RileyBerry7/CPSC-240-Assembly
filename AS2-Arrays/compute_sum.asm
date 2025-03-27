; compute_sum.asm
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
;    Author: Riley Berry
;    Email: rberr7@csuf.fullerton.edu
;    CWID: 885405613
;    Course: CPSC 240-5, Section 5
;
; - Program Information -
;    Program: Arrays
;    Languages: Assembly (x86-64), C
;    Date Created: 2/18/25
;    Related Files: input_array.asm, output_array.asm, manager.asm, main.c, isfloat.asm, compute_sum.asm, sort.c, swap.asm, r.sh
;
; - Purpose:
;    This program computes the mean of an array of floating-point numbers input by the user. 
;    This module, 'compute_sum.asm', is responsible for calculating the sum of the array elements.
;    The sum is calculated using a loop that iterates over the array of floating-point numbers.
;
; - Description:
;    This function receives two parameters: a pointer to an array of double-precision floating-point numbers, and the number of valid 
;    elements in the array. It iterates through the array and accumulates the sum of the elements using the 'addsd' instruction. 
;    The total sum is returned in xmm0.
;****************************************************************************************************************************

; Declarations
global compute_sum

section .data

section .bss
    align   64
    backup  resb 832  ; Reserve space for backing up CPU state during execution

section .text

compute_sum:
    ; Back up general-purpose registers (GPRs) for safe state restoration after the computation
    push    rbp
    mov     rbp, rsp
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
    pushf

    ;_________________________________________________________________________________________________________________________
    ; Perform State Component Backup
    mov     rax, 7
    mov     rdx, 0
    xsave   [backup]    ; Save the CPU state to restore later
    ;_________________________________________________________________________________________________________________________

    ; Back up incoming parameters (array pointer and count of valid numbers)
    mov     r14, rdi    ; r14 holds the array pointer
    mov     r15, rsi    ; r15 holds the count of valid numbers in the array

    ; Initialize loop counter to zero
    xor     r13, r13    ; r13 serves as the loop counter

begin_loop:
    ; Check if all array elements have been processed
    cmp     r13, r15
    jge     done         ; If loop counter reaches the array size, exit the loop

    ; Add the current element in the array to the total sum
    addsd   xmm8, [r14 + 8 * r13]   ; Add the value at [r14 + 8*r13] to xmm8 (sum)
    inc     r13                     ; Increment loop counter
    jmp     begin_loop               ; Jump back to the beginning of the loop

done:
    ; Before restoring the state, we save xmm8 to memory since xmm registers are not preserved across state restore
    sub     rsp, 8
    movsd   qword [rsp], xmm8

    ;_________________________________________________________________________________________________________________________
    ; Perform State Component Restore
    mov     rax, 7
    mov     rdx, 0
    xrstor  [backup]   ; Restore the saved CPU state
    ;_________________________________________________________________________________________________________________________

    ; Restore the value of xmm8 from memory
    movsd   xmm8, qword [rsp]
    add     rsp, 8      ; Adjust the stack pointer

    ; Move the sum to xmm0 (to return it as the function result)
    movsd   xmm0, xmm8

    ; Restore the general-purpose registers (GPRs) to their original values
    popf
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
    pop     rbp

    ret

