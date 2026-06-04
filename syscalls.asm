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

%macro tcgets 1
    mov rax, 16
    mov rdi, 0
    mov rsi, TCGETS
    mov rdx, %1
    syscall
%endmacro

%macro tcsets 1
    mov rax, 16
    mov rdi, 0
    mov rsi, TCSETS
    mov rdx, %1
    syscall
%endmacro

TCGETS equ 0x5401
TCSETS equ 0x5402
