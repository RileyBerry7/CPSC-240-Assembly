; acdc.inc
; Common macros and definitions for the Electricity project.

%macro GET_RES 1
    ; Macro to prompt the user and get a sub-circuit resistance.
    ; Parameter 1: memory location to store the converted resistance.
    ; Display the prompt (you could use the msg_resist defined in edison.asm)
    ; and then call readLine and atof to convert input.
    push dword 32       ; Maximum bytes to read
    push dword %1       ; Address to store the result
    call readLine       ; Call your keyboard input routine
    ; Ideally, convert the string to float using atof
%endmacro

