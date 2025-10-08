section .data
    uid dq 0
section .text
global _start

_start:

    mov rax,102
    syscall

    mov qword [uid], rax
    push qword [uid]

    mov rax,60
    mov rdi,0
    syscall
