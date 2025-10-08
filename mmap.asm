section .text
global _start
_start:

    mov rax, 9        ; 1) __NR_mmap (número de syscall para mmap en x86-64)
    xor rdi, rdi      ; 2) rdi = addr = 0 (NULL) → pide al kernel que elija la dirección
    mov rsi, 4096     ; 3) rsi = length = 4096 bytes (1 página típica)
    mov rdx, 7        ; 4) rdx = prot = 7 => PROT_READ(1) | PROT_WRITE(2) | PROT_EXEC(4)
    mov r10, 34       ; 5) r10 = flags = 34 => MAP_PRIVATE(0x2) | MAP_ANONYMOUS(0x20)
    mov r8, -1        ; 6) r8 = fd = -1 (usado con MAP_ANONYMOUS; -1 indica "no file")
    mov r9, 0         ; 7) r9 = offset = 0 (desplazamiento en el fd; irrelevante con ANONYMOUS)
    syscall           ; 8) invoca al kernel: mmap(addr, length, prot, flags, fd, offset)

    ; al volver del syscall:
    ;  - si éxito: rax = dirección base del mapeo (puntero, >= PAGE_SIZE, típicamente no 0)
    ;  - si error: rax contiene un valor negativo (-errno). Habitualmente se comprueba
    ;    si (signed)rax < 0 para detectar error; errno = -rax.
    ; ejemplo: rax = -12 => error EFAULT (12)

    mov rax,60       
    xor rdi,rdi       
    syscall
