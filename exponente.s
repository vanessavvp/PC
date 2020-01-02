            .data
Inicio:             .asciiz  "Practica 6. PRINCIPIOS DE COMPUTADORES\nVanessa Villalba\n"
opciones:           .asciiz  "\n-----MENU DE OPCIONES-----\n"
base:               .asciiz  "Introduce la base: "
ex:                 .asciiz  "Introduce el exponente: "
positivo:           .asciiz  "1. Calcular un exponente normal\n"
menor_cero:         .asciiz  "2. Calcular un exponente negativo\n"
euler:              .asciiz  "3. Calcular el numero de euler\n"
salir:              .asciiz  "4. Salir del programa\n--------------------------\n"
resultado:          .asciiz  "El resultado es: "
euler_resultado:    .asciiz  "El numero de euler elevado a X es: "
            .text
main: 
    la $a0, Inicio
    li $v0, 4
    syscall

    menu:
        la $a0, opciones
        li $v0, 4
        syscall

        la $a0, positivo
        li $v0, 4
        syscall

        la $a0, menor_cero
        li $v0, 4
        syscall

        la $a0, euler
        li $v0, 4
        syscall

        la $a0, salir
        li $v0, 4
        syscall

        li $v0, 5
        syscall
        move $t1, $v0

        beq $t1, 1, ex_normal
        beq $t1, 2, ex_neg
        beq $t1, 3, ex_euler
        beq $t1, 4, exit

        ex_normal: 

            la $a0, base
            li $v0, 4
            syscall

            li $v0, 6
            syscall
            mov.s $f4 ,$f0

            la $a0, ex
            li $v0, 4
            syscall

            li $v0, 5
            syscall
            move $t0, $v0

            jal normal          #Salto a la subrutina

            la $a0, resultado
            li $v0, 4
            syscall

            li $v0, 2
            syscall

            b menu

        ex_neg: 
            la $a0, base
            li $v0, 4
            syscall

            li $v0, 6
            syscall
            mov.s $f4 ,$f0

            la $a0, ex
            li $v0, 4
            syscall

            li $v0, 5
            syscall
            move $t0, $v0

            jal negado

            la $a0, resultado
            li $v0, 4
            syscall

            li $v0, 2
            syscall

            b menu

        ex_euler:
            la $a0, ex
            li $v0, 4
            syscall

            li $v0, 5
            syscall
            move $t0, $v0

            jal calculo_e

            la $a0, resultado
            li $v0, 4
            syscall

            li $v0, 2
            syscall

            la $a0, ex
            li $v0, 4
            syscall

            li $v0, 5
            syscall
            move $t0, $v0

            jal e_elevado

            la $a0, euler_resultado
            li $v0, 4
            syscall

            li $v0, 2
            syscall

            b menu

    exit:
    li $v0, 10
    syscall                                     #EXIT

        
#----------------CALCULO DEL EXPONENTE POSITIVO O IGUAL A 0----------------------------------------------
    normal: 

	    li.s $f18,1.00
	    beq $t0,$zero,exp0                      #Si el exponente es igual a 0 salta a la etiqueta 
	    li $t2, 1
            for:	
                bge $t2,$t0,endfor
	            mul.s $f0,$f0,$f4               #Multiplica la base por si misma 
	            addi $t2,1
	            j for
            endfor:
	        mov.s $f12,$f0
	        jr $ra

        exp0:	
            mov.s $f12,$f18
	        jr $ra

 #-------------------CALCULO DEL EXPONENTE NEGATIVO--------------------------------------------------------       

    negado: 

	    li.s $f18,1.00
	    beq $t0,$zero,exp0
	    li $t2,1
        abs $t0, $t0                            #Hacemos el valor absoluto del exponente, se haya introducido con signo negativo o no 
        for2:	
            bge $t2,$t0,endfor2
	        mul.s $f0,$f0,$f4                   #Multiplicamos la base por si misma 
	        addi $t2,1
	        j for2
        endfor2:
	        div.s $f0,$f18,$f0                  #Dividimos 1/base_multiplicada
	        mov.s $f12,$f0
	        jr $ra

    exp02:	
        mov.s $f12,$f18
	    jr $ra
        


#-------------------------CALCULO DE E ----------------------------------------------------------------------

calculo_e:
	beq $t0,$zero,exp0_e
	li.s $f18,1.00

	mtc1 $t0,$f6                                #Hacemos una copia cruda de int a float
	cvt.s.w $f6,$f6                             #Convertimos a float la variable    
	li $t2,1
    base_e: 
	    div.s $f0,$f18,$f6                      #Dividimos 1 entre el valor del exponente   1/n
	    add.s $f0,$f0,$f18                      #Le sumamos un 1 al valor anterior 
	    mov.s $f4,$f0                   
    exponente_e:
	    bge $t2,$t0,endfor_e
	    mul.s $f0,$f0,$f4                       #Elevamos el resultado de base_e a n        (1+1/n)^n
	    addi $t2,1
	    j exponente_e
    endfor_e:
	    mov.s $f12,$f0
	    jr $ra

    exp0_e:	
        mov.s $f12,$f18   
	    jr $ra


#Numero de Euler elevado 

e_elevado:
	mov.s $f4,$f0
    li $t2, 1
exponente:
	bge $t2,$t0,endfor_e_2
	mul.s $f0,$f0,$f4
	addi $t2,1
	j exponente
endfor_e_2:
	mov.s $f12,$f0
	jr $ra

exp0_e_2:	
    mov.s $f12,$f18
	jr $ra

