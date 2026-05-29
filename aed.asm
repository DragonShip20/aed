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

section .data
;; Our buffer is currently 512b, will be expanded
buffer times 512 db 0
cursor dq 0

section .text
global _start

_start: 
    ;; TODO: set raw terminal mode here
    exit 0
