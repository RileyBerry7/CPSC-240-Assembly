; atof.asm
; A simple routine for converting an ASCII string to a floating point number.
; Input: pointer to ASCII string in ESI.
; Output: floating point number in ST0.
section .text
global atof

atof:
    ; This minimal stub just returns 0.0.
    fldz
    ret
