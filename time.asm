section .data
    time_t dq 0
section .text

global _start
_start:

    mov rax, 201
    lea rdi, [rel time_t]
    syscall

    push qword [time_t]

    mov rax, 60
    mov rdi, 0
    syscall