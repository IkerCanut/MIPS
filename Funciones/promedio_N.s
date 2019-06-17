.data
Array:     .space    1024

.text
main:
        li      $v0, 5                  #
        syscall                         # Leer N
        move    $t0, $v0                # Guardarlo en $t0
precarga:
        li      $t1, 4
        mult    $t0, $t1                # Se pasa a bytes ( x4 )
        mflo    $t0                     # $t0 tiene el tamano maximo
        and     $t1, $t1, $0            # $t0 reiniciado
carga:
        beq     $t1, $t0, presuma       # $t1 es el contador
        li      $v0, 5                  #
        syscall                         # Leer elemento del array
        sw      $v0, Array($t1)         # Almacenarlo en Array[i]
        addi    $t1, $t1, 4             # i++
        j carga                         # Y pa' rriba
presuma:
        and     $t1, $t1, $0            # Se reinician las variables $t1 y $t3
        and     $t3, $t3, $0            # $t3 va a ser el resultado
suma:
        beq     $t0, $t1, promedio      # $t1 es el contador
        lw      $t2, Array($t1)         # Se carga el elemento en $t2
        add     $t3, $t3, $t2           # $t3 = $t3 + $t2
        addi    $t1, $t1, 4             # i++
        j suma                          # Pa'rriba
promedio:
        li      $t1, 4                  # Cargamos 4 en $v1
        div     $t0, $t1                # LongEnBytes / 4
        mflo    $t0                     # $v0 = long
        div     $t3, $t0                # $t3
        mflo    $t3
mostrar:
        li      $v0, 1                  # 
        move    $a0, $t3                # 
        syscall                         # Imprimir $t3

        li      $v0, 10                 # 
        syscall                         # Exit
