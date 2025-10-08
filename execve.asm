section .data
    path    db '/bin/sh', 0
    argv    dq path, 0       ; argv[0] = "/bin/sh", argv[1] = NULL
    envp    dq 0             ; envp = { NULL }

section .text
global _start

_start:
    mov     rax, 59          ; execve
    lea     rdi, [rel path]  ; filename -> pointer to "/bin/sh"
    lea     rsi, [rel argv]  ; argv -> pointer to array { path, NULL }
    lea     rdx, [rel envp]  ; envp -> pointer to array { NULL }
    syscall

    ; si execve falla -> exit(1)
    mov     rax, 60
    mov     rdi, 1
    syscall
