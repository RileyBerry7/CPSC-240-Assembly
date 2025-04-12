; Keyboard.asm
; Contains routines to handle keyboard input.

section .text
global readLine

; readLine: Reads from standard input.
; Expects:
;   - ECX: pointer to the buffer to store the input.
;   - EDX: maximum number of bytes to read.
; Returns:
;   - Input is stored in the provided buffer.
readLine:
    mov ebx, 0    ; File descriptor for stdin
    mov eax, 3    ; Syscall number for sys_read
    int 0x80
    ret

