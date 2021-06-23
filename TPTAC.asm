;/--------------------------------------------------\
;|	             TRABALHO PRATICO DE                |
;|    TECNOLOGIAS E ARQUITETURAS DE COMPUTADORES    |
;|	           ANO LETIVO DE 2020/2021              |
;<-------------------------------------------------->
;|          João André Linhares Oliveira            |
;|                   2018012875                     |
;|         Pedro Miguel Pinheiro Miranda            |
;|                   2020139811                     |
;\--------------------------------------------------/

; ---------------------------------------------------------
; |!!!!!!!!!!!!!!!!! TP TAC - VARIANTE 2 !!!!!!!!!!!!!!!!!|
; ---------------------------------------------------------

; START

.8086
.model small
.stack 2048

; PILHA

PILHA	SEGMENT PARA STACK 'STACK'
		db 2048 dup(?)
PILHA	ENDS

; ---------------------------------------------------------

; DADOS E VARIAVEIS A USAR

; ---------------------------------------------------------

dseg	segment para public 'data' ; segmento de codigo "D"

        UserInputMenu   dw  ?

		; MENU INICIAL
		
        MenuOptions db "                                                          ",13,10
					db "                    **************************************",13,10
					db "                    *                                    *",13,10
					db "                    *                                    *",13,10
					db "                    *   ISEC - Trabalho Pratico de TAC   *",13,10
					db "                    *                                    *",13,10
					db "                    *                                    *",13,10
                    db "                    *   1. Jogar                         *",13,10
                    db "                    *   2. Top 10                        *",13,10
					db "                    *   3. Ajuda                         *",13,10
                    db "                    *   4. Sair                          *",13,10
					db "                    *                                    *",13,10
					db "                    *                                    *",13,10
					db "                    **************************************",13,10
					db "                                                          ",13,10
					db "                                                          ",13,10,'$'
					
		; MENU AJUDA

        Ajuda       db "                                                          ",13,10
					db "                    **************************************",13,10
					db "                    *                                    *",13,10
					db "                    *                Ajuda               *",13,10
					db "                    *                                    *",13,10
					db "                    *   Neste jogo seras colocado num    *",13,10
					db "                    *  labirinto. No labirinto, teras de *",13,10
                    db "                    *  guiar o teu avatar para encontrar *",13,10
                    db "                    *  as letras da palavra pedida.      *",13,10
					db "                    *   A medida que o fizeres, vais     *",13,10
                    db "                    *  passar de nivel, e seras pontuado *",13,10
					db "                    *  com base no tempo em que          *",13,10
					db "                    *  demoraste a completar os niveis.  *",13,10
                    db "                    *                                    *",13,10
                    db "                    *  Boa sorte!                        *",13,10
					db "                    *                                    *",13,10
					db "                    **************************************",13,10
					db "                                                          ",13,10
					db "                                                          ",13,10,'$'

		; TEXTO BEM VINDO

		Bem_Vindo	db "Bem-Vindo ao Jogo do Labirinto! Have fun ;) $"

		; VARIAVEIS ETC.
        
		;Parede			db		"177" ; deprecated
		TEMPVAR1		dw		0
		TEMPVAR2		db		0
		TEMPVAR3		dw		1
		TEMPVAR4		dw		0
		STR12	 		DB 		"            "	; String para 12 digitos
		STR10			DB		"          "
		DDMMAAAA 		db		"                     "
		
		; CONTADOR

		timer			dw 		'0'				; Contador de tempo
		Horas			dw		0				; Vai guardar a hora atual
		Minutos			dw		0				; Vai guardar os minutos actuais
		Segundos		dw		0				; Vai guardar os segundos actuais
		Old_seg			dw		0				; Guarda os ultimos segundos que foram lidos
		Tempo_init		dw		0				; Guarda o tempo de inicio do jogo
		Tempo_j			dw		0				; Guarda o tempo que decorre o jogo
		Tempo_limite	dw		100				; tempo maximo de Jogo
		String_TJ		db		"     / 100$"

		; PALAVRAS

		String_num 		db 		"  0 $"

		; strings manuais p/ficheiro

        String_Fich1  	db	    "ISEC  $"	
		String_Fich2  	db	    "ISEC  $"	
		String_Fich3  	db	    "ISEC  $"	

		; strings auto

		STRINGCHARS		dw		4
		STRINGSAUTO		db		"ISEC  $"
						db		"DEIS  $"
						db		"MASM  $"

		Construir_nome	db	    "            $"	
		Dim_nome		dw		5	; Comprimento do Nome
		indice_nome		dw		0	; indice que aponta para Construir_nome
		
		; FIM DO JOGO

		Fim_Ganhou		db	    " Ganhou $"	
		Fim_Perdeu		db	    " Perdeu $"	

		; FICHEIROS

        Erro_Open       db      'Erro ao tentar abrir o ficheiro$'
        Erro_Ler_Msg    db      'Erro ao tentar ler do ficheiro$'
        Erro_Close      db      'Erro ao tentar fechar o ficheiro$'
        Fich1         	db      'LAB1.TXT',0
        Fich2         	db      'LAB2.TXT',0
        Fich3         	db      'LAB3.TXT',0
        HandleFich      dw      0
        car_fich        db      ?

		; ???

		string			db	"Teste pratico de T.I",0
		Car				db	32	; Guarda um caracter do Ecra
		Cor				db	7	; Guarda os atributos de cor do caracter
		POSy			db  10	; a linha pode ir de [1 .. 25]
		POSx			db	40	; POSx pode ir [1..80]	
		POSya			db	3	; posicao anterior de y
		POSxa			db	3	; posicao anterior de x
			
		; Variáveis da criação de ficheiro
		
		fname	db	'TOP10.TXT',0
		fhandle dw	0
		buffer	db	'1 5 6 7 8 9 1 5 7 8 9 2 3 7 8 15 16 18 19 20 3',13,10
				db 	'+ - / * * + - - + * / * + - - + * / + - - + * ',13,10
				db	'10 12 14 7 9 11 13 5 10 15 7 8 9 10 13 5 10 11',13,10 
				db 	'/ * + - - + * / + - / * * + - - + * * + - - + ',13,10
				db	'3 45 23 11 4 7 14 18 31 27 19 9 6 47 19 9 6 51',13,10
				db	'______________________________________________',13,10
		msgErrorCreate	db	"Ocorreu um erro na criacao do ficheiro!$"
		msgErrorWrite	db	"Ocorreu um erro na escrita para ficheiro!$"
		msgErrorClose	db	"Ocorreu um erro no fecho do ficheiro!$"
		
		
		; Horas
		NUM_SP		db		"                    $" 	; Para apagar zona de ecra


		; testes do café
		wow		db	    " $"
		
dseg	ends ; fim do segmento "D"

; ---------------------------------------------------------

cseg	segment para public 'code' ; segmento "C" comeca

assume		cs:cseg, ds:dseg, ss:pilha

; ------------------------------------------------------------------

; MACROS

; macro para manusear posicoes no ecra "X,Y"

goto_xy	macro	POSx,POSy
		mov		ah,02h
		mov		bh,0		; numero da pagina
		mov		dl,POSx
		mov		dh,POSy
		int		10h
endm

; MOSTRA - Faz o display de uma string terminada em $

MOSTRA MACRO STR 

	MOV AH,09H

	LEA DX,STR 

	INT 21H

ENDM

; ------------------------------------------------------------------

; PROCEDIMENTO PARA LER UMA TECLA	

LE_TECLA	PROC
sem_tecla:
		call Trata_Horas
		MOV	AH,0BH
		INT 21h
		cmp AL,0
		je	sem_tecla
		
		
		MOV	AH,08H
		INT	21H
		MOV	AH,0
		CMP	AL,0
		JNE	SAI_TECLA
		MOV	AH, 08H
		INT	21H
		MOV	AH,1
SAI_TECLA:	
		RET
LE_TECLA	ENDP


; PROCEDIMENTO PARA APAGAR ECRA


apaga_ecra	proc
			mov		ax,0B800h
			mov		es,ax
			xor		bx,bx
			mov		cx,25*80
		
apaga:		mov		byte ptr es:[bx],' '
			mov		byte ptr es:[bx+1],7
			inc		bx
			inc 	bx
			loop	apaga
			ret
apaga_ecra	endp



; -------------------------------------------
; 			  CODIGO DOS NIVEIS
; -------------------------------------------

; -------------------------------------------

; -------------------------------------------
; IMP_FICH1 - ABRE E GERE FICHEIRO DO NIVEL 1
; -------------------------------------------

IMP_FICH1	PROC

		;abre ficheiro
        mov     ah,3dh
        mov     al,0
		; FICHEIRO = LABIRINTO 1
        lea     dx,Fich1
        int     21h
        jc      erro_abrir
        mov     HandleFich,ax
        jmp     ler_ciclo

erro_abrir:
        mov     ah,09h
        lea     dx,Erro_Open
        int     21h
        jmp     sai_f

ler_ciclo:
        mov     ah,3fh
        mov     bx,HandleFich
        mov     cx,1
        lea     dx,car_fich
        int     21h
		jc		erro_ler
		cmp		ax,0		;EOF?
		je		fecha_ficheiro
        mov     ah,02h
		mov		dl,car_fich
		int		21h
		jmp		ler_ciclo

erro_ler:
        mov     ah,09h
        lea     dx,Erro_Ler_Msg
        int     21h

fecha_ficheiro:
        mov     ah,3eh
        mov     bx,HandleFich
        int     21h
        jnc     sai_f
        mov     ah,09h
        lea     dx,Erro_Close
        Int     21h

imprime_palavra:				;por concluir
		goto_xy 22,11
		mov     ah,09h
        lea     dx,String_Fich1
        int     21h
        jnc     sai_f

sai_f:	
		RET
		
IMP_FICH1	endp		

; -------------------------------------------
; IMP_FICH2 - ABRE E GERE FICHEIRO DO NIVEL 2
; -------------------------------------------

IMP_FICH2	PROC

		;abre ficheiro
        mov     ah,3dh
        mov     al,0
		; FICHEIRO = LABIRINTO 2
        lea     dx,Fich2
        int     21h
        jc      erro_abrir2
        mov     HandleFich,ax
        jmp     ler_ciclo2

erro_abrir2:
        mov     ah,09h
        lea     dx,Erro_Open
        int     21h
        jmp     sai_f2

ler_ciclo2:
        mov     ah,3fh
        mov     bx,HandleFich
        mov     cx,1
        lea     dx,car_fich
        int     21h
		jc		erro_ler2
		cmp		ax,0		;EOF?
		je		fecha_ficheiro2
        mov     ah,02h
		mov		dl,car_fich
		int		21h
		jmp		ler_ciclo2

erro_ler2:
        mov     ah,09h
        lea     dx,Erro_Ler_Msg
        int     21h

fecha_ficheiro2:
        mov     ah,3eh
        mov     bx,HandleFich
        int     21h
        jnc     sai_f2

        mov     ah,09h
        lea     dx,Erro_Close
        Int     21h

imprime_palavra2:				;por concluir
		goto_xy 22,11
		mov     ah,09h
        lea     dx,String_Fich2
        int     21h
        jnc     sai_f2

sai_f2:	
		RET
		
IMP_FICH2	endp		

; -------------------------------------------
; IMP_FICH3 - ABRE E GERE FICHEIRO DO NIVEL 3
; -------------------------------------------

IMP_FICH3	PROC

		;abre ficheiro
        mov     ah,3dh
        mov     al,0
		; FICHEIRO = LABIRINTO 3
        lea     dx,Fich3
        int     21h
        jc      erro_abrir3
        mov     HandleFich,ax
        jmp     ler_ciclo3

erro_abrir3:
        mov     ah,09h
        lea     dx,Erro_Open
        int     21h
        jmp     sai_f3

ler_ciclo3:
        mov     ah,3fh
        mov     bx,HandleFich
        mov     cx,1
        lea     dx,car_fich
        int     21h
		jc		erro_ler3
		cmp		ax,0		;EOF?
		je		fecha_ficheiro3
        mov     ah,02h
		mov		dl,car_fich
		int		21h
		jmp		ler_ciclo3

erro_ler3:
        mov     ah,09h
        lea     dx,Erro_Ler_Msg
        int     21h

fecha_ficheiro3:
        mov     ah,3eh
        mov     bx,HandleFich
        int     21h
        jnc     sai_f3

        mov     ah,09h
        lea     dx,Erro_Close
        Int     21h

imprime_palavra3:				;por concluir
		goto_xy 22,11
		mov     ah,09h
        lea     dx,String_Fich3
        int     21h
        jnc     sai_f3

sai_f3:	
		RET
		
IMP_FICH3	endp		

; ------------------------------------------------------------------
; ------------------------------------------------------------------
; ------------------------------------------------------------------

; PROCS. PARA A PALAVRA A COMPLETAR NO JOGO

; ------- MODO MANUAL - DEPRECATED ---------

; PALAVRA_A_COMPLETAR1	PROC
; 	; Palavra a procurar
; 	goto_xy	10,21			; Mostra a palavra que o utilizador deve completar no labirinto 1
; 	mov     ah, 09h
; 	lea     dx, String_Fich1
; 	int		21H	
; PALAVRA_A_COMPLETAR1	ENDP

; PALAVRA_A_COMPLETAR2	PROC
; 	; Palavra a procurar
; 	goto_xy	10,21			; Mostra a palavra que o utilizador deve completar no labirinto 2
; 	mov     ah, 09h
; 	lea     dx, String_Fich2
; 	int		21H	
; PALAVRA_A_COMPLETAR2	ENDP

; PALAVRA_A_COMPLETAR3	PROC
; 	; Palavra a procurar
; 	goto_xy	10,21			; Mostra a palavra que o utilizador deve completar no labirinto 3
; 	mov     ah, 09h
; 	lea     dx, String_Fich3
; 	int		21H	
; PALAVRA_A_COMPLETAR3	ENDP

; ------------- MODO AUTOMATICO ------------

; PROCEDIMENTO PARA CALCULAR UMA PALAVRA ALEATORIA

PalavRandom proc

			mov ah, 0
			int 1ah
			mov ax,dx
			mov dx,0
			mov bx, STRINGCHARS
			div bx
			mov TEMPVAR4,dx
			ret

PalavRandom endp


PALAVRA_A_COMPLETAR1	PROC
	
	goto_xy	11,20

	call	PalavRandom ; vai pedir uma palavra aleatoria ao proc
	mov		ax, TEMPVAR4
	xor		bx,bx
	mov		bx, 10
	mul		bx
	mov		SI, ax
	mov		TEMPVAR4, SI

	mov		ah, 09h
	
	lea		dx, STRINGSAUTO[SI] ; mostra a palavra escolhida
	int		21h

	ret

PALAVRA_A_COMPLETAR1	ENDP

PALAVRA_A_COMPLETAR2	PROC
	
	goto_xy	11,20

	call	PalavRandom
	mov		ax, TEMPVAR4
	xor		bx,bx
	mov		bx, 10
	mul		bx
	mov		SI, ax
	mov		TEMPVAR4, SI

	mov		ah, 09h
	
	lea		dx, STRINGSAUTO[SI]
	int		21h

	ret

PALAVRA_A_COMPLETAR2	ENDP

PALAVRA_A_COMPLETAR3	PROC
	
	goto_xy	11,20

	call	PalavRandom
	mov		ax, TEMPVAR4
	xor		bx,bx
	mov		bx, 10
	mul		bx
	mov		SI, ax
	mov		TEMPVAR4, SI

	mov		ah, 09h
	
	lea		dx, STRINGSAUTO[SI]
	int		21h

	ret

PALAVRA_A_COMPLETAR3	ENDP


TEMPO_TIMER	PROC
	; Mostra qt tempo / 100
	goto_xy	57,0
	mov     ah, 09h
	lea     dx, String_TJ
	int		21H	
TEMPO_TIMER	ENDP


; ---------------------------------------------------------

; PROCEDIMENTO QUE GERE O AVATAR

; ---------------------------------------------------------


AVATAR	PROC

	START:		
			mov		ax,0B800h
			mov		es,ax

			goto_xy	POSx,POSy		; Vai para nova posição

			mov 	ah, 08h			; Guarda o Caracter que está na posição do Cursor
			mov		bh,0			; numero da página
			int		10h			

			mov		Car, al			; Guarda o Caracter que está na posição do Cursor
			mov		Cor, ah			; Guarda a cor que está na posição do Cursor

			jmp 	CICLO


	PAREDE:
			mov		al, POSxa	    ; Guarda a posicao do cursor
			mov		POSx, al
			mov		al, POSya	    ; Guarda a posicao do cursor
			mov 	POSy, al

			jmp 	START
	
	; ADICIONAR:
	; 		goto_xy	9,22
	; 		mov     ah, 09h
	; 		mov		Construir_nome, 'I'
	; 		lea		ax,	Construir_nome
	; 		int		21H	
		
	CICLO:	
			goto_xy	POSxa,POSya		; Vai para a posição anterior do cursor

			mov		ah, 02h
			mov		dl, Car			; Repoe Caracter guardado 
			int		21H		
		
			goto_xy	POSx,POSy		; Vai para nova posição

			mov 	ah, 08h
			mov		bh,0			; numero da página
			int		10h		

			mov		Car, al			; Guarda o Caracter que está na posição do Cursor
			mov		Cor, ah			; Guarda a cor que está na posição do Cursor
			
			;goto_xy 38,11
			;MOSTRA wow
			
			goto_xy	78,0			; Mostra o caractr que estava na posição do AVATAR

			mov		ah, 02h			; IMPRIME caracter da posição no canto
			mov		dl, Car	
			int		21H		
			
			; deteção de letras - deprecated

			; cmp		al, 73			;I
			; je		ADICIONAR
			
			; cmp		al, 83			;S
			
			; cmp		al, 69			;E
			
			; cmp		al, 67			;C
			
			cmp		al, 177
			je		PAREDE
			
			;goto_xy	POSx,POSy		; Coloca o avatar na posicao do cursor
			
			mov		TEMPVAR3, 0
			mov		bx, TEMPVAR4
			mov		TEMPVAR1, bx

	deteta_letras:	
			mov SI, TEMPVAR1
			cmp STRINGSAUTO[SI],32
			je	fim_pal
			cmp al,STRINGSAUTO[SI]
			je ConstroiPalavra

	fim_nivel:
			mov bx, TEMPVAR4
			mov TEMPVAR1, bx
			mov SI, TEMPVAR1
			mov TEMPVAR1,0
			lea cx, Construir_nome

	fim_pal:
			;call NIVEL2	
			jmp fim_nivel

	volta_posicao:
			goto_xy	POSx,POSy		; Vai para posição do cursor
			;jmp IMPRIME
	
	CicloParaFormarPalavras:	
			mov bx,cx
			add bx,TEMPVAR3
			xor bh,bh
			xor ah,ah
			mov al,STRINGSAUTO[SI]
			cmp [bx],ax
			jne volta_posicao
			cmp STRINGSAUTO[SI],32
			je fim_pal
			inc TEMPVAR1
			inc SI
			jmp CicloParaFormarPalavras

	ConstroiPalavra:		
			XOR CX,CX
			add cx,TEMPVAR3
			mov TEMPVAR2, cl

			lea	cx, Construir_nome
			mov bx,cx
			add bx,TEMPVAR3
			xor bh,bh

			mov [bx],al
			mov dx, cx
			mov	ah, 09h	
			int 21H

			goto_xy	POSx,POSy
			jmp ret2

	ret2:		
			inc TEMPVAR1
			inc TEMPVAR3
			jmp deteta_letras		
			
	IMPRIME:	
            mov		ah, 02h
			mov		dl, 190         ; Coloca AVATAR
			int		21H	
			goto_xy	POSx,POSy	    ; Vai para posicao do cursor
			
			mov		al, POSx	    ; Guarda a posicao do cursor
			mov		POSxa, al
			mov		al, POSy	    ; Guarda a posicao do cursor
			mov 	POSya, al
		
		
	LER_SETA:
        	call 	LE_TECLA
			cmp		ah, 1
			je		ESTEND
			CMP 	AL, 27	; ESC
			JE		FIMAVA
			jmp		LER_SETA
		
	ESTEND:		
            cmp 	al,48h
			jne		BAIXO
			dec		POSy		; cima
			jmp		CICLO

    BAIXO:
    		cmp		al,50h
			jne		ESQUERDA
			inc 	POSy		; baixo
			jmp		CICLO

    ESQUERDA:
			cmp		al,4Bh
			jne		DIREITA
			dec		POSx		; esquerda
			jmp		CICLO

	DIREITA:
			cmp		al,4Dh
			jne		LER_SETA 
			inc		POSx		; direita
			jmp		CICLO

    FIMAVA:		
			RET

AVATAR	endp



IDK	PROC

	
	mov			ah,4CH 		; FIM DO PROGRAMA
    
	INT			21H

IDK	ENDP


; -------------------------------------------

; PROCEDIMENTO DO TOP 10

; -------------------------------------------

TOP10	PROC

    	MOV		AX, 0Bh
		MOV		DS, AX
	
		mov		ah, 3ch				; Abrir o ficheiro para escrita
		mov		cx, 00H				; Define o tipo de ficheiro ??
		lea		dx, fname			; DX aponta para o nome do ficheiro 
		int		21h					; Abre efectivamente o ficheiro (AX fica com o Handle do ficheiro)
		jnc		escreve				; Se não existir erro escreve no ficheiro
	
		mov		ah, 09h
		lea		dx, msgErrorCreate
		int		21h
	
		jmp		fimtop10

    escreve:

		mov		bx, ax				; Coloca em BX o Handle
    	mov		ah, 40h				; indica que é para escrever
    	
		lea		dx, buffer			; DX aponta para a infromação a escrever
    	mov		cx, 240				; CX fica com o numero de bytes a escrever
		int		21h					; Chama a rotina de escrita
		jnc		close				; Se não existir erro na escrita fecha o ficheiro
	
		mov		ah, 09h
		lea		dx, msgErrorWrite
		int		21h

    close:

		mov		ah,3eh				; fecha o ficheiro
		int		21h
		jnc		fimtop10
	
		mov		ah, 09h
		lea		dx, msgErrorClose
		int		21h

    fimtop10:

		call	MenuInicial
        
TOP10	endp

; -------------------------------------------

; PROCEDIMENTO DO JOGO

; -------------------------------------------

JOGAR	PROC

	call		apaga_ecra  ; apaga o ecra

	goto_xy		0,0         ; x = 0; y = 0 - vai para o inicio

    call		IMP_FICH1    ; procedimento que imprime o conteudo do ficheiro

	call		PALAVRA_A_COMPLETAR1
	
	call		TEMPO_TIMER
	
	call 		AVATAR      ; procedimento do avatar
	
    goto_xy		0,22        ; x = 0; y = 22
	
	mov			ah,4CH 		; FIM DO PROGRAMA
    
	INT			21H

JOGAR	ENDP


; -------------------------------------------

; PROCEDIMENTO DO NIVEL 2

; -------------------------------------------


NIVEL2	PROC

	call		apaga_ecra  ; apaga o ecra

	goto_xy		0,0         ; x = 0; y = 0 - vai para o inicio

    call		IMP_FICH2   ; procedimento que imprime o conteudo do ficheiro
	
	call		PALAVRA_A_COMPLETAR2

	call		TEMPO_TIMER
	
	call 		AVATAR      ; procedimento do avatar

    goto_xy		0,22        ; x = 0; y = 22
		
	mov			ah,4CH
	
    INT			21H

NIVEL2	ENDP


; -------------------------------------------

; PROCEDIMENTO DO NIVEL 3

; -------------------------------------------


NIVEL3	PROC

	call		apaga_ecra  ; apaga o ecra

	goto_xy		0,0         ; x = 0; y = 0 - vai para o inicio

    call		IMP_FICH3   ; procedimento que imprime o conteudo do ficheiro
	
	call		PALAVRA_A_COMPLETAR3

	call		TEMPO_TIMER
	
	call 		AVATAR      ; procedimento do avatar

    goto_xy		0,22        ; x = 0; y = 22
		
	mov			ah,4CH
	
    INT			21H

NIVEL3 ENDP

; ------------------------------------------------------------------

; PROC. INSTRUCOES

; ------------------------------------------------------------------


INSTRUCOES	PROC

	goto_xy		0,0
    ;call        apaga_ecra
    lea         dx, Ajuda ; mostra a ajuda
    mov         ah, 9
    INT			21H
	
	call		MenuInicial
	
	ret
	

INSTRUCOES	ENDP

; ------------------------------------------------------------------
; ------------------------------------------------------------------
; HORAS - Le Hora DO SISTEMA E COLOCA em tres variaveis (Horas, Minutos, Segundos)
; CH - Horas, CL - Minutos, DH - Segundos
; ------------------------------------------------------------------
; ------------------------------------------------------------------

Ler_TEMPO PROC	
 
		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX
	
		PUSHF
		
		MOV AH, 2CH             ; Buscar a hORAS
		INT 21H                 
		
		XOR AX,AX
		MOV AL, DH              ; segundos para al
		mov Segundos, AX		; guarda segundos na variavel correspondente
		
		XOR AX,AX
		MOV AL, CL              ; Minutos para al
		mov Minutos, AX         ; guarda MINUTOS na variavel correspondente
		
		XOR AX,AX
		MOV AL, CH              ; Horas para al
		mov Horas,AX			; guarda HORAS na variavel correspondente
 
		POPF
		POP DX
		POP CX
		POP BX
		POP AX
 		RET 
		
Ler_TEMPO   ENDP 


Trata_Horas PROC

		PUSHF
		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX		

		call 	Ler_TEMPO			; Horas, minutos e segundos do Sistema
		
		MOV		AX, Segundos
		cmp		AX, Old_seg			; Verifica se os segundos mudaram desde a ultima leitura
		je		fim_horas			; Se a hora não mudou desde a última leitura sai.
		mov		Old_seg, AX			; Se segundos são diferentes actualiza informação do tempo 
		
		

	    
		inc 	Tempo_j
		mov		ax, Tempo_j		
		MOV	bl, 10     
		div 	bl
		add 	al, 30h				; Caracter Correspondente às dezenas
		add	ah,	30h
		
		mov		cx, ax
	;	mov		Tempo_j, ax
	
		
		
		MOV 	STR10[0],al			
		MOV 	STR10[1],ah
		MOV 	STR10[2],'$'
		GOTO_XY 59,0
		MOSTRA STR10 	
		
		
		mov 	ax,Horas
		MOV		bl, 10     
		div 	bl
		add 	al, 30h				; Caracter Correspondente às dezenas
		add		ah,	30h				; Caracter Correspondente às unidades
	
		MOV 	STR12[0],al			
		MOV 	STR12[1],ah
		MOV 	STR12[2],'h'
		MOV 	STR12[3],'$'
		GOTO_XY 1,0
		MOSTRA STR12 	


		mov 	ax,Minutos
		MOV 	bl, 10     
		div 	bl
		add 	al, 30h				; Caracter Correspondente às dezenas
		add		ah,	30h				; Caracter Correspondente às unidades
		MOV 	STR12[0],al			 
		MOV 	STR12[1],ah
		MOV 	STR12[2],'m'		
		MOV 	STR12[3],'$'
		GOTO_XY	5,0
		MOSTRA	STR12 		
		
		
		mov 	ax,Segundos
		MOV 	bl, 10     
		div 	bl
		add 	al, 30h				; Caracter Correspondente às dezenas
		add		ah,	30h				; Caracter Correspondente às unidades
		MOV 	STR12[0],al			 
		MOV 	STR12[1],ah
		MOV 	STR12[2],'s'		
		MOV 	STR12[3],'$'
		GOTO_XY	9,0
		MOSTRA	STR12 		
        	
		
	fimhoras:
		
		POPF
		
		POP		DX		
		POP 	CX
		POP 	BX
		POP 	AX
		RET		

		MOV		AH,4Ch
		INT		21h
		
		
	fim_horas:		
		goto_xy	POSx,POSy			; Volta a colocar o cursor onde estava antes de actualizar as horas
		
		POPF

		POP DX		
		POP CX
		POP BX
		POP AX
		
		RET		

	; a testar os fins	
	tenso:	
		mov  ax, 4c00h
		int  21h	
		
		
		cmp		cx, '10'
		je		tenso
		
			
Trata_Horas ENDP

; ------------------------------------------------------------------

; IMPRIME O MENU INICIAL

MostraMenu	proc

	goto_xy   0,0
	lea  dx,  MenuOptions
	mov  ah,  9
	int  21h
	ret
	
MostraMenu	endp

; ------------------------------------------------------------------

; LE A TECLA NO MENU INICIAL

Le_Tecla_Menu	PROC

	nao_ha:	
			mov		ah,0bh
			int		21h
			cmp		al,0
			je		nao_ha

			mov		ah,08h
			int		21h
			mov		ah,0
			cmp		al,0
			jne		sucesso

			mov		ah, 08h
			int		21h
			mov		ah,1
			
	sucesso:	;sai do loop
			RET

Le_Tecla_Menu	endp


; TRATA DO MENU DO PROGRAMA

MenuInicial	proc	

	mov		ah, 09h
	lea		dx, Bem_Vindo
	int		21h

	loopMenu: call	Le_Tecla_Menu

		call		apaga_ecra  ; apaga o ecra

		call        MostraMenu ; imprime o menu no ecra

		mov ah, 1h
		int 21h	

		; chama o procedimento conforme a tecla pressionada
		
		cmp 	al, 49 ; 1
		je		OPCJOGAR
		cmp		al, 50 ; 2
		je		OPCTOP10
		cmp		al, 51 ; 3
		je		OPCINSTRUCOES
		cmp		al, 52 ; 4
		je		OPCSAIR
		jmp     loopMenu ; jump -> volta a tentar
		
		
		OPCJOGAR:
			
			call    JOGAR	
			
		OPCTOP10:

			call    TOP10
			
		OPCINSTRUCOES:

			call    INSTRUCOES 
			
		OPCSAIR:	
			
			mov  ax, 4c00h
			int  21h


MenuInicial	endp



; ------------------------------------------------------------------

; ---------------------------- MAIN --------------------------------

; ------------------------------------------------------------------



Main	proc

	mov			ax, dseg
	mov			ds,ax
		
	mov			ax,0B800h
	mov			es,ax

	; call		MovsIniciais	; inicia o programa - deprecated

    call		apaga_ecra		; apaga o ecra

	call		MenuInicial		; trata do programa

Main	endp 					; fim do main

Cseg	ends 					; fim do segmento de codigo

end		Main 					; fim do programa







; ------------------------------------------------------------------


; ------------------------ FIM DO PROGRAMA -------------------------


; ------------------------------------------------------------------




	; -------------------------------
	
	; CODIGO/APONTAMENTOS DE TESTES.

	; -------------------------------

	; !!! 177 = ASCII CODE DAS BORDAS DO LABIRINTO !!!

	; -------------------------------

	; procedimento que servia para resumir o main


	; MovsIniciais proc

	; mov			ax, dseg
	; mov			ds,ax
		
	; mov			ax,0B800h
	; mov			es,ax

	; MovsIniciais endp	
    
	; -----------------------------

    ; codigo para usar o switch nao funcional
    

    ; push    rbp
    ; mov     rbp, rsp
    ; sub     rsp, 16

    ; call    ReadInt
    ; mov     UserInputMenu, eax
        
    ; switch nao funcional.
    ;     switch:
    ;     
    ;         MOV AH, 1   ; le caracter do utilizador
    ;         INT 21H
    ;         
    ;         movsx   eax, BYTE PTR [rbp-1]
    ;         cmp     eax, 51
    ;         je      .L5
    ;         cmp     eax, 51
    ;         jg      .L6
    ;         cmp     eax, 49
    ;         je      .L7
    ;         cmp     eax, 50
    ;         je      .L8
    ;         jmp     switch
    ; 
    ; 
    ; .L7: ; JOGAR
    ; 
    ;     mov     eax, 0
    ;     call    jogar
    ; 
    ; .L8: ; TOP 10
    ; 
    ;     mov     eax, 0
    ;     call    TOP10
    ; 
    ; .L5: ; SAIR
    ; 
    ;     mov     eax, 0
    ;     leave
    ;     ret
    ; 
    ; .L6: ; SAI DO SWITCH
    ; 
    ;     mov     eax, 0
    ;     leave
    ;     ret
	;
	; -----------------------------------