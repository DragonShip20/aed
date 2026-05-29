%macro exit 1
    mov rax, 60
    mov rdi, %1
    syscall
%endmacro

%macro print 2
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

%macro getc 1
    mov rax, 0
    mov rdi, 0
    mov rsi, %1
    mov rdx, 1
    syscall
%endmacro

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

section .text
global _start

_start: 
    call enable_raw_mode
    exit 0

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
