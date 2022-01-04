ModoVideo macro 
mov ah, 00h
mov al, 13h 
int 10h   
mov ax, 0A000h
mov ds, ax  ; DS = A000h (memoria de graficos).
endm 

ModoTexto macro  
mov ah, 00h 
mov al, 03h 
int 10h 
endm 


PintarMargen macro color 
LOCAL primera,segunda ,tercera, cuarta, tablero, salir, tableroHorizontal, lineaVertical, lineaHorizontal, pintarCuadroRojo, pintarLineaRoja, PintarBlancas, tableroVertical
mov dl, color
;empieza en pixel (i,j) = (20, 0) aplicando el mapeo  20 * 320 + 0  = 6400
;barra horizontal superior 
    mov di, 6410 
primera: 
    mov [di],dl    
    inc di ;para que pinte  a la derecha 
    cmp di, 6707 ; resultado de 20 * 320 + 319, el 319 significa que está en la última columna de la fila 
    jne primera


;barra horizontal inferior
; (i, j ) = (190, 0 )  => 180 * 320 + 0 = 57,600 
    mov di, 57610  ; se sumé 10 para el borde  
segunda: 
    mov [di],dl 
    inc di 
    cmp di, 57907 ; resultado de 180 * 320 + 319 = 57919 ,  le resté 10 por el borde
    jne segunda 

;barra vertical izq
    mov di , 6410  ; comenzamos en la primera posición de la barra horizontal superior
tercera: 
    mov [di],dl     
    add di, 320 ;ahora queremos pintar hacia abajo, por eso le sumamos los bytes de una fila, para que haga el cambio de fila 
    cmp di, 57610 ;terminamos en la primera posicion de la barra horizontal inferior   
    jne tercera 

;barra vertical derecha
    mov di , 6706 ; comenzamos en la ultima posicion de la barra horizontal superior
cuarta: 
    mov [di],dl     
    add di, 320 ;ahora queremos pintar hacia abajo, por eso le sumamos los bytes de una fila, para que haga el cambio de fila 
    cmp di, 57906 ;terminamos en la ultima posicion de la barra horizontal inferior 
    jne cuarta 

mov cx,8

mov ax,57610
mov bx,6410


tableroVertical:

    mov di, bx
    lineaVertical: 
        mov [di],dl     
        add di, 320 
        cmp di, ax  
        jne lineaVertical

    add ax,37
    add bx,37

    loop tableroVertical


mov cx,8

mov ax,6707
mov bx,6410

tableroHorizontal:

    mov di, bx
    lineaHorizontal: 
        mov [di],dl     
        inc di 
        cmp di, ax  
        jne lineaHorizontal

    add ax,6400
    add bx,6400

    loop tableroHorizontal

pintarCuadros 37
pintarCuadros 6400
pintarCuadros 12837
pintarCuadros 19200
pintarCuadros 25637
pintarCuadros 32000
pintarCuadros 38437
pintarCuadros 44800

salir:

endm 

pintarCuadros macro alineador
LOCAL ciclo
push cx
push si
mov cx,4
push dx
mov si,alineador
ciclo:
	pintarCuadro si
	add si,74
loop ciclo
pop dx
pop cx
pop si
endm

pintarCuadro macro sumador
LOCAL PintarLinea, Ver, pintarCuadroRojo, pintarLineaRoja

push cx


mov cx,36

mov ax,6731
mov bx,12811 

add ax,sumador
add bx,sumador

mov dl, 15 ; COLOR 
;push di

pintarCuadroRojo:
	push di ; POSIBLEEEE CAMBIOOO
	mov di, ax
	pintarLineaRoja:
		mov [di],dl     
		add di, 320 
		cmp di, bx  
		jne pintarLineaRoja

	add ax,1
	add bx,1
	pop di ; POSIBLEEEE CAMBIOOO

loop pintarCuadroRojo
pop cx
;pop di
endm

pintarPieza macro color, alineador
LOCAL DibujarPieza, Dibujar
push cx

mov cx,19

mov ax,7699
mov bx,11859 

add ax,alineador
add bx,alineador

mov dl, color ; COLOR 


DibujarPieza:

	mov di, ax
	Dibujar:
		mov [di],dl     
		add di, 320 
		cmp di, bx  
		jne Dibujar

	add ax,1
	add bx,1

loop DibujarPieza
pop cx
endm

pintarReina macro color, alineador, color2
LOCAL DibujarPieza, Dibujar, CambiarColor, Seguir, DibujarPieza1, Dibujar1, mantenerColor
push cx

mov cx,19

mov ax,7699
mov bx,11859 

add ax,alineador
add bx,alineador

mov dl, color ; COLOR 

DibujarPieza:

	mov di, ax
	Dibujar:
		cmp cx,8
		jg CambiarColor
		mantenerColor:
		mov [di],dl     
		add di, 320 
		jmp Seguir

		CambiarColor:
		cmp cx,11
		jg mantenerColor
		mov dl,color2
		mov [di],dl   
		add di, 320 
		mov dl,color

		Seguir:
		cmp di, bx  
		jne Dibujar

	add ax,1
	add bx,1

loop DibujarPieza
pop cx


push cx
mov cx,19
mov ax,9299
mov bx,10259 
add ax,alineador
add bx,alineador
mov dl, color2 ; COLOR 
DibujarPieza1:

	mov di, ax
	Dibujar1:
		mov [di],dl     
		add di, 320 
		cmp di, bx  
		jne Dibujar1

	add ax,1
	add bx,1

loop DibujarPieza1
pop cx
endm

PintarCuadrado macro posicion , color 
    push dx
	push di
    mov di, posicion    
    mov dl, color 
;pintamos los 3 bytes de la primera fila 
    mov [di], dl   ; estamos pasando el color 
    mov [di+1], dl   ; estamos pasando el color 
    mov [di+2], dl   ; estamos pasando el color 
;pintamos la siguiente fila, esas 3 casillas 
    mov [di+320], dl
    mov [di+321], dl
    mov [di+322], dl
;pintamos la siguiente fila, esas 3 casillas 
    mov [di+640], dl
    mov [di+641], dl
    mov [di+642], dl

    mov [di+960], dl
    mov [di+961], dl
    mov [di+962], dl
	pop di
    pop dx
endm

delay macro param   ;numero que queremos que se tarde
		push ax
		push bx
		xor ax, ax
		xor bx, bx
		;se asigna a ax y  comienza un ciclo
		;el ciclo solo se hace para perder tiempo
        mov ax,param
        ret2:
			dec ax  ;se decrementa ax de manera que llegue a 0 
			jz finRet
			mov bx, param  ;mientras  ax no sea 0, se asigna el parametro a bx 
			ret1:
				dec bx
			jnz ret1
		jmp ret2                
        finRet:
        pop bx
		pop ax
    endm 

imprimirVideo macro caracter, color
    mov ah, 09h
    mov al, caracter ;al guarda el valor que vamos a escribir
    mov bh, 0
    mov bl, color
    mov cx,1
    int 10h
endm

printVideo macro buffer,color,size
mov ah,13h
mov al,01h
mov bh,00h
mov bl,color
lea bp,buffer
mov cl,size
int 10h
endm

printTurnoVideo macro
posicionarCursor 1,1  ;posicionar cursors (y,x)

imprimirVideo 'T' , 10

posicionarCursor 1,2  ;posicionar cursors (y,x)

imprimirVideo 'u' , 10

posicionarCursor 1,3  ;posicionar cursors (y,x)

imprimirVideo 'r' , 10

posicionarCursor 1,4  ;posicionar cursors (y,x)

imprimirVideo 'n' , 10

posicionarCursor 1,5  ;posicionar cursors (y,x)

imprimirVideo 'o' , 10

posicionarCursor 1,6  ;posicionar cursors (y,x)

imprimirVideo ':' , 10
endm

printAzulVideo macro
posicionarCursor 1,8  ;posicionar cursors (y,x)

imprimirVideo 'A' , 9

posicionarCursor 1,9  ;posicionar cursors (y,x)

imprimirVideo 'z' , 9

posicionarCursor 1,10  ;posicionar cursors (y,x)

imprimirVideo 'u' , 9

posicionarCursor 1,11  ;posicionar cursors (y,x)

imprimirVideo 'l' , 9
endm

printRojoVideo macro
posicionarCursor 1,8  ;posicionar cursors (y,x)

imprimirVideo 'R' , 12

posicionarCursor 1,9  ;posicionar cursors (y,x)

imprimirVideo 'o' , 12

posicionarCursor 1,10  ;posicionar cursors (y,x)

imprimirVideo 'j' , 12

posicionarCursor 1,11  ;posicionar cursors (y,x)

imprimirVideo 'o' , 12
endm


posicionarCursor macro y,x
    mov ah,02h
    mov dh,y
    mov dl,x
    mov bh,0
    int 10h
endm

print macro buffer ;imprime cadena
push ax
push dx

	mov ax, @data
	mov ds,ax
	mov ah,09h ;Numero de funcion para imprimir buffer en pantalla
	mov dx,offset buffer ;equivalente a que lea dx,buffer, inicializa en dx la posicion donde comienza la cadena
	int 21h

pop dx
pop ax
endm

close macro ;cierra el programa
	mov ah, 4ch ;Numero de funcion que finaliza el programa
	xor al,al
	int 21h
endm

getChar macro  ;obtiene el caracter y se almacena el valor en el registro al

	mov ah,01h ; se guarda en al en codigo hexadecimal
	int 21h

endm

;id_macro macro (variable1, variables2 ... variablen)
obtenerTexto macro buffer
LOCAL ObtenerChar, endTexto
	xor si,si ; xor si,si =	mov si,0
	
	;while (caracter != "/n"){
		;buufer[i] = caracter
		;i++
		;}
	ObtenerChar:
		getChar
		cmp al,0dh ; ascii de salto de linea en hexa
		je endTexto

		; si = 1

		mov buffer[si],al ;mov destino, fuente arreglo[1] = al
		; si = 2
		inc si ; si = si + 1 // si++
		jmp ObtenerChar

	endTexto:

		mov al,24h ; asci del singo dolar $
		mov buffer[si], al 

endm



obtenerRuta macro buffer
LOCAL ObtenerChar, endTexto
	xor si,si ; xor si,si =	mov si,0
	
	ObtenerChar:
		getChar
		cmp al,0dh ; ascii de salto de linea en hexa
		je endTexto
		mov buffer[si],al ;mov destino, fuente
		inc si ; si = si + 1
		jmp ObtenerChar

	endTexto:
		mov al,00h ;
		mov buffer[si], al  
endm

abrir macro buffer,handler

	mov ah,3dh
	mov al,02h ;010b 2d
	lea dx,buffer
	int 21h
	jc Error1
	mov handler,ax ;C:/arichi.txt ----- 1245h

endm

cerrar macro handler
	
	mov ah,3eh
	mov bx, handler
	int 21h
	;jc Error2
	mov handler,ax

endm

leer macro handler,buffer, numbytes
	
	mov ah,3fh
	mov bx,handler
	mov cx,numbytes
	lea dx,buffer ; mov dx,offset buffer 
	int 21h
	;jc  Error5

endm

limpiar macro buffer, numbytes, caracter
LOCAL Repetir
push si
push cx

	xor si,si
	xor cx,cx
	mov	cx,numbytes
	;si = 0
	Repetir:
		mov buffer[si], caracter
		inc si ; si ++
		Loop Repetir
pop cx
pop si
endm

crear macro buffer, handler
	
	mov ah,3ch
	mov cx,00h
	lea dx,buffer
	int 21h
	;ya cree el archivo
	;jump carry si la bandera de accareo esta en 1 se ejecuta
	;jc Error4
	mov handler, ax

endm

escribir macro handler, buffer, numbytes

	mov ah, 40h
	mov bx, handler
	mov cx, numbytes
	lea dx, buffer
	int 21h
	;jc Error3

endm



StringToInt macro string
LOCAL Unidades,Decenas,salir, Centenas

	sizeNumberString string; en la variable bl me retorna la cantidad de digitos
	xor ax,ax
	xor cx,cx

	cmp bl,1
	je Unidades

	cmp bl,2
	je Decenas

	cmp bl,3
	je Centenas



	Unidades:
		mov al,string[0]
		SUB al,30h
		jmp salir

	Decenas:

		mov al,string[0]
		sub al,30h
		mov bl,10
		mul bl


		xor bx,bx
		mov bl,string[1]
		sub bl,30h

		add al,bl

		jmp salir

;bl 1111 1111 ->255
; 0 - 999 
; bx 1111 1111 1111 1111 -> 65535
	Centenas:
	    ;543
		mov al,string[0] ;[0] -> 53 -> 5 en ascii
		sub al,30h;  -> 53-48 = 5 => Ax=5 => Ax-Ah,Al
		mov bx,100;  -> bx = 100
		mul bx; -> ax*bx = 5*100 = 500
		mov cx,ax; cx = 500
		;dx = Centenas

		xor ax,ax ; ax = 0
		mov al,string[1] ;[1] -> 52 -> 4 en ascii
		sub al,30h ; -> 52-48 = 4 => Ax=4 => Ax-Ah,Al
		mov bx,10 ;  -> bx = 10
		mul bx ; -> ax*bx = 4*10 = 40

		xor bx,bx
		mov bl,string[2] ;[2] -> 51 -> 3 en ascii
		sub bl,30h ; -> 51-48 = 3 => Ax=3 => Ax-Ah,Al

		add ax,bx ; ax = 3 + 40
		add ax,cx ; ax = 43 + 500 = 543
		
		jmp salir

	salir:
	

endm

;1.1
;[49][46][49]
;ax = entera
;bx = decimal
IntToString macro num, number ; ax 1111 1111 1111 1111 -> 65535
LOCAL Inicio,Final,Mientras,MientrasN,Cero,InicioN
push si
push di
limpiar number,SIZEOF number,24h
mov ax,num ; ax = numero entero a convertir 23
cmp ax,0 
je Cero
xor di,di
xor si,si
jmp Inicio

;ax = 123

Inicio:
	
	cmp ax,0 ;ax = 0
	je Mientras
	mov dx,0 
	mov cx,10 
	div cx ; 1/10 = ax = 0 dx = 2
	mov bx,dx 
	add bx,30h ; 1 + 48 = ascii 
	push bx 
	inc di	; di = 3
	jmp Inicio

Mientras:
	;si = 0 , di = 3
	cmp si,di 
	je Final
	pop bx 
	mov number[si],bl 
	inc si 
	;si = 2 di = 3
	jmp Mientras

Cero:
 mov number[0],30h
 jmp Final

Final:
pop di
pop si


endm

sizeNumberString macro string
LOCAL LeerNumero, endTexto
	xor si,si ; xor si,si =	mov si,0
	xor bx,bx

	LeerNumero:
		mov bl,string[si] ;mov destino, fuente
		cmp bl,24h ; ascii de signo dolar
		je endTexto
		inc si ; si = si + 1
		jmp LeerNumero

	endTexto:
		mov bx,si

endm

FloatToString macro entera, decimal, number

LOCAL Inicio,Final,MientrasEntero,Cero,FinalEntero, InicioDecimal, MientrasDecimal
push si
push di

limpiar number,SIZEOF number,24h
mov ax,entera ; ax = numero entero a convertir
cmp ax,0 
je Cero
xor di,di
xor si,si
jmp Inicio


Inicio:
	;514
	cmp ax,0 ; ax = 0 -> Brinca a mientras
	je MientrasEntero
	mov dx,0 ;dx = 0
	mov cx,10 ; cx = 10
	div cx ; ax / 10 ->   resultado => ax=0 ! residuo => dx = 1 
	mov bx,dx ; bx = residuo de la division = 1
	add bx,30h ; residuo => residuo + 30h => numero convertido a su valor en ascii
	push bx ; numero convertido a su valor en ascii en la pila [1] = 49 415
	inc di	; di = di + 1
	jmp Inicio

MientrasEntero:
;514
	cmp si,di ; di = 2 ! si = 1
	je FinalEntero
	pop bx ; bx = [0] = 52
	mov number[si],bl ; numero[1] = 52
	inc si ; si =1
	jmp MientrasEntero

Cero:
 mov number[0],30h
 jmp Final

FinalEntero:
;12.4
;si = 2
;Se termina de convertir la parte entera a texto
;Se asigna el punto decimal

mov number[si],46
inc si
inc di

;si = 3
;di = 3

mov ax,decimal ; ax = numero entero a convertir
cmp ax,0 
je CeroDecimal
jmp InicioDecimal


InicioDecimal:
	;514
	cmp ax,0 ; ax = 0 -> Brinca a mientras
	je MientrasDecimal
	mov dx,0 ;dx = 0
	mov cx,10 ; cx = 10
	div cx ; ax / 10 ->   resultado => ax=0 ! residuo => dx = 1 
	mov bx,dx ; bx = residuo de la division = 1
	add bx,30h ; residuo => residuo + 30h => numero convertido a su valor en ascii
	push bx ; numero convertido a su valor en ascii en la pila [1] = 49 415
	inc di	; di = di + 1
	jmp InicioDecimal

MientrasDecimal:
;514
	cmp si,di ; di = 7 ! si = 4
	je Final
	pop bx ; bx = [0] = 52
	mov number[si],bl ; numero[1] = 52
	inc si ; si =1
	jmp MientrasDecimal

CeroDecimal:
 mov number[si],30h
 jmp Final


Final:


pop di
pop si


endm


DivisionConDecimal macro num1, num2 ; 13 / 5
LOCAL ForAux,Final

	mov ax,num1 ;13
	mov bx,num2 ; 5
	div bx ;13/5 -> ax = 2 ! dx = 3
	mov residuo,dx
	mov resultadorDivisionEntero,ax ; 2

	ForAux:
		cmp residuo,0
		je Final
		mov bx,10 ; bx = 10
		mov ax, residuo ;ax = 3
		mul bx ; ax = 10*3 = 30
		mov bx,num2 ;bx = 5
		div bx ; 30/5
		mov residuo,dx
		mov resultadorDivisionDecimal,ax
		jmp ForAux

Final:

endm


agregarExt macro ruta

LOCAL Mientras, FinMientras
	xor si,si ; xor si,si =	mov si,0
	;hola
	;0 -> h ascii
	;
	Mientras:
		mov al,ruta[si] ;mov destino, fuente
		inc si ; si++
		cmp al,00h ; ascii de signo nulo
		je FinMientras
		jmp Mientras

	FinMientras:
		;ruta[4]
		dec si
		mov ruta[si], 2Eh ; .
		inc si
		mov ruta[si], 78h ; x
  		inc si
  		mov ruta[si], 6Dh ; m
  		inc si
  		mov ruta[si], 6Ch ; l
  		inc si
  		mov ruta[si], 00h ;caracter nulo al final
  

endm

ContarUnidades macro numero
LOCAL Mientras, FinMientras

xor si,si ;registro de 16 bits
xor bx,bx

	Mientras:
	mov al,numero[si]
	cmp al,24h ;cuando encontremos $ dejamos el contador
	je FinMientras
	inc si
	jmp Mientras

	FinMientras:
	;si el contador vale 2 el numero es > 9 si el contador vale 1 el numero <10
	mov bx,si ;bl nos indica si son unidades o si son decenas
	; como sabemos que el numero  <2 sabemos que el resultado de guarda en bl
endm

TextoAEntero macro texto ;en el registo al se va a guardar el numero convertido
LOCAL Unidades, Decenas, Final
xor al,al
ContarUnidades texto
;bl me indica si el numero tiene unidades o tiene decenas

cmp bl,1
je Unidades
cmp bl,2
je Decenas
jmp Final

	Unidades:
		;texto[0] -> numero de unidades en ascii
		mov al,texto[0]
		sub al, 48 ; al = al - 48
		jmp Final


	Decenas:
		
		;texto[0]-> numero de decenas en ascii
		;texto[1]-> numero de unidades en ascii
		mov al,texto[0]
		sub al,48 ; ya tengo las decenas en su valor decimal 45 -> 4
		mov bl,10
		mul bl ; al = al * bl
		;al = 40

		xor bl,bl
		mov bl, texto[1]
		sub bl, 48 ; bl = 5

		add al,bl ;  al = 40 +5

		jmp Final

	Final:

endm

EnteroATexto macro numero, texto
LOCAL Unidades, Decenas, Final
xor al,al

mov al,numero
cmp al,9 ;numero > 9 tiene decenas
ja Decenas
jmp Unidades

	Unidades:
		add al,48 ;2+48 = 50
		mov texto[0],al
		jmp Final
	


	Decenas:

		xor bl,bl
		;al tiene el numero completo 45
		mov bl,10

		div bl ; 45/10 al = 4 y ah = 5

		add al,48
		mov texto[0],al
		
		add ah,48
		mov texto[1],ah

		jmp Final



	Final:

endm


AgregarId macro arreglo, global
LOCAL Mientras, FinMientras, FinMientras2

	xor si,si
	xor di,di
	Mientras:
		mov al,global[si] ;mov destino, fuente
		inc si ; si++
		cmp al, 36 ; ascii de signo nulo
		je FinMientras
		jmp Mientras

	FinMientras:
		mov di,1
		mov al, arreglo[di] ;mov destino, fuente
		dec si
		mov global[si], al
		inc di
		inc si
		cmp al, 36 ; ascii de signo nulo
		je FinMientras2
		jmp FinMientras

	FinMientras2:
		mov al, 59
		mov global[si], al			

endm

TableroInicial macro arreglo, tam
LOCAL Mientras, FinMientras, Salto, PrintNegras, PrintFichaNegra, PrintEspacio, latrue, SegundoIf, PrintFichaBlanca, Modo1, comp, AlineacionBlanca1, AlineacionBlanca2, AlineacionNegra1, AlineacionNegra2, i0, i01, i1, i2, i3, PrintBlancas, blancas
push ax

    xor si,si
    xor di,di

    Mientras:

        cmp si, 7
        jg i0
        jmp comp

        i0:
        cmp si,15
        jg i01
        mov di,1
        jmp comp

        i01:
        cmp si,24
        jg blancas
        mov di,0
        jmp comp    

        blancas:
        cmp si,32
        jg i1

        i1:
        cmp si,47
        jg i2
        mov di, 1
        jmp comp

        i2:
        cmp si,55
        jg i3
        mov di, 0
        jmp comp

        i3:
        mov di, 1

        comp:

        cmp si,tam
        jg FinMientras
        jmp latrue

        latrue:

            inc si ;si++
            mov ax,si ; ax = si
            mov bl,2 ; bl = 2
            div bl ; ax / bl

            cmp si,24
            jl PrintNegras
            jg SegundoIf
            ;jmp FinMientras

            PrintNegras: ; INICIA ALMACENAMIENTO DE FICHAS NEGRAS
            cmp di, 0
            je AlineacionNegra1
            jmp AlineacionNegra2

                AlineacionNegra1:
                    cmp ah,0
                    je PrintEspacio ; je == 0
                    jmp PrintFichaNegra

                AlineacionNegra2:
                    cmp ah,0
                    je PrintFichaNegra ; je == 0
                    jmp PrintEspacio

                PrintFichaNegra:
                    mov tablero[si], 1
                    jmp Mientras

            SegundoIf:
                cmp si,40
                jg PrintBlancas
                jmp PrintEspacio

            PrintBlancas: ; INICIA ALMACENAMIENTO DE FICHAS BLANCAS

            cmp di, 0
            je AlineacionBlanca1
            jmp AlineacionBlanca2

                AlineacionBlanca1:
                    cmp ah,0
                    je PrintEspacio ; je == 0
                    jmp PrintFichaBlanca

                AlineacionBlanca2:
                    cmp ah,0
                    je PrintFichaBlanca ; je == 0
                    jmp PrintEspacio

                PrintFichaBlanca:
                    mov tablero[si], 2
                    jmp Mientras

            PrintEspacio:
                mov tablero[si], 95

    jmp Mientras 

    FinMientras:

pop ax
endm

limpiarTexto macro arreglo,tam,caracter,caracterRemove
LOCAL Repetir, ContinuacionMientras, EliminarDolar
push si
push cx

	xor si,si
	xor cx,cx
	mov	cx,tam
	;si = 0
	Repetir:
		mov al,arreglo[si]
		cmp al,caracterRemove
		je EliminarDolar
		inc si ; si ++
		jmp ContinuacionMientras

	
	EliminarDolar:
	mov arreglo[si],caracter
	inc si
	jmp ContinuacionMientras

	ContinuacionMientras:
	Loop Repetir

pop cx
pop si
endm

CrearTableroHtml macro arreglo
LOCAL Mientras, FinMientras, ImprimirSalto, EscribirBlanca, EscribirNegra, Seguir, EscribirEspacio, SeguirEscribiendo, PunteoBlancas, EscribirReinaNegra, EscribirReinaBlanca


; SE CREA EL ARCHIVO
crear nombreArchivo, handler
escribir handler, abrirHtml, SIZEOF abrirHtml
escribir handler, estilosCSS1, SIZEOF estilosCSS1
escribir handler, saltoRep, SIZEOF saltoRep
escribir handler, estilosCSS2, SIZEOF estilosCSS2
escribir handler, saltoRep, SIZEOF saltoRep
escribir handler, estilosCSS3, SIZEOF estilosCSS3
escribir handler, saltoRep, SIZEOF saltoRep
escribir handler, estilosCSS4, SIZEOF estilosCSS4
escribir handler, saltoRep, SIZEOF saltoRep
escribir handler, abrirTabla, SIZEOF abrirTabla
escribir handler, abrirFila, SIZEOF abrirFila

escribir handler, abrirParrafo, SIZEOF abrirParrafo
escribir handler, nombresHtml, SIZEOF nombresHtml

limpiarTexto nombre1,SIZEOF nombre1,32,36 ; LIMPIA LA COPIA DEL NOMBRE DEL JUGADOR
escribir handler, nombre1, SIZEOF nombre1
limpiarTexto separadorHtml,SIZEOF separadorHtml,32,36 ; LIMPIA LA COPIA DEL NOMBRE DEL JUGADOR
escribir handler, separadorHtml, SIZEOF separadorHtml
limpiarTexto nombre2,SIZEOF nombre2,32,36 ; LIMPIA LA COPIA DEL NOMBRE DEL JUGADOR
escribir handler, nombre2, SIZEOF nombre2

escribir handler, saltoHtml, SIZEOF saltoHtml
escribir handler, punteoHtml, SIZEOF punteoHtml
cmp jueganNegras,1
je PunteoBlancas
limpiarTexto punteoTexto1,SIZEOF punteoTexto1,32,36 ; LIMPIA LA COPIA DEL PUNTEO
escribir handler, punteoTexto1, SIZEOF punteoTexto1

escribir handler, saltoHtml, SIZEOF saltoHtml
escribir handler, porcentajePiezasHtml, SIZEOF porcentajePiezasHtml
IntToString piezasRestantesA,porcentajTexto2
limpiarTexto porcentajTexto2,SIZEOF porcentajTexto2,32,36 ; LIMPIA LA COPIA DEL PUNTEO
escribir handler, porcentajTexto2, SIZEOF porcentajTexto2
limpiarTexto simboloPorcentaje,SIZEOF simboloPorcentaje,32,36 ; LIMPIA LA COPIA DEL %
escribir handler, simboloPorcentaje, SIZEOF simboloPorcentaje
jmp SeguirEscribiendo

PunteoBlancas:
limpiarTexto punteoTexto2,SIZEOF punteoTexto2,32,36 ; LIMPIA LA COPIA DEL PUNTEO
escribir handler, punteoTexto2, SIZEOF punteoTexto2

escribir handler, saltoHtml, SIZEOF saltoHtml
escribir handler, porcentajePiezasHtml, SIZEOF porcentajePiezasHtml
IntToString piezasRestantesR,porcentajTexto1
limpiarTexto porcentajTexto1,SIZEOF porcentajTexto1,32,36 ; LIMPIA LA COPIA DEL PUNTEO
escribir handler, porcentajTexto1, SIZEOF porcentajTexto1
limpiarTexto simboloPorcentaje,SIZEOF simboloPorcentaje,32,36 ; LIMPIA LA COPIA DEL %
escribir handler, simboloPorcentaje, SIZEOF simboloPorcentaje

SeguirEscribiendo:
escribir handler, cerrarParrafo, SIZEOF cerrarParrafo

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

			cmp aux,95
			je EscribirEspacio
			cmp aux,2
			je EscribirBlanca
			cmp aux,1
			je EscribirNegra
			cmp aux,20
			je EscribirReinaNegra
			cmp aux,21
			je EscribirReinaBlanca

			EscribirEspacio:
			escribir handler, abrirColumna, SIZEOF abrirColumna
			escribir handler, espacioRep, SIZEOF espacioRep
			escribir handler, cerrarColumna, SIZEOF cerrarColumna
			jmp Seguir
			;print aux

			EscribirBlanca:
			escribir handler, fichaBlancaHtml, SIZEOF fichaBlancaHtml
			jmp Seguir

			EscribirNegra:
			escribir handler, fichaNegraHtml, SIZEOF fichaNegraHtml
			jmp Seguir

			EscribirReinaNegra:
			escribir handler, reinaNegraHtml, SIZEOF reinaNegraHtml
			jmp Seguir

			EscribirReinaBlanca:
			escribir handler, reinaBlancaHtml, SIZEOF reinaBlancaHtml
			jmp Seguir

			Seguir:

			cmp di,7;3
			je ImprimirSalto	 ; if(di == 3){ Imprimir salto}


			mov aux,32   		; else{print(" ")
			;print aux
			

			inc di				;di++
			inc si   			; si++}
		jmp Mientras

	ImprimirSalto:
		xor di,di 			; di = 0
		escribir handler, cerrarFila, SIZEOF cerrarFila 
		escribir handler, abrirFila, SIZEOF abrirFila
		escribir handler, saltoRep, SIZEOF saltoRep
		;print salto			;print("/n")
		inc si  			; si++
		jmp Mientras

	FinMientras:
	escribir handler, cerrarFila, SIZEOF cerrarFila
	escribir handler, cerrarTabla, SIZEOF cerrarTabla
	escribir handler, cerrarHtml, SIZEOF cerrarHtml

pop di
pop si
cerrar handler
endm

CrearTableroVideo macro arreglo
LOCAL ciclo, finCiclo, Mientras, FinMientras, ImprimirSalto, EscribirBlanca, EscribirNegra, Seguir, EscribirEspacio, SeguirEscribiendo, PunteoBlancas, EscribirReinaNegra, EscribirReinaBlanca, CambioDeFila
push cx
push si
mov cx,1
xor si,si
push dx


ciclo:
	cmp cx,65
	je finCiclo

	
	mov di,cx
	mov al, arreglo[di]
	;mov aux, al 		   ; print(arreglo[si])

	cmp al,95
	je EscribirEspacio
	cmp al,2
	je EscribirBlanca
	cmp al,1
	je EscribirNegra
	cmp al,20
	je EscribirReinaNegra
	cmp al,21
	je EscribirReinaBlanca

	EscribirEspacio:
	;pintarPieza 12,30
	add alineadorTablero,37
	jmp Seguir
	;print aux

	EscribirBlanca:
	pintarPieza 9,alineadorTablero
	add alineadorTablero,37
	jmp Seguir

	EscribirNegra:
	pintarPieza 12,alineadorTablero
	add alineadorTablero,37
	jmp Seguir

	EscribirReinaNegra:
	pintarReina 12,alineadorTablero,8
	add alineadorTablero,37
	;pintarPieza 12,alineadorTablero
	jmp Seguir

	EscribirReinaBlanca:
	pintarReina 9,alineadorTablero,29
	add alineadorTablero,37
	;pintarPieza 12,alineadorTablero
	jmp Seguir

	Seguir:

	cmp si,7;3
	je CambioDeFila	 ; if(di == 3){ Imprimir salto}

	inc si
	inc cx
	jmp ciclo

	CambioDeFila:
		xor si,si
		;pintarPieza 10,alineadorTablero
		add alineadorTablero,6104;103
		inc cx
		jmp ciclo

	
finCiclo:
pop dx
pop cx
pop si
endm

GuardarTableroPila macro tab ;Se guardan las posiciones del tablero del ultimo al primero, por que es una pila, el ultimo en entrar es el primero en salir
    LOCAL salir, mientras
    mov di,65

    mientras:
        dec di
        cmp di,0
        je salir
        mov al,tab[di]
        push ax
        jmp mientras

    salir:
endm

RecuperarTableroPila macro ;Se guardan las posiciones del tablero del ultimo al primero, por que es una pila, el ultimo en entrar es el primero en salir
    LOCAL salir, mientras
    mov di,0

    mientras:
        inc di
        cmp di,65
        je salir
        pop ax
        mov tablero[di],al
        jmp mientras

    salir:
endm