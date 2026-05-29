section .data
output db "Hello world", 10
output_len equ $-output

section .text
global _start

_start:
    mov rax, output
    mov rbx, output_len
    call print

    call exit
	
exit:
    mov rax, 60
    xor rdi, rdi
    syscall

print:
    push rbx
    push rax
    mov rax, 1
    mov rdi, 1
    pop rsi
    pop rdx
    syscall
    ret
