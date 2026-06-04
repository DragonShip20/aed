%include "syscalls.asm"

section .bss
termios resb 64

section .data
;; Our buffer is currently 512b, will be expanded
buffer times 512 db 0
cursor dq 0

;; Constants for setting terminal raw mode
TCGETS equ 0x5401
TCSETS equ 0x5402
ICANON equ 0000002h
ECHO   equ 0000010h

;; ANSI escape codes
clear_screen db 27,"[2J",27,"[H"
clear_screen_len equ $ - clear_screen

section .text
global _start

_start: 
    call enable_raw_mode
    call render
.main_loop:
    mov rbx, [cursor]
    lea r8, [buffer+rbx]
    getc r8
    inc qword [cursor]
    cmp byte [r8], 'q'
    je .main_loop_end
    call render
    jmp .main_loop
    
.main_loop_end:
    exit 0

render:
    ;; TODO: optimise this, make this faster
    print clear_screen, clear_screen_len
    print buffer, 512
    ret

enable_raw_mode:
    ;; ioctl(TCGETS)
    mov rax, 16
    mov rdi, 0
    mov rsi, TCGETS
    mov rdx, termios
    syscall

    ;; disable ICANON + ECHO
    mov eax, [termios + 12]
    and eax, ~(ICANON | ECHO)
    mov [termios + 12], eax

    ;; ioctl(TCSETS)
    mov rax, 16
    mov rdi, 0
    mov rsi, TCSETS
    mov rdx, termios
    syscall

    ret
