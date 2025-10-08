section .data
    pid dq 0

section .text
    global _start

_start:
    ; syscall getpid()
    mov rax, 39
    syscall

    ; Guardar el PID en memoria
    mov qword [pid], rax
    
    ; Poner el valor del PID en la pila
    push qword [pid]    

    ; salir
    mov rax, 60
    xor rdi, rdi
    syscall
