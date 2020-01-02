# PRACTICA 4. PRINCIPIO DE COMPUTADORES.
# programa que imprime la traspuesta de la matriz
# La matriz tiene dimension mxn

m:		.word  2	# numero de filas de m1
n:		.word  2	# numero de columnas de  m1
size:   .word  4	#  tamano de cada elemento

			.data
m1:			.word 	2, 3, 4, 5

m3:			.word	1, 2, 3, 4, 5
			.word	6, 7, 8, 9, 0
			.word	0, 2, 4, 6, 8
			.word	1, 3, 5, 7, 9
espacio:    .asciiz "\n"
inicio:		.asciiz	"PRACTICA 4. PRINCIPIO DE COMPUTADORES.\nVanessa Villalba\n"
normal:		.asciiz	"La matriz por defecto es:\n"
tras:		.asciiz	"La matriz traspuesta de ella es:\n"
diago:		.asciiz "La diagonal de la matriz es:\n"
filas:		.asciiz "Introduzca la cantidad de filas:\n"
col:		.asciiz "Introduzca la cantidad de columnas:\n"
dato:		.asciiz "Introduzca los datos correspondientes a la matriz nueva(Dispuesta por filas):\n"
new_:		.asciiz "La matriz introducida es:\n"

m2:			.word 0,

			.text
main:

  #REGISTRO      /   VALOR
  #  $t0        |     size
  #  $t1        |     m  filas
  #  $t2        |     n
  #  $s0        |     m1
  #  $t3        |     mxn
  #  $t4        |     iterador (j)
  #  $s1        |     copia de la dir de memoria de la matriz
  #  $t5        |     iterador (i)

  la $a0, inicio
  li $v0,4
  syscall
  lw $t0, size 
  lw $t1, m  #filas
  lw $t2, n  #columnas
  la $s0, m1
  move $s1, $s0
  move $s2, $s0
  jal inicial
  
  jal trasp
  jal diag
  
  li	$v0,10
  syscall
		

#IMPRESION DE LA MATRIZ INICIAL

inicial:
  la $a0, normal
  li $v0, 4
  syscall

  mul $t3, $t1, $t2 				#Multiplicamos las filas por columnas para saber la cantidad de datos que tiene nuestra matriz
  move $t5, $zero 	

  bucle_for_col: 
	bge $t5, $t1, fin_col		    #Verificamos si nuestro iterador es mayor al numero de columnas
	move $t4, $zero 

	bucle_for_filas: 
	  bge $t4, $t2, fin_filas       #Verificamos si nuestro iterador es mayor al numero de filas
	  lw $t6, 0($s1)
	  move $a0, $t6
	  li $v0, 1
	  syscall
	  add $s1, $s1, $t0		        #Le sumamos size a la dir de mem de la matriz para obtener la direccion del sig valor
	  addi $t4, 1 #i++
	  j bucle_for_filas

	fin_filas:
	la $a0, espacio
	li $v0, 4
	syscall

	addi $t5, 1 #j++
	j bucle_for_col
  fin_col:
  jr $ra
  #FIN MATRIZ INICIAL

#TRASPUESTA DE LA MATRIZ
trasp:
  la $a0, tras
  li $v0,4
  syscall

  mul $t3, $t2, $t0  				  #Ncol * size para conocer el numero de B necesarios por cada fila
  move $t4, $zero 

  for_traspuesta_1: 
	bge  $t4, $t2, fin_tras_1		  #Verificamos si nuestro iterador es mayor al numero de col
	move $s1, $s0						
	move $t5, $zero 

	for_traspuesta_2:
	  bge $t5, $t1, fin_tras_2		
	  lw  $t6, 0($s1)              	  #Volcamos el valor de la direccion de memoria de la matriz en el primer indice
	  move $a0, $t6					  #Imprimimos el dato leido 
	  li $v0, 1
	  syscall

	  add $s1, $s1, $t3				  #Le sumamos a la direccion de memoria  Ncol*size
	  addi $t5, 1 
	  j for_traspuesta_2

	fin_tras_2:
	add $s0, $s0, $t0				  #Le sumamos a la direccion de memoria size para desplazarse a la sig col
	addi $t4,1
	la $a0, espacio					  #Imprimimos un salto de linea
	li $v0, 4
	syscall
	j for_traspuesta_1
				
  fin_tras_1:
  jr $ra
  #FIN TRASPUESTA

#DIAGONAL DE LA MATRIZ

diag:
  la $a0, diago
  li $v0, 4
  syscall

  mul $t3, $t1, $t2                    #Multiplicamos mxn para conocer la cantidad de datos que tendra nuestra matriz
  mul $t4, $t3, $t0                    #Multiplicamos la cantidad de datos por size, para conocer los Bytes totales de la matriz
  mul $t5, $t2, $t0                    #Multiplicamos el numero de columnas por size para saber la cantidad de Bytes contenidos en una fila de la matriz
  add $t6, $t5, $t0                    #Le sumamos a la cantidad de Bytes de una fila entera,(size) 4Bytes, para lograr los datos de la traspuesta

  if:
	bgt $t1, $t2, else                 #Saltamos a la etiqueta else si el numero de filas es mayor al de columnas

	move $t7, $zero                    #Inicializamos nuestra estructura iterativa
	bucle_diag_fila:
	  bge $t7, $t1, fin_bucle_diag_fila #Verificamos la condicion de que nuestro iterador sea mayor a nfil
	  lw $t8, 0($s2)                   #Volcamos el valor de la primera posicion del espacio de memoria de nuestra matriz en un registro temporal
	  move $a0, $t8                    #Imprimimos el valor
	  li $v0, 1
	  syscall

	  add $s2, $s2, $t6
	  addi $t7,1
	  la $a0, espacio
	  li $v0, 4
	  syscall

	  j bucle_diag_fila

	fin_bucle_diag_fila:
	j final
		
	else:
	  move $t7, $zero                   #Inicializamos nuestra estructura iterativa

	  bucle_diag_col:
		bge $t7, $t2, fin_bucle_diag_col #Verificamos la condicion de que nuestro iterador sea mayor a la cantidad de columnas
		lw $t8, 0($s1)                  #Volcamos el valor de la primera posicion del espacio de memoria de nuestra matriz en un registro temporal
		move $a0, $t8                   #Imprimimos el valor
		li $v0, 1
		syscall

		add $s2, $s2, $t6
		addi $t7,1
		la $a0, espacio
		li $v0, 4
		syscall

		j bucle_diag_col

	  fin_bucle_diag_col:
	  j final 

    final:
	jr $ra
	#FINAL DIAGONAL