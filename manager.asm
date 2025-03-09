; manager.asm
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
;   	Author: Riley Berry
;   	Email: rberr7@csuf.fullerton.edu
;   	Class: CPSC 240 - Section 5
;
; - Program Information -
;   	Program Name: Arrays Program
;   	Programming Languages: x86-64 Assembly, C
;   	Created: 2/22/25
;   	Files: main.c, manager.asm, input_array.asm, output_array.asm, compute_sum.asm, isfloat.asm, sort.c, swap.asm, etc.
;
; - Purpose -
;   The manager function orchestrates the execution flow of the program by:
;     1. Displaying program instructions to the user.
;     2. Gathering an array of floating-point numbers from user input.
;     3. Printing the collected numbers.
;     4. Computing and displaying the sum and mean of the array.
;     5. Sorting and displaying the sorted array.
;     6. Returning the computed sum to the main function.
;____________________________________________________________________________________________________________________________

global manager   ; Entry point for the program

section .data
    msg1 db "Please enter the lengths of three sides of a triangle:", 0xA, 0xA, 0
    msg2 db "Thank you.", 0xA, 0xA, 0
    msg3 db "These inputs have been tested and they are sides of a valid triangle.", 0xA, 0xA, 0
    msg4 db "The Huron formula will be applied to find the area.", 0xA, 0xA, 0
    msg5 db "The area is %l sq units. This number will be returned to the caller module", 0xA, 0xA, 0

    msg1_len equ $ - msg1
    msg2_len equ $ - msg2
    msg3_len equ $ - msg3
    msg4_len equ $ - msg4
    msg5_len equ $ - msg5

section .bss
    ; Reserve space for placeholder data
    area resq 1  ; Space for area (could be dynamically updated later)

section .text
manager:
    ; Print msg1 (Please enter the lengths of three sides)
    mov eax, 0x4          ; sys_write system call number
    mov ebx, 1            ; File descriptor (stdout)
    mov ecx, msg1         ; Pointer to msg1
    mov edx, msg1_len     ; Length of msg1
    int 0x80              ; Interrupt to invoke system call

    ; Print msg2 (Thank you)
    mov eax, 0x4
    mov ebx, 1
    mov ecx, msg2
    mov edx, msg2_len
    int 0x80

    ; Print msg3 (Inputs are valid)
    mov eax, 0x4
    mov ebx, 1
    mov ecx, msg3
    mov edx, msg3_len
    int 0x80

    ; Print msg4 (Huron formula will be applied)
    mov eax, 0x4
    mov ebx, 1
    mov ecx, msg4
    mov edx, msg4_len
    int 0x80

    ; Print msg5 (The area will be shown, with a placeholder for the area)
    mov eax, 0x4
    mov ebx, 1
    mov ecx, msg5
    mov edx, msg5_len
    int 0x80

    ; Return to the C++ caller
    ret                   ; Return control back to the calling C++ function



;section .data
;    initial_message       db "This program will manage an array of 64-bit floating-point numbers.", 10, 0
;    input_numbers_message db "Enter a sequence of 64-bit floats separated by spaces.", 10, \
;                             "Press Enter followed by Control+D to finish input.", 10, 0
;    show_numbers_message  db "Numbers received and stored in the array:", 10, 0
sec;    sum_numbers_message   db "The arithmetic sum of the array is: %lf", 10, 0
;    mean_numbers_message  db "The arithmetic mean of the array is: %lf", 10, 0
;    sorted_message        db "Array after sorting:", 10, 0
;    concluding_message    db "Thank you for using the Array Management System.", 10, 0
;
;    string_format db "%s", 0
;    float_format  db "%lf", 0
;
;section .bss
;    align   64
;    backup  resb 832
;    array   resq 8          ; Storage for up to 8 floating-point numbers
;
;section .text
;global manager
;extern printf
;extern input_array
;extern output_array
;extern compute_sum
;extern sort_array
;
;manager:
;    ;=========================
;    ; Register Backup
;    ;=========================
;    push    rbp
;    mov     rbp, rsp
;    pushfq
;    push    rbx
;    push    rcx
;    push    rdx
;    push    rsi
;    push    rdi
;    push    r8
;    push    r9
;    push    r10
;    push    r11
;    push    r12
;    push    r13
;    push    r14
;    push    r15
;
;    ;==== Save CPU State ====
;    mov         rax, 18
;    mov         rdx, 0
;    xsave       [backup]
;    ;=========================
;
;    ;=========================
;    ; Display Initial Messages
;    ;=========================
;    mov         rdi, string_format
;    mov         rsi, initial_message
;    call        printf
;
;    mov         rdi, string_format
;    mov         rsi, input_numbers_message
;    call        printf
;
;    ;=========================
;    ; Get User Input
;    ;=========================
;    mov         rdi, array       ; Pointer to array storage
;    mov         rsi, 8           ; Maximum number of elements
;    call        input_array
;    mov         r13, rax         ; Store actual number of elements entered
;
;    ; Display collected numbers
;    mov         rdi, string_format
;    mov         rsi, show_numbers_message
;    call        printf
;
;    mov         rdi, array
;    mov         rsi, r13
;    call        output_array
;
;    ;=========================
;    ; Compute Sum of Array
;    ;=========================
;    mov         rdi, array
;    mov         rsi, r13
;    call        compute_sum
;    movsd       xmm15, xmm0      ; Store sum in xmm15
;
;    ; Print sum
;    mov         rdi, sum_numbers_message
;    movsd       xmm0, xmm15
;    call        printf
;
;    ;=========================
;    ; Compute Mean of Array
;    ;=========================
;    test        r13, r13         ; Ensure r13 != 0 to avoid division by zero
;    jz          skip_mean
;
;    cvtsi2sd    xmm1, r13        ; Convert r13 (integer count) to float in xmm1
;    divsd       xmm15, xmm1      ; xmm15 = sum / count
;
;    ; Print mean
;    mov         rdi, mean_numbers_message
;    movsd       xmm0, xmm15
;    call        printf
;
;skip_mean:
;
;    ;=========================
;    ; Sort and Display Sorted Array
;    ;=========================
;    mov         rdi, array
;    mov         rsi, r13
;    call        sort_array
;
;    mov         rdi, string_format
;    mov         rsi, sorted_message
;    call        printf
;
;    mov         rdi, array
;    mov         rsi, r13
;    call        output_array
;
;    ;=========================
;    ; Display Conclusion Message
;    ;=========================
;    mov         rdi, string_format
;    mov         rsi, concluding_message
;    call        printf
;
;    ;=========================
;    ; Restore CPU State
;    ;=========================
;    mov         rax, 18
;    mov         rdx, 0
;    xrstor      [backup]
;
;    ;=========================
;    ; Return Sum to Main
;    ;=========================
;    movsd       xmm0, xmm15      ; Return sum
;    mov         rax, r13         ; Return number of elements (if needed)
;
;    ;=========================
;    ; Restore Registers & Exit
;    ;=========================
;    pop     r15
;    pop     r14
;    pop     r13
;    pop     r12
;    pop     r11
;    pop     r10
;    pop     r9
;    pop     r8
;    pop     rdi
;    pop     rsi
;    pop     rdx
;    pop     rcx
;    pop     rbx
;    popfq
;    pop     rbp
;    ret
;
;
