
%define BUFSZ (1<<20)      ; (1<<20) es un desplazamiento a la izquierda: 1 * 2^20 = 1.048.576 bytes → 1 MiB.
                           ;  MiB ≈ MB + 4.86%.

section .bss
    buff resb BUFSZ
section .text
global _start

_start:

    ; SOCKET
    mov rax, 41
    mov rdi, 2 ;IPV4
    mov rsi, 1 ;TCP
    xor rdx, rdx ; Default
    syscall

    ; Store socket FD
    mov r8, rax

    ; CONNECT
    mov rax, 42
    mov rdi, r8
                    ;   Stack        Low  <----------- High
    ; Entrada esperada: 02 00 11 5c C0 A8 12 8D 00 00 00 00 00 00 00 00   
    ;                   └──┘  └──┘  └────────┘  └──────────────────────┘
    ;                   0-1   2-3   4-7         8-15         (16 bytes en total)
    ;                   fam   port  IP          padding

    ; Mapeado de los campos de sockaddr_in:
                        ; Bytes 0-1:   02 00           → sin_family (AF_INET = 2)
                        ; Bytes 2-3:   11 5c           → sin_port (4444)
                        ; Bytes 4-7:   C0 A8 12 8D     → sin_addr (192.168.18.141)
                        ; Bytes 8-15:  00 00 00 00...  → sin_zero (padding)
    xor r9,r9 ; 0
    push r9 ; 64 bits de padding a 0 (8 bytes)
    mov r10, 0x8d12a8c05c110002
    push r10
    mov rsi, rsp ; direccion del tope de la pila
    mov rdx, 16 ;IPV4 (espera 16 bytes)
    syscall



    xor r9,r9  ; r9 = offset acumulado en buff
.read_again:

    cmp r9, BUFSZ    ; n bytes leidos == tamaño del buffer --> buffer lleno
    jae .done

    ; READ
    mov rax, 0
    mov rdi, r8

    lea rsi, [rel buff]    ; puntero al buffer
    add rsi, r9            ; puntero al buffer + offset

    mov rdx, BUFSZ       ; tamaño máximo de lectura = tamaño del buffer en este caso
    sub rdx, r9          ; tamaño del buffer -  n bytes escritos = espacio libre restante

    syscall

    test rax, rax           ; EOF
    jz   .done
    add r9, rax              ; n bytes ya leidos +  n bytes leidos en esta iteracción
    jmp  .read_again


.done:
    ; EXIT
    mov rax, 60
    xor rdi, rdi
    syscall

