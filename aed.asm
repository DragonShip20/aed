section .data
buffer times 512 db 0
cursor dq 0

section .text
global _start

_start: 
    mov rax, buffer
    add rax, [cursor]
    call getc
    
    inc qword [cursor]

    mov rax, buffer
    mov rbx, 10
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

getc:
    push rax
    mov rax, 0
    mov rdi, 0
    pop rsi
    mov rdx, 1
    syscall
    ret
