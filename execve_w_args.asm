section .data
    path db '/bin/echo',0
    arg1 db 'Hola',0
    arg2 db 'Mundo', 0

    argv dq path,arg1,arg2,0 ; argv array: ptrs + NULL terminator | Hay 4 elementos → 4 × 8 = 32 bytes

    ; pasamos envp = NULL con xor rdx, rdx

section .text
global _start

_start:

    mov rax,59
    lea rdi, [rel path]
    lea rsi,[rel argv]
    xor rdx,rdx
    syscall

    ; si execve falla -> exit(1)
    mov     rax, 60
    mov     rdi, 1
    syscall