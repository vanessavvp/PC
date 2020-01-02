#Codigo guia en C 
#
#include <stdio.h>
#
#int n;
#double pto;
#double resultado;
#
#double iterativa (int ord, double x) {
#
#  double h0 = 1;
#  double h1 = 2*x;
#  double resul;
#  if(ord > 2) {
#    int i = 0;
#      for(i = 2; i <= ord; i++) { 
#        resul = (2*x*h1) - (2*(i - 1)*h0);
#        h0 = h1;
#        h1 = resul;
#      }
#      printf("el resultado es: %ld\n", resul);
#  }
#  else {
#    if (ord==0) return (1);
#    if (ord==1) return (2*x);
#  }
#}
#int main () {
#  printf("Introduce el orden del polinomio: ");
#  scanf("%d",&n);
#  printf("Introduce un punto para calcular el polinomio: ");
#  scanf ("%ld",&pto);
#  resultado = iterativa(n, pto);
#  //printf("solucion iterativa: %ld", resultado);
#}
#
# RECURSIVA
#double hermite(double x, int n) {
#  if(n==0) return 1.0;
#  if(n==1) return 2*x;
#  return (2*x*hermite(x, n-1)-2*(n-1)*hermite(x, n-2));
#}
 
       .data

inicio:     .asciiz  "Practica 5. Principios de Computadores.\nIntegrantes: Marcos Padilla y Vanessa Villalba\n"
orden:      .asciiz  "Introduce el orden del polinomio: "
punto:      .asciiz  "Introduce el punto con el que se va a trabajar: "
hermite:    .asciiz  "El resultado del polinomio es: "
error:      .asciiz  "Error, el orden es negativo\n"
espacio:    .asciiz  "\n"
nuevo:      .asciiz  "¿Quieres volver a intentar?\tSi=1  No=0\n"

        .text

main: 
  la $a0, inicio
  li $v0, 4
  syscall

  nuevo_inicio:
  la $a0, orden
  li $v0, 4
  syscall

  li $v0, 5
  syscall

  move $t0, $v0                                      #Almacenamos la orden del polinomio(N)           
  la $a0, punto
  li $v0, 4
  syscall

  li $v0, 7
  syscall

  mov.d $f12, $f0                                     #Almacenamos el punto a evaluar(X)
  jal iterativa
  jal recursiva
  li $v0, 10                                          #Exit
  syscall

  iterativa:
    mtc1.d $t0, $f14                                    #Hacemos una copia del registro entero que contiene el orden a un double
    cvt.d.w $f14, $f14                                  #Convertimos la copia en un double
    li.d $f0,  0.0000000
    li.d $f20, 1.0000000                                #H0   Es un punto double por lo que necesitara 8 0
    li.d $f22, 2.0000000  
    li.d $f18, -1.0000000                                    
    li.d $f16, 1.0000000                                #Se utilizara mas adelante en for1
    mul.d $f4,$f22, $f12                                #H1     #2*x	Cambio por j
    mov.d $f6, $f22                                     #Hago una copia del registro $f22 que vale 2, para utilizarlo en nuestra estructura iterativa #cambio por 
    c.le.d $f14, $f18                                   #Es la orden menor o igual a -1?, salta al mensaje de error
    bc1t ferror
    c.lt.d $f14, $f22                                   #Es el orden mayor a 2?
    bc1f iter_mayor_dos                                 #Si se cumple que el orden es mayor a 2
    bc1t iter_menor_dos                                 #para el caso que sea menor que dos salta a iter_menor_dos
    
    iter_mayor_dos:
      mul.d $f0, $f22, $f12                       #2*x
      mul.d $f0, $f0, $f4                         #2*x*h1  Sabemos que h1 = 2*x  por lo tanto multiplicamos el registro $f4 por si mismo
      sub.d $f8, $f6, $f16                        #i-1 #cambio de j
      mul.d $f8, $f22, $f8                        #2*(i-1)
      mul.d $f8, $f8, $f20                        #(2*(i-1)*h0)
      sub.d $f0, $f0, $f8                         #result = (2*x*h1) - (2*(i-1)*h0)
      mov.d $f20, $f4                             #h0 = h1
      mov.d $f4, $f0
      add.d $f6, $f6, $f16                        #i++
      c.le.d $f6, $f14                            #Verificamos que nuestra i siga siendo menor o igual al orden
      bc1t iter_mayor_dos

    fin_iter_mayor_dos:
    la $a0, hermite
    li $v0, 4
    syscall 

    mov.d $f12, $f0                                       #se imprime el resultado del polinomio
    li $v0, 3
    syscall

    jr $ra

    iter_menor_dos:
      c.eq.d  $f14, $f20                        #Es el orden igual a 1?
      bc1t is_one                               #compara si n es igual que uno, en ese caso continua, sino salta a isone
      bc1f zero_

      zero_:
        la $a0, hermite
        li $v0, 4
        syscall

        mov.d $f12, $f20                   #Imprime un 1
        li $v0, 3
        syscall

        jr $ra
        #FIN DE ZERO_

      is_one:
        la $a0, hermite
        li $v0, 4
        syscall

        mov.d $f12, $f4                    #Se imprime el resultado                                 
        li $v0, 3
        syscall

        jr $ra
        #FIN_IS_ONE

      ferror:
        la $a0, error
        li $v0, 4
        syscall

        la $a0, espacio
        li $v0, 4
        syscall

        la $a0, nuevo                                     #Mensaje de introducir nuevo orden
        li $v0, 4
        syscall

        li $v0, 5
        syscall
        move $t0, $v0   
        li $t2, 1

        if:
          blt $t0, $t2, else                             #Si la opcion introducida es menor a 1, salta a else
          b nuevo_inicio

        else:
          jr $ra
      
    #FIN ITERATIVA