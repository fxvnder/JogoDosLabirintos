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

	; ----------- MENUS -----------

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

	; OUTPUT QUANDO O JOGADOR GANHA

	FINALGANHO  db "                                                          ",13,10
				db "                    **************************************",13,10
				db "                    *                                    *",13,10
				db "                    *                                    *",13,10
				db "                    *          Ganhou - Parabens!        *",13,10
				db "                    *                                    *",13,10
				db "                    *                                    *",13,10
				db "                    **************************************",13,10
				db "                                                          ",13,10
				db "                                                          ",13,10,'$'
				;db "A sua pontuacao final: ",13,10,'$'

	; OUTPUT QUANDO O JOGADOR PERDE

	FINALPERDEU db "                                                          ",13,10
				db "                    **************************************",13,10
				db "                    *                                    *",13,10
				db "                    *                                    *",13,10
				db "                    *           Acabou o tempo!          *",13,10
				db "                    *                                    *",13,10
				db "                    *                                    *",13,10
				db "                    **************************************",13,10
				db "                                                          ",13,10
				db "                                                          ",13,10,'$'
				;db "A sua pontuacao final: ",13,10,'$'

	; TEXTO BEM VINDO

	Bem_Vindo	db "Bem-vindo ao Jogo do Labirinto! Have fun ;)",13,10
				db "Prima qualquer tecla para continuar...!    ",13,10,'$'
				

	; TEXTO TOP10

	CarrTop10	db "Prima qualquer tecla para voltar ao menu!",13,10
				db "                                                       	",13,10
				db "                                                       	",13,10
				db " Top 10:												",13,10,'$'

	; VARIAVEIS ETC.
	
	; VARIAVEIS TEMPORARIAS USADAS PARA TESTES

	; Parede		db		"177" ; deprecated
	; TEMPVAR1		dw		0
	; TEMPVAR2		db		0
	; TEMPVAR3		dw		1
	; TEMPVAR4		dw		0

	; VARIAVEIS USADAS NO PROGRAMA

	UserInputMenu   dw  	?				; INPUT NO MENU INICIAL
	NIVELATUAL		dw		0				; NIVEL ATUAL
	progressoC		dw		0				; PROGRESSO NA PALAVRA
	STR12	 		DB 		"            "	; String para 12 digitos
	STR10			DB		"          "
	DDMMAAAA 		db		"                     "
	
	; VARIAVEIS P/ PONTUACAO

	; cada nivel completado sao x pontos - o tempo demorado
	PontosLvl1		dw		100
	PontosLvl2		dw		200
	PontosLvl3		dw		300
	PontosLvl4		dw		400
	PontosLvl5		dw		500

	PontosFinais	dw		0

	; CONTADOR
 
	; timer			dw 		'0'				; Contador de tempo
	Horas			dw		0				; Vai guardar a hora atual
	Minutos			dw		0				; Vai guardar os minutos actuais
	Segundos		dw		0				; Vai guardar os segundos actuais
	Old_seg			dw		0				; Guarda os ultimos segundos que foram lidos
	Tempo_init		dw		0				; Guarda o tempo de inicio do jogo
	Tempo_j			dw		-1				; Guarda o tempo que decorre o jogo
	Tempo_limite	dw		100				; tempo maximo de Jogo
	String_TJ		db		"     / 100$"

	; PALAVRAS

	String_num 		db 		"  0 $"

	; strings manuais p/ficheiro

	String_Inic  	db	    "ISEC  $"	
	String_Lvl2  	db	    "DEIS  $"	
	String_Lvl3  	db	    "TAC   $"	
	String_Lvl4  	db	    "ASM   $"	
	String_Lvl5  	db	    "TP    $"	


	; strings automaticas - deprecated

	;STRINGCHARS	dw		4
	;STRINGSAUTO	db		"ISEC  $"
	;				db		"DEIS  $"
	;				db		"TAC   $"
	;				db		"ASM   $"
	;				db		"TP    $"

	; strings usadas para outputs

	Construir_nome	db	    "            $"	
	PalavraI		db	    "I           $"	
	PalavraIS		db	    "IS          $"	
	PalavraISE		db	    "ISE         $"	
	PalavraISEC		db	    "ISEC        $"	
	PalavraD		db	    "D           $"	
	PalavraDE		db	    "DE          $"	
	PalavraDEI		db	    "DEI         $"	
	PalavraDEIS		db	    "DEIS        $"	
	PalavraT		db	    "T           $"	
	PalavraTA		db	    "TA          $"	
	PalavraTAC		db	    "TAC         $"	
	PalavraA		db		"A           $"
	PalavraAS		db		"AS          $"
	PalavraASM		db		"ASM         $"
	PalavraT2		db		"T           $"
	PalavraTP		db		"TP          $"

	Dim_nome		dw		5	; Comprimento do Nome
	indice_nome		dw		0	; indice que aponta para Construir_nome
	
	; FIM DO JOGO - deprecated (os nossos têm mais piada)

	;Fim_Ganhou		db	    " Ganhou $"	
	;Fim_Perdeu		db	    " Perdeu $"	

	; FICHEIROS

	Erro_Open       db      'Erro ao tentar abrir o ficheiro$'
	Erro_Ler_Msg    db      'Erro ao tentar ler do ficheiro$'
	Erro_Close      db      'Erro ao tentar fechar o ficheiro$'
	Fich1         	db      'LAB1.TXT',0
	Fich2         	db      'LAB2.TXT',0
	Fich3         	db      'LAB3.TXT',0
	Fich4         	db      'LAB4.TXT',0
	Fich5         	db      'LAB5.TXT',0
	FichTop10		db		'TOP10.TXT',0
	HandleFich      dw      0
	car_fich        db      ?

	string			db	"Teste pratico de T.I",0
	Car				db	32	; Guarda um caracter do Ecra
	Cor				db	7	; Guarda os atributos de cor do caracter

	; coordenadas

	POSy			db  10	; a linha pode ir de [1 .. 25]
	POSx			db	40	; POSx pode ir [1..80]	
	POSya			db	3	; posicao anterior de y
	POSxa			db	3	; posicao anterior de x
		
	; Variáveis da criação de ficheiro
	
	fname	db	'TOP10.TXT',0 ;ficheiro top10
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


	; Apagar letras
	apaga_letra	db	    " $"
	
		
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

sai_f3:	
	RET
	
IMP_FICH3	endp		

; -------------------------------------------
; IMP_FICH4 - ABRE E GERE FICHEIRO DO NIVEL 4
; -------------------------------------------

IMP_FICH4	PROC

	;abre ficheiro

	mov     ah,3dh
	mov     al,0

	; FICHEIRO = LABIRINTO 4

	lea     dx,Fich4
	int     21h
	jc      erro_abrir4
	mov     HandleFich,ax
	jmp     ler_ciclo4

erro_abrir4:
	mov     ah,09h
	lea     dx,Erro_Open
	int     21h
	jmp     sai_f4

ler_ciclo4:
	mov     ah,3fh
	mov     bx,HandleFich
	mov     cx,1
	lea     dx,car_fich
	int     21h
	jc		erro_ler4
	cmp		ax,0		;EOF?
	je		fecha_ficheiro4
	mov     ah,02h
	mov		dl,car_fich
	int		21h
	jmp		ler_ciclo4

erro_ler4:
	mov     ah,09h
	lea     dx,Erro_Ler_Msg
	int     21h

fecha_ficheiro4:
	mov     ah,3eh
	mov     bx,HandleFich
	int     21h
	jnc     sai_f4

	mov     ah,09h
	lea     dx,Erro_Close
	Int     21h

sai_f4:	
	RET
	
IMP_FICH4	endp		

; -------------------------------------------
; IMP_FICH5 - ABRE E GERE FICHEIRO DO NIVEL 5
; -------------------------------------------

IMP_FICH5	PROC

	;abre ficheiro

	mov     ah,3dh
	mov     al,0

	; FICHEIRO = LABIRINTO 5

	lea     dx,Fich5
	int     21h
	jc      erro_abrir5
	mov     HandleFich,ax
	jmp     ler_ciclo5

erro_abrir5:
	mov     ah,09h
	lea     dx,Erro_Open
	int     21h
	jmp     sai_f5

ler_ciclo5:
	mov     ah,3fh
	mov     bx,HandleFich
	mov     cx,1
	lea     dx,car_fich
	int     21h
	jc		erro_ler5
	cmp		ax,0		;EOF?
	je		fecha_ficheiro5
	mov     ah,02h
	mov		dl,car_fich
	int		21h
	jmp		ler_ciclo5

erro_ler5:
	mov     ah,09h
	lea     dx,Erro_Ler_Msg
	int     21h

fecha_ficheiro5:
	mov     ah,3eh
	mov     bx,HandleFich
	int     21h
	jnc     sai_f5

	mov     ah,09h
	lea     dx,Erro_Close
	Int     21h

sai_f5:	
	RET
	
IMP_FICH5	endp		

; ------------------------------------------------------------------
; ------------------------------------------------------------------
; ------------------------------------------------------------------

; PROCS. PARA A PALAVRA A COMPLETAR NO JOGO

; -------------- MODO MANUAL ----------------

PALAVRA_A_COMPLETAR	PROC
 	
	INICIOWORD:
		jmp	VERIFICANIVEL ; VAI VERIFICAR EM QUE LVL ESTA O JOGADOR

	PALAVRALABI1:
		; Palavra a procurar
		goto_xy	10,21			; Mostra a palavra que o utilizador deve completar no labirinto 1
		mov     ah, 09h
		lea     dx, String_Inic ; ISEC
		int		21H	
		jmp		FIM

	PALAVRALABI2:
		goto_xy	10,21			; Mostra a palavra que o utilizador deve completar no labirinto 2
		mov     ah, 09h
		lea     dx, String_Lvl2 ; DEIS
		int		21H	
		jmp		FIM

	PALAVRALABI3:
		; Palavra a procurar
		goto_xy	10,21			; Mostra a palavra que o utilizador deve completar no labirinto 3
		mov     ah, 09h
		lea     dx, String_Lvl3 ; TAC
		int		21H	
		jmp		FIM

	PALAVRALABI4:
		; Palavra a procurar
		goto_xy	10,21			; Mostra a palavra que o utilizador deve completar no labirinto 3
		mov     ah, 09h
		lea     dx, String_Lvl4 ; ASM
		int		21H	
		jmp		FIM

	PALAVRALABI5:
		; Palavra a procurar
		goto_xy	10,21			; Mostra a palavra que o utilizador deve completar no labirinto 3
		mov     ah, 09h
		lea     dx, String_Lvl5 ; TP
		int		21H	
		jmp		FIM


	VERIFICANIVEL:
		cmp 	NIVELATUAL, 49 ; 1
		je		PALAVRALABI1

		cmp 	NIVELATUAL, 50 ; 2
		je		PALAVRALABI2

		cmp 	NIVELATUAL, 51 ; 3
		je		PALAVRALABI3
		
		cmp 	NIVELATUAL, 52 ; 4
		je		PALAVRALABI4
		
		cmp 	NIVELATUAL, 53 ; 5
		je		PALAVRALABI5
		

	FIM:	
		RET

		
PALAVRA_A_COMPLETAR	ENDP

; GERENCIADOR DO TIMER

TEMPO_TIMER	PROC
	; Mostra qt tempo / 100
	goto_xy	57,0 ; x = 9, y = 0
	mov     ah, 09h
	lea     dx, String_TJ
	int		21H	
TEMPO_TIMER	ENDP


; ---------------------------------------------------------

; PROCEDIMENTO QUE GERE O AVATAR

; ---------------------------------------------------------

AVATAR	PROC

	Inicio:		
		mov		ax,0B800h
		mov		es,ax

		goto_xy	POSx,POSy		; Vai para nova posição
		mov 	ah, 08h			; Guarda o Caracter que está na posição do Cursor
		mov		bh,0			; numero da página
		int		10h			
		mov		Car, al			; Guarda o Caracter que está na posição do Cursor
		mov		Cor, ah			; Guarda a cor que está na posição do Cursor	
		jmp 	CICLO

	; GERENCIADOR DA DETEÇÃO DE PAREDES

	PAREDE:
		; retorna o filho atrás, já que ele está a ir contra a parede
		mov		al, POSxa	   
		mov		POSx, al
		mov		al, POSya	 
		mov 	POSy, al
		jmp 	Inicio

			 
	; -------------------- LETRAS ---------------------

	; >>>>>>>>>>>>>>>>>>>> NIVEL 1 <<<<<<<<<<<<<<<<<<<<

	ADICIONAR_I:
		cmp		progressoC, 49
		je		SEGUE_I
		jmp		RESETA_PROGRESSO

	SEGUE_I:
		goto_xy	10,22
		MOSTRA	PalavraI
		goto_xy 38,11 			; Onde está o I no labirinto 1
		MOSTRA  apaga_letra
		mov		progressoC, 50	; ProgressoNaPalavra +1
		mov		al, POSxa	    ; Guarda a posicao do cursor
		mov		POSx, al
		mov		al, POSya	    ; Guarda a posicao do cursor
		mov 	POSy, al
		jmp 	Inicio



	ADICIONAR_IS:
		cmp		progressoC, 50
		je		SEGUE_IS
		jmp		RESETA_PROGRESSO
		
	SEGUE_IS:
		goto_xy	10,22
		MOSTRA	PalavraIS
		goto_xy 32,5 			; Onde está o S no labirinto 1
		MOSTRA	apaga_letra
		mov		progressoC, 51	; ProgressoNaPalavra +1
		mov		al, POSxa	    ; Guarda a posicao do cursor
		mov		POSx, al
		mov		al, POSya	    ; Guarda a posicao do cursor
		mov 	POSy, al
		jmp 	Inicio



	ADICIONAR_ISE:
		cmp		progressoC, 51
		je		SEGUE_ISE
		jmp		RESETA_PROGRESSO
		
	SEGUE_ISE:
		goto_xy	10,22
		MOSTRA	PalavraISE
		goto_xy 75,17			; Onde está o E no labirinto 1
		MOSTRA	apaga_letra	
		mov		progressoC, 52	; ProgressoNaPalavra +1
		mov		al, POSxa	    ; Guarda a posicao do cursor
		mov		POSx, al
		mov		al, POSya	    ; Guarda a posicao do cursor
		mov 	POSy, al
		jmp 	Inicio



	ADICIONAR_ISEC:
		cmp		progressoC, 52
		je		SEGUE_ISEC
		jmp		RESETA_PROGRESSO

	SEGUE_ISEC:
		goto_xy	10,22
		MOSTRA	PalavraISEC
		goto_xy 24,19 			; Onde está o C no labirinto 1
		MOSTRA	apaga_letra

		mov		progressoC, 53	; ProgressoNaPalavra +1

		; calcula pontuacao

		mov		ax, PontosLvl1
		sub		ax, Tempo_j
		mov		bx, PontosFinais
		add		ax, bx
		mov		PontosFinais, ax

		; segue para o nivel seguinte

		mov		al, POSxa	    ; Guarda a posicao do cursor
		mov		POSx, al
		mov		al, POSya	    ; Guarda a posicao do cursor
		mov 	POSy, al
		jmp		JOGAR2
			


	; >>>>>>>>>>>>>>>>>>>> NIVEL 2 <<<<<<<<<<<<<<<<<<<<



	ADICIONAR_D:
		cmp		progressoC, 49
		je		SEGUE_D
		jmp		RESETA_PROGRESSO

	SEGUE_D:
		goto_xy	10,22
		MOSTRA	PalavraD
		goto_xy 2,6 			; Onde está o D no labirinto 2
		MOSTRA	apaga_letra
		mov		progressoC, 50	; ProgressoNaPalavra +1
		mov		al, POSxa	    ; Guarda a posicao do cursor
		mov		POSx, al
		mov		al, POSya	    ; Guarda a posicao do cursor
		mov 	POSy, al
		jmp 	Inicio



	ADICIONAR_DE:
		cmp		progressoC, 50
		je		SEGUE_DE
		jmp		RESETA_PROGRESSO

	SEGUE_DE:
		goto_xy	10,22
		MOSTRA	PalavraDE
		goto_xy 64,15 			; Onde está o E no labirinto 2
		MOSTRA	apaga_letra
		mov		progressoC, 51	; ProgressoNaPalavra +1
		mov		al, POSxa	    ; Guarda a posicao do cursor
		mov		POSx, al
		mov		al, POSya	    ; Guarda a posicao do cursor
		mov 	POSy, al
		jmp 	Inicio



	ADICIONAR_DEI:		
		cmp		progressoC, 51
		je		SEGUE_DEI
		jmp		RESETA_PROGRESSO

	SEGUE_DEI:
		goto_xy	10,22
		MOSTRA	PalavraDEI
		goto_xy 2,19 			; Onde está o I no labirinto 2
		MOSTRA	apaga_letra
		mov		progressoC, 52	; ProgressoNaPalavra +1
		mov		al, POSxa	    ; Guarda a posicao do cursor
		mov		POSx, al
		mov		al, POSya	    ; Guarda a posicao do cursor
		mov 	POSy, al
		jmp 	Inicio



	ADICIONAR_DEIS:
		cmp		progressoC, 52
		je		SEGUE_DEIS
		jmp		RESETA_PROGRESSO

	SEGUE_DEIS:
		goto_xy	10,22
		MOSTRA	PalavraDEIS
		goto_xy 71,3 			; Onde está o S no labirinto 2
		MOSTRA	apaga_letra

		mov		progressoC, 53	; ProgressoNaPalavra +1
		
		; calcula pontuacao

		mov		ax, PontosLvl2
		sub		ax, Tempo_j
		mov		bx, PontosFinais
		add		ax, bx
		mov		PontosFinais, ax

		; segue para o nivel seguinte

		mov		al, POSxa	    ; Guarda a posicao do cursor
		mov		POSx, al
		mov		al, POSya	    ; Guarda a posicao do cursor
		mov 	POSy, al
		jmp 	JOGAR3



	; >>>>>>>>>>>>>>>>>>>> NIVEL 3 <<<<<<<<<<<<<<<<<<<<



	ADICIONAR_T:
		cmp		progressoC, 49
		je		SEGUE_T
		jmp		RESETA_PROGRESSO

	SEGUE_T:
		goto_xy	10,22
		MOSTRA	PalavraT
		goto_xy 45,10 			; Onde está o T no labirinto 3
		MOSTRA	apaga_letra
		mov		progressoC, 50	; ProgressoNaPalavra +1
		mov		al, POSxa	    ; Guarda a posicao do cursor
		mov		POSx, al
		mov		al, POSya	    ; Guarda a posicao do cursor
		mov 	POSy, al
		jmp 	Inicio



	ADICIONAR_TA:
		cmp		progressoC, 50
		je		SEGUE_TA
		jmp		RESETA_PROGRESSO

	SEGUE_TA:
		goto_xy	10,22
		MOSTRA	PalavraTA
		goto_xy 55,17 			; Onde está o A no labirinto 3
		MOSTRA	apaga_letra
		mov		progressoC, 51	; ProgressoNaPalavra +1
		mov		al, POSxa	    ; Guarda a posicao do cursor
		mov		POSx, al
		mov		al, POSya	    ; Guarda a posicao do cursor
		mov 	POSy, al
		jmp 	Inicio



	ADICIONAR_TAC:
		cmp		progressoC, 51
		je		SEGUE_TAC
		jmp		RESETA_PROGRESSO

	SEGUE_TAC:
		goto_xy	10,22
		MOSTRA	PalavraTAC
		goto_xy 10,15 			; Onde está o C no labirinto 3
		MOSTRA	apaga_letra

		mov		progressoC, 52	; ProgressoNaPalavra +1
		
		; calcula pontuacao

		mov		ax, PontosLvl3
		sub		ax, Tempo_j
		mov		bx, PontosFinais
		add		ax, bx
		mov		PontosFinais, ax

		; segue para o nivel seguinte

		mov		al, POSxa	    ; Guarda a posicao do cursor
		mov		POSx, al
		mov		al, POSya	    ; Guarda a posicao do cursor
		mov 	POSy, al
		jmp 	JOGAR4


	; >>>>>>>>>>>>>>>>>>>> NIVEL 4 <<<<<<<<<<<<<<<<<<<<


	ADICIONAR_A:
		cmp		progressoC, 49
		je		SEGUE_A
		jmp		RESETA_PROGRESSO

	SEGUE_A:
		goto_xy	10,22
		MOSTRA	PalavraA
		goto_xy 6,12 			; Onde está o A no labirinto 4
		MOSTRA	apaga_letra
		mov		progressoC, 50	; ProgressoNaPalavra +1
		mov		al, POSxa	    ; Guarda a posicao do cursor
		mov		POSx, al
		mov		al, POSya	    ; Guarda a posicao do cursor
		mov 	POSy, al
		jmp 	Inicio



	ADICIONAR_AS:
		cmp		progressoC, 50
		je		SEGUE_AS
		jmp		RESETA_PROGRESSO

	SEGUE_AS:
		goto_xy	10,22
		MOSTRA	PalavraAS
		goto_xy 47,3 			; Onde está o S no labirinto 4
		MOSTRA	apaga_letra
		mov		progressoC, 51	; ProgressoNaPalavra +1
		mov		al, POSxa	    ; Guarda a posicao do cursor
		mov		POSx, al
		mov		al, POSya	    ; Guarda a posicao do cursor
		mov 	POSy, al
		jmp 	Inicio



	ADICIONAR_ASM:
		cmp		progressoC, 51
		je		SEGUE_ASM
		jmp		RESETA_PROGRESSO

	SEGUE_ASM:
		goto_xy	10,22
		MOSTRA	PalavraASM
		goto_xy 65,3 			; Onde está o M no labirinto 4
		MOSTRA	apaga_letra

		mov		progressoC, 52	; ProgressoNaPalavra +1
		
		; calcula pontuacao

		mov		ax, PontosLvl4
		sub		ax, Tempo_j
		mov		bx, PontosFinais
		add		ax, bx
		mov		PontosFinais, ax

		; segue para o nivel seguinte

		mov		al, POSxa	    ; Guarda a posicao do cursor
		mov		POSx, al
		mov		al, POSya	    ; Guarda a posicao do cursor
		mov 	POSy, al
		jmp 	JOGAR5
		
		
	; >>>>>>>>>>>>>>>>>>>> NIVEL 5 <<<<<<<<<<<<<<<<<<<<


	ADICIONAR_T2:
		cmp		progressoC, 49
		je		SEGUE_T2
		jmp		RESETA_PROGRESSO

	SEGUE_T2:
		goto_xy	10,22
		MOSTRA	PalavraT2
		goto_xy 3,12 			; Onde está o T no labirinto 5
		MOSTRA	apaga_letra
		mov		progressoC, 50	; ProgressoNaPalavra +1
		mov		al, POSxa	    ; Guarda a posicao do cursor
		mov		POSx, al
		mov		al, POSya	    ; Guarda a posicao do cursor
		mov 	POSy, al
		jmp 	Inicio



	ADICIONAR_TP:
		cmp		progressoC, 50
		je		SEGUE_TP
		jmp		RESETA_PROGRESSO

	SEGUE_TP:
		goto_xy	10,22
		MOSTRA	PalavraTP
		goto_xy 64,7 			; Onde está o P no labirinto 5
		MOSTRA	apaga_letra

		mov		progressoC, 51	; ProgressoNaPalavra +1
		
		; calcula pontuacao

		mov		ax, 500
		sub		ax, Tempo_j
		mov		bx, PontosFinais
		add		ax, PontosFinais
		mov		PontosFinais, ax

		; segue para o nivel seguinte

		mov		al, POSxa	    ; Guarda a posicao do cursor
		mov		POSx, al
		mov		al, POSya	    ; Guarda a posicao do cursor
		mov 	POSy, al
		jmp 	GanhouText
		;jmp	Inicio



	; RESETA O PROGRESSO NA PALAVRA


	RESETA_PROGRESSO:

		; ProgressoNaPalavra reset - desnecessário pq os JOGAR dão manage
		; mov		progressoC, 49	

		
		; RESET DOS NIVEIS

		; LVL 1

		cmp 	NIVELATUAL, 49 	; LVL 1
		je		RESETA_LVL1

		; LVL 2

		cmp		NIVELATUAL, 50 	; LVL 2
		je		RESETA_LVL2	

		; LVL 3

		cmp		NIVELATUAL, 51 	; LVL 3
		je		RESETA_LVL3

		; LVL 4

		cmp		NIVELATUAL, 52 	; LVL 4
		je		RESETA_LVL4

		; LVL 5

		cmp		NIVELATUAL, 53 	; LVL 5
		je		RESETA_LVL5


	RESETA_LVL1:
		goto_xy	10,22			
		MOSTRA	Construir_nome	; RESETA O PROGRESSO
		mov		al, POSxa	    ; Guarda a posicao do cursor
		mov		POSx, al
		mov		al, POSya	    ; Guarda a posicao do cursor
		mov 	POSy, al
		jmp 	JOGAR			; RECOMEÇA O NIVEL

	RESETA_LVL2:
		goto_xy	10,22
		MOSTRA	Construir_nome	; RESETA O PROGRESSO
		mov		al, POSxa	    ; Guarda a posicao do cursor
		mov		POSx, al
		mov		al, POSya	    ; Guarda a posicao do cursor
		mov 	POSy, al
		jmp		JOGAR2			; RECOMEÇA O NIVEL

	RESETA_LVL3:

		goto_xy	10,22
		MOSTRA	Construir_nome	; RESETA O PROGRESSO
		mov		al, POSxa	    ; Guarda a posicao do cursor
		mov		POSx, al
		mov		al, POSya	    ; Guarda a posicao do cursor
		mov 	POSy, al
		jmp		JOGAR3			; RECOMEÇA O NIVEL

	RESETA_LVL4:

		goto_xy	10,22
		MOSTRA	Construir_nome	; RESETA O PROGRESSO
		mov		al, POSxa	    ; Guarda a posicao do cursor
		mov		POSx, al
		mov		al, POSya	    ; Guarda a posicao do cursor
		mov 	POSy, al
		jmp		JOGAR4			; RECOMEÇA O NIVEL

	RESETA_LVL5:

		goto_xy	10,22
		MOSTRA	Construir_nome	; RESETA O PROGRESSO
		mov		al, POSxa	    ; Guarda a posicao do cursor
		mov		POSx, al
		mov		al, POSya	    ; Guarda a posicao do cursor
		mov 	POSy, al
		jmp		JOGAR5			; RECOMEÇA O NIVEL

	; CICLO

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
		
		goto_xy	78,0			; Mostra o caractr que estava na posição do AVATAR
		mov		ah, 02h			; IMPRIME caracter da posição no canto
		mov		dl, Car	
		int		21H		
		
		; call	Ver_Tecla
		
		cmp		al, 177
		je		PAREDE
		
		goto_xy	POSx,POSy		; Coloca o avatar na posicao do cursor
		
		; VERIFICA O NIVEL E ATRIBUI AS PALAVRAS A ENCONTRAR

		cmp 	NIVELATUAL, 49
		je		PALAVRANIVEL1
		
		cmp 	NIVELATUAL, 50
		je		PALAVRANIVEL2

		cmp 	NIVELATUAL, 51
		je		PALAVRANIVEL3

		cmp 	NIVELATUAL, 52
		je		PALAVRANIVEL4

		cmp 	NIVELATUAL, 53
		je		PALAVRANIVEL5

	; GERENCIADOR DE PALAVRAS / NIVEL

	PALAVRANIVEL1:		
		
		cmp		al, 73			;I
		je		ADICIONAR_I
		
		cmp		al, 83			;S
		je		ADICIONAR_IS
		
		cmp		al, 69			;E
		je		ADICIONAR_ISE
		
		cmp		al, 67			;C
		je		ADICIONAR_ISEC

	PALAVRANIVEL2:		
		cmp		al, 68			;D
		je		ADICIONAR_D
		
		cmp		al, 69			;E
		je		ADICIONAR_DE
		
		cmp		al, 73			;I
		je		ADICIONAR_DEI
		
		cmp		al, 83			;S
		je		ADICIONAR_DEIS

	PALAVRANIVEL3:		
		cmp		al, 84			;T
		je		ADICIONAR_T
		
		cmp		al, 65			;A
		je		ADICIONAR_TA
		
		cmp		al, 67			;C
		je		ADICIONAR_TAC

	PALAVRANIVEL4:		
		cmp		al, 65			;A
		je		ADICIONAR_A
		
		cmp		al, 83			;S
		je		ADICIONAR_AS
		
		cmp		al, 77			;M
		je		ADICIONAR_ASM

	PALAVRANIVEL5:		
		cmp		al, 84			;T
		je		ADICIONAR_T
		
		cmp		al, 80			;P
		je		ADICIONAR_TP

	; IMPRIME AVATAR

	IMPRIME:	
		mov		ah, 02h
		mov		dl, 4			; !!! CHAR AVATAR !!!
		int		21H	
		goto_xy	POSx,POSy	    ; Vai para posicao do cursor
		
		mov		al, POSx	    ; Guarda a posicao do cursor
		mov		POSxa, al
		mov		al, POSy	    ; Guarda a posicao do cursor
		mov 	POSya, al
		
	; LE INPUT DO TECLADO; SAI COM ESC	

	LER_SETA:
		call 	LE_TECLA
		cmp		ah, 1
		je		ESTEND
		cmp 	AL, 27		; ESC
		JE		SAI_PROG
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

	SAI_PROG:
		call apaga_ecra
		mov  ax, 4c00h
		int  21h

    FIMAVA:		
		RET
		
	FIMTESTE:
	RET

AVATAR	endp



; -------------------------------------------

; PROCEDIMENTO DO TOP 10

; -------------------------------------------

TOP10	PROC

	call apaga_ecra
	goto_xy	1,1
	mov		ah, 09h
	lea     dx,CarrTop10
    int     21h

	lefichtop10:
		;abre ficheiro
        mov     ah,3dh
        mov     al,0
        lea     dx,FichTop10 ; TOP10.TXT
        int     21h
        jc      erro_fichtop10
        mov     HandleFich,ax
        jmp     ler_top10

	erro_fichtop10:
        mov     ah,09h
        lea     dx,Erro_Open
        int     21h
        jmp     fimtop10

	ler_top10:
        mov     ah,3fh
        mov     bx,HandleFich
        mov     cx,1
        lea     dx,car_fich
        int     21h
		jc		erro_lertop10
		cmp		ax,0		;EOF?
		je		fecha_top10
        mov     ah,02h
		mov		dl,car_fich
		int		21h
		jmp		ler_top10

	erro_lertop10:
        mov     ah,09h
        lea     dx,Erro_Ler_Msg
        int     21h

	fecha_top10:
        mov     ah,3eh
        mov     bx,HandleFich
        int     21h
        jnc     fimtop10

        mov     ah,09h
        lea     dx,Erro_Close
        Int     21h

    fimtop10:

		call	MenuInicial

; PROCEDIMENTO PARA FAZER O TOP 10 - DEPRECATED

    ; 	MOV		AX, 0Bh
	; 	MOV		DS, AX
	
	; 	mov		ah, 3ch				; Abrir o ficheiro para escrita
	; 	mov		cx, 00H				; Define o tipo de ficheiro ??
	; 	lea		dx, fname			; DX aponta para o nome do ficheiro 
	; 	int		21h					; Abre efectivamente o ficheiro (AX fica com o Handle do ficheiro)
	; 	jnc		escreve				; Se não existir erro escreve no ficheiro
	
	; 	mov		ah, 09h
	; 	lea		dx, msgErrorCreate
	; 	int		21h
	
	; 	jmp		fimtop10

    ; escreve:

	; 	mov		bx, ax				; Coloca em BX o Handle
    ; 	mov		ah, 40h				; indica que é para escrever
    	
	; 	lea		dx, buffer			; DX aponta para a infromação a escrever
    ; 	mov		cx, 240				; CX fica com o numero de bytes a escrever
	; 	int		21h					; Chama a rotina de escrita
	; 	jnc		close				; Se não existir erro na escrita fecha o ficheiro
	
	; 	mov		ah, 09h
	; 	lea		dx, msgErrorWrite
	; 	int		21h

    ; close:

	; 	mov		ah,3eh				; fecha o ficheiro
	; 	int		21h
	; 	jnc		fimtop10
	
	; 	mov		ah, 09h
	; 	lea		dx, msgErrorClose
	; 	int		21h
        
TOP10	endp

; -------------------------------------------

; PROCEDIMENTO DO JOGO

; -------------------------------------------

JOGAR	PROC

	;NIVEL1
	call		apaga_ecra  ; apaga o ecra
	goto_xy		0,0         ; x = 0; y = 0 - vai para o inicio
    call		IMP_FICH1   ; procedimento que imprime o conteudo do ficheiro
	mov			NIVELATUAL, 49 ; LVL 1
	mov			progressoC, 49 ; PROG 1
	call		PALAVRA_A_COMPLETAR	
	call		TEMPO_TIMER
	call 		AVATAR      ; procedimento do avatar
    goto_xy		0,22        ; x = 0; y = 22

JOGAR	ENDP


JOGAR2	PROC

	;NIVEL2
	call		apaga_ecra  ; apaga o ecra
	goto_xy		0,0         ; x = 0; y = 0 - vai para o inicio
    call		IMP_FICH2   ; procedimento que imprime o conteudo do ficheiro
	mov			NIVELATUAL, 50 ; LVL 2
	mov			progressoC, 49 ; PROG 1
	call		PALAVRA_A_COMPLETAR
	call		TEMPO_TIMER
	call 		AVATAR      ; procedimento do avatar
    goto_xy		0,22        ; x = 0; y = 22

JOGAR2	ENDP


JOGAR3	PROC

	;NIVEL3
	call		apaga_ecra  ; apaga o ecra
	goto_xy		0,0         ; x = 0; y = 0 - vai para o inicio
    call		IMP_FICH3   ; procedimento que imprime o conteudo do ficheiro
	mov			NIVELATUAL, 51 ; LVL 3
	mov			progressoC, 49 ; PROG 1
	call		PALAVRA_A_COMPLETAR
	call		TEMPO_TIMER
	call 		AVATAR      ; procedimento do avatar
    goto_xy		0,22        ; x = 0; y = 22

JOGAR3	ENDP

JOGAR4	PROC

	;NIVEL4
	call		apaga_ecra  ; apaga o ecra
	goto_xy		0,0         ; x = 0; y = 0 - vai para o inicio
    call		IMP_FICH4   ; procedimento que imprime o conteudo do ficheiro
	mov			NIVELATUAL, 52 ; LVL 4
	mov			progressoC, 49 ; PROG 1
	call		PALAVRA_A_COMPLETAR
	call		TEMPO_TIMER
	call 		AVATAR      ; procedimento do avatar
    goto_xy		0,22        ; x = 0; y = 22

JOGAR4	ENDP

JOGAR5	PROC

	;NIVEL5
	call		apaga_ecra  ; apaga o ecra
	goto_xy		0,0         ; x = 0; y = 0 - vai para o inicio
    call		IMP_FICH5   ; procedimento que imprime o conteudo do ficheiro
	mov			NIVELATUAL, 53 ; LVL 5
	mov			progressoC, 49 ; PROG 1
	call		PALAVRA_A_COMPLETAR
	call		TEMPO_TIMER
	call 		AVATAR      ; procedimento do avatar
    goto_xy		0,22        ; x = 0; y = 22

	;call		GanhouText	; DEPRECATED - VITORIA > JOGAR 3

	;mov		ah,4CH 		; DEPRECATED - FIM DO PROGRAMA
	;INT		21H			; ^^

JOGAR5	ENDP


; Quando acaba o lvl 5

GanhouText PROC

	call	apaga_ecra  ; apaga o ecra	
	goto_xy	0,5
	mov		ah, 09h
	lea		dx, FINALGANHO
	;lea	dx, PontosFinais
	int		21h

	call	MenuInicial
	ret

GanhouText ENDP


; Quando esgota o tempo

PerdeuText PROC

	call	apaga_ecra  ; apaga o ecra	
	mov		Tempo_j, -1
	goto_xy	0,5
	mov		ah, 09h
	lea		dx, FINALPERDEU
	;lea	bx, PontosFinais
	int		21h

	call	MenuInicial
	ret

PerdeuText ENDP



; ------------------------------------------------------------------

; PROC. INSTRUCOES

; ------------------------------------------------------------------


INSTRUCOES	PROC

	goto_xy		0,2
    ;call		apaga_ecra
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
	mov		cx, Tempo_j
	
	MOV		bl, 10     
	div 	bl
	add 	al, 30h				; Caracter Correspondente às dezenas
	add		ah,	30h
	
	; mov	cx, ax
	; mov	Tempo_j, ax		
	
	MOV 	STR10[0],al			
	MOV 	STR10[1],ah
	MOV 	STR10[2],'$'
	GOTO_XY	59,0
	MOSTRA	STR10 	
	
	; QUANDO ACABA O JOGO

	cmp		Tempo_j, 99 ; 99 PORQUE O JOGO COMEÇA NO -1
	je		tenso
	
	; HORAS

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
	MOSTRA	STR12 	

	; MINUTOS

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
	
	; SEGUNDOS

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

	; a testar os fins	
	
	fimhoras:
		POPF
		POP		DX		
		POP		CX
		POP		BX
		POP		AX
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

	; QUANDO PERDE	

	tenso:	
		call	PerdeuText
			
Trata_Horas ENDP

; ------------------------------------------------------------------

; IMPRIME O MENU INICIAL

MostraMenu	proc

	goto_xy   0,3
	lea  dx,  MenuOptions ; menu inic
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
		je		nao_ha ;loop

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

; ------------------------------------------------------------------

; Dá as boas vindas

BoasVindas proc

	goto_xy 0,20
	mov		ah, 09h
	lea		dx, Bem_Vindo ; mostra o texto de boas vindas ate ao utilizador clicar em qualquer tecla
	int		21h

BoasVindas endp

; TRATA DO MENU DO PROGRAMA

MenuInicial	proc	

	loopMenu: 

		call	Le_Tecla_Menu

		call	apaga_ecra  ; apaga o ecra

		call    MostraMenu ; imprime o menu no ecra

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
		cmp		al, 27 ; ESC
		je		OPCSAIR
		jmp     loopMenu ; jump -> volta a tentar
		
		; switch

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

    call		apaga_ecra		; apaga o ecra

	call		BoasVindas

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

; TESTES AVATAR

; PROCEDIMENTOS PARA AUTOMAÇÃO

; deteta_letras:	
; 		mov SI, TEMPVAR1
; 		cmp STRINGSAUTO[SI],32
; 		je	fim_pal
; 		cmp al,STRINGSAUTO[SI]
; 		je ADC_LETRA

; fim_nivel:
; 		mov bx, TEMPVAR4
; 		mov TEMPVAR1, bx
; 		mov SI, TEMPVAR1
; 		mov TEMPVAR1,0
; 		lea cx, Construir_nome

; fim_pal:
; 		call NIVEL2	
; 		jmp fim_nivel

; ADC_LETRA:		
; 		XOR CX,CX
; 		add cx,TEMPVAR3
; 		mov TEMPVAR2, cl

; 		lea	cx, Construir_nome
; 		mov bx,cx
; 		add bx,TEMPVAR3
; 		xor bh,bh

; 		mov [bx],al
; 		mov dx, cx
; 		mov	ah, 09h	
; 		int 21H

; 		goto_xy	POSx,POSy
; 		jmp ret2

; ret2:		
; 		inc TEMPVAR1
; 		inc TEMPVAR3
; 		jmp deteta_letras


; -------------------------------------------

; CODIGO USADO PARA AUTOMATIZAR PALAVRAS

; ------------- MODO AUTOMATICO ------------

; PROCEDIMENTO PARA CALCULAR UMA PALAVRA ALEATORIA

; PalavRandom proc near

; 			mov ah, 0
; 			int 1ah
; 			mov ax,dx
; 			mov dx,0
; 			mov bx, STRINGCHARS
; 			div bx
; 			mov TEMPVAR4,dx
; 			ret

; PalavRandom endp


; PALAVRA_A_COMPLETAR1	PROC
	
; 	call	PalavRandom
; 	mov		ax, TEMPVAR4
; 	xor		bx,bx
; 	mov		bx, 10
; 	mul		bx
; 	mov		SI, ax
; 	mov		TEMPVAR4, SI

; 	mov		ah, 09h
	
; 	lea		dx, STRINGSAUTO[SI]
; 	int		21h

; 	ret

; PALAVRA_A_COMPLETAR1	ENDP

; PALAVRA_A_COMPLETAR2	PROC
	
; 	call	PalavRandom
; 	mov		ax, TEMPVAR4
; 	xor		bx,bx
; 	mov		bx, 10
; 	mul		bx
; 	mov		SI, ax
; 	mov		TEMPVAR4, SI

; 	mov		ah, 09h
	
; 	lea		dx, STRINGSAUTO[SI]
; 	int		21h

; 	ret

; PALAVRA_A_COMPLETAR2	ENDP

; PALAVRA_A_COMPLETAR3	PROC
	
; 	call	PalavRandom
; 	mov		ax, TEMPVAR4
; 	xor		bx,bx
; 	mov		bx, 10
; 	mul		bx
; 	mov		SI, ax
; 	mov		TEMPVAR4, SI

; 	mov		ah, 09h
	
; 	lea		dx, STRINGSAUTO[SI]
; 	int		21h

; 	ret

; PALAVRA_A_COMPLETAR3	ENDP

	
	
; deprecated vars -> main CICLO

	; mov		TEMPVAR3, 0
	; mov		bx, TEMPVAR4
	; mov		TEMPVAR1, bx



; NIVEIS ANTIGOS - DEPRECATED


; -------------------------------------------

; PROCEDIMENTO DO NIVEL 2

; -------------------------------------------


; NIVEL2	PROC

; 	call		apaga_ecra  ; apaga o ecra

; 	goto_xy		0,0         ; x = 0; y = 0 - vai para o inicio

;     call		IMP_FICH2   ; procedimento que imprime o conteudo do ficheiro
	
; 	;call		PALAVRA_A_COMPLETAR2

; 	call		TEMPO_TIMER
	
; 	;mov			NIVELATUAL, 50

; 	call 		AVATAR    ; procedimento do avatar

;     goto_xy		0,22        ; x = 0; y = 22

; 	; call		NIVEL3

; 	mov			ah,4CH
	
;     INT			21H

; NIVEL2	ENDP


; ; -------------------------------------------

; ; PROCEDIMENTO DO NIVEL 3

; ; -------------------------------------------


; NIVEL3	PROC

; 	call		apaga_ecra  ; apaga o ecra

; 	goto_xy		0,0         ; x = 0; y = 0 - vai para o inicio

;     call		IMP_FICH3   ; procedimento que imprime o conteudo do ficheiro
	
; 	;call		PALAVRA_A_COMPLETAR3

; 	call		TEMPO_TIMER

; 	;mov			NIVELATUAL, 51
	
; 	call 		AVATAR      ; procedimento do avatar

;     goto_xy		0,22        ; x = 0; y = 22

; 	call		GanhouText
		
; 	mov			ah,4CH
	
;     INT			21H

; NIVEL3 ENDP