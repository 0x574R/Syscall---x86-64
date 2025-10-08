
; ============================================================================
;  TCP Write (Linux x86-64) — EDUCATIONAL PURPOSES ONLY
;  With <3 by 574R — No guarantees.
; ============================================================================

%define BUFSZ (1<<20)      ; (1<<20) es un desplazamiento a la izquierda: 1 * 2^20 = 1.048.576 bytes → 1 MiB.
                           ;  MiB ≈ MB + 4.86%.
section .data
    msg db 'Hello World!!',0x0A,0
    len equ $ - msg
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



    xor r9, r9
    lea r9, [rel msg]

    xor r10,r10
    mov r10, len

.write_again:
    mov rax, 1                     ; syscall: write
    mov rdi, r8                    ; FD del socket
    mov rsi, r9                    ; Puntero al buffer (luego se ajusta)
    mov rdx, r10                   ; Bytes a escribir (luego se reduce)
    syscall                        ; Ejecuta write()
    
    
    test rax, rax                  ; Verifica si rax == 0
    jz .done                       ; Si rax == 0, terminar
    
    
    sub r10, rax                   ; r10 -= bytes escritos (decrementa bytes restantes)
    add r9, rax                    ; r9 += bytes escritos (avanza puntero en el buffer)

    jmp .write_again               ; Repetir escritura

.done:
    mov rax, 60                    ; syscall: exit
    xor rdi, rdi                   ; exit code = 0 (éxito)
    syscall                        