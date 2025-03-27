; "output_array.asm"
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
;    Author name: Riley Berry
;    Author email: rberr7@csuf.fullerton.edu
;    CWID: 885405613
;    Class: 240-5 Section 5
;
; - Program information -
;    Program name: Arrays
;    Programming languages: Assembly (x86-64), C
;    Date created: 2/28/25
;    Files in this program: input_array.asm, output_array.asm, manager.asm, main.c, isfloat.asm, compute_sum.asm, sort.c, swap.asm, r.sh
;
;  Purpose:
;    This program calculates the mean of an array of floats. This array of floats is input by the user. 
;    This module (output_array.asm) is responsible for outputting the array of floating-point numbers in a formatted manner.
;    The numbers will be printed with exactly nine digits after the decimal point and separated by spaces.
;
; - Description -
;    This function receives an array of double-precision floating-point numbers and its size.
;    It iterates over the array and prints each number in a formatted way using printf from the C standard library.
;
;****************************************************************************************************************************

; Declarations
extern printf
global output_array

section .data
    number_in_array db "%f", 10, 0  ; Fixed format string for floating-point numbers

section .bss
    align   64
    backup  resb 832

section .text

output_array:
    ; Back up all the GPRs
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

    ;==== Perform State Component Backup ====
    mov     rax, 7
    mov     rdx, 0
    xsave   [backup]
    ;==== End State Component Backup ========

    ;Back up the incoming parameter
    mov     r14, rdi  ;r14 is the array
    mov     r15, rsi  ;r15 is the count of valid numbers in the array

    ;Block to create a loop
    xor     r13, r13   ;r13 is the loop counter

begin_loop:
    cmp     r13, r15
    jge     done

    mov     rax, 1
    mov     rdi, number_in_array
    mov     rsi, r13            ;Second paramter
    mov     r12, r13
    shl     r12, 3              ;<==Fast multiplication by 8
    add     r12, r14
    mov     rdx, r12            ;Third parameter
    movsd   xmm0, [r14+8*r13]   ;Fourth parameter
    mov     rcx, [r14+8*r13]    ;Fifth parameter
    call    printf
    inc     r13
    jmp     begin_loop

done:
    ;==== Perform State Component Restore ====
    mov     rax, 7
    mov     rdx, 0
    xrstor  [backup]
    ;==== End State Component Restore ========


    ;return 0 which is the traditional signal of success
    xor     rax, rax

    ; Restoring the original value to the GPRs
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
