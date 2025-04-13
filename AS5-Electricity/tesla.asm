;****************************************************************************************************************************
; tesla.asm — Calculates total equivalent resistance for three resistors in parallel
;
; Computes total resistance for three parallel resistors using:
;       1 / Rt = 1/R1 + 1/R2 + 1/R3
; so that Rt = 1 / (1/R1 + 1/R2 + 1/R3)
;
; Inputs:
;   - [ESP]     = R1 (float)
;   - [ESP+4]   = R2 (float)
;   - [ESP+8]   = R3 (float)
;
; Output:
;   - ST(0) = total resistance Rt as a float
;
; Date: 04/05/25
;____________________________________________________________________________________________________________________________

section .text
global compute_resist

compute_resist:
    ;-------------------------------------------------
    ; Compute reciprocal of R1: 1/R1
    ;-------------------------------------------------
    fld     dword [esp]       ; ST(0) = R1
    fld1                    ; ST(0) = 1.0, ST(1) = R1
    fdiv                    ; ST(0) = 1.0 / R1  (i.e. 1/R1)
                             ; (fdiv here divides ST(0) by ST(1) and leaves 1/R1 on top)
    ;-------------------------------------------------
    ; Compute reciprocal of R2: 1/R2 and add to sum
    ;-------------------------------------------------
    fld     dword [esp+4]     ; ST(0) = R2, ST(1) = 1/R1
    fld1                    ; ST(0) = 1.0, ST(1) = R2, ST(2) = 1/R1
    fdiv                    ; ST(0) = 1.0 / R2  (i.e. 1/R2)
    faddp   st1, st0         ; ST(0) = (1/R1 + 1/R2)
                             ; (This pops the top element after adding)
    ;-------------------------------------------------
    ; Compute reciprocal of R3: 1/R3 and add to sum
    ;-------------------------------------------------
    fld     dword [esp+8]     ; ST(0) = R3, ST(1) = (1/R1 + 1/R2)
    fld1                    ; ST(0) = 1.0, ST(1) = R3, ST(2) = (1/R1+1/R2)
    fdiv                    ; ST(0) = 1.0 / R3  (i.e. 1/R3)
    faddp   st1, st0         ; ST(0) = (1/R1 + 1/R2 + 1/R3)
                             ; (Adds 1/R3 to the current sum and pops the stack)
    ;-------------------------------------------------
    ; Invert the sum to get the equivalent resistance
    ; Rt = 1 / (1/R1 + 1/R2 + 1/R3)
    ;-------------------------------------------------
    fld1                    ; ST(0) = 1.0, ST(1) = (1/R1+1/R2+1/R3)
    fdivp   st1, st0         ; ST(0) = 1.0 / (sum of reciprocals) = Rt
    ret

