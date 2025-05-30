section .data
    num_a       dd 150          ; Numerando 
    num_b       dd 25           ; Denominador
    encabezado  db "Cociente de la operación: ", 0
    encabezado_len equ $ - encabezado
    separador   db 0xA, 0xD     ; Retorno de carro

section .bss
    buffer_num  resb 12         ; Buffer para conversión numérica

section .text
    global _start

_start:
    ; Realizar la operación de división
    mov ebx, [num_b]           ; Cargar divisor
    mov eax, [num_a]           ; Cargar dividendo
    cdq                        ; Extender EAX a EDX:EAX 
    idiv ebx                   ; EDX:EAX / EBX → EAX=cociente, EDX=residuo

    ; Configurar conversión a string
    mov esi, eax               ; Guardar cociente
    lea edi, [buffer_num + 10] ; Puntero al final del buffer
    mov byte [edi], 0          ; Terminador nulo

    mov ecx, 10                ; Base decimal
    mov ebx, 1                 ; Contador de dígitos (mínimo 1)

    ; Manejar caso especial para cero
    test esi, esi
    jnz convertir_cociente
    mov byte [edi-1], '0'
    jmp mostrar_resultado

convertir_cociente:
    dec edi                    ; Mover puntero
    mov eax, esi
    xor edx, edx               ; Limpiar EDX para división
    div ecx                    ; EAX = cociente, EDX = residuo
    add dl, 0x30               ; Convertir a ASCII
    mov [edi], dl              ; Almacenar dígito
    mov esi, eax               ; Actualizar cociente
    inc ebx                    ; Incrementar contador
    test eax, eax              ; ¿Terminamos?
    jnz convertir_cociente

mostrar_resultado:
    ; Mostrar texto descriptivo
    mov eax, 4                 ; sys_write
    mov ebx, 1                 ; stdout
    mov ecx, encabezado
    mov edx, encabezado_len
    int 0x80

    ; Mostrar valor numérico
    mov eax, 4
    mov ebx, 1
    mov ecx, edi               ; Puntero al inicio del número
    mov edx, buffer_num + 11
    sub edx, edi               ; Calcular longitud
    int 0x80

    ; Mostrar separador
    mov eax, 4
    mov ebx, 1
    mov ecx, separador
    mov edx, 2
    int 0x80

    ; Terminar programa
    mov eax, 1                 ; sys_exit
    xor ebx, ebx               ; código 0
    int 0x80
