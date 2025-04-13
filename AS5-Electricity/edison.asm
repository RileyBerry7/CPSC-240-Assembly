; edison.asm
; Handles the input of resistances for the sub-circuits and EMF input.

extern name
extern career
extern atof
extern res1
extern res2
extern res3
extern compute_resist
extern display_current
extern ftoa
extern strlen

section .data
    msg_name db 'Please enter your full name: ', 0
    len_msg_name equ $ - msg_name

    msg_career db 'Please enter the career path you are following: ', 0
    len_msg_career equ $ - msg_career

    msg_appreciate_start db 'Thank you. We appreciate all ', 0
    len_appreciate_start equ $ - msg_appreciate_start

    msg_appreciate_end db 's.', 0xA, 0xA, 0
    len_appreciate_end equ $ - msg_appreciate_end

    msg_subcircuit_prompt db "Your circuit has 3 sub-circuits.", 0xA
                          db "Please enter the resistance in ohms on each of the three sub-circuits separated by ws.", 0xA, 0
    len_subcircuit_prompt equ $ - msg_subcircuit_prompt

    msg_result_intro db "Thank you.", 0xA, \
                     "The total resistance of the full circuit is computed to be ", 0
    len_result_intro equ $ - msg_result_intro

    msg_result_unit db " ohms.", 0xA, 0xA, 0
    len_result_unit equ $ - msg_result_unit

    msg_promptEMF db "EMF is constant on every branch of any circuit.", 0xA, "Please enter the EMF (volts): ", 0
    len_msg_EMF equ $ - msg_promptEMF

    msg_current_intro db "Thank you.", 0xA, \
                   "The current flowing in this circuit has been computed: ", 0
    len_current_intro equ $ - msg_current_intro

    msg_current_units db " amps", 0xA, 0xA, 0
    len_current_units equ $ - msg_current_units

    msg_personal_thanks_prefix db "Thank you ", 0
    len_thanks_prefix equ $ - msg_personal_thanks_prefix

    msg_personal_thanks_suffix db " for using the program Electricity.", 0xA, 0
    len_thanks_suffix equ $ - msg_personal_thanks_suffix

section .bss
    resist_input     resb 32
    EMFbuffer        resb 32
    total_res        resd 1
    EMF              resd 1
    current          resd 1
    current_str_buf  resb 64

section .text
global edison_main

edison_main:
    ; Prompt for full name
    mov edx, len_msg_name
    mov ecx, msg_name
    mov ebx, 1
    mov eax, 4
    int 0x80

    ; Read full name
    mov edx, 64
    mov ecx, name
    mov ebx, 0
    mov eax, 3
    int 0x80

    ; Prompt for career path
    mov edx, len_msg_career
    mov ecx, msg_career
    mov ebx, 1
    mov eax, 4
    int 0x80

    ; Read career path
    mov edx, 64
    mov ecx, career
    mov ebx, 0
    mov eax, 3
    int 0x80

    ; Strip newline from career
    mov ecx, career
    mov edi, 0
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

    ; Appreciation message
    mov edx, len_appreciate_start
    mov ecx, msg_appreciate_start
    mov ebx, 1
    mov eax, 4
    int 0x80

    mov edx, 64
    mov ecx, career
    mov ebx, 1
    mov eax, 4
    int 0x80

    mov edx, len_appreciate_end
    mov ecx, msg_appreciate_end
    mov ebx, 1
    mov eax, 4
    int 0x80

    ; Prompt resistance input
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_subcircuit_prompt
    mov edx, len_subcircuit_prompt
    int 0x80

    ; Sub-circuit 1
    mov edx, 32
    mov ecx, resist_input
    mov ebx, 0
    mov eax, 3
    int 0x80
    mov esi, resist_input
    call atof
    fstp dword [res1]

    ; Sub-circuit 2
    mov edx, 32
    mov ecx, resist_input
    mov ebx, 0
    mov eax, 3
    int 0x80
    mov esi, resist_input
    call atof
    fstp dword [res2]

    ; Sub-circuit 3
    mov edx, 32
    mov ecx, resist_input
    mov ebx, 0
    mov eax, 3
    int 0x80
    mov esi, resist_input
    call atof
    fstp dword [res3]

    ; Compute total resistance
    push dword [res3]
    push dword [res2]
    push dword [res1]
    call compute_resist
    add esp, 12
    fstp dword [total_res]

    ; Print result intro
    mov edx, len_result_intro
    mov ecx, msg_result_intro
    mov ebx, 1
    mov eax, 4
    int 0x80

    ; Convert total_res to ASCII
    fld dword [total_res]
    mov edi, current_str_buf
    call ftoa

    ; Get length of converted string
    mov edi, current_str_buf
    call strlen
    mov edx, eax              ; result length in edx

    ; Print converted total resistance
    mov eax, 4
    mov ebx, 1
    mov ecx, current_str_buf
    int 0x80

    ; Print unit
    mov edx, len_result_unit
    mov ecx, msg_result_unit
    mov ebx, 1
    mov eax, 4
    int 0x80

    ; Prompt for EMF input
    mov edx, len_msg_EMF
    mov ecx, msg_promptEMF
    mov ebx, 1
    mov eax, 4
    int 0x80

    ; Read EMF input
    mov edx, 32
    mov ecx, EMFbuffer
    mov ebx, 0
    mov eax, 3
    int 0x80
    mov esi, EMFbuffer
    call atof
    fstp dword [EMF]

    ; Compute current = EMF / total_res
    fld dword [EMF]
    fld dword [total_res]
    fdivp st1, st0
    fstp dword [current]

    ; Print current intro
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_current_intro
    mov edx, len_current_intro
    int 0x80

    ; Convert current to string
    fld dword [current]
    mov edi, current_str_buf
    call ftoa

    ; Get string length
    mov edi, current_str_buf
    call strlen
    mov edx, eax

    ; Print converted current
    mov eax, 4
    mov ebx, 1
    mov ecx, current_str_buf
    int 0x80

    ; Print units
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_current_units
    mov edx, len_current_units
    int 0x80

    ; Final thank-you message
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_personal_thanks_prefix
    mov edx, len_thanks_prefix
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, name
    mov edx, 64
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_personal_thanks_suffix
    mov edx, len_thanks_suffix
    int 0x80

    ret

