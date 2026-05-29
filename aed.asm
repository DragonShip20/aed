section .data
;; Our buffer is currently 512b, will be expanded
buffer times 512 db 0
cursor dq 0

section .text
global _start

_start: 
    ;; TODO: set raw terminal mode here
    mov rax, buffer
    add rax, [cursor]
    call getc
    
    inc qword [cursor]

    mov rax, buffer
    mov rbx, 10
    call print

    call exit

;; TODO: replace small functions (one syscall) with macros
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
