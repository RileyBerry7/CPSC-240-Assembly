; ftoa.asm
; Converts a float in ST(0) to a null-terminated ASCII string
; Input:
;   - ST(0) = float to convert
;   - EDI = pointer to output buffer (char*)
; Output:
;   - Writes ASCII string to [EDI]
;   - Result is null-terminated
; Requires:
;   - FPU loaded with value
;   - EDI pointing to a buffer (recommended: resb 64)

section .data
    ten dd 10.0

section .bss
    temp_int resd 1

section .text
    global ftoa

ftoa:
    push eax
    push ecx
    push edx
    push esi

    ; Separate float into integer and fractional parts
    fld st0                    ; duplicate float
    frndint                    ; round to integer
    fsub st1, st0              ; st1 = original - integer → fractional
    fxch                       ; put integer in st0
    fistp dword [temp_int]     ; store integer part
    mov eax, [temp_int]
    mov esi, edi               ; backup output pointer

    ; Convert integer part to ASCII (in reverse, then push)
    cmp eax, 0
    jne .convert_int
    mov byte [edi], '0'
    inc edi
    jmp .after_int

.convert_int:
    mov ecx, 0
.int_loop:
    xor edx, edx
    mov ebx, 10
    div ebx
    add dl, '0'
    push dx
    inc ecx
    test eax, eax
    jnz .int_loop

.pop_digits:
    pop dx
    mov [edi], dl
    inc edi
    loop .pop_digits

.after_int:
    ; Decimal point
    mov byte [edi], '.'
    inc edi

    ; Fractional part (up to 8 digits)
    fld st0                    ; load fractional
    mov ecx, 8                 ; digits to convert

.frac_loop:
    fld dword [ten]
    fmulp st1, st0             ; multiply fractional * 10
    fld st0
    frndint
    fistp dword [temp_int]
    mov eax, [temp_int]
    add al, '0'
    mov [edi], al
    inc edi
    fsub dword [temp_int]      ; subtract digit from frac
    loop .frac_loop

    ; Null terminator
    mov byte [edi], 0

    ; Clean FPU and restore
    fstp st0                   ; remove remaining fractional part
    pop esi
    pop edx
    pop ecx
    pop eax
    ret

