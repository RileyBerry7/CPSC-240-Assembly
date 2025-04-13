;****************************************************************************************************************************
; edison.asm — Manages user input/output for the "Electricity" program
;
; Copyright (C) 2025 Riley Berry
;
; This file is part of the software program "Electricity".
; Distributed under GNU GPL v3: https://www.gnu.org/licenses/
;****************************************************************************************************************************

;____________________________________________________________________________________________________________________________
; Author:       Riley Berry
; Email:        rberr7@csu.fullerton.edu
; CWID:         885405613
; Course:       CPSC 240-5 Section 3
;
; File Purpose:
;   - Collect user name and career
;   - Request and process resistance values for three sub-circuits
;   - Compute and display total resistance and circuit current based on EMF
;   - Display personalized acknowledgment
;
; Date:         04/05/25
;____________________________________________________________________________________________________________________________

;****************************************************************************************************
; External Symbols
;****************************************************************************************************
extern name
extern career
extern atof            ; Use the updated atof (see note at the end)
extern res1
extern res2
extern res3
extern compute_resist
extern display_current
extern ftoa
extern strlen

;****************************************************************************************************
; Data Section - Constant strings used in prompts and messages
;****************************************************************************************************
section .data
    msg_name                db 'Please enter your full name: ', 0
    len_msg_name            equ $ - msg_name

    msg_career              db 'Please enter the career path you are following: ', 0
    len_msg_career          equ $ - msg_career

    msg_appreciate_start    db 'Thank you. We appreciate all ', 0
    len_appreciate_start    equ $ - msg_appreciate_start

    msg_appreciate_end      db 's.', 0xA, 0xA, 0
    len_appreciate_end      equ $ - msg_appreciate_end

    msg_subcircuit_prompt   db "Your circuit has 3 sub-circuits.", 0xA, \
                              "Please enter the resistance in ohms on each of the three sub-circuits separated by ws.", 0xA, 0
    len_subcircuit_prompt   equ $ - msg_subcircuit_prompt

    msg_result_intro        db "Thank you.", 0xA, 0xA, 0
                            db "The total resistance of the full circuit is computed to be ", 0
    len_result_intro        equ $ - msg_result_intro

    msg_result_unit         db " ohms.", 0xA, 0xA, 0
    len_result_unit         equ $ - msg_result_unit

    msg_promptEMF           db "EMF is constant on every branch of any circuit.", 0xA, \
                              "Please enter the EMF (volts): ", 0
    len_msg_EMF             equ $ - msg_promptEMF

    msg_current_intro       db "Thank you.", 0xA, 0xA, \
                              "The current flowing in this circuit has been computed: ", 0
    len_current_intro       equ $ - msg_current_intro

    msg_current_units       db " amps", 0xA, 0xA, 0
    len_current_units       equ $ - msg_current_units

    msg_personal_thanks_prefix db "Thank you ", 0
    len_thanks_prefix       equ $ - msg_personal_thanks_prefix

    msg_personal_thanks_suffix db " for using the program Electricity.", 0xA, 0xA, 0
    len_thanks_suffix       equ $ - msg_personal_thanks_suffix

;****************************************************************************************************
; BSS Section - Buffers and uninitialized storage
;****************************************************************************************************
section .bss
    resist_input        resb 32
    EMFbuffer           resb 32
    total_res           resd 1
    EMF                 resd 1
    current             resd 1
    current_str_buf     resb 64

;****************************************************************************************************
; Text Section - Main function and utility routines
;****************************************************************************************************
section .text
global edison_main

;----------------------------------------------------------------------------------------------------
; edison_main — Core logic and flow of the Electricity program
;----------------------------------------------------------------------------------------------------
edison_main:

    ;-----------------------------------
    ; Prompt: Name
    ;-----------------------------------
    mov edx, len_msg_name
    mov ecx, msg_name
    call print

    mov edx, 32
    mov ecx, name
    call read_line          ; Read user name; read_line now appends a null terminator
    call strip_newline

    ;-----------------------------------
    ; Prompt: Career
    ;-----------------------------------
    mov edx, len_msg_career
    mov ecx, msg_career
    call print

    mov edx, 32
    mov ecx, career
    call read_line
    call strip_newline

    ;-----------------------------------
    ; Appreciation Message
    ;-----------------------------------
    mov edx, len_appreciate_start
    mov ecx, msg_appreciate_start
    call print

    mov edx, 32
    mov ecx, career
    call print

    mov edx, len_appreciate_end
    mov ecx, msg_appreciate_end
    call print

    ;-----------------------------------
    ; Resistance Input Instructions
    ;-----------------------------------
    mov edx, len_subcircuit_prompt
    mov ecx, msg_subcircuit_prompt
    call print

    ;--- Sub-circuit 1 ---
    call get_resistance
    fstp dword [res1]

    ;--- Sub-circuit 2 ---
    call get_resistance
    fstp dword [res2]

    ;--- Sub-circuit 3 ---
    call get_resistance
    fstp dword [res3]

    ;-----------------------------------
    ; Calculate Total Resistance
    ;-----------------------------------
    push dword [res3]
    push dword [res2]
    push dword [res1]
    call compute_resist
    add esp, 12
    fstp dword [total_res]

    ;-----------------------------------
    ; Output: Total Resistance
    ;-----------------------------------
    mov edx, len_result_intro
    mov ecx, msg_result_intro
    call print

    fld dword [total_res]
    mov edi, current_str_buf
    call ftoa

    mov edi, current_str_buf
    call strlen
    mov edx, eax
    mov ecx, current_str_buf
    call print

    mov edx, len_result_unit
    mov ecx, msg_result_unit
    call print

    ;-----------------------------------
    ; Prompt: EMF
    ;-----------------------------------
    mov edx, len_msg_EMF
    mov ecx, msg_promptEMF
    call print

    mov edx, 32
    mov ecx, EMFbuffer
    call read_line
    call strip_newline

    mov esi, EMFbuffer        ; Set pointer into ESI for atof
    call atof                 ; atof converts the string to float (in ST(0))
    fstp dword [EMF]

    ;-----------------------------------
    ; Calculate and Display Current
    ;-----------------------------------
    fld dword [EMF]
    fld dword [total_res]
    fdivp st1, st0
    fstp dword [current]

    mov edx, len_current_intro
    mov ecx, msg_current_intro
    call print

    fld dword [current]
    mov edi, current_str_buf
    call ftoa

    mov edi, current_str_buf
    call strlen
    mov edx, eax
    mov ecx, current_str_buf
    call print

    mov edx, len_current_units
    mov ecx, msg_current_units
    call print

    ;-----------------------------------
    ; Final Thanks with Name
    ;-----------------------------------
    mov edx, len_thanks_prefix
    mov ecx, msg_personal_thanks_prefix
    call print

    mov edx, 32
    mov ecx, name
    call print

    mov edx, len_thanks_suffix
    mov ecx, msg_personal_thanks_suffix
    call print

    ret

;****************************************************************************************************
; Helper Functions
;****************************************************************************************************

;----------------------------------------------------------------------------------------------------
; read_line — Reads one line of input from stdin into [ECX] with maximum length in EDX;
;            then appends a null terminator right after the data.
;----------------------------------------------------------------------------------------------------
read_line:
    mov ebx, 0         ; STDIN
    mov eax, 3         ; sys_read
    int 0x80
    mov byte [ecx + eax], 0   ; Append null terminator
    ret

;----------------------------------------------------------------------------------------------------
; print — Writes string from [ECX] of length EDX to stdout
;----------------------------------------------------------------------------------------------------
print:
    mov eax, 4
    mov ebx, 1         ; STDOUT
    int 0x80
    ret

;----------------------------------------------------------------------------------------------------
; get_resistance — Reads a float string and leaves its float value on the FPU stack.
;----------------------------------------------------------------------------------------------------
get_resistance:
    mov edx, 32
    mov ecx, resist_input
    call read_line           ; read_line now null-terminates the input
    call strip_newline       ; remove any newline character
    mov esi, resist_input    ; Pass pointer in ESI (required by atof)
    call atof                ; atof converts the ASCII string to a float (in ST(0))
    ret

;----------------------------------------------------------------------------------------------------
; strip_newline — Scans string at [ECX] and replaces the first newline (ASCII 10) with a null terminator.
;----------------------------------------------------------------------------------------------------
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

