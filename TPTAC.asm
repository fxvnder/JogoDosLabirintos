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

; START

.8086
.model small
.stack 2048


dseg	segment para public 'data'


		STR12	 		DB 		"            "	; String para 12 digitos
		DDMMAAAA 		db		"                     "
		
		Horas			dw		0				; Vai guardar a HORA actual
		Minutos			dw		0				; Vai guardar os minutos actuais
		Segundos		dw		0				; Vai guardar os segundos actuais
		Old_seg			dw		0				; Guarda os �ltimos segundos que foram lidos
		Tempo_init		dw		0				; Guarda O Tempo de inicio do jogo
		Tempo_j			dw		0				; Guarda O Tempo que decorre o  jogo
		Tempo_limite	dw		100				; tempo m�ximo de Jogo
		String_TJ		db		"    /100$"

		String_num 		db 		"  0 $"
        String_nome  	db	    "ISEC  $"	
		Construir_nome	db	    "            $"	
		Dim_nome		dw		5	; Comprimento do Nome
		indice_nome		dw		0	; indice que aponta para Construir_nome
		
		Fim_Ganhou		db	    " Ganhou $"	
		Fim_Perdeu		db	    " Perdeu $"	

        Erro_Open       db      'Erro ao tentar abrir o ficheiro$'
        Erro_Ler_Msg    db      'Erro ao tentar ler do ficheiro$'
        Erro_Close      db      'Erro ao tentar fechar o ficheiro$'
        Fich         	db      'LAB1.TXT',0
        HandleFich      dw      0
        car_fich        db      ?

		string			db	"Teste pratico de T.I",0
		Car				db	32	; Guarda um caracter do Ecra
		Cor				db	7	; Guarda os atributos de cor do caracter
		POSy			db	3	; a linha pode ir de [1 .. 25]
		POSx			db	3	; POSx pode ir [1..80]	
		POSya			db	3	; posicao anterior de y
		POSxa			db	3	; posicao anterior de x
dseg	ends

cseg	segment para public 'code'
assume		cs:cseg, ds:dseg

goto_xy	macro		POSx,POSy
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

; FIM DAS MACROS



; ROTINA PARA APAGAR ECRA

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


; IMP_FICH - ABRE E IMPRIME FICHEIRO

IMP_FICH	PROC

		;abre ficheiro
        mov     ah,3dh
        mov     al,0
        lea     dx,Fich
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
		
IMP_FICH	endp		

; LE UMA TECLA	

LE_TECLA	PROC
		
		mov		ah,08h
		int		21h
		mov		ah,0
		cmp		al,0
		jne		SAI_TECLA
		mov		ah, 08h
		int		21h
		mov		ah,1
SAI_TECLA:	RET
LE_TECLA	endp


; Avatar


AVATAR	PROC

			mov		ax,0B800h
			mov		es,ax

			goto_xy	POSx,POSy		; Vai para nova possi��o
			mov 	ah, 08h         ; Guarda o Caracter que est� na posicao do Cursor
			mov		bh,0			; numero da p�gina
			int		10h			
			mov		Car, al			; Guarda o Caracter que est� na posicao do Cursor
			mov		Cor, ah			; Guarda a cor que est� na posicao do Cursor	

        CICLO:		  

            goto_xy	POSxa,POSya		; Vai para a posicao anterior do cursor
			mov		ah, 02h
			mov		dl, Car			; Repoe Caracter guardado 
			int		21H		
		
			goto_xy	POSx,POSy		; Vai para nova possi��o
			mov 	ah, 08h
			mov		bh,0			; numero da p�gina
			int		10h		
			mov		Car, al			; Guarda o Caracter que est� na posicao do Cursor
			mov		Cor, ah			; Guarda a cor que est� na posicao do Cursor
		
			goto_xy	78,0			; Mostra o caractr que estava na posicao do AVATAR
			mov		ah, 02h			; IMPRIME caracter da posicao no canto
			mov		dl, Car	
			int		21H			
	
			goto_xy	POSx,POSy		; Vai para posicao do cursor

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
			JE		FIM
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

        fim:		

			RET

AVATAR		endp



;########################################################################

; Criar ficheiro

TOP10	PROC

    	MOV		AX, DADOS
		MOV		DS, AX
	
		mov		ah, 3ch				; Abrir o ficheiro para escrita
		mov		cx, 00H				; Define o tipo de ficheiro ??
		lea		dx, fname			; DX aponta para o nome do ficheiro 
		int		21h					; Abre efectivamente o ficheiro (AX fica com o Handle do ficheiro)
		jnc		escreve				; Se não existir erro escreve no ficheiro
	
		mov		ah, 09h
		lea		dx, msgErrorCreate
		int		21h
	
		jmp		fim

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
		jnc		fim
	
		mov		ah, 09h
		lea		dx, msgErrorClose
		int		21h

    fim:

		MOV		AH,4CH
		INT		21H
        
TOP10	endp

; PROC. JOGO

JOGAR   PROC

	call		apaga_ecra  ; apaga o ecra

	goto_xy		0,0         ; x = 0; y = 0 - vai para o inicio

    call		IMP_FICH    ; procedimento que imprime o conteudo do ficheiro

	call 		AVATAR      ; procedimento do avatar

    goto_xy		0,22        ; x = 0; y = 22
		
	mov			ah,4CH
	
    INT			21H


JOGAR ENDP


; 177 = ASCII CODE DAS BORDAS DO LABIRINTO


; MAIN


Main  proc

	mov			ax, dseg
	mov			ds,ax
		
	mov			ax,0B800h
	mov			es,ax

    call		apaga_ecra  ; apaga o ecra

    push    rbp
    mov     rbp, rsp
    sub     rsp, 16

    switch:
    
        ; OBTEM CARACTER DO USER

        MOV AH, 1   ; le caracter do utilizador
        INT 21H
        
        movsx   eax, BYTE PTR [rbp-1]
        cmp     eax, 51
        je      .L5
        cmp     eax, 51
        jg      .L6
        cmp     eax, 49
        je      .L7
        cmp     eax, 50
        je      .L8
        jmp     switch


.L7: ; JOGAR

    mov     eax, 0
    call    jogar

.L8: ; TOP 10

    mov     eax, 0
    call    TOP10

.L5: ; SAIR

    mov     eax, 0
    leave
    ret

.L6: ; SAI DO SWITCH

    mov     eax, 0
    leave
    ret


Main    endp
Cseg	ends

end	Main