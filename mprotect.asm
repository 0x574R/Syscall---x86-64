
%define  PAGE_LENGTH   4096
section .data
    val db 0x41
section .text
global _start
_start:

    ; MMAP
    mov rax, 9
    xor rdi, rdi
    mov rsi, PAGE_LENGTH
    mov rdx, 1                  ; PROT_READ(1)
    mov r10, 34
    mov r8, -1
    xor r9, r9
    syscall

    ; Store address
    mov r10, rax

    ; MMAP
    mov rax,10
    mov rdi, r10
    mov rsi, PAGE_LENGTH
    mov rdx, 7              ; PROT_READ(1) | PROT_WRITE(2) | PROT_EXEC(4)
    syscall

    ; Write a byte
    mov rbx, [val]     
    mov [r10], rbx      

    ; EXIT
    mov rax, 60
    xor rdi, rdi
    syscall