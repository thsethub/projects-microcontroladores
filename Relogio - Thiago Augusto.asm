PROCESSOR       16F877A
	RADIX           DEC			;define para decimal, serve para setar como decimal quando n�o for bin�rio(b)

#INCLUDE <p16F877A.inc>	
	__config	0x3F32

	org 0X00
	goto inicio

	org 0X04					
	goto inter

	org 0x20					;aloca��o de mem�ria livre para uso
temp 	res 2					;Vari�vel para a rotina de atraso
segu	res 1					;Conta as unidades de segundo.
segd	res 1					;Conta as dezenas de segundo.
minU	res 1
minD	res 1
horaU	res 1
horaD	res 1

w_temp	res 1					;Salva o que est� no acumulador
s_temp	res 1					;Salva o que est� no STATUS
flags	res 1					;Registrador auxiliar
display	res 1

inicio

	banksel	TRISD				;Seleciona o banksel do TRISD, TRISD � o configura PORTD.
	movlw	00000000b			;Bit que estiver em 0 � sa�da. Todos os pinos da PORTD e PORTA ser�o sa�das.
	movwf	TRISD				;Movendo os bits do acumulador para o registrador.
	movwf	TRISA
	movlw	6					;Ao mover 6 para o ADCON1, configura a PORTA como porta digital.
	movwf	ADCON1
	bsf	PIE1,TMR1IE			    ;Liga interrup��o timer1.
	bsf	INTCON,PEIE		     	;Liga int. perif�rico.
	bsf	INTCON,GIE		    	;Liga int. geral.

	banksel	PORTD				;Seleciona o banco da porta D
	movlw	00000000b			;Move 0 para o acumulador
	movwf	PORTD				;Zera a porta D
	movwf	PORTA				;Zera a porta B
	clrf	T1CON				;Garantir que tudo inicie em zero.

	bsf	T1CON,TMR1ON		    ;Liga TRM1.				
	bsf	T1CON,T1CKPS1           ;Configura o preescale para 1:8
	bsf	T1CON,T1CKPS0			;Configura o preescale para 1:8

	clrf	segu				;Limpa os registradores
	clrf	segd
	clrf	minU
	clrf	minD
	clrf	horaU
	clrf	horaD
	clrf	flags
	clrf	display
	clrf	s_temp
	clrf	w_temp
	clrf 	TMR1L
	clrf 	TMR1H	


exibirHHMM
;--------------------------------- EXIBI��O --------------------------------------------------
;	DISP4 = PORTA,5				-Unidade de segundo
;	DISP3 = PORTA,4				-Dezena de segundo
;	DISP2 = PORTA,3				-Unidade de Minuto
;	DISP1 = PORTA,2				-Dezena de Minuto
	;Horas e Minutos

		call	contagens

		;TECLA QUE CHAMA A FUN��O MINUTOS SEGUNDOS
	btfsc	PORTB,3
	goto	$+4
	btfss	PORTB,3
	goto	$-1
	goto 	exibirMMSS

	bcf	PORTA,4					;Desliga o DISP3
	bcf	PORTA,3
	bcf PORTA,2
	bsf	PORTA,5					;Liga o DISP4.

	pageselw	hex7seg
	movf 	minU,w				;Rotaciona para direita o que est� em segu, e salva no acumulador
	call 	hex7seg				;Chamando a subrotina.
	clrf	PCLATH
	movwf	PORTD				;Movendo do acumulador para a PORTD.

	call	atraso				;Atraso para manter a primeira tela do display ligada


	bcf	PORTA,5					;desliga o primeiro display de 7 segmentos.
	bcf PORTA,3
	bcf PORTA,2
	bsf	PORTA,4					;segundo display de 7 segmentos.
	
	pageselw	hex7seg
	movf	minD,w				;Move o que est� segd para o acumulador
	call 	hex7seg				;Chamando a subrotina.
	clrf	PCLATH
	movwf	PORTD				;Movendo do acumulador para a PORTD.

	call	atraso				;Atraso para manter a segunda tela do display ligada

	bcf	PORTA,5					;desliga o primeiro display de 7 segmentos.
	bcf PORTA,4
	bcf PORTA,2
	bsf	PORTA,3					;segundo display de 7 segmentos.

	pageselw	hex7seg
	movf		horaU,w
	call		hex7seg
	clrf		PCLATH	
	movwf		PORTD

	btfsc	flags,0				;Se esse bit for 0, vai pular a proxima linha
	bsf	PORTD,7					;Se o bit 0 da flag for 1, liga o ponto				;
	btfss	flags,0				;Testa o bit 0 da flag, se for 1, pula a proxima linha.
	bcf	PORTD,7					;Se o bit 0 da flag for 0, desliga o ponto

	call	atraso
	
	bcf	PORTA,5					;desliga o primeiro display de 7 segmentos.
	bcf PORTA,4
	bcf PORTA,3
	bsf	PORTA,2					;segundo display de 7 segmentos.

	pageselw	hex7seg
	movf	horaD,w
	call	hex7seg
	clrf	PCLATH
	movwf	PORTD

	call	atraso

goto	exibirHHMM

exibirMMSS
;--------------------------------- EXIBI��O --------------------------------------------------
;	DISP4 = PORTA,5				-Unidade de segundo
;	DISP3 = PORTA,4				-Dezena de segundo
;	DISP2 = PORTA,3				-Unidade de Minuto
;	DISP1 = PORTA,2				-Dezena de Minuto
	;Horas e Minutos
		pageselw contagens
		call	contagens
		clrf	PCLATH

		;TECLA QUE CHAMA A FUN��O MINUTOS SEGUNDOS
	btfsc	PORTB,3
	goto	$+4
	btfss	PORTB,3
	goto	$-1
	goto 	exibirHHMM

	bcf	PORTA,4					;Desliga o DISP3
	bcf	PORTA,3
	bcf PORTA,2
	bsf	PORTA,5					;Liga o DISP4.

	pageselw	hex7seg
	rrf 		segu,w				;Rotaciona para direita o que est� em segu, e salva no acumulador
	call 		hex7seg				;Chamando a subrotina.
	clrf		PCLATH
	movwf		PORTD				;Movendo do acumulador para a PORTD.

	call	atraso				;Atraso para manter a primeira tela do display ligada


	bcf	PORTA,5					;desliga o primeiro display de 7 segmentos.
	bcf PORTA,3
	bcf PORTA,2
	bsf	PORTA,4					;segundo display de 7 segmentos.
	
	pageselw	hex7seg
	movf		segd,w				;Move o que est� segd para o acumulador
	call 		hex7seg				;Chamando a subrotina.
	clrf		PCLATH
	movwf		PORTD				;Movendo do acumulador para a PORTD.

	call	atraso				;Atraso para manter a segunda tela do display ligada

	bcf	PORTA,5					;desliga o primeiro display de 7 segmentos.
	bcf PORTA,4
	bcf PORTA,2
	bsf	PORTA,3					;segundo display de 7 segmentos.

	pageselw	hex7seg
	movf		minU,w
	call		hex7seg
	clrf		PCLATH
	movwf		PORTD

	btfsc	flags,0				;Se esse bit for 0, vai pular a proxima linha
	bsf	PORTD,7					;Se o bit 0 da flag for 1, liga o ponto				;
	btfss	flags,0				;Testa o bit 0 da flag, se for 1, pula a proxima linha.
	bcf	PORTD,7					;Se o bit 0 da flag for 0, desliga o ponto

	call	atraso
	
	bcf	PORTA,5					;desliga o primeiro display de 7 segmentos.
	bcf PORTA,4
	bcf PORTA,3
	bsf	PORTA,2					;segundo display de 7 segmentos.

	pageselw	hex7seg
	movf		minD,w
	call		hex7seg
	clrf		PCLATH
	movwf		PORTD

	call	atraso

	goto	exibirMMSS

atraso							
	movlw	499/256+1			;move para o acumulador w. Essa divis�o � feita na inten��o de que possamos escrever o n�mero exato. Quantas vezes a parte alta conta 256.
	movwf	temp				;passa do acumulador para o registrador.
	movlw	499%256				;resto da divis�o.
	movwf	temp+1				;segundo byte de temp, parte baixa.

	nop
	nop
	nop
	nop
	nop

	decf	temp+1,f			;decrementa 1 do registrador temp+1 e guarda no pr�prio registrador.
	btfsc	STATUS,Z			;se o resultado do decremento n�o tiver dado zero, ele pula o pr�ximo passo.

	decfsz	temp,f				;se o bit Z de STATUS estiver em 1, quando a conta der 0, pula o pr�ximo comando.
	goto	$-8					;volta 8 linhas, at� o temporizador ser zerado.

	return

inter
; Entra na interrup��o a cada meio segundo

;------------------------------- Salva contexto ---------------------------
	movwf	w_temp				;salva o que est� no acumulador
	swapf	STATUS,w			;Usa-se o swapf para que o status n�o seja modificado ao mover para o acumulador, j� que o movf mexe na ula,
	movwf	s_temp              ;...Por exemplo, se tiver 0 no acumulador, o bit Z do status vai para 1, modificando o pr�prio STATUS.
;--------------------------------------------------------------------------

	bcf	PIR1,TMR1IF				;Zera o contador do timer, para que possa estourar novamente

	incf	segu				;Incrementa segu

	nop							;nops para ajustar o tempo de interrup��o em meio segundo
	nop
	nop

	movlw	3038/256            ;Inicia o contador do timer, ajustando para que a interrup��o dure meio segundo.
	movwf	TMR1H	            ;Move o que est� no acumulador para a parte alta do TMR1
	movlw	3038%256			;Resto da divis�o para o acumulador
	movwf	TMR1L				;Move o que est� no acumulador para a parte baixa do TMR1

;Respons�vel pela troca de ligado e desligado do ponto, se alternando pela segunda vez que passa pela interrup��o.

	btfss	segu,1				; O bit 1 de segu, troca toda vez que � incrementa 2 vezes, o que dura 1 segundo.
	bcf		flags,0				; � executado se o bit 1 de segu for 0
	btfsc	segu,1
	bsf		flags,0				; � executado se o bit 1 de segu for 1
			
;------------------------ Restaura contexto -------------------------------------------------------

	swapf	s_temp,w			;Faz o swap novamente, voltando ao normal, j� que essa instru��o inverte a parte baixa com a parte alta
	movwf	STATUS				;Retorna o valor do status para antes de entrar na interrup��o
	swapf	w_temp,f			;Retorna o valor que estava no acumulador antes de entrar na interrup��o
	swapf	w_temp,w

	retfie

ajustHoraD
;	DISP4 = PORTA,5				-Unidade de segundo
;	DISP3 = PORTA,4				-Dezena de segundo
;	DISP2 = PORTA,3				-Unidade de Minuto
;	DISP1 = PORTA,2				-Dezena de Minuto

	bcf		PORTA,5
	bcf		PORTA,4
	bcf		PORTA,3
	bsf		PORTA,2

		btfsc	PORTB,0
		goto	$+4
		btfss	PORTB,0
		goto	$-1
		goto	ajustHoraU

	;Validador de entrada(se for 2, a entrada ser� limitada)
		btfsc	PORTB,0
		goto	$+7
		movf	horaD,w
		xorlw	2
		btfss	STATUS,Z
		goto	$+3
		btfss	PORTB,0
		goto	$-1
	;Limita a decrementa��o	
		movf	horaD,w
		xorlw	0
		btfss	STATUS,Z
		goto	$+7
		btfsc	PORTB,1
		goto	$+5
		btfss	PORTB,1
		goto	$-1
		movlw	2		
		movwf	horaD
	;Decrementa��o
		btfsc	PORTB,1
		goto	$+4
		btfss	PORTB,1
		goto	$-1
		decf	horaD
	;Limita a incrementa��o
		movf	horaD,w
		xorlw	3
		btfss	STATUS,Z
		goto	$+2
		clrf	horaD
	;Incrementa��o
		btfsc	PORTB,2
		goto	$+4
		btfss	PORTB,2
		goto	$-1
		incf	horaD
		
	pageselw	hex7seg
	movf	horaD,w
	call	hex7seg
	clrf	PCLATH
	movwf	PORTD

	call	atraso

	goto	ajustHoraD
ajustHoraU
	bcf		PORTA,5
	bcf		PORTA,4
	bcf		PORTA,2
	bsf		PORTA,3
	;l�gica para limitar Hora
		movf	horaU,w
		xorlw	0			
		btfss	STATUS,Z
		goto	$+7
		btfsc	PORTB,1
		goto	$+10
		btfss	PORTB,1
		goto	$-1
		movlw	9		
		movwf	horaU
	;limita a decrementa��o
		movf	horaU,w
		xorlw	0
		btfss	STATUS,Z
		goto	$+7
		btfsc	PORTB,1
		goto	$+10
		btfss	PORTB,1
		goto	$-1
		movlw	3		
		movwf	horaU
	;decrementa��o
		btfsc	PORTB,1
		goto	$+4
		btfss	PORTB,1
		goto	$-1
		decf	horaU

	;limita a incrementa��o
		movf	horaU,w
		xorlw	4
		btfss	STATUS,Z
		goto	$+2
		clrf	horaU
	;incrementa��o
		btfsc	PORTB,2
		goto	$+4
		btfss	PORTB,2
		goto	$-1
		incf	horaU

		pageselw	hex7seg
		movf	horaU,w
		call	hex7seg
		clrf	PCLATH
		movwf	PORTD

		call	atraso

	
	goto	ajustHoraU
;ajustalarm

;goto ajusalarm

contagens
	;bot�o para parar contagem
		movlw	00000001b
		btfsc	PORTB,1
		goto	$+4
		btfss	PORTB,1
		goto	$-1
		xorwf T1CON,f

		movlw	00000001b
		btfsc	PORTB,0
		goto	$+5
		btfss	PORTB,0
		goto	$-1
		xorwf	T1CON,f
		call 	ajustHoraD



	clrc						;Limpa o carry
	rrf 	segu,w				;Rotaciona para direita o que est� em segu, e salva no acumulador.
	xorlw	10					;compara��o entre o acumulador(segu) e 10. Se segu=10, xor=0. Se segu=!10, xor=1.
	btfss	STATUS,Z			;se xor=0, Z=1, n�o pula(n�o entra no goto). Se xor=1, Z=0, pula tres linhas.
	goto	$+3
	clrf 	segu				;zerar segu.
	incf	segd				;incrementa segd.

	movf	segd,w				;Envia o que est� em segd para o acumulador
	xorlw 	6					;Faz um Xor entre o que est� no acumulador e 6
	btfss	STATUS,Z			;Pula a pr�xima linha se o bit Z for 0.
	goto	$+3
	clrf	segd				;Zera o Valor de segd
	incf	minU		

	movf	minU, w
	xorlw	10
	btfss	STATUS,Z
	goto 	$+3
	clrf	minU
	incf	minD

	movf	minD,w
	xorlw	6
	btfss	STATUS,Z
	goto	$+3
	clrf	minD
	incf	horaU

	movf	horaD,w			;movendo unidade de hora para o acumulador
	xorlw	2				;
	btfss	STATUS,Z
	goto	$+8
	movf	horaU,w
	xorlw	4
	btfss	STATUS,Z
	goto 	$+10
	clrf	horaU
	clrf	horaD
	goto 	$+7
	movf	horaU,w
	xorlw	10
	btfss	STATUS,Z
	goto 	$+3
	clrf	horaU
	incf	horaD

	return
	org	200h
hex7seg
	andlw	00001111b			;Faz a opera��o and do literal com o acumulador, e salva no acumulador. Serve para garantir que ao usar o rrf, zere o carry e evita que o ultimo bit n�o fique em 1.
	addwf	PCL,f				;Adicione w ao PCL(para dar um salto), assim a subrotina vai retornar o valor que deseja. PCL � o contador de programa.

	retlw	00111111b	;0	
	retlw	00000110b	;1
	retlw	01011011b	;2
	retlw	01001111b	;3
	retlw	01100110b	;4
	retlw	01101101b	;5
	retlw	01111100b	;6
	retlw	00000111b	;7
	retlw	01111111b	;8
	retlw	01100111b	;9
		retlw	01110111b	;A
		retlw	01111100b	;b
		retlw	00111001b	;C
		retlw	01011110b	;d
		retlw	01111001b	;E
		retlw	01110001b	;F	
	end
