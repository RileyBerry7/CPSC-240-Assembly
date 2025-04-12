; faraday.asm

; External symbols (imported from other object files)
extern edison_main
extern compute_resist
extern readLine
extern atof

; Global symbols (exported to other object files)
global faraday_main
global display_current

; Shared memory locations (defined here, accessed elsewhere)
global name
global career
global res1
global res2
global res3

section .bss
    name         resb 64
    career       resb 64
    res1         resd 1
    res2         resd 1
    res3         resd 1
    EMF          resd 1
    total_res    resd 1
    current      resd 1
    EMFbuffer    resb 32

section .data
    msg_welcome   db 'Welcome to Electricity brought to you by Riley Berry.', 0xA, 0
    len_welcome     equ $ - msg_welcome

    msg_description db 'This program will compute the resistance current flow in your direct circuit.', 0xA, 0xA, 0
    len_description equ $ - msg_description

    msg_name      db 'Please enter your full name: ', 0
    len_msg_name    equ $ - msg_name

    msg_career    db 'Please enter the career path you are following: ', 0
    len_msg_career  equ $ - msg_career

    msg_appreciate_start db 'Thank you. We appreciate all ', 0
    len_appreciate_start equ $ - msg_appreciate_start

    msg_appreciate_end db 's.', 0xA, 0xA, 0
    len_appreciate_end equ $ - msg_appreciate_end

    msg_subcircuit_prompt db "Your circuit has 3 sub-circuits.", 0xA, \
        "Please enter the resistance in ohms on each of the three sub-circuits separated by ws.", 0xA, 0
    len_subcircuit_prompt equ $ - msg_subcircuit_prompt

    msg_promptEMF    db 'Please enter the EMF (volts): ', 0
    len_msg_EMF      equ $ - msg_promptEMF

section .text
faraday_main:
    ; Display welcome message
    mov edx, len_welcome
    mov ecx, msg_welcome
    mov ebx, 1
    mov eax, 4
    int 0x80

    ; Display program description
    mov edx, len_description
    mov ecx, msg_description
    mov ebx, 1
    mov eax, 4
    int 0x80

    ; Call edison to input sub-circuit resistances
    call edison_main

    ; Call tesla to compute total resistance
    push dword [res3]
    push dword [res2]
    push dword [res1]
    call compute_resist
    add esp, 12
    fstp dword [total_res]

    ; Prompt for EMF input
    mov edx, len_msg_EMF
    mov ecx, msg_promptEMF
    mov ebx, 1
    mov eax, 4
    int 0x80

    ; Read EMF input into buffer
    mov edx, 32
    mov ecx, EMFbuffer
    mov ebx, 0
    mov eax, 3
    int 0x80

    ; Convert EMF ASCII to float
    mov esi, EMFbuffer
    call atof
    fstp dword [EMF]

    ; Compute current: current = EMF / total_res
    fld dword [EMF]
    fld dword [total_res]
    fdivp st1, st0
    fstp dword [current]

    ; Display the computed current
    call display_current

    ; Exit program
    mov ebx, 0
    mov eax, 1
    int 0x80

; Stub for display_current (should be implemented)
display_current:
    ret

