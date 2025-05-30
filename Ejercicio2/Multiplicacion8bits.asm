section .data
    factor1    db 0x07        ; Primer factor en hexadecimal
    factor2    db 5           ; Segundo factor
    mensaje    db "El producto es: ", 0
    mensaje_len equ $ - mensaje
    nueva_linea db 0xA        ; Carácter de nueva línea

section .bss
    resultado_str resb 6      ; Buffer para cadena de resultado

section .text
    global _start

_start:
    ; Realizar la operación matemática
    mov bl, [factor1]        ; Cargar primer valor en BL
    mov cl, [factor2]        ; Cargar segundo valor en CL
    mov al, bl               ; Copiar a AL para multiplicación
    mul cl                   ; AX = AL * CL

    ; Preparar conversión a cadena
    movzx esi, ax            ; Extender resultado a 32 bits
    mov edi, resultado_str + 5 ; Apuntar al final del buffer
    mov byte [edi], 0        ; Terminador nulo

    mov ebx, 10              ; Base decimal
convertir_numero:
    dec edi                  ; Mover hacia el buffer
    xor edx, edx             ; Limpiar EDX para división
    div ebx                  ; Dividir EDX:EAX por EBX
    add dl, 0x30             ; Convertir a ASCII
    mov [edi], dl            ; Almacenar dígito
    test eax, eax            ; ¿Cociente cero?
    jnz convertir_numero     ; Si no, continuar

    ; Mostrar mensaje descriptivo
    mov eax, 4              ; sys_write
    mov ebx, 1              ; stdout
    mov ecx, mensaje
    mov edx, mensaje_len
    int 0x80

    ; Mostrar resultado numérico
    mov eax, 4              ; sys_write
    mov ebx, 1              ; stdout
    mov ecx, edi            ; Puntero al inicio 
    mov edx, resultado_str + 6
    sub edx, edi            ; Calcular longitud
    int 0x80

    ; Nueva línea final
    mov eax, 4
    mov ebx, 1
    mov ecx, nueva_linea
    mov edx, 1
    int 0x80

    ; Finalizar programa
    mov eax, 1              ; sys_exit
    xor ebx, ebx            ; código 0
    int 0x80
