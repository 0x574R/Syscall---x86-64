section .text
global _start
_start:

    mov rax, 0x007665722f6d6873        ; 8 bytes
    push rax                      
    mov rax, 0x2f7665642f000000        ; 8 bytes                                    
    push rax                      


            ; /dev/shm/rev  ---> stack
            ; 00 00 00 2F 64 65 76 2F |||| 73 68 6D 2F 72 65 76 00   --> 13 bytes
            

    mov rax, 263
    xor rdi, rdi
    lea rsi, [rsp + 3]   ; Direccion donde empieza el contenido util en la pila
    xor rdx, rdx
    syscall 


    mov rax, 60
    xor rdi, rdi 
    syscall