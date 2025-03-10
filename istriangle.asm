; istriangle.asm
; This file checks if the first three values from the input array form a valid triangle
; using the triangle inequality theorem.

;extern float_array ; Declare float_array as extern

global istriangle

;=========================
; Function to check if inputs form a valid triangle
;=========================
istriangle:
    ; Assume the address of float_array is passed in rdi
    ; Access the three floats (assuming they are the first three elements in float_array)

    ; Load the first element (side 1) into xmm0
    movsd xmm0, [rdi]            ; float_array[0]
    
    ; Load the second element (side 2) into xmm1
    movsd xmm1, [rdi + 8]        ; float_array[1] (next 8 bytes after the first)
    
    ; Load the third element (side 3) into xmm2
    movsd xmm2, [rdi + 16]       ; float_array[2] (next 8 bytes after the second)

    ; Now you can compare these values to check if they form a valid triangle
    ; For example, let's check if the sum of any two sides is greater than the third

    ; Check if side 1 + side 2 > side 3
    addsd xmm0, xmm1             ; xmm0 = side1 + side2
    comisd xmm0, xmm2            ; Compare xmm0 (side1 + side2) with side3
    jae valid_triangle           ; If side1 + side2 > side3, continue

    ; If the check fails, return false (not a valid triangle)
    mov rax, 0                   ; Return 0 (false)
    ret

valid_triangle:
    ; Check if side 1 + side 3 > side 2
    addsd xmm0, xmm2             ; xmm0 = side1 + side3
    comisd xmm0, xmm1            ; Compare xmm0 (side1 + side3) with side2
    jae final_check              ; If side1 + side3 > side2, continue

    ; If the check fails, return false (not a valid triangle)
    mov rax, 0                   ; Return 0 (false)
    ret

final_check:
    ; Check if side 2 + side 3 > side 1
    addsd xmm0, xmm1             ; xmm0 = side2 + side3
    comisd xmm0, xmm0            ; Compare xmm0 (side2 + side3) with side1
    jae is_valid                 ; If side2 + side3 > side1, continue

    ; If the check fails, return false (not a valid triangle)
    mov rax, 0                   ; Return 0 (false)
    ret

is_valid:
    ; If all checks pass, return true (valid triangle)
    mov rax, 1                   ; Return 1 (true)
    ret
