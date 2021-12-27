include macros.asm ;archivo con los macros a utilizar


ImprimirTablero macro arreglo 
LOCAL Mientras, FinMientras, ImprimirSalto
push si
push di

xor si,si
mov si,1
xor di,di

	Mientras:
		cmp si,65;17
		je FinMientras				; while(si<=17){}

			mov al, arreglo[si]
			mov aux, al 		   ; print(arreglo[si])
			print aux

			cmp di,7;3
			je ImprimirSalto	 ; if(di == 3){ Imprimir salto}


			mov aux,32   		; else{print(" ")
			print aux
			

			inc di				;di++
			inc si   			; si++}
		jmp Mientras

	ImprimirSalto:
		xor di,di 			; di = 0
		print salto			;print("/n")
		inc si  			; si++
		jmp Mientras

	FinMientras:

pop di
pop si
endm

AnalizarComando macro com ; A1:B2 arreglo1 = [A][1]; arreglo2 = [B][2]
LOCAL Ver, Seguir, Mover, Error, ValidarNegras, ValidarBlancas

mov al,com[0]
mov posicionInicial[0],al ; arreglo1[0] = comando[0]

mov al,com[1]
mov posicionInicial[1],al ; arreglo1[1] = comando[1]

mov al,com[3]
mov posicionFinal[0],al ;  arreglo2[0] = comando[3]

mov al,com[4]
mov posicionFinal[1],al ;  arreglo2[1] = comando[4]




ConversionCoordenadas posicionInicial ;convierte la coordenada y la guarda en al


xor si,si ;si tiene el indicie inicial
mov si,ax

ConversionCoordenadas posicionFinal ;convierte la coordenada y la guarda en al

xor di,di ;di tiene el indice final
mov di,ax


;aqui van validaciones
inc bandera
print bandera
mov dx,di ; GUARDA EL INIDICE FINAL EN dx
mov cx,si ; GUARDA EL INDICE INICIAL EN cx

sub cx,dx ; cx = cx - dx

cmp jueganNegras,1
je ValidarNegras
jmp ValidarBlancas

ValidarNegras:
	cmp cx,-18 ; cx == -18
	mov saltaFicha,1 ;INDICA QUE ES UN MOVIMIENTO SALTAFICHA
	je Mover
	cmp cx,-14 ; cx == -14
	mov saltaFicha,1 ;INDICA QUE ES UN MOVIMIENTO SALTAFICHA
	je Mover
	cmp cx,-9 ; cx == -9
	mov saltaFicha,0 ;INDICA QUE NO ES UN MOVIMIENTO SALTAFICHA
	je Mover
	cmp cx,-7 ; cx == -7
	mov saltaFicha,0 ;INDICA QUE NO ES UN MOVIMIENTO SALTAFICHA
	je Mover
	jmp Error

ValidarBlancas:
	cmp cx,18 ; cx == 18
	mov saltaFicha,1 ;INDICA QUE ES UN MOVIMIENTO SALTAFICHA
	je Mover
	cmp cx,14 ; cx == 14
	mov saltaFicha,1 ;INDICA QUE ES UN MOVIMIENTO SALTAFICHA
	je Mover
	cmp cx,9 ; cx == 9
	mov saltaFicha,0 ;INDICA QUE NO ES UN MOVIMIENTO SALTAFICHA
	je Mover
	cmp cx,7 ; cx == 7
	mov saltaFicha,0 ;INDICA QUE NO ES UN MOVIMIENTO SALTAFICHA
	je Mover
	jmp Error

;-------------INICIA CAMBIO DE POSICION DE LA FICHA-----------------
Mover:

cmp saltaFicha,1
je 

xor ax,ax

mov al, tablero[si] ;al = arreglo[si]
mov tablero[si],95 ;arreglo[si] = '_'

mov tablero[di],al ;arreglo[di] = arreglo[si]
jmp Seguir
;-------------TERMINA CAMBIO DE POSICION DE LA FICHA-----------------

Error:
print errorDeMovimiento
mov seRepite,1
Seguir:

endm


ConversionCoordenadas macro coordenada ; A1 -> 1 -> (columna) + (fila-1)*4
; ADD valor1, valor2 -> valor1 = valor1 + valor2
; MUL valor -> al = al * valor
; SUB valor1, valor2 -> valor1 = valor1 - valor2
; DIV valor -> al = al / valor -> ah tiene el residuo 

mov al, coordenada[0] ; al = A = 65
mov columna, al        ; columna = 65
ConversionColumna columna ; columna convertida

mov al, coordenada[1] ; al = 1 = 49
mov fila,al 		  ; fila =  49

ConversionFila fila

xor ax,ax
xor bx,bx

mov al,fila ;fila - 1
SUB al,1

mov bl,8;4
MUL bl ; (fila-1)*4 -> al

xor bx,bx
mov bl,columna 

ADD al,bl ;(columna) + (fila-1)*8 = al

;la conversion del resultado se guarda en al 
;IntToString ax,numero
;print numero
;print salto

endm

ConversionColumna macro valor ; valor = valor - 64

mov al,valor ; al = valor
sub al,64   ; al = al - 64
mov valor,al ; valor = al

endm

ConversionFila macro valor ; valor = valor - 48

mov al,valor ; al = valor
sub al,48   ; al = al - 48
mov valor,al ; valor = al

endm


.model small

;----------------SEGMENTO DE PILA---------------------

.stack

;----------------SEGMENTO DE DATO---------------------

.data
enc db 0ah, 0dh, 'Universidad de San Carlos de Guatemala',0ah, 0dh,'Arquitectura de Ensambladores y Computadores 1' , 0ah, 0dh, 'Jose Fernando Valdez Perez 201503651' , 0ah, 0dh, 'Practica 3',0ah, 0dh, 'Inrese x si desea cerrar el programa' , '$'
jp1 db 0ah, 0dh, 'Jugador 1 ingrese su nombre:', '$'
jp2 db 0ah, 0dh, 'Jugador 2 ingrese su nombre:', '$'
msjTurno db 0ah, 0dh, 'Turno del jugador:', '$'
finJuego db 0ah, 0dh, 'Ingrese x para finalizar el juego', '$'
juegaB db 0ah, 0dh, 'Juega blancas', '$'
juegaN db 0ah, 0dh, 'Juega negras', '$'
punteo db 0ah, 0dh, 'Punteo actual:', '$'
que db 0ah, 0dh, 'yeaaaaaaaaaa', '$'
errorDeMovimiento db 0ah, 0dh, 'Error: Movimiento invalido', '$'
salto db 0ah,0dh, '$' ,'$'
nombre1 db 10 dup('$'), '$'
nombre2 db 10 dup('$'), '$'
textoComando db 0ah, 0dh, 'Ingrese su comando:', '$'

posicionInicial db 2 dup('$'), '$'
posicionFinal db 2 dup('$'), '$'

; DATOS PARA CONTROL DE FICHAS 
posInit db 0
posFinish db 0 

valorInicial db 0, '$' 
valorFinal db 0, '$' 

aux db 0, '$' 
resultado db 0, '$'
columna db 0, '$'
fila db 0, '$'

; BANDERAS
bandera db 0
seRepite db 0
jueganNegras db 0 ; BANDERA PARA SABER QUE TURNO JUEGA
saltaFicha db 0 ; BANDERA PARA SABER SI INTENTA SALTAR FICHA

tablero db 65 dup('$'), '$'

numero db 2 dup('$'), '$'

comando db 5 dup('$'), '$' ; A1:B2



;----------------SEGMENTO DE CODIGO---------------------


.code
main proc
	
	Menu:


		print enc
		print salto 
        TableroInicial tablero, SIZEOF tablero ; LLENADO INICIAL DEL TABLERO DE DAMAS

		getChar ; lee un caracter del teclado y lo guarda en al
		cmp al, 120 ; if (al == 120){va a brincar a la etiqueta salir}else{va a continuar con el programa}
		je Salir

		print jp1
		obtenerTexto nombre1
		print salto

		print jp2 
		obtenerTexto nombre2
		print salto

	Juego:

		Turno1:
		mov seRepite,0
		mov jueganNegras,0
		print msjTurno
		print nombre1
		print juegaB
		print punteo
		print salto
		ImprimirTablero tablero
		print textoComando
		obtenerTexto comando
		print salto

		AnalizarComando comando

		print finJuego
		getChar ; lee un caracter del teclado y lo guarda en al
		cmp al, 120 ; if (al == 120){va a brincar a la etiqueta salir}else{va a continuar con el programa}
		je Menu 

		cmp seRepite,1 
		je Turno1

		jmp Turno2

		Turno2:
		mov seRepite,0
		mov jueganNegras,1
		print msjTurno
		print nombre2
		print juegaN
		print punteo
		print salto
		ImprimirTablero tablero
		print textoComando
		obtenerTexto comando

		AnalizarComando comando

		print finJuego

		getChar ; lee un caracter del teclado y lo guarda en al
		cmp al, 120 ; if (al == 120){va a brincar a la etiqueta salir}else{va a continuar con el programa}
		je Menu

		cmp seRepite,1 
		je Turno2

		jmp Turno1

		jmp Menu



	Salir:
		close

main endp
end main