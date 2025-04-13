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

    ;...

    ; Exit program
    mov ebx, 0
    mov eax, 1
    int 0x80

; Stub for display_current (should be implemented)
display_current:
    ret

