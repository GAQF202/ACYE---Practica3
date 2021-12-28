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
LOCAL Mientras, FinMientras, Salto, PrintNegras, PrintFichaNegra, PrintEspacio, latrue, SegundoIf, PrintFichaBlanca, Modo1, comp, AlineacionBlanca1, AlineacionBlanca2, AlineacionNegra1, AlineacionNegra2
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

LlenarTableroInicial macro

	mov tablero[0], 0 ; tablero[0] = 0
	mov tablero[1], 1
	mov tablero[2], 95
	mov tablero[3], 1
	mov tablero[4], 95
	mov tablero[5], 1
	mov tablero[6], 95
	mov tablero[7], 1
	mov tablero[8], 95

	mov tablero[9], 95
	mov tablero[10], 1
	mov tablero[11], 95
	mov tablero[12], 1
	mov tablero[13], 95
	mov tablero[14], 1
	mov tablero[15], 95
	mov tablero[16], 1

	mov tablero[17], 1
	mov tablero[18], 95
	mov tablero[19], 1
	mov tablero[20], 95
	mov tablero[21], 1
	mov tablero[22], 95
	mov tablero[23], 1
	mov tablero[24], 95

	mov tablero[25], 95
	mov tablero[26], 95
	mov tablero[27], 95
	mov tablero[28], 95
	mov tablero[29], 95
	mov tablero[30], 95
	mov tablero[31], 98
	mov tablero[32], 95
	mov tablero[33], 95
	mov tablero[34], 95
	mov tablero[35], 95
	mov tablero[36], 95
	mov tablero[37], 95
	mov tablero[38], 95
	mov tablero[39], 95
	mov tablero[40], 95

	mov tablero[41], 95
	mov tablero[42], 2
	mov tablero[43], 95
	mov tablero[44], 2
	mov tablero[45], 95
	mov tablero[46], 2
	mov tablero[47], 95
	mov tablero[48], 2

	mov tablero[49], 2
	mov tablero[50], 95
	mov tablero[51], 2
	mov tablero[52], 95
	mov tablero[53], 2
	mov tablero[54], 95
	mov tablero[55], 2
	mov tablero[56], 95
	
	mov tablero[57], 95
	mov tablero[58], 2
	mov tablero[59], 95
	mov tablero[60], 2
	mov tablero[61], 95
	mov tablero[62], 2
	mov tablero[63], 95
	mov tablero[64], 2

endm