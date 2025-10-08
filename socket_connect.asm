
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
    ; Entrada esperada: 02 00 11 5c 7f 00 00 01 00 00 00 00 00 00 00 00   
    ;                   └──┘  └──┘  └────────┘  └──────────────────────┘
    ;                   0-1   2-3   4-7         8-15         (16 bytes en total)
    ;                   fam   port  IP          padding

    ; Mapeado de los campos de sockaddr_in:
                        ; Bytes 0-1:   02 00           → sin_family (AF_INET = 2)
                        ; Bytes 2-3:   11 5c           → sin_port (4444)
                        ; Bytes 4-7:   7f 00 00 01     → sin_addr (127.0.0.1)
                        ; Bytes 8-15:  00 00 00 00...  → sin_zero (padding)
    xor r9,r9 ; 0
    push r9 ; 64 bits de padding a 0 (8 bytes)
    mov r10, 0x0100007f5c110002
    push r10
    mov rsi, rsp ; direccion del tope de la pila
    mov rdx, 16 ;IPV4 (espera 16 bytes)
    syscall

    ; EXIT
    mov rax, 60
    xor rdi, rdi
    syscall

