;****************************************************************************************************************************
; faraday.asm — Entry point and startup messages for the "Electricity" program
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
;   - Displays welcome and program info
;   - Calls main input/output logic from edison.asm
;   - Handles final output and formatted exit message
;
; Date:         04/05/25
;____________________________________________________________________________________________________________________________

;****************************************************************************************************
; External Functions and Symbols
;****************************************************************************************************
extern edison_main
extern compute_resist
extern readLine
extern atof
extern ftoa
extern strlen

;****************************************************************************************************
; Global Symbols
;****************************************************************************************************
global _start
global display_current
global name
global career
global res1
global res2
global res3

;****************************************************************************************************
; BSS Section - Shared buffers and global floats
;****************************************************************************************************
section .bss
    name            resb 32
    career          resb 32
    res1            resd 1
    res2            resd 1
    res3            resd 1
    EMF             resd 1
    total_res       resd 1
    current         resd 1
    EMFbuffer       resb 32
    float_buffer    resb 32

;****************************************************************************************************
; Data Section - Program messages and formatting
;****************************************************************************************************
section .data
    msg_border:
        times 100 db '#'
        db 0xA, 0
    len_border equ $ - msg_border

    msg_welcome db 0xA, 'Welcome to Electricity brought to you by Riley Berry.', 0xA, 0
    len_welcome equ $ - msg_welcome

    msg_description db 'This program will compute the resistance and current flow in your direct circuit.', 0xA, 0xA, 0
    len_description equ $ - msg_description

    msg_intro db 'The driver received this number ', 0
    len_msg_intro equ $ - msg_intro

    msg_tail db ', and will keep it until next semester.', 0xA, \
                 'A zero will be returned to the Operating System', 0xA, 0xA, 0
    len_msg_tail equ $ - msg_tail

;****************************************************************************************************
; Text Section - Program Execution
;****************************************************************************************************
section .text

;----------------------------------------------------------------------------------------------------
; _start — Entry point of the program
;----------------------------------------------------------------------------------------------------
_start:

    ;-----------------------------------
    ; Display top border
    ;-----------------------------------
    mov edx, len_border
    mov ecx, msg_border
    mov ebx, 1
    mov eax, 4
    int 0x80

    ;-----------------------------------
    ; Display welcome message
    ;-----------------------------------
    mov edx, len_welcome
    mov ecx, msg_welcome
    mov ebx, 1
    mov eax, 4
    int 0x80

    ;-----------------------------------
    ; Display description
    ;-----------------------------------
    mov edx, len_description
    mov ecx, msg_description
    mov ebx, 1
    mov eax, 4
    int 0x80

    ;-----------------------------------
    ; Start core logic (edison.asm)
    ;-----------------------------------
    call edison_main

    ;-----------------------------------
    ; Final report message
    ;-----------------------------------
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_intro
    mov edx, len_msg_intro
    int 0x80

    ; Convert float at [current] to string and print
    fld dword [current]
    call ftoa
    mov ecx, eax
    mov edx, 32
    mov ebx, 1
    mov eax, 4
    int 0x80

    ; Print trailing comment message
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_tail
    mov edx, len_msg_tail
    int 0x80

    ;-----------------------------------
    ; Display bottom border
    ;-----------------------------------
    mov edx, len_border
    mov ecx, msg_border
    mov ebx, 1
    mov eax, 4
    int 0x80

    ;-----------------------------------
    ; Exit to OS
    ;-----------------------------------
    mov ebx, 0
    mov eax, 1
    int 0x80

;----------------------------------------------------------------------------------------------------
; Stub function: display_current — placeholder if needed externally
;----------------------------------------------------------------------------------------------------
display_current:
    ret
