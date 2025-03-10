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

%include "triangle.inc"   ; Contains macros
extern printf
extern istriangle           ; Extern for istriangle function

global manager            ; Entry point for the program

section .data
    msg_prompt db "Please enter the lengths of three sides of a triangle:", 0xA, 0
    msg_invalid db "Invalid input, please try again.", 0xA, 0
    msg_thank_you db "Thank you.", 0xA, 0xA, 0
    msg_valid_triangle db "These inputs have been tested and they are sides of a valid triangle.", 0xA, 0
    msg_invalid_triangle db "These inputs have been tested and they are not sides of a valid triangle.", 0xA, 0
    msg_prompt_len equ $ - msg_prompt
    msg_invalid_len equ $ - msg_invalid
    msg_thank_you_len equ $ - msg_thank_you
    string_format db "%s", 0
    float_format db "%lf", 0

section .bss
    user_input resb 32    ; Reserve 32 bytes for user input
    float_array resq 100  ; Reserve space for 100 floats (adjustable)
    float_count resd 1    ; Counter for stored floats

section .text
manager:
    ;=========================
    ; Register Backup
    ;=========================
    push    rbp
    mov     rbp, rsp
    pushfq
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

    ;=========================
    ; Display Initial Messages
    ;=========================
    mov         rdi, string_format
    mov         rsi, msg_prompt
    call        printf

input_loop:
    ; Read user input
    mov rax, 0           ; sys_read
    mov rdi, 0           ; file descriptor 0 (stdin)
    mov rsi, user_input  ; Buffer to store input
    mov rdx, 32          ; Max input size
    syscall

    ; Preserve the number of bytes read in rbx (since rax is used later)
    mov rbx, rax         ; Save the number of bytes read in rbx

    ; Check for EOF (Ctrl+D sends 0 bytes)
    cmp rbx, 0           ; If sys_read returns 0, EOF was reached
    je end_input_loop    ; Exit loop if EOF

    ; Null-terminate the input string (safety precaution)
    mov byte [rsi + rbx], 0  ; Null-terminate the string

    ; Check if user has entered anything (rbx > 1 means some input was provided)
    cmp rbx, 1           ; If no input was entered (rbx == 0 or rbx == 1)
    jbe input_loop       ; Skip checking if no input

    ; Check if the input is a valid float
    mov rdi, user_input     ; Load address of user input
    call check_isfloat      ; Call the function that checks if the input is a valid float

    cmp rax, 0               ; If rax == 0, the input is invalid
    jl error_input         ; Jump to invalid_input if invalid

    ; Convert input string to float and store in array
    mov rax, [float_count]   ; Load current float count
    mov rbx, float_array     ; Get base address of array
    mov rsi, user_input      ; Load address of user input string
    call string_to_float     ; Convert string to float and return in xmm0
    movsd [rbx + rax * 8], xmm0 ; Store in array (64-bit)

    inc dword [float_count]  ; Increment count

    jmp input_loop           ; Loop again

error_input:
    ; Print error message
    mov rax, 1              ; sys_write
    mov rdi, 1              ; file descriptor 1 (stdout)
    mov rsi, msg_invalid    ; message to print
    mov rdx, msg_invalid_len
    syscall

    ; Clear the user_input buffer before next attempt (safety precaution)
    mov rdi, user_input     ; Ensure rdi points to user_input buffer
    xor rcx, rcx            ; Clear rcx
    mov rdx, 32             ; 32 bytes to clear
    rep stosb

    jmp input_loop          ; Restart loop

end_input_loop:
    ; Print thank you message
    mov rax, 1             ; sys_write
    mov rdi, 1             ; file descriptor 1 (stdout)
    mov rsi, msg_thank_you  ; message to print
    mov rdx, msg_thank_you_len
    syscall


;=========================
; Call istriangle to check if inputs form a valid triangle
;=========================
mov rdi, float_array    ; Pass float_array as argument to istriangle
call istriangle         ; Call istriangle function

;=========================
; Display appropriate message based on the result
;=========================
cmp rax, 1              ; Check if istriangle returned true (valid triangle)
jne invalid_triangle    ; Jump to invalid_triangle if not valid (rax != 1)

; If valid triangle
valid_triangle:
    mov rdi, string_format
    mov rsi, msg_valid_triangle
    call printf
    jmp restore_and_exit

invalid_triangle:
    ; If not a valid triangle
    mov rdi, string_format
    mov rsi, msg_invalid_triangle
    call printf

  restore_and_exit:
    ;=========================
    ; Restore Registers & Exit
    ;=========================
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
    popfq
    pop     rbp
    ret

;=========================
; Function to Convert String to Float
;=========================
string_to_float:
    ; Initialize registers
    xor rax, rax            ; Clear rax (will hold the final result)
    xor rbx, rbx            ; Clear rbx (will store the current character)
    xor rcx, rcx            ; Clear rcx (counter for position)
    xor rdx, rdx            ; Clear rdx (will hold the fractional part)
    mov r8, 1               ; Set r8 to 1 to handle whether we're before or after the decimal point

parse_loop:
    ; Load the current byte (character) from the string
    mov al, byte [rsi + rcx]
    test al, al             ; Check if it's the null terminator
    jz done_parsing         ; If null terminator, end parsing

    ; If the character is a digit
    cmp al, '0'
    jl skip_char
    cmp al, '9'
    jg skip_char

    sub al, '0'             ; Convert the character to a number (0-9)
    ; If we're before the decimal point (r8 == 1)
    test r8, r8
    jz after_decimal        ; If after decimal, we need to adjust the fractional part

    ; Before the decimal point: Build the integer part
    imul rax, rax, 10       ; Multiply result by 10 to shift left
    add rax, rbx            ; Add the current digit
    jmp next_char

after_decimal:
    ; After decimal point: Build the fractional part
    imul rdx, rdx, 10       ; Multiply fractional part by 10 to shift left
    add rdx, rbx            ; Add the current digit

next_char:
    inc rcx                  ; Move to the next character
    jmp parse_loop

skip_char:
    ; Check if we encountered a decimal point
    cmp al, '.'
    je decimal_point_found

    ; If we encounter something other than a digit or a decimal, skip it
    jmp next_char

decimal_point_found:
    ; Mark that we are after the decimal point
    xor r8, r8               ; Set r8 to 0 (after decimal point)

    jmp next_char

done_parsing:
    ; Convert the fractional part to the correct float
    ; rdx holds the fractional part
    ; rax holds the integer part

    ; Divide the fractional part by 10^n (adjusting for the decimal point)
    ; We'll use floating-point division for simplicity here

    ; Note: For simplicity, this function assumes that the fractional part
    ; has at most 6 digits. You can extend it as needed.
    movsd xmm0, rdx         ; Move the fractional part into xmm0
    cvtsi2sd xmm0, xmm0     ; Convert integer part (rax) to double and store in xmm0
    ret


;=========================
; Function to Check if Input is a Valid Float
;=========================
check_isfloat:
    ; We will use the string_to_float to validate the string
    mov rdi, rsi         ; Move the string address into rdi
    call string_to_float ; Call the string to float function
    test rax, rax        ; Check if the result is non-zero
    jz invalid_float     ; If zero, it's not a valid float
    mov rax, 1           ; Return 1 if valid
    ret

invalid_float:
    mov rax, 0           ; Return 0 if invalid
    ret

