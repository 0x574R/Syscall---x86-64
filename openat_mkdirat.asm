section .data
    path db 'test',0
    folder db 'new',0
section .text
global _start
_start:
    
    ; OPENAT
    mov rax, 257
    mov rdi, -100           ; AT_FDCWD - Current working directory
    lea  rsi, [rel path]
    mov rdx, 0x10000        ; O_DIRECTORY
    syscall

    ; FD in RAX register

    ; MKDIRAT
    mov rdi, rax
    mov rax, 258
    lea rsi, [rel folder]
    mov rdx, 0o777   ; Permiso 777
    syscall


    ; EXIT
    mov rax, 60
    xor rdi, rdi
    syscall