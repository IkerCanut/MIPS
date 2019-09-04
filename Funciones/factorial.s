.data

msg: .word 69

.text

factorial:

li $t0, 1
beq $a0, $t0, basecase

# push
addi $sp, $sp, -4
sw $ra, ($sp)

# recursive call
addi $a0, $a0, -1
jal factorial
addi $a0, $a0, 1
mul $v0, $v0, $a0

# pop
lw $ra, ($sp)
addi $sp, $sp, 4

end:
jr $ra

basecase:
li $v0, 1
j end

main:

li $a0, 3
jal factorial
addi $t0, $v0, 0
li $v0, 10
syscall
