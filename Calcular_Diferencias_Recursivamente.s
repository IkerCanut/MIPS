.data
TxInicio: .asciiz   "Cuantos numeros quiere ingresar? "
TxPrompt: .asciiz   ">> "
TxEnter:  .asciiz   "\n"
TxEspac:  .asciiz   " "
TxDifere: .asciiz   "\nLas diferencias son: \n"
          .align    4
Array:    .space    1024

.text
main:
    jal inicio                    # Almacena en $t0 el largo en bytes de la cadena y en $t1 la cantidad de elementos
    
    and $t8, $t8, $0              # Se reinicia el registro temporal
    addi $t8, $t8, 1              # Se cierra el programa en el caso de que se ingresen:
    beq $t0, $0, cerrar           # 0 Numeros
    beq $t0, $t8, cerrar          # 1 Numero

    jal carga                     # Carga en el Array N numeros

    addi $t1, $t1, 1              # Se le suma uno porque en el bucle se le resta uno apenas empieza.
    li $v0, 4                     #
    la $a0, TxDifere              #
    syscall                       # Se imprime el texto de diferencias
    jal diferencia                # Imprime las diferencias entre los elementos, luego las diferencias de las diferencias, ...

    j cerrar

exit:                             #
    jr $ra                        # Vuelve a la direccion del jal en el main

inicio:
    li $v0, 4                     #
    la $a0, TxInicio              #
    syscall                       # Imprime TxInicio

    li $v0, 5                     # 
    syscall                       # Recibe N
    move $t0, $v0                 # $t0 = N   Luego va a almacenar los bytes
    move $t1, $v0                 # $t1 = N   Almacena la cantidad de elementos
    li $t2, 4                     # 
    mul $t0, $t0, $t2             # $t0 *= 4  (Para que sea en bytes)
    and $t2, $t2, $0              # Se reinicia $t2

    j exit                        # Se vuelve al main

carga:
    beq $t2, $t0, exit            # Cuando son iguales ya esta cargado // $t2 = contador

    li $v0, 4                     #
    la $a0, TxPrompt              #
    syscall                       # Imprime TxPrompt

    li $v0, 5                     #
    syscall                       #
    sw $v0, Array($t2)            # Almacena en Array[i] en numero
    
    addi $t2, $t2, 4              # i++
    j carga                       # Vuelve al main

diferencia:
    addi $t1, $t1, -1             # Se le resta uno a la cantidad de pasadas
    move $t7, $t1                 # $t7 es el iterador
    beq $t1, $0, exit             # Si $t1 llega a cero, no hay mas elementos y se vuelve al main

    move $t2, $t4                 # $t2 y $t3 son los punteros
    move $t3, $t4                 # Al final de cada pasada, deben apuntar a donde apuntaba $t0 la pasada anterior. En la primera, apuntan al inicio
    move $t4, $t0                 # Se almacena $t0 para la siguiente pasada

    addi $t3, $t3, 4              # $t3 apunta uno mas adelante
    addi $t7, $t7, -1             # $t7 es el iterador

    li $v0, 4                     #
    la $a0, TxEnter               #
    syscall                       # Imprime un enter para dividir las lineas

bucle:
    beq $t7, $0, diferencia       # Cuando el iterador llega a 0, se le debe hacer la pasada con i-1 veces
    lw $t5, Array($t2)            # $t5 = Array [i]
    lw $t6, Array($t3)            # $t6 = Array [i+1]
    
    sub $t9, $t5, $t6             # Registro temporal = Array[i] - Array[i+1]
    sw $t9, Array($t0)            # Se almacena en el siguiente lugar del Array
    addi $t0, $t0, 4              # Se aumenta el puntero final

    move $a0, $t9                 # Se prepara la resta...
    li $v0, 1                     #
    syscall                       # Y se imprime

    li $v0, 4                     #
    la $a0, TxEspac               #
    syscall                       # Imprime un Espacio

    addi $t2, $t2, 4              # Se aumentan en uno los contadores $t2 y $t3
    addi $t3, $t3, 4              # Seria el equivalente a 4 bytes
    addi $t7, $t7, -1             # El iterador se decrementa en uno
    j bucle                       # Se vuelve al bucle

cerrar:
    li $v0, 10                    #
    syscall                       # Salida del programa