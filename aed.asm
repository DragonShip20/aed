%include "syscalls.inc"
%include "terminal.inc"

section .data
global buffer

;; Our buffer is currently 4096b, will be expanded
buffer times 4096 db 0
cursor dq 0
length dq 0
input db 0

;; Special keys
CTRL_Q equ 17
BACKSPACE1 equ 127
BACKSPACE2 equ 8

;; Special messages
exit_message db "Really exit? (y/n): "
exit_message_len equ $-exit_message

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
    print clear_screen, clear_screen_len
    print exit_message, exit_message_len
    mov r8, input
    getc r8
    call exit_check
    jmp .main_loop

.exit:
    print clear_screen, clear_screen_len
    exit 0

exit_check:
    cmp byte [r8], 'y'
    je _start.exit
    cmp byte [r8], 'n'
    je _start.main_loop
    ret

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

