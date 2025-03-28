; globals.asm
global random_numbers
global num_count

section .bss
; Reserve space for 100 doubles (8 bytes each)
random_numbers: resq 100

; Reserve space for a 32-bit integer
num_count: resd 1

