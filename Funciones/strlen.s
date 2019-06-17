.data
cadena: .asciiz "holaaaaaaaa"
	.align 2
n:	.space 4
.text
main:
	la $t0, cadena
mientras:
	lb $t1, ($t0)
	beq $t1, $0, finmientras
	addi $t2, $t2, 1
	addi $t0, $t0, 1
	j mientras
finmientras:
	sw $t2, n($0)

