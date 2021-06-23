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

; CODE
CODIGO	SEGMENT	para	public	'code'


; MAIN
Main    proc

mov  dx, msg    ; msg > dx
mov  ah, 9      ; ah = 9 - "print string"
int  0x21

msg  db 'teste!', 0x0d, 0x0a, '$'

main	endp

    CODIGO ENDS
		
END	main
