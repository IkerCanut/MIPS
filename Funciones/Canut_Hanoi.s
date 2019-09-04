.data
    TxInicio:       .asciiz "Introduzca el numero de discos: "
    TxMovimientos:  .asciiz "Movimientos:"
    TxDisco:        .asciiz "\nDisco "
    TxDe:           .asciiz " de "
    TxFlecha:       .asciiz " -> "
                    .align 4

.text
main:
    li $v0, 4               #
    la $a0, TxInicio        #
    syscall                 # Imprimir texto inicio
    li $v0, 5               #
    syscall	                # Guardar numero

    move $a0, $v0           # Se carga N
    li   $a1, 'A'           # 
    li   $a2, 'B'           # 
    li   $a3, 'C'           # Los 3 char de las 3 varillas

    jal hanoi               # Llamada a la funcion

    li $v0, 10              #
    syscall                 # Terminar programa


hanoi:
    addi $sp, $sp, -20      # Espacio del stack
    sw   $ra, 0($sp)        # Direccion de retorno
    sw   $s0, 4($sp)        # n
    sw   $s1, 8($sp)        # orig
    sw   $s2, 12($sp)       # dest
    sw   $s3, 16($sp)       # spare

    move $s0, $a0           #
    move $s1, $a1           #
    move $s2, $a2           #
    move $s3, $a3           # Muevo a los s para hacer las rotaciones

    li $t1, 1               #
    beq $s0, $t1, imprimir  # Si es 1, imprimir

                            # Primera llamada
    addi $a0, $s0, -1       # n--
    move $a1, $s1           # Orig se mantiene
    move $a2, $s3           #
    move $a3, $s2           # Se invierten dest y spare
    jal hanoi               # Se llama la funcion, primera recursion
    j imprimir

loop:
    addi $a0, $s0, -1       # n--
    move $a1, $s3           # 
    move $a3, $s1           # Se invierten orig y spare
    move $a2, $s2           # Dest se mantiene
    jal hanoi               # Se llama nuevamente, segunda recursion

chauHanoi:
    lw  $ra, 0($sp)         # Se recupera la direccion de retorno
    lw  $s0, 4($sp)         # Se recupera n
    lw  $s1, 8($sp)         # Se recupera orig
    lw  $s2, 12($sp)        # Se recupera dest
    lw  $s3, 16($sp)        # Se recupera spare

    addi $sp, $sp, 20       # se devuele el stack pointer a su posicion
    jr $ra                  # Termina la vuelta.
    
imprimir:
    li $v0,  4              #
    la $a0,  TxDisco        #
    syscall                 # puts("Disco: ")
    li $v0,  1              #
    move $a0, $s0           #
    syscall                 # Imprime n
    li $v0,  4              #
    la $a0,  TxDe           #
    syscall                 # puts(" de ")
    li $v0,  11             # Imprime el caracter
    move $a0, $s1           # 
    syscall                 # Imprime el caracter
    li $v0,  4              #
    la $a0,  TxFlecha       #
    syscall                 # Imprime la hermosa flecha
    li $v0,  11             #
    move $a0, $s2           #
    syscall                 # Imprime el caracter

    li $t1, 1               # Si es 1...
    beq $s0, $t1, chauHanoi # devolve todo como estaba
    j loop                  # Se vuelve para hacer la segunda llamada.
