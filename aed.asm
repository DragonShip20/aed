%include "syscalls.asm"

section .bss
termios resb 64

section .data
;; Our buffer is currently 512b, will be expanded
buffer times 4096 db 0
cursor dq 0
length dq 0
input db 0

;; Constants for setting terminal raw mode
ICANON equ 0000002h
ECHO   equ 0000010h
IXON equ 0002000h
ICRNL  equ 0000400h

;; ANSI escape codes
clear_screen db 27,"[2J",27,"[H"
clear_screen_len equ $ - clear_screen

;; Special keys
CTRL_Q equ 17
BACKSPACE1 equ 127
BACKSPACE2 equ 8

section .text
global _start

_start: 
    call enable_raw_mode
    call render

.main_loop:
    mov r8, input
    getc r8
    call handle_char
    mov al, [r8]
    cmp al, 0x20
    jb .loop_finish
    cmp al, 0x7E
    ja .loop_finish

    mov rbx, [cursor]
    mov [buffer + rbx], al

.loop_finish:
    inc qword [cursor]
    inc qword [length]
    call render
    jmp .main_loop
    
.main_loop_end:
    exit 0

handle_char:
    cmp byte [r8], CTRL_Q
    je _start.main_loop_end
    cmp byte [r8], BACKSPACE1
    je handle_backspace
    cmp byte [r8], BACKSPACE2
    je handle_backspace
    ret

handle_backspace:
    cmp qword [cursor], 0
    je .done
    dec qword [cursor]
    dec qword [length]
    mov rbx, [cursor]

.shift_loop:
    mov al, [buffer+rbx+1]
    mov [buffer+rbx], al
    inc rbx
    cmp rbx, [length]
    jbe .shift_loop

.done:
    call render
    jmp _start.main_loop

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
