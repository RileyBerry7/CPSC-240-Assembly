;****************************************************************************************************************************
; atof.asm — Converts a null-terminated ASCII string at [ESI] to a float in ST(0)
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
;   - Converts an ASCII float string (e.g., "3.14", "-2.5") into a real value on the x87 FPU stack.
;   - Input:  ESI → pointer to null-terminated ASCII string.
;   - Output: ST(0) ← corresponding float value.
;
; Clobbers: EAX, EBX, ECX, EDX, EDI
;
; Date:         04/05/25
;____________________________________________________________________________________________________________________________

section .text
global atof

atof:
    ;----------------------------------------------------
    ; Initialize accumulators and FPU.
    ;----------------------------------------------------
    xor eax, eax            ; Clear EAX: will accumulate integer part.
    xor ebx, ebx            ; Clear EBX: will accumulate fractional part.
    xor ecx, ecx            ; Clear ECX: count of digits in the fractional part.
    xor edx, edx            ; Clear EDX (temporary digit holder).
    fldz                    ; Load 0.0 into ST(0): this will hold our final value.
    mov edi, 0              ; Clear EDI: sign flag (0 for positive, 1 for negative).

    ;----------------------------------------------------
    ; Skip any leading whitespace (space or tab).
    ;----------------------------------------------------
.skip_whitespace:
    mov al, [esi]
    cmp al, ' '
    je .skip_next
    cmp al, 9               ; Tab character.
    je .skip_next
    jmp .check_sign
.skip_next:
    inc esi
    jmp .skip_whitespace

    ;----------------------------------------------------
    ; Check for optional sign.
    ;----------------------------------------------------
.check_sign:
    mov al, [esi]
    cmp al, '-'
    jne .check_plus
    mov edi, 1              ; Negative sign detected.
    inc esi
    jmp .parse_int
.check_plus:
    cmp al, '+'
    jne .parse_int
    inc esi

    ;----------------------------------------------------
    ; Parse the integer portion.
    ;----------------------------------------------------
.parse_int:
    xor eax, eax          ; Clear integer accumulator.
.int_loop:
    mov al, [esi]
    cmp al, '0'
    jb  .check_dot      ; If less than '0', no more digits.
    cmp al, '9'
    ja  .check_dot      ; If greater than '9', stop integer parsing.
    ; Convert ASCII digit to numerical digit.
    movzx edx, al       ; Move byte from memory to EDX.
    sub edx, '0'
    imul eax, eax, 10   ; Multiply accumulated integer by 10.
    add eax, edx        ; Add current digit.
    inc esi
    jmp .int_loop

    ;----------------------------------------------------
    ; Check if there's a decimal point.
    ;----------------------------------------------------
.check_dot:
    mov al, [esi]
    cmp al, '.'
    jne .build_float   ; No decimal; proceed to combine.
    inc esi            ; Skip the decimal point.
    jmp .parse_frac

    ;----------------------------------------------------
    ; Parse the fractional portion.
    ;----------------------------------------------------
.parse_frac:
    xor ebx, ebx       ; Clear fractional accumulator.
    xor ecx, ecx       ; Clear digit count.
.frac_loop:
    mov al, [esi]
    cmp al, '0'
    jb  .build_float  ; If character < '0', done.
    cmp al, '9'
    ja  .build_float  ; If character > '9', done.
    movzx edx, al     ; Convert ASCII to digit.
    sub edx, '0'
    imul ebx, ebx, 10 ; Multiply fractional accumulator by 10.
    add ebx, edx      ; Add current digit.
    inc ecx         ; Increment digit count in fractional part.
    inc esi
    jmp .frac_loop

    ;----------------------------------------------------
    ; Build the final float value.
    ;  Load integer part, then add fractional part.
    ;----------------------------------------------------
.build_float:
    ; Push integer part (EAX) on stack and load as integer into FPU.
    push eax
    fild dword [esp]    ; ST(0) ← integer part.
    add esp, 4

    ; If there is a fractional part, process it.
    test ecx, ecx
    jz .maybe_neg       ; No digits after the decimal; skip fraction processing.

    ; Push fractional accumulator (EBX) and load it.
    push ebx
    fild dword [esp]    ; ST(0) ← fractional numerator.
    add esp, 4

    ; Compute 10^n, where n = number of digits in fraction (stored in ECX).
    mov edx, ecx        ; Copy count to EDX.
    fld1                ; Load 1.0 into ST(0); this will be used to build 10^n.
.pow10:
    fmul dword [ten]    ; Multiply ST(0) by 10.0.
    dec edx
    jnz .pow10

    ; Divide the fractional number by 10^n.
    fdivp st1, st0      ; ST(0) ← (fraction numerator) / (10^n); ST(1) holds integer part.
    faddp st1, st0      ; Add the fraction to the integer part.
    
.maybe_neg:
    ; Apply negative sign if needed.
    cmp edi, 1
    jne .done
    fchs                ; Change sign of the float in ST(0).

.done:
    ret

;****************************************************************************************************
; Data Section — Constants
;****************************************************************************************************
section .data
ten: dd 10.0

