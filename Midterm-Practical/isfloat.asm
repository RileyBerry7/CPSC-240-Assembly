; isfloat.asm
; **********************************************************************************************************************
; - Legal Information -
; Copyright (C) 2025 Riley Berry.
; This file is part of the software program "Arrays".
; Arrays Program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public
; License version 3 as published by the Free Software Foundation.
; **********************************************************************************************************************
; - Author Information -
; Author name: Riley Berry
; Author email: rberr7@csuf.fullerton.edu
; CWID: 885405613
; Class: 240-5 Section 5
;
; - Program information -
; Program name: Harmonic Mean (Midterm)
; Programming languages: Assembly (x86-64)
; Date created: 3/10/25
;
; Purpose:
; This file (isfloat.asm) validates if a string represents a valid floating-point number.
; It checks if the string contains only digits, a decimal point, and optionally a minus sign at the beginning.
; **********************************************************************************************************************

global isfloat  ; Make the isfloat function available for use in other files

section .data  ; Section for data storage
msg_invalid_float db "Invalid float input", 0  ; Error message for invalid float input

section .text  ; Section for code

; Function: isfloat
; --------------------
; This function checks if the input string represents a valid floating-point number.
; It considers only digits, a single decimal point, and an optional minus sign.
;
; Parameters:
;   rdi: Address of the string to be checked
;
; Returns:
;   rax: 1 if the string is a valid float, 0 otherwise
isfloat:
        push rbx            ; Save the rbx register value on the stack
        push rdi            ; Save the rdi register (string address) on the stack

        ; Loop through each character to ensure it's a valid float
check_loop:
        mov al, byte [rdi]        ; Load the current character from the string
        cmp al, 0                 ; If null terminator, end of string
        je  check_done            ; Jump to done if null terminator (end of string) is found

        ; Check if the character is a digit or a valid part of the float (decimal point, minus sign)
        cmp al, '0'               ; Check if the character is a digit or less than '0'
        jb  invalid_char          ; Jump to invalid_char if it's less than '0' (invalid character)
        cmp al, '9'               ; Check if it's greater than '9'
        ja  check_decimal_point   ; Jump to check_decimal_point if it's greater than '9'
        jmp valid_char            ; If it's a valid digit, continue checking the next character

check_decimal_point:
        cmp al, '.'               ; Check if the character is a decimal point
        je  valid_char            ; If it's a decimal point, it's valid for floats
        jmp invalid_char          ; If it's neither a digit nor a decimal point, jump to invalid_char

valid_char:
        inc rdi                    ; Move to the next character in the string
        jmp check_loop             ; Continue checking the next character

invalid_char:
        mov rax, 0                 ; Not a valid float, set rax to 0
        pop rdi                    ; Restore the rdi register from the stack
        pop rbx                    ; Restore the rbx register from the stack
        ret                        ; Return from the function

check_done:
        ; Successfully passed all checks, the string is a valid float
        mov rax, 1                 ; Set rax to 1, indicating a valid float
        pop rdi                    ; Restore the rdi register from the stack
        pop rbx                    ; Restore the rbx register from the stack
        ret                        ; Return from the function

