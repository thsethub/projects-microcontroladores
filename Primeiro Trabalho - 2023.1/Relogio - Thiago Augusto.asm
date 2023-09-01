PROCESSOR       16F877A
	RADIX           DEC			;define para decimal, serve para setar como decimal quando não for binário(b)

#INCLUDE <p16F877A.inc>	
	__config	0x3F32

	org 0X00
	goto inicio

	org 0X04					
	goto inter

	org 0x20					;alocação de memória livre para uso
temp 	res 2					;Variável para a rotina de atraso
segu	res 1					;Conta as unidades de segundo.
segd	res 1					;Conta as dezenas de segundo.
minU	res 1
minD	res 1
horaU	res 1
horaD	res 1

w_temp	res 1					;Salva o que está no acumulador
s_temp	res 1					;Salva o que está no STATUS
flags	res 1					;Registrador auxiliar
display	res 1

inicio

	banksel	TRISD				;Seleciona o banksel do TRISD, TRISD é o configura PORTD.
	movlw	00000000b			;Bit que estiver em 0 é saída. Todos os pinos da PORTD e PORTA serão saídas.
	movwf	TRISD				;Movendo os bits do acumulador para o registrador.
	movwf	TRISA
	movlw	6					;Ao mover 6 para o ADCON1, configura a PORTA como porta digital.
	movwf	ADCON1
	bsf	PIE1,TMR1IE			    ;Liga interrupção timer1.
	bsf	INTCON,PEIE		     	;Liga int. periférico.
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
;--------------------------------- EXIBIÇÃO --------------------------------------------------
;	DISP4 = PORTA,5				-Unidade de segundo
;	DISP3 = PORTA,4				-Dezena de segundo
;	DISP2 = PORTA,3				-Unidade de Minuto
;	DISP1 = PORTA,2				-Dezena de Minuto
	;Horas e Minutos

		call	contagens

		;TECLA QUE CHAMA A FUNÇÃO MINUTOS SEGUNDOS
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
	movf 	minU,w				;Rotaciona para direita o que está em segu, e salva no acumulador
	call 	hex7seg				;Chamando a subrotina.
	clrf	PCLATH
	movwf	PORTD				;Movendo do acumulador para a PORTD.

	call	atraso				;Atraso para manter a primeira tela do display ligada


	bcf	PORTA,5					;desliga o primeiro display de 7 segmentos.
	bcf PORTA,3
	bcf PORTA,2
	bsf	PORTA,4					;segundo display de 7 segmentos.
	
	pageselw	hex7seg
	movf	minD,w				;Move o que está segd para o acumulador
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
;--------------------------------- EXIBIÇÃO --------------------------------------------------
;	DISP4 = PORTA,5				-Unidade de segundo
;	DISP3 = PORTA,4				-Dezena de segundo
;	DISP2 = PORTA,3				-Unidade de Minuto
;	DISP1 = PORTA,2				-Dezena de Minuto
	;Horas e Minutos
		pageselw contagens
		call	contagens
		clrf	PCLATH

		;TECLA QUE CHAMA A FUNÇÃO MINUTOS SEGUNDOS
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
	rrf 		segu,w				;Rotaciona para direita o que está em segu, e salva no acumulador
	call 		hex7seg				;Chamando a subrotina.
	clrf		PCLATH
	movwf		PORTD				;Movendo do acumulador para a PORTD.

	call	atraso				;Atraso para manter a primeira tela do display ligada


	bcf	PORTA,5					;desliga o primeiro display de 7 segmentos.
	bcf PORTA,3
	bcf PORTA,2
	bsf	PORTA,4					;segundo display de 7 segmentos.
	
	pageselw	hex7seg
	movf		segd,w				;Move o que está segd para o acumulador
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
	movlw	499/256+1			;move para o acumulador w. Essa divisão é feita na intenção de que possamos escrever o número exato. Quantas vezes a parte alta conta 256.
	movwf	temp				;passa do acumulador para o registrador.
	movlw	499%256				;resto da divisão.
	movwf	temp+1				;segundo byte de temp, parte baixa.

	nop
	nop
	nop
	nop
	nop

	decf	temp+1,f			;decrementa 1 do registrador temp+1 e guarda no próprio registrador.
	btfsc	STATUS,Z			;se o resultado do decremento não tiver dado zero, ele pula o próximo passo.

	decfsz	temp,f				;se o bit Z de STATUS estiver em 1, quando a conta der 0, pula o próximo comando.
	goto	$-8					;volta 8 linhas, até o temporizador ser zerado.

	return

inter
; Entra na interrupção a cada meio segundo

;------------------------------- Salva contexto ---------------------------
	movwf	w_temp				;salva o que está no acumulador
	swapf	STATUS,w			;Usa-se o swapf para que o status não seja modificado ao mover para o acumulador, já que o movf mexe na ula,
	movwf	s_temp              ;...Por exemplo, se tiver 0 no acumulador, o bit Z do status vai para 1, modificando o próprio STATUS.
;--------------------------------------------------------------------------

	bcf	PIR1,TMR1IF				;Zera o contador do timer, para que possa estourar novamente

	incf	segu				;Incrementa segu

	nop							;nops para ajustar o tempo de interrupção em meio segundo
	nop
	nop

	movlw	3038/256            ;Inicia o contador do timer, ajustando para que a interrupção dure meio segundo.
	movwf	TMR1H	            ;Move o que está no acumulador para a parte alta do TMR1
	movlw	3038%256			;Resto da divisão para o acumulador
	movwf	TMR1L				;Move o que está no acumulador para a parte baixa do TMR1

;Responsável pela troca de ligado e desligado do ponto, se alternando pela segunda vez que passa pela interrupção.

	btfss	segu,1				; O bit 1 de segu, troca toda vez que é incrementa 2 vezes, o que dura 1 segundo.
	bcf		flags,0				; È executado se o bit 1 de segu for 0
	btfsc	segu,1
	bsf		flags,0				; É executado se o bit 1 de segu for 1
			
;------------------------ Restaura contexto -------------------------------------------------------

	swapf	s_temp,w			;Faz o swap novamente, voltando ao normal, já que essa instrução inverte a parte baixa com a parte alta
	movwf	STATUS				;Retorna o valor do status para antes de entrar na interrupção
	swapf	w_temp,f			;Retorna o valor que estava no acumulador antes de entrar na interrupção
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

	;Validador de entrada(se for 2, a entrada será limitada)
		btfsc	PORTB,0
		goto	$+7
		movf	horaD,w
		xorlw	2
		btfss	STATUS,Z
		goto	$+3
		btfss	PORTB,0
		goto	$-1
	;Limita a decrementação	
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
	;Decrementação
		btfsc	PORTB,1
		goto	$+4
		btfss	PORTB,1
		goto	$-1
		decf	horaD
	;Limita a incrementação
		movf	horaD,w
		xorlw	3
		btfss	STATUS,Z
		goto	$+2
		clrf	horaD
	;Incrementação
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
	;lógica para limitar Hora
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
	;limita a decrementação
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
	;decrementação
		btfsc	PORTB,1
		goto	$+4
		btfss	PORTB,1
		goto	$-1
		decf	horaU

	;limita a incrementação
		movf	horaU,w
		xorlw	4
		btfss	STATUS,Z
		goto	$+2
		clrf	horaU
	;incrementação
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
	;botão para parar contagem
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
	rrf 	segu,w				;Rotaciona para direita o que está em segu, e salva no acumulador.
	xorlw	10					;comparação entre o acumulador(segu) e 10. Se segu=10, xor=0. Se segu=!10, xor=1.
	btfss	STATUS,Z			;se xor=0, Z=1, não pula(não entra no goto). Se xor=1, Z=0, pula tres linhas.
	goto	$+3
	clrf 	segu				;zerar segu.
	incf	segd				;incrementa segd.

	movf	segd,w				;Envia o que está em segd para o acumulador
	xorlw 	6					;Faz um Xor entre o que está no acumulador e 6
	btfss	STATUS,Z			;Pula a próxima linha se o bit Z for 0.
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
	andlw	00001111b			;Faz a operação and do literal com o acumulador, e salva no acumulador. Serve para garantir que ao usar o rrf, zere o carry e evita que o ultimo bit não fique em 1.
	addwf	PCL,f				;Adicione w ao PCL(para dar um salto), assim a subrotina vai retornar o valor que deseja. PCL é o contador de programa.

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
