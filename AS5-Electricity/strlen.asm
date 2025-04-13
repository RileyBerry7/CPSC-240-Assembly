;****************************************************************************************************************************
; strlen.asm — Calculates the length of a null-terminated ASCII string
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
;   - Computes the length of a null-terminated string
;   - Returns number of characters, excluding the null byte
;
; Input:
;   - EDI → pointer to start of string
;
; Output:
;   - EAX ← length of string (not including null terminator)
;
; Date:         04/05/25
;____________________________________________________________________________________________________________________________

section .text
global strlen

;----------------------------------------------------------------------------------------------------
; strlen — Returns the length of a null-terminated string
;----------------------------------------------------------------------------------------------------
strlen:
    push edi                ; Preserve EDI
    xor eax, eax            ; EAX will count the number of characters

.loop:
    cmp byte [edi], 0       ; Check for null terminator
    je  .done
    inc edi
    inc eax
    jmp .loop

.done:
    pop edi                 ; Restore EDI
    ret

