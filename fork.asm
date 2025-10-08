section .text
global _start
_start:

    mov rax, 57
    syscall

    cmp rax, 0  ; si rax == 0 → estamos en el hijo
    jmp hijo

    padre:
        mov rax, 60
        mov rdi, 0
        syscall

    hijo:
        mov rax, 60
        mov rdi, 0
        syscall
    
    
; El kernel le da al hijo una copia completa del contexto del padre en el momento del fork
