; strlen.asm
; Calculates the length of a null-terminated string
; Input:
;   EDI = pointer to the string
; Output:
;   EAX = length of the string (not including the null terminator)

section .text
    global strlen

strlen:
    push edi
    xor eax, eax            ; length counter = 0

.loop:
    cmp byte [edi], 0       ; check for null terminator
    je .done
    inc edi
    inc eax
    jmp .loop

.done:
    pop edi
    ret

