; triangle.inc

; Declare message strings
section .data
author_info1 db "This program is brought to you as a courtesy of", 0xA, 0
author_info1_len equ $ - author_info1

author_info2 db "Author: Riley Berry,", 0xA, 0
author_info2_len equ $ - author_info2

author_info3 db "Cwid: 885405613", 0xA, 0
author_info3_len equ $ - author_info3

author_info4 db "Email: rberry7@csu.fullerton.edu", 0xA, 0
author_info4_len equ $ - author_info4

author_info5 db "", 0xA, 0  ; An empty line at the end for spacing
author_info5_len equ $ - author_info5

;***********************************************************************

%macro print_author_info 0
    ; Print program header with author information
    mov eax, 0x4                ; sys_write
    mov ebx, 1                  ; File descriptor (stdout)
    mov ecx, author_info1               ; Pointer to author_info1
    mov edx, author_info1_len           ; Length of author_info1
    int 0x80                    ; Invoke system call

    mov eax, 0x4                ; sys_write
    mov ebx, 1                  ; File descriptor (stdout)
    mov ecx, author_info2               ; Pointer to author_info2
    mov edx, author_info2_len           ; Length of author_info2
    int 0x80                    ; Invoke system call

    mov eax, 0x4                ; sys_write
    mov ebx, 1                  ; File descriptor (stdout)
    mov ecx, author_info3               ; Pointer to author_info3
    mov edx, author_info3_len           ; Length of author_info3
    int 0x80                    ; Invoke system call

    mov eax, 0x4                ; sys_write
    mov ebx, 1                  ; File descriptor (stdout)
    mov ecx, author_info4               ; Pointer to author_info4
    mov edx, author_info4_len           ; Length of author_info4
    int 0x80                    ; Invoke system call

    mov eax, 0x4                ; sys_write
    mov ebx, 1                  ; File descriptor (stdout)
    mov ecx, author_info5               ; Pointer to author_info5
    mov edx, author_info5_len           ; Length of author_info5
    int 0x80                    ; Invoke system call
%endmacro


