%include "syscalls.inc"
%include "aed.inc"

section .bss
termios resb 64

section .data
global clear_screen
global clear_screen_len

;; Constants for setting terminal raw mode
ICANON equ 0000002h
ECHO   equ 0000010h
IXON equ 0002000h
ICRNL  equ 0000400h

;; ANSI escape codes
clear_screen db 27,"[2J",27,"[H"
clear_screen_len equ $ - clear_screen

section .text
global render
global enable_raw_mode

render:
    ;; TODO: optimise this, make this faster
    print clear_screen, clear_screen_len
    print buffer, 512
    ret

enable_raw_mode:
    tcgets termios

    ;; disable IXON + ICRNL
    mov eax, [termios + 0]
    and eax, ~(IXON | ICRNL)
    mov [termios + 0], eax

    ;; disable ICANON + ECHO
    mov eax, [termios + 12]
    and eax, ~(ICANON | ECHO)
    mov [termios + 12], eax

    tcsets termios
    ret
