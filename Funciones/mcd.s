.data

.text
main:
li $v0,5		        # Leer Entero
syscall			        # 
move $t0, $v0		    # Almacenarlo en $t0

li $v0,5
syscall
move $t1, $v0

mcd:
beq $t0, $t1, salida    # Si son iguales, se termina el programa
bgt $t0, $t1, casoB     # $t0 > $t1
casoA:
move $t2, $t1           # t2 = t1 
move $t1, $t0           # t1 = t0
sub $t0, $t2, $t1       # t0 = t2 - t1
j    mcd
casoB:
move $t2, $t0           # t2 = t0
move $t0, $t1           # t0 = t1
sub $t1, $t2, $t0       # t1 = t2 - t0
j    mcd
salida:
li $v0, 1
move $a0, $t0
syscall

li $v0, 10              #
syscall	                # EXIT
