; "triangles.asm"
;****************************************************************************************************************************
; - Legal Information -
;
; Copyright (C) 2025 Riley Berry.
;
; This file is part of the software program "Triangle".
; Triangle is free software: you can redistribute it and/or modify it under the terms of the GNU General Public
; License version 3 as published by the Free Software Foundation.
; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
; of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
; A copy of the GNU General Public License v3 is available at: https://www.gnu.org/licenses/
;****************************************************************************************************************************

;____________________________________________________________________________________________________________________________
; - Author Information -
;   	Author name: Riley Berry
;   	Author email: rberr7@csuf.fullerton.edu
;   	CWID: 885405613
;   	Class: 240-5 Section 5
;
; - Program information -
;   	Program name: Triangle
;   	Programming languages: Assembly (x86-64), C
;   	Date created: 2/5/25
;   	Files in this program: triangles.asm, geometry.c, rsh.sh
;
; 	Purpose:
;   This program calculates the third side of a triangle based on the user's input for the other two sides and 
;   the angle between them. Specifically it uses the law of cosines to find the unkown side length.
;
; - This file(triangles.asm) contains the assembly module
;___________________________________________________________________________________________________________________________________
; INITIALIZATION CODE BEGINS HERE

extern fgets
extern stdin
extern printf                                                ; External function for writing to standard output
extern scanf  
extern strlen
extern cos
global triangle                                               ; Makes the triangle function callable from other files

section .data                                                 ; Place initialized data here
    pi  dq 3.141592653589793                                  ; Define constant for pi (double precision)
    one_eighty dq 180.0                                       ; Define constant for 180 degrees (double precision)
    two dq 2.0                                                ; Define constant for 2 (double precision)

    ; User prompts and format strings
    prompt_1 db " Please enter your first name: ", 0  ;
    prompt_2 db " Please enter your last name : ", 0 ;
    prompt_3 db " Please enter the sides of your triangle: ", 0 ;
    prompt_4 db " Please enter the angle between these sides:", 0
    output_1 db "The calculated third side of your triangle is: %lf", 0         ; Output message format
    output_2 db "Please enjoy your triangle %s %s.", 0                          ; Outro message format
    input_format_1 db "%lf %lf", 0
    input_format_2 db "%lf", 0
section .bss                                                 ; Place uninitialized data here
    last_name   resb 40
    first_name  resb 40
    side_1      resq 1   ; Reserve space for the first side (double)
    side_2      resq 1   ; Reserve space for the second side (double)
    angle       resq 1   ; Reserve space for the angle (double)
    degree      resq 1
    cos_theta   resq 1
    third_side  resq 1  ; Reserve space for the computed third side

;_______________________________________________________________________________________________________________________
; EXECUTABLE CODE BEGINS HERE

section .text                                                 ; Place executable instructions here
	
    triangle:                                                     ; Entry point. Execution begins here

    ;-----------------------------------------------------------------------------------------------------------
    ; Backup all GPRs

    push       rbp                                              ; Save stack base pointer
    mov        rbp, rsp                                         ; Set up frame pointer for compatibility with C
    push       rbx                                              ; Backup rbx
    push       rcx                                              ; Backup rcx
    push       rdx                                              ; Backup rdx
    push       rsi                                              ; Backup rsi
    push       rdi                                              ; Backup rdi
    push       r8                                               ; Backup r8
    push       r9                                               ; Backup r9
    push       r10                                              ; Backup r10
    push       r11                                              ; Backup r11
    push       r12                                              ; Backup r12
    push       r13                                              ; Backup r13
    push       r14                                              ; Backup r14
    push       r15                                              ; Backup r15
    pushf
                                                       ; Backup rflags
;--------------------------------------------------------------------------------------
; INPUT 1 - First Name

    ; Prompt for first name
    mov rax, 0
    mov rdi, prompt_1
    call printf

    ; Get first name from user input
    mov rdi, first_name
    mov rsi, 40
    mov rdx, [stdin]
    call fgets

;----------------------------------------------------------------------------------------
; INPUT 2 - Last Name

    ; Prompt for last name
    mov rax, 0
    mov rdi, prompt_2
    call printf

    ; Get last name from user input
    mov rdi, last_name
    mov rsi, 40
    mov rdx, [stdin]
    call fgets

;--------------------------------------------------------------------------------------
; INPUT 3 - Triangle Sides

    ; Prompt for sides input
    mov rdi, prompt_3
    call printf

    ; Read two floating-point numbers (sides of the triangle)
    sub rsp, 16
    mov rdi, input_format_1
    mov rsi, side_1
    mov rdx, side_2
    call scanf
    movsd xmm14, [side_1]
    movsd xmm15, [side_2]
    add rsp, 16

;-------------------------------------------------------------------------------------
; INPUT 4 - Angle Between Sides
    
    ; Prompt for angle input
    mov rdi, prompt_4
    call printf

    ; Read angle (in degrees)
    sub rsp, 16
    mov rdi, input_format_2
    mov rsi, degree
    call scanf
    movsd xmm13, [degree]
    add rsp, 16

;--------------------------------------------------------------------------------------
; PROCESSING - Calculate Unknown Side Length

    ; Convert degree to radians
    movsd xmm13, [degree]
    mulsd xmm13, [pi]
    divsd xmm13, [one_eighty]
    movsd [degree], xmm13

    ; Compute cos(theta)
    movsd xmm0, [degree]
    call cos
    movsd [cos_theta], xmm0

    ; Compute 4ab*cos(theta)
    movsd xmm14, [two]
    mulsd xmm14, [side_1]
    mulsd xmm14, [side_2]
    mulsd xmm14, [cos_theta]

    ; Compute c^2 = a^2 + b^2 - 2ab*cos(theta)
    movsd xmm13, [side_1]
    movsd xmm12, [side_2]
    mulsd xmm13, [side_1]
    mulsd xmm12, [side_2]
    addsd xmm12, xmm13
    subsd xmm12, xmm14
    sqrtsd xmm12, xmm12

;--------------------------------------------------------------------------------------
; OUTPUT - Calulated Length and Outro Message

    ; Print the length of the third side
    mov rdi, output_1
    movsd xmm0, xmm12
    call printf

    ; Print the output_2 message
    mov rdi, output_2
    mov rsi, first_name
    mov rdx, last_name
    call printf

;--------------------------------------------------------------------------------------
; Empty Registers

    popf
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rbp
;--------------------------------------------------------------------------------------
; Return - the calculated length
    ret

section .note.GNU-stack noexec nowrite progbits
;______________________________________________________________________________________________
; PROGRAM ENDS HERE
