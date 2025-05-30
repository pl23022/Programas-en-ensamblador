section .data
    num1    dw 30      ; Primer número (16 bits)
    num2    dw 10      ; Segundo número (16 bits)
    num3    dw 5       ; Tercer número (16 bits)
    result  dw 0       ; Variable para almacenar el resultado

section .text
    global _start

_start:
    mov ax, [num1]     ; Cargar num1 en AX
    sub ax, [num2]     ; Restar num2 de AX
    sub ax, [num3]     ; Restar num3 de AX
    mov [result], ax   ; Guardar resultado
    
    ; Salida del programa
    mov eax, 1         ; syscall exit
    mov ebx, 0         ; código de salida 0
    int 0x80
