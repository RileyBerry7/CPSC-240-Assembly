; electricity.asm
; Main file for Electricity Assignment.
; Written in pure assembly using Linux syscalls for I/O

extern faraday_main      ; in faraday.asm

global _start

section .data
section .bss
section .text

_start:
    ; Call faraday for greeting and user input (name and career)
    call faraday_main

    ret

