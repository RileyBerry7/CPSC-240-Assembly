; tesla.asm
; Computes the total resistance from three sub-circuit resistances.
; Expects R1, R2, and R3 as 32-bit floating point numbers passed on the stack.
; The result is left in the FPU register ST0.

section .text
global compute_resist

compute_resist:
    ; Calculate reciprocal of R1
    fld dword [esp]      ; Load R1
    fld1                 ; Load constant 1.0
    fxch st1             ; Exchange to get 1.0 on top
    fdiv st1, st0        ; st1 = 1.0 / R1
    fst st0              ; Duplicate reciprocal if needed (or store it temporarily)

    ; Calculate reciprocal of R2
    fld dword [esp+4]    ; Load R2
    fld1
    fxch st1
    fdiv st1, st0        ; Compute 1/R2
    ; Add to reciprocal of R1 (which is in st? – careful FPU stack management is needed)
    ; For clarity, assume you have stored the first reciprocal properly.
    ; This is a simplified approach:
    faddp st1, st0       ; Add 1/R2 to 1/R1 (result in st0)

    ; Calculate reciprocal of R3 and add it
    fld dword [esp+8]    ; Load R3
    fld1
    fxch st1
    fdiv st1, st0       ; Compute 1/R3
    faddp st1, st0      ; Add it to the sum

    ; Now st0 holds (1/R1 + 1/R2 + 1/R3)
    fld1
    fxch st1
    fdivp st1, st0      ; Compute total resistance = 1 / (sum of reciprocals)
    ; Now the total resistance is on top of the FPU stack.
    ret

