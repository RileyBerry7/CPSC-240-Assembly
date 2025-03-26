; sum_of_reciprocals.asm
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
;    Program: Harmonic Mean (Midterm)
;    Languages: Assembly (x86-64), C
;    Date Created: 3/10/25
;    Related Files: input_array.asm, output_array.asm, manager.asm, main.c, isfloat.asm, compute_sum.asm, sort.c, swap.asm, r.sh
;
; - Purpose:
;    This program computes the harmonic mean of an array of floating-point numbers input by the user.
;    This module, 'sum_of_reciprocals.asm', is responsible for calculating the sum of the reciprocals of nonzero elements.
;****************************************************************************************************************************

; Declarations
global sum_of_reciprocals

section .data
    one dq 1.0          ; Constant for computing reciprocal
    zero dq 0.0         ; Constant zero for comparison

section .bss
    align   64
    backup  resb 832    ; Reserve space for backing up CPU state during execution

section .text

sum_of_reciprocals:
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

    ; Perform State Component Backup
    mov     rax, 7
    mov     rdx, 0
    xsave   [backup]    ; Save CPU state

    ; Initialize loop counter and sum
    mov     r14, rdi    ; r14 holds the array pointer
    mov     r15, rsi    ; r15 holds the count of valid numbers
    xor     r13, r13    ; r13 is the loop counter
    pxor    xmm8, xmm8  ; Initialize sum in xmm8 to 0

begin_loop:
    cmp     r13, r15
    jge     done        ; If counter reaches array size, exit loop

    movsd   xmm0, [r14 + 8 * r13]  ; Load current array element
    ucomisd xmm0, qword [zero]     ; Compare with zero
    je      skip_zero              ; If element is zero, skip

    movsd   xmm1, qword [one]      ; Load 1.0
    divsd   xmm1, xmm0             ; Compute reciprocal (1 / element)
    addsd   xmm8, xmm1             ; Accumulate into sum

skip_zero:
    inc     r13
    jmp     begin_loop

done:
    sub     rsp, 8
    movsd   qword [rsp], xmm8      ; Save sum

    ; Restore CPU State
    mov     rax, 7
    mov     rdx, 0
    xrstor  [backup]

    movsd   xmm8, qword [rsp]      ; Restore sum
    add     rsp, 8
    movsd   xmm0, xmm8             ; Move sum to return register

    ; Restore registers
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
