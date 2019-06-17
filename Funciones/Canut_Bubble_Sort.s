.data
	tArray:	   .word     8
	Array:     .space    32
	TxInicio:  .asciiz   "Bubble Sort\n   Por Iker Canut\n\n Ingrese 8 numeros, separados por enters por favor:\n"
	TxFinal:   .asciiz   "\n\n Los numeros ordenados son: \n"
	TxEnter:   .asciiz   "\n"

.text
main:
	li $v0, 4
	la $a0, TxInicio
	syscall							# puts(TxInicio)
	jal carga						# jump and link -> Carga
	jal bubble_sort					# jump and link -> Bubble Sort
	jal printArray					# jump and link -> Imprimir
	li $v0, 10
	syscall							# exit(0)

carga:
	beq $t0, 32, exit				# branch on equal. 32 = 8 * 4
	li $v0, 5
	syscall							# read integer from the console
	sw $v0, Array($t0)				# store word
	add $t0, $t0, 4
	j carga

exit:
	jr $ra							# salida del jal

bubble_sort:
	li $t0, 0						# i = 0
	li $t9, 9
first_loop:
	addi $t0, $t0, 1				# i ++
	beq $t0, $t9, exit				# Cuando se ejecuta 8 veces (1 - 9) -> Salir
	li $t1, 0						# j = 0
	la $t2, Array					# Array [j]
	la $t3, Array
	addi $t3, $t3, 4				# Array [j + 1]
second_loop:
	lw $t4, ($t2)
	lw $t5, ($t3)
	blt $t4, $t5, notSwap
	sw $t4, ($t3)					# Swap
	sw $t5, ($t2)					# Swap
	notSwap:
	addi $t2, $t2, 4				# Array [j]
	addi $t3, $t3, 4				# Array [j + 1]
	addi $t1, $t1, 1				# j++
	beq $t1, 7, first_loop
	j second_loop

printArray:
	lw $t0, tArray($0)				# Guarda el tamano del Array en t0
	la $t1, Array					# Guarda la direccion de memoria del Array en t1
	li $v0, 4
	la $a0, TxFinal
	syscall	
printNextElement:
	lw $t2, ($t1)					# t2 = *t1
	move $a0, $t2					# a0 = t2
	li $v0, 1						# v0 = 1
	syscall							# syscall(1, t2) -> print_int(t2)
	li $v0, 4
	la $a0, TxEnter
	syscall
	addi $t1, $t1, 4				# t1 = t1 + 4
	addi $t0, $t0, -1				# t0 = t0 + -1
	beq $t0, 0, exit
	j printNextElement
