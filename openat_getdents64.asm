; x86-64 Linux (NASM) - acumula todas las linux_dirent64 sin repetir

%define BUFSZ (1<<20)      ; (1<<20) es un desplazamiento a la izquierda: 1 * 2^20 = 1.048.576 bytes → 1 MiB.
                           ;  MiB ≈ MB + 4.86%.
section .data               
    path db 'test',0        

section .bss                
    buf  resb BUFSZ         ; Reserva BUFSZ bytes para acumular todas las entradas

section .text               
global _start               
_start:                     

    ; openat(AT_FDCWD, path, O_DIRECTORY, 0)
    mov rax, 257            ; Nº syscall: openat
    mov rdi, -100           ; 1er arg: AT_FDCWD (directorio actual como base)
    lea rsi, [rel path]     ; 2º arg: puntero a "test"
    mov rdx, 0x10000        ; 3er arg: flags = O_DIRECTORY
    xor r10d, r10d          ; 4º arg: mode = 0 (no se usa si no hay O_CREAT)
    syscall                 ; Llamada: RAX = FD del directorio

    mov rbx, rax            ; Guarda el FD en RBX
    xor r12, r12            ; R12 = offset acumulado dentro de buf (empieza en 0)

read_again:                 ; Bucle de lectura hasta EOF
    
    ; getdents64(fd, buf + offset, BUFSZ - offset)
    mov rax, 217            ; Nº syscall: getdents64
    mov rdi, rbx            ; 1er arg: FD del directorio
    lea rsi, [rel buf]      ; 2º arg: puntero a la base del buffer inicial
    add rsi, r12            ;         + offset actual de escritura
    mov rdx, BUFSZ          ; 3er arg: tamaño máximo disponible en inicio
    sub rdx, r12            ;          - espacio ya ocupado (buffer - escrito)
    syscall                 ; RAX = bytes leídos (0 => EOF)

    
    ; Se debe iterar hasta que rax vale 0 (no hay nada que escribir en el buffer)

    test rax, rax           ; ¿bytes leídos == 0?
    jz   done               ; sí: fin del directorio -> salir
    add  r12, rax           ; no: avanza el offset sumando lo ya escrito
    jmp  read_again         ; y repite

done:
    mov rax, 60             
    xor rdi, rdi            
    syscall                 

