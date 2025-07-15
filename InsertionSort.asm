.data
array: .word 5, 3, 8, 4, 2, 9 #Arreglo a ordenar
length: .word 6		#Longitud del arreglo
msg: .asciiz "Arreglo ordenado: "
space: .asciiz " "
.text
main:
	la $a0, array 
	lw $a1, length
	jal insertionSort
	
	# Imprimir el vector
	li $v0, 4
	la $a0, msg
	syscall
	la $t0, array
	lw $t1, length
	li $t2, 0
imprimir:
	bge $t2, $t1, exit	# sale si i>= lenght
	# Calcular direccion array[i]
	sll $t3, $t2, 2		# i + 4
	add $t3, $t3, $t0	# direccion base + i
	lw $a0, 0($t3)		# Cargar valor desde array[i]
	# Imprimir numero
	li $v0, 1
	syscall
	# Imprimir espacio
	li $v0, 4
	la $a0, space
	syscall
	addi $t2, $t2, 1	# i++
	j imprimir
exit:
	# Salir del programa
	li $v0, 10
	syscall
	
insertionSort:
    # Preservar registros
    addi $sp, $sp, -16
    sw $ra, 12($sp)
    sw $s0, 8($sp)     # i
    sw $s1, 4($sp)     # j
    sw $s2, 0($sp)     # aux

    li $s0, 1          # i = 1

forExt:
    bge $s0, $a1, endExt   # Si i >= n, termina

    move $s1, $s0          # j = i
    sll $t0, $s1, 2        # j * 4
    add $t0, $a0, $t0      # $t0 = dirección de v[j]
    lw $s2, 0($t0)         # aux = v[j]

while:
    blez $s1, whileExit    # Si j <= 0, termina
    lw $t2, -4($t0)        # v[j-1]
    bge $s2, $t2, whileExit # Si aux >= v[j-1], termina

    sw $t2, 0($t0)         # v[j] = v[j-1]
    addi $s1, $s1, -1      # j--
    addi $t0, $t0, -4      # Actualiza $t0 a v[j-1]
    j while

whileExit:
    sw $s2, 0($t0)         # v[j] = aux (usa $t0 actualizado)
    addi $s0, $s0, 1       # i++
    j forExt

endExt:
    # Restaurar registros
    lw $s2, 0($sp)
    lw $s1, 4($sp)
    lw $s0, 8($sp)
    lw $ra, 12($sp)
    addi $sp, $sp, 16
    jr $ra
