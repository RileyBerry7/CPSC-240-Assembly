; executive.asm
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
;    and manages the overall execution.
;____________________________________________________________________________________________________________________________

extern fill_random_array
extern sort
extern normalize_array
extern show_array
extern printf
extern fgets
extern stdin           ; Ensure that stdin is available from the C library
extern atoi
extern malloc          ; Import malloc to allocate memory dynamically

global executive
section .data
;=========================
; Data Section
;=========================
msg_name_prompt     db "Please enter your name: ", 0
msg_title_prompt    db "Please enter your title (Mr, Ms, Sargent, Chief, Project Leader, etc): ", 0
msg_greeting        db "Nice to meet you ", 0
msg_description     db "This program will generate 64-bit IEEE float numbers.", 10, 0
msg_limit_prompt    db "How many numbers do you want? Today's limit is 100 per customer. ", 0
msg_array_stored    db "Your numbers have been stored in an array. Here is that array:", 10, 10, 0
msg_normalized      db "The array will now be normalized to the range 1.0 to 2.0. Here is the normalized array:", 10, 10, 0
msg_sorted          db "The array will now be sorted. Here is the sorted array:", 0
msg_goodbye         db "Goodbye ", 0
msg_return_visit    db ". You are welcome any time.", 0
newline db 10, 0   ; newline (LF) and null terminator
newline2 db 10, 10, 0   ; two newlines (LF, LF) and a null terminator

section .bss
;=========================
; BSS Section            =
;=========================
name_input      resb 64   ; Reserve 64 bytes for name input
title_input     resb 64   ; Reserve 64 bytes for title input
quantity_input  resb 64   ; Reseves 64 bytes for # of float in the array
num_count       resd 1    ; Reserve 1 word (4 bytes) for storing number count
array_ptr       resq 1    ; Pointer for dynamically allocated array

section .text
executive:
    ;======================
    ; Register Backup     =
    ;======================
    push    rbp
    mov     rbp, rsp
    pushfq
    push    rbx
    push    rcx
    push    rdx
    push    rsi
    push    rdi

    ;=============
    ; Input Name =
    ;=============
    mov     rdi, msg_name_prompt       ; Load prompt message address into rdi
    call    printf                     ; Print the prompt message

    ; Read the name with fgets:
    ; Parameters: (char *buffer, int num, FILE *stream)
    mov     rdi, name_input            ; Buffer for input
    mov     rsi, 64                    ; Maximum number of bytes to read
    mov     rdx, qword [stdin]
    call    fgets

    ; Remove the trailing newline, if present
    mov     rdi, name_input
    call    remove_newline

    ;================
    ; Input Title   =
    ;================
    mov     rdi, msg_title_prompt      ; Load title input prompt into rdi
    call    printf                     ; Print the prompt for title

    mov     rdi, title_input           ; Buffer for input
    mov     rsi, 64                    ; Maximum number of bytes to read
    mov     rdx, qword [stdin]               ; Use the standard input stream
    call    fgets

    ; Remove the trailing newline, if present
    mov     rdi, title_input
    call    remove_newline

    ; Append a space at the end of title_input
    mov     rdi, title_input       ; Point to the beginning of title_input
.find_end:
    cmp     byte [rdi], 0          ; Look for the null terminator
    je      .append_space
    inc     rdi
    jmp     .find_end
.append_space:
    mov     byte [rdi], ' '        ; Replace the null terminator with a space
    inc     rdi
    mov     byte [rdi], 0          ; Append a new null terminator after the space

    ;=========================
    ; Greet User             =
    ;=========================
    mov     rdi, msg_greeting
    call    printf
    mov     rdi, title_input
    call    printf
    mov     rdi, name_input
    call    printf

    ; Prints two newlines
    mov     rdi, newline2
    call    printf
    
    ;=========================
    ; Input Array Quantity   =
    ;=========================
    mov     rdi, msg_description
    call    printf
    mov     rdi, msg_limit_prompt
    call    printf
    
    mov     rdi, quantity_input            ; Buffer for input
    mov     rsi, 64                    ; Maximum number of bytes to read
    mov     rdx, qword [stdin]
    call    fgets

    ; Remove the trailing newline, if present
    mov     rdi, quantity_input
    call    remove_newline

    mov     rdi, quantity_input   ; Pass the string to atoi
    call    atoi                  ; atoi returns the integer in rax
    mov     rdi, rax              ; Prepare rdi for fill_random_array

    mov     r15, rax              ; Save the number of elements for later
    
    ;============================
    ; Dynamically Allocate Array =
    ;============================
    mov     rsi, rax              ; Size (quantity of doubles)
    shl     rsi, 3                ; Multiply by 8 (size of double in bytes)
    call    malloc                ; Call malloc to allocate memory
    mov     [array_ptr], rax      ; Store the pointer to the array

    ;============================    
    ; Generate and Display Array
    ;===========================
    ; Generate the random numbers.
    mov     rdi, [array_ptr]      ; Pass the pointer to the array
    call fill_random_array

       ; Print message that array is stored.
    mov     rdi, msg_array_stored
    call    printf

     ; Pass the pointer to the dynamically allocated array (rdi)
    mov     rdi, [array_ptr]      ; rdi = array pointer
    mov     rsi, r15              ; rsi = number of elements (size of the array)

    ; Call show_array to display the array
    ;call    show_array

    ;============================    
    ; Normalize and Display Array
    ;===========================

    mov     rdi, msg_normalized
    call    printf

    ;============================    
    ; Sort and Display Array
    ;==========================

    mov     rdi, msg_sorted
    call    printf

 
    ;=========================
    ; Goodbye Message
    ;=========================

    ; Prints two newlines
    mov     rdi, newline2
    call    printf

    mov     rdi, msg_goodbye           ; Load goodbye message into rdi
    call    printf                     ; Print the goodbye message
    mov     rdi, title_input           ; Load title_input into rdi
    call    printf                     ; Print the title
    mov     rdi, name_input            ; Load name_input into rdi
    call    printf                     ; Print the name
    mov     rdi, msg_return_visit      ; Load return visit message into rdi
    call    printf                     ; Print the return visit message

    ;=========================
    ; Restore Registers & Exit
    ;=========================
    pop     rdi                        ; Restore rdi
    pop     rsi                        ; Restore rsi
    pop     rdx                        ; Restore rdx
    pop     rcx                        ; Restore rcx
    pop     rbx                        ; Restore rbx
    popfq                               ; Restore flags
    pop     rbp                        ; Restore rbp

    ; Return the address of name_input to main.c (via rax)
    mov     rax, name_input
    ret                                 ; Return to calling function (main.c)

;================================================================================
; remove_newline:
;   A helper routine to scan through the provided string (in rdi)
;   and replace the first newline (0x0A) encountered with a null terminator.
;================================================================================
remove_newline:
    push    rdi                        ; Save pointer in case needed
.remove_loop:
    cmp     byte [rdi], 0              ; Check for end of string
    je      .done
    cmp     byte [rdi], 0Ah            ; Check if current character is newline (LF)
    je      .replace
    inc     rdi
    jmp     .remove_loop
.replace:
    mov     byte [rdi], 0              ; Replace newline with null terminator
.done:
    pop     rdi                        ; Restore original pointer
    ret

