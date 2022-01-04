include macros2.asm ;archivo con los macros a utilizar


ImprimirTablero macro arreglo 
LOCAL Mientras, FinMientras, ImprimirSalto
push si
push di

xor si,si
mov si,1
xor di,di

mov contador,1 ; SE REINICIA EL CONTADOR
IntToString contador,numero ; CONVIERTO EL CONTADOR A STRING
print numero ; IMPRIMO EL NUMERO 1
print espacio ; IMPRIMO ESPACIO


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
		inc contador
		xor di,di 			; di = 0
		print salto			;print("/n")
		inc si  			; si++
		
		; MIENTRAS CONTADOR NO SEA IGUAL A NUEVE LO IMPRIME
		cmp contador,9 ; contador == 9
		je Mientras
		IntToString contador,numero
		print numero
		print espacio

		jmp Mientras

	FinMientras:

pop di
pop si
endm

AnalizarComando macro com ; A1:B2 arreglo1 = [A][1]; arreglo2 = [B][2]
LOCAL Ver, Seguir, Mover, Error, ValidarNegras, ValidarBlancas, SaltarFicha, SoloMover, IncrementoJugador1, ValidarReinaN, ValidarReinaB, CoronarNegras, CoronarBlancas, ValidarMovReina, validarComidaBlancas, limpiarEspacio

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

mov dx,di ; GUARDA EL INIDICE FINAL EN dx
mov cx,si ; GUARDA EL INDICE INICIAL EN cx

sub cx,dx ; cx = cx - dx

cmp tablero[si],20
je ValidarMovReina
cmp tablero[si],21
je ValidarMovReina

cmp jueganNegras,1
je ValidarNegras
jmp ValidarBlancas

ValidarNegras:
	cmp cx,-18 ; cx == -18
	mov restador,-9 ; RESTADOR PARA INDICAR LA POSICION QUE DEBE ELIMINARSE
	mov saltaFicha,1 ;INDICA QUE ES UN MOVIMIENTO SALTAFICHA
	je Mover
	cmp cx,-14 ; cx == -14
	mov restador,-7 ; RESTADOR PARA INDICAR LA POSICION QUE DEBE ELIMINARSE
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
	mov restador,9 ; RESTADOR PARA INDICAR LA POSICION QUE DEBE ELIMINARSE
	mov saltaFicha,1 ;INDICA QUE ES UN MOVIMIENTO SALTAFICHA
	je Mover
	cmp cx,14 ; cx == 14
	mov restador,7 ; RESTADOR PARA INDICAR LA POSICION QUE DEBE ELIMINARSE
	mov saltaFicha,1 ;INDICA QUE ES UN MOVIMIENTO SALTAFICHA
	je Mover
	cmp cx,9 ; cx == 9
	mov saltaFicha,0 ;INDICA QUE NO ES UN MOVIMIENTO SALTAFICHA
	je Mover
	cmp cx,7 ; cx == 7
	mov saltaFicha,0 ;INDICA QUE NO ES UN MOVIMIENTO SALTAFICHA
	je Mover
	jmp Error

ValidarMovReina:
	cmp cx,18 ; cx == 18
	mov restador,9 ; RESTADOR PARA INDICAR LA POSICION QUE DEBE ELIMINARSE
	mov saltaFicha,1 ;INDICA QUE ES UN MOVIMIENTO SALTAFICHA
	je Mover
	cmp cx,14 ; cx == 14
	mov restador,7 ; RESTADOR PARA INDICAR LA POSICION QUE DEBE ELIMINARSE
	mov saltaFicha,1 ;INDICA QUE ES UN MOVIMIENTO SALTAFICHA
	je Mover
	cmp cx,9 ; cx == 9
	mov saltaFicha,0 ;INDICA QUE NO ES UN MOVIMIENTO SALTAFICHA
	je Mover
	cmp cx,7 ; cx == 7
	mov saltaFicha,0 ;INDICA QUE NO ES UN MOVIMIENTO SALTAFICHA
	je Mover
	cmp cx,-18 ; cx == -18
	mov restador,-9 ; RESTADOR PARA INDICAR LA POSICION QUE DEBE ELIMINARSE
	mov saltaFicha,1 ;INDICA QUE ES UN MOVIMIENTO SALTAFICHA
	je Mover
	cmp cx,-14 ; cx == -14
	mov restador,-7 ; RESTADOR PARA INDICAR LA POSICION QUE DEBE ELIMINARSE
	mov saltaFicha,1 ;INDICA QUE ES UN MOVIMIENTO SALTAFICHA
	je Mover
	cmp cx,-9 ; cx == -9
	mov saltaFicha,0 ;INDICA QUE NO ES UN MOVIMIENTO SALTAFICHA
	je Mover
	cmp cx,-7 ; cx == -7
	mov saltaFicha,0 ;INDICA QUE NO ES UN MOVIMIENTO SALTAFICHA
	je Mover
	jmp Error

;-------------INICIA CAMBIO DE POSICION DE LA FICHA-----------------
Mover:

cmp saltaFicha,1
je SaltarFicha
jmp SoloMover

SaltarFicha:
mov bx,si ; bx = posicion inicial
sub bx,restador ; posicion inicial - restador

cmp jueganNegras,1 ; juegan negras == 1
jl validarComidaBlancas ; SI ES MENOR ENTONCES ES 0
cmp tablero[bx],1 ; COMPARA SI LA FICHA A COMER ES DEL COLOR CONTRARIO 
je Error ;SI ES DEL MISMO COLOR LA FICHA QUE SALTA ENTONCES SALTA ERROR
jmp limpiarEspacio
validarComidaBlancas:
cmp tablero[bx],2
je Error
jmp limpiarEspacio

limpiarEspacio:
mov tablero[bx],95 ; [ficha] = _

cmp jueganNegras, 0 ; jueganNegras == 0
je IncrementoJugador1 
sub piezasRestantesA,8 ; DECREMENTA LA CANTIDAD DE FICHAS RESTANTES JUGADOR 1
inc punteoJugador2 ; AUMENTAR EL PUTNEO DEL JUGADOR 2
;IntToString piezasRestantesA,porcentajTexto1
; COMIENZA CALCULO DE PORCENTAJE DE FICHAS AZULES
;sub piezasRestantesA,8
;mov bx,12
;xor dx,dx
;div bx
;mov bx,100
;mul bx
; TERMINA CALCULO DE PORCENTAJE DE FICHAS AZULES
jmp SoloMover
IncrementoJugador1:
sub piezasRestantesR,8 ; DECREMENTA LA CANTIDAD DE FICHAS RESTANTES JUGADOR 2
inc punteoJugador1 ; AUMENTAR EL PUNTEO DEL JUGADOR 1
;IntToString piezasRestantesR,porcentajTexto2
; COMIENZA CALCULO DE PORCENTAJE DE FICHAS ROJAS
;sub piezasRestantesR,8
;mov bx,12
;xor dx,dx
;div bx
;mov bx,100
;mul bx
; TERMINA CALCULO DE PORCENTAJE DE FICHAS ROJAS


SoloMover:
xor ax,ax
mov al, tablero[si] ;al = arreglo[si]
; ---VERIFICA QUE NO EXISTA UNA FICHA EN ESA POSICION---
cmp tablero[di],1
je Error
cmp tablero[di],2
je Error
; ---VERIFICA QUE NO EXISTA UNA FICHA EN ESA POSICION---
mov tablero[si],95 ;arreglo[si] = '_'
mov tablero[di],al ;arreglo[di] = arreglo[si]

cmp jueganNegras, 1
je ValidarReinaN
jmp ValidarReinaB
jmp Seguir

ValidarReinaN:
cmp di,58
jl Seguir
je CoronarNegras
cmp di,60
je CoronarNegras
cmp di,62
je CoronarNegras
cmp di,64
je CoronarNegras
jmp Seguir

ValidarReinaB:
cmp di,8
jg Seguir
je CoronarBlancas
cmp di,5
je CoronarBlancas
cmp di,3
je CoronarBlancas
cmp di,1
je CoronarBlancas
jmp Seguir

CoronarNegras:
mov tablero[di],20 ;arreglo[di] = ASCII 20
jmp Seguir

CoronarBlancas:
mov tablero[di],21 ;arreglo[di] = ASCII 21

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
enc db 0ah, 0dh, 'Universidad de San Carlos de Guatemala',0ah, 0dh,'Arquitectura de Ensambladores y Computadores 1' , 0ah, 0dh, 'Gerson Aaron Quinia Folgar 201904157' , 0ah, 0dh, 'Practica 3',0ah, 0dh, 'Inrese x si desea cerrar el programa' , '$'
jp1 db 0ah, 0dh, 'Jugador 1 ingrese su nombre:', '$'
jp2 db 0ah, 0dh, 'Jugador 2 ingrese su nombre:', '$'
msjTurno db 0ah, 0dh, 'Turno del jugador:', '$'
finJuego db 0ah, 0dh, 'Ingrese x para finalizar el juego', '$'
juegaB db 0ah, 0dh, 'Juega blancas', '$'
juegaN db 0ah, 0dh, 'Juega negras', '$'
simboloPorcentaje db ' %', '$'
punteo db 0ah, 0dh, 'Punteo actual: ', '$'
porcentajePiezas db 0ah, 0dh, 'Porcentaje de piezas: ', '$'
que db 0ah, 0dh, 'yeaaaaaaaaaa', '$'
errorDeMovimiento db 0ah, 0dh, 'Error: Movimiento invalido', '$'
salto db 0ah,0dh, '$' ,'$'
espacio db ' ', '$'
nombre1 db 10 dup('$'), '$'
nombre2 db 10 dup('$'), '$'

nombreRep1 db 10 dup('$'), '$'
nombreRep2 db 10 dup('$'), '$'

textoComando db 0ah, 0dh, 'Ingrese su comando:', '$'

posicionInicial db 2 dup('$'), '$'
posicionFinal db 2 dup('$'), '$'

; DATOS PARA CONTROL DE FICHAS 
posInit db 0
posFinish db 0
restador dw 0  
piezasRestantesA dw 100 ; CAMBIAR A 12
piezasRestantesR dw 100 ; CAMBIAR A 12
;porcentajeA dw 100
;porcentajeR dw 100

; DATOS PARA CONTROL DE PUNTEOS
punteoJugador1 dw 0
punteoJugador2 dw 0
punteoTexto1 db 2 dup('$'), '$'
punteoTexto2 db 2 dup('$'), '$'
punteoRep1 db 2 dup('$'), '$'
punteoRep2 db 2 dup('$'), '$'
porcentajTexto1 db 3 dup('$'), '$'
porcentajTexto2 db 3 dup('$'), '$'

alineadorTablero dw 37

valorInicial db 0, '$' 
valorFinal db 0, '$' 

aux db 0, '$' 
resultado db 0, '$'
columna db 0, '$'
fila db 0, '$'

punteoHtml db 0ah, 0dh, 'Punteo actual: ', ' '
nombresHtml db 0ah, 0dh, 'Jugadores: ', ' '
porcentajePiezasHtml db 0ah, 0dh, 'Porcentaje de piezas: ', ' '

; BANDERAS
bandera db 0
seRepite db 0
jueganNegras db 0 ; BANDERA PARA SABER QUE TURNO JUEGA
saltaFicha db 0 ; BANDERA PARA SABER SI INTENTA SALTAR FICHA
contador dw 1

tablero db 65 dup('$'), '$'

numero db 2 dup('$'), '$'

comando db 5 dup('$'), '$' ; A1:B2

comandoReporte db 5 dup('REP'), '$' 

handler dW ?
nombreArchivo db 'reporte.htm',0
saltoRep db 0ah,0dh, ' ' ,' '
espacioRep db ' ', ' '
fichaNormal db 0ah, 0dh, '&#8226', ' '

; ETIQUETAS PARA REPORTE EN HTML
abrirHtml db '<html>'
cerrarHtml db '</html>'
abrirParrafo db '<p>'
cerrarParrafo db '</p>'
abrirTabla db '<table id="tablero">'
cerrarTabla db '</table>'
abrirFila db '<tr>'
cerrarFila db '</tr>'
abrirColumna db '<td>'
cerrarColumna db '</td>'
saltoHtml db '</br>'
separadorHtml db ' / '

fichaBlancaHtml db '<td style="text-align:center; color:white;	">⚪</td>'
fichaNegraHtml db '<td style="text-align:center; color:black;	">⚫</td>'
reinaNegraHtml db '<td>&#9813</td>'
reinaBlancaHtml db '<td>&#x265B</td>'

estilosCSS1 db '<style>body{background: #00af2c;color: #eee;font-family: sans-serif;text-align: center;}'
estilosCSS2 db '#tablero{background: url(http://jesuscastillo.esy.es/DisenoInterfacesWeb/Tema4/imagenes/madera.jpeg);box-shadow: 0 10px 10px -6px rgba(0, 0, 0, .6);border-radius: 3px;border-collapse: collapse;width: 400px;height: 400px;margin: auto;}'
estilosCSS3 db '#tablero td{color: rgb(247, 240, 240);font-size: 36px;text-shadow: 1px 1px 1px rgba(255, 255, 255, 0.6);;width: 50px;height: 50px;}'
estilosCSS4 db '#tablero tr:nth-child(odd) td:nth-child(even),#tablero tr:nth-child(even) td:nth-child(odd){background: rgba(0, 0, 0, 0.5);}#tablero tr:nth-child(n+7) td{color: rgb(29, 28, 28);text-shadow: 1px 1px 1px rgba(0,0,0,0.6);}</style>'


;----------------SEGMENTO DE CODIGO---------------------


.code
main proc

	Menu:

		print enc
		print salto 
        TableroInicial tablero, SIZEOF tablero ; LLENADO INICIAL DEL TABLERO DE DAMAS
		GuardarTableroPila tablero
		

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
		mov jueganNegras,0 ; DESACTIVA BANDERA 


		; ENTRA EN MODO VIDEO
		ModoVideo
		printTurnoVideo
		printAzulVideo

		RecuperarTableroPila
		PintarMargen 10
		CrearTableroVideo tablero
		GuardarTableroPila tablero
		getChar
		
		; REGRESA AL MODO TEXTO
		ModoTexto
		RecuperarTableroPila

		; DATOS DEL JUGADOR
		print msjTurno
		limpiarTexto nombre1,SIZEOF nombre1,36,32 ; LIMPIA LA COPIA DEL NOMBRE DEL JUGADOR
		print nombre1
		print punteo
		print espacio
		IntToString punteoJugador2,punteoTexto2
		IntToString punteoJugador1,punteoTexto1
		print punteoTexto1

		print salto
		print porcentajePiezas
		print espacio
		IntToString piezasRestantesA,porcentajTexto1
		IntToString piezasRestantesR,porcentajTexto2
		limpiarTexto porcentajTexto1,SIZEOF porcentajTexto1,36,32 ; LIMPIA LA COPIA DEL NOMBRE DEL JUGADOR
		print  porcentajTexto1
		print simboloPorcentaje
		print salto

		print textoComando
		obtenerTexto comando
		print salto
		; ------------INICIA VERIFICACION DE ENTRADA---------------
		mov cx,3   ;Determinamos la cantidad de datos a leer/comparar
		mov AX,DS  ;mueve el segmento datos a AX
		mov ES,AX  ;Mueve los datos al segmento extra
		lea si,comando  ;cargamos en si la cadena que contiene vec
		lea di,comandoReporte ;cargamos en di la cadena que contiene vec2
		repe cmpsb  ;compara las dos cadenas
		je Reportar1 ;Si fueron iguales
		AnalizarComando comando
		jmp Continuar1

		Reportar1:
		mov seRepite,1
		CrearTableroHtml tablero
		jmp Continuar1

		Continuar1:
		GuardarTableroPila tablero
		; ------------TERMINA VERIFICACION DE ENTRADA---------------

		print finJuego
		getChar ; lee un caracter del teclado y lo guarda en al
		cmp al, 120 ; if (al == 120){va a brincar a la etiqueta salir}else{va a continuar con el programa}
		je Menu 


		cmp seRepite,1 
		je Turno1

		jmp Turno2

		Turno2:
		mov seRepite,0
		mov jueganNegras,1 ; ACTIVA BANDERA
		
		; ENTRA EN MODO VIDEO
		ModoVideo
		printTurnoVideo
		printRojoVideo

		RecuperarTableroPila
		PintarMargen 10
		CrearTableroVideo tablero
		GuardarTableroPila tablero
		getChar
		
		; REGRESA AL MODO TEXTO
		ModoTexto
		RecuperarTableroPila

		; DATOS DEL JUGADOR
		print msjTurno
		print nombre2
		print punteo
		print espacio
		IntToString punteoJugador1,punteoTexto1
		IntToString punteoJugador2,punteoTexto2
		print punteoTexto2

		print salto
		print porcentajePiezas
		print espacio
		IntToString piezasRestantesR,porcentajTexto2
		IntToString piezasRestantesA,porcentajTexto1
		print  porcentajTexto2
		print simboloPorcentaje
		print salto

		print textoComando
		obtenerTexto comando

		; ------------INICIA VERIFICACION DE ENTRADA---------------
		mov cx,3   ;Determinamos la cantidad de datos a leer/comparar
		mov AX,DS  ;mueve el segmento datos a AX
		mov ES,AX  ;Mueve los datos al segmento extra
		lea si,comando  ;cargamos en si la cadena que contiene vec
		lea di,comandoReporte ;cargamos en di la cadena que contiene vec2
		repe cmpsb  ;compara las dos cadenas
		je Reportar2 ;Si fueron iguales
		AnalizarComando comando
		jmp Continuar2

		Reportar2:
		mov seRepite,1
		CrearTableroHtml tablero
		jmp Continuar2

		Continuar2:

		; ------------TERMINA VERIFICACION DE ENTRADA---------------

		GuardarTableroPila tablero
		print finJuego

		getChar ; lee un caracter del teclado y lo guarda en al
		cmp al, 120 ; if (al == 120){va a brincar a la etiqueta salir}else{va a continuar con el programa}
		je Menu

		cmp seRepite,1 
		je Turno2

		jmp Turno1

		jmp Menu



	Salir:
		;CrearTableroHtml tablero
		close

main endp
end main