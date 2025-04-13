;****************************************************************************************************************************
; scanf.asm — Simple scanf-like input routine
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
;   - Reads user input using Linux syscalls
;   - Replaces newline character (0xA) with a null terminator (0)
;
; Usage:
;   ECX → buffer address
;   EDX → maximum buffer size
;
; Output:
;   Buffer is filled with user input, newline replaced with 0
;
; Date:         04/05/25
;____________________________________________________________________________________________________________________________

section .text
global scanf

;----------------------------------------------------------------------------------------------------
; scanf — Read line from stdin and null-terminate
;----------------------------------------------------------------------------------------------------
scanf:
    ;-----------------------------------
    ; Perform syscall: read(0, ecx, edx)
    ;-----------------------------------
    mov eax, 3                  ; syscall number for sys_read
    mov ebx, 0                  ; file descriptor 0 (stdin)
    int 0x80                    ; read into [ecx], up to [edx] bytes

    ;-----------------------------------
    ; Strip newline character (0xA)
    ;-----------------------------------
    mov esi, ecx                ; ESI → start of buffer
    mov edi, eax                ; EDI = number of bytes read

.strip_loop:
    cmp byte [esi], 0x0A        ; check for newline
    je  .newline_found
    inc esi
    dec edi
    jnz .strip_loop
    jmp .done

.newline_found:
    mov byte [esi], 0           ; replace newline with null byte

.done:
    ret

