; edison.asm
; Handles the input of resistances for the sub-circuits.

extern name
extern career

extern atof      ; Defined in atof.asm
extern res1      ; From electricity.asm
extern res2      ; From electricity.asm
extern res3      ; From electricity.asm

section .data
    msg_name      db 'Please enter your full name: ', 0
    len_msg_name    equ $ - msg_name

    msg_career    db 'Please enter the career path you are following: ', 0
    len_msg_career  equ $ - msg_career

    msg_appreciate_start db 'Thank you. We appreciate all ', 0
    len_appreciate_start equ $ - msg_appreciate_start

    msg_appreciate_end db 's.', 0xA, 0xA, 0
    len_appreciate_end equ $ - msg_appreciate_end

    msg_subcircuit_prompt db "Your circuit has 3 sub-circuits.", 0xA
                      db "Please enter the resistance in ohms on each of the three sub-circuits separated by ws.", 0xA, 0
    len_subcircuit_prompt equ $ - msg_subcircuit_prompt

    msg_resist db 'Please enter the resistance (ohms) for sub-circuit: ', 0
    len_msg_resist equ $ - msg_resist

section .bss
    resist_input resb 32

section .text
global edison_main

edison_main:

; Prompt for full name.
    mov edx, len_msg_name
    mov ecx, msg_name
    mov ebx, 1
    mov eax, 4
    int 0x80

    ; Read full name (into the externally defined 'name' buffer).
    mov edx, 64
    mov ecx, name
    mov ebx, 0
    mov eax, 3
    int 0x80

    ; Prompt for career path.
    mov edx, len_msg_career
    mov ecx, msg_career
    mov ebx, 1
    mov eax, 4
    int 0x80

    ; Read career path (into the externally defined 'career' buffer).
    mov edx, 64
    mov ecx, career
    mov ebx, 0
    mov eax, 3
    int 0x80

    ; Strip newline character
    mov ecx, career
    mov edi, 0
    jmp .strip_newline

.strip_newline:
    cmp byte [ecx + edi], 10
    je  .found_newline
    cmp byte [ecx + edi], 0
    je  .end_strip
    inc edi
    jmp .strip_newline

.found_newline:
    mov byte [ecx + edi], 0
.end_strip:


    ; Print first part of appreciation message.
    mov edx, len_appreciate_start
    mov ecx, msg_appreciate_start
    mov ebx, 1
    mov eax, 4
    int 0x80

    ; Print the career input (no formatting, just raw user input).
    mov edx, 64      ; you may reduce this if needed — currently always prints 64 chars
    mov ecx, career
    mov ebx, 1
    mov eax, 4
    int 0x80

    ; Print last part of appreciation message.
    mov edx, len_appreciate_end
    mov ecx, msg_appreciate_end
    mov ebx, 1
    mov eax, 4
    int 0x80

    ; Prompt for resistance input:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_subcircuit_prompt 
    mov edx, len_subcircuit_prompt 
    int 0x80

    ; --- Input for sub-circuit 1 ---
    mov edx, len_msg_resist
    mov ecx, msg_resist
    mov ebx, 1
    mov eax, 4
    int 0x80

    mov edx, 32
    mov ecx, resist_input
    mov ebx, 0
    mov eax, 3
    int 0x80

    mov esi, resist_input
    call atof
    fstp dword [res1]

    ; --- Input for sub-circuit 2 ---
    mov edx, len_msg_resist
    mov ecx, msg_resist
    mov ebx, 1
    mov eax, 4
    int 0x80

    mov edx, 32
    mov ecx, resist_input
    mov ebx, 0
    mov eax, 3
    int 0x80

    mov esi, resist_input
    call atof
    fstp dword [res2]

    ; --- Input for sub-circuit 3 ---
    mov edx, len_msg_resist
    mov ecx, msg_resist
    mov ebx, 1
    mov eax, 4
    int 0x80

    mov edx, 32
    mov ecx, resist_input
    mov ebx, 0
    mov eax, 3
    int 0x80

    mov esi, resist_input
    call atof
    fstp dword [res3]

    ret
