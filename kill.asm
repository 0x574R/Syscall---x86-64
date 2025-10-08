section .data
    pid dq 96338      ; usa dq (8 bytes) para el PID
    act db 9          ; señal (9 -> SIGKILL)

section .text
global _start

_start:
    ; preparar syscall kill(pid, sig)
    mov     rax, 62                ; syscall: kill
    mov     rdi, qword [rel pid]   ; edi = pid
    movzx   rsi, byte  [rel act]   ; esi = sig (zero-extend desde byte)
    syscall

    mov     rax, 60
    xor     rdi, rdi
    syscall
