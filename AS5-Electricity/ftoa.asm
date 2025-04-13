;****************************************************************************************************************************
; ftoa.asm — Converts a float in ST(0) to a null-terminated ASCII string in [EDI]
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
;   - Converts a floating-point number in ST(0) to an ASCII string
;   - Resulting string is written starting at [EDI], null-terminated
;   - Handles up to 8 decimal places of precision
;
; Date:         04/05/25
;____________________________________________________________________________________________________________________________

;****************************************************************************************************
; Data Section — Constants
;****************************************************************************************************
section .data
    ten dd 10.0

;****************************************************************************************************
; BSS Section — Temporary storage
;****************************************************************************************************
section .bss
    temp_int resd 1            ; Buffer for intermediate integer storage

;****************************************************************************************************
; Text Section — ftoa: float to ASCII string conversion
;****************************************************************************************************
section .text
    global ftoa

;----------------------------------------------------------------------------------------------------
; ftoa — Convert float in ST(0) to string at [EDI]
; Input:  ST(0) = float to convert
; Output: ASCII string at [EDI]
; Clobbers: EAX, ECX, EDX, ST(0-1), modifies [EDI]
;----------------------------------------------------------------------------------------------------
ftoa:
    push eax
    push ecx
    push edx
    push esi

    ;-----------------------------------
    ; Split float into integer and fractional parts
    ;-----------------------------------
    fld     st0                     ; Duplicate original float
    frndint                         ; Round to nearest integer
    fsub    st1, st0                ; ST(1) = original - int → fractional part
    fxch                            ; Exchange ST(0) and ST(1), int now in ST(0)
    fistp   dword [temp_int]        ; Store integer portion
    mov     eax, [temp_int]         ; Load int part into EAX
    mov     esi, edi                ; Preserve original output pointer

    ;-----------------------------------
    ; Convert integer part to ASCII (reversed, then pushed)
    ;-----------------------------------
    cmp     eax, 0
    jne     .convert_int
    mov     byte [edi], '0'
    inc     edi
    jmp     .after_int

.convert_int:
    mov     ecx, 0                  ; Digit counter
.int_loop:
    xor     edx, edx
    mov     ebx, 10
    div     ebx
    add     dl, '0'
    push    dx
    inc     ecx
    test    eax, eax
    jnz     .int_loop

.pop_digits:
    pop     dx
    mov     [edi], dl
    inc     edi
    loop    .pop_digits

.after_int:
    ;-----------------------------------
    ; Add decimal point
    ;-----------------------------------
    mov     byte [edi], '.'
    inc     edi

    ;-----------------------------------
    ; Process fractional part (up to 8 digits)
    ;-----------------------------------
    fld     st0                    ; Fractional part is still on stack
    mov     ecx, 8                 ; Limit to 8 decimal digits

.frac_loop:
    fld     dword [ten]
    fmulp   st1, st0               ; Multiply fraction by 10
    fld     st0
    frndint
    fistp   dword [temp_int]       ; Get next digit
    mov     eax, [temp_int]
    add     al, '0'
    mov     [edi], al
    inc     edi
    fsub    dword [temp_int]       ; Subtract digit value
    loop    .frac_loop

    ;-----------------------------------
    ; Null terminate the string
    ;-----------------------------------
    mov     byte [edi], 0

    ;-----------------------------------
    ; Clean up and return
    ;-----------------------------------
    fstp    st0                    ; Clear remaining ST(0)
    pop     esi
    pop     edx
    pop     ecx
    pop     eax
    ret
