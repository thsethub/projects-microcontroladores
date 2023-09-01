PROCESSOR       16F877A
	RADIX           DEC			;define para decimal, serve para setar como decimal quando não for binário(b)

#INCLUDE <p16F877A.inc>	
	__config	0x3F32

	org 0X00
	goto inicio

	org 0X04					
	goto inter

	org 0x20					;alocação de memória livre para uso
temp 	res 2					
segu	res 1					
segd	res 1					
minU	res 1					
minD	res 1
horaU	res 1
horaD	res 1
alarm	res	1
alarmUmin	res 1
alarmDmin	res 1
alarmUhora	res	1
alarmDhora	res	1
buser	res	1
w_temp	res 1					
s_temp	res 1					
flags	res 1					
display	res 1

inicio

	banksel	TRISD				
	movlw	00000000b			
	movwf	TRISD				
	movwf	TRISA
	movwf	TRISC
	movlw	6					
	movwf	ADCON1
;interrupções
	bsf	PIE1,TMR1IE			    
	bsf	INTCON,PEIE		     	
	bsf	INTCON,GIE		    	

	banksel	PORTD				
	movlw	00000000b			
	movwf	PORTD				
	movwf	PORTA				
	movwf	PORTC

	clrf	T1CON				
	bsf	T1CON,TMR1ON		    			
	bsf	T1CON,T1CKPS1           
	bsf	T1CON,T1CKPS0			

	clrf	segu				;Limpa os registradores
	clrf	segd
	clrf	minU
	clrf	minD
	clrf	horaU
	clrf	horaD
	clrf	flags
	clrf	buser
	clrf	alarm
	clrf	alarmDmin
	clrf	alarmUmin
	clrf	alarmDhora
	clrf	alarmUhora
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

		;PARTE QUE CHAMA A FUNÇAO DE ALARME
		movf	alarm,w		
		xorlw	1
		btfss	STATUS,Z	
		goto	$+4			
		pageselw	funAlarme	
		call	funAlarme			
		clrf	PCLATH

		;TECLA QUE CHAMA A FUNÇÃO MINUTOS SEGUNDOS
	btfsc	PORTB,3
	goto	$+4
	btfss	PORTB,3
	goto	$-1
	goto 	exibirMMSS

	bcf	PORTA,4					
	bcf	PORTA,3
	bcf PORTA,2
	bsf	PORTA,5					

	pageselw	hex7seg
	movf 	minU,w				;Rotaciona para direita o que está em segu, e salva no acumulador
	call 	hex7seg				;Chamando a subrotina.
	clrf	PCLATH
	movwf	PORTD				;Movendo do acumulador para a PORTD.

				movf	alarm,w		
				xorlw	0			
				btfss	STATUS,Z	
				goto	$+3			
				bcf		PORTD,7		
				goto	$+2			
				bsf		PORTD,7		

	call	atraso				


	bcf	PORTA,5					
	bcf PORTA,3
	bcf PORTA,2
	bsf	PORTA,4					
	
	pageselw	hex7seg
	movf	minD,w				
	call 	hex7seg				
	clrf	PCLATH
	movwf	PORTD				

	call	atraso				

	bcf	PORTA,5					
	bcf PORTA,4
	bcf PORTA,2
	bsf	PORTA,3					

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
	
	bcf	PORTA,5					
	bcf PORTA,4
	bcf PORTA,3
	bsf	PORTA,2					

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
		call	contagens
	
		;PARTE QUE CHAMA A FUNÇAO DE ALARME
		movf	alarm,w		
		xorlw	1
		btfss	STATUS,Z	
		goto	$+4			
		pageselw	funAlarme
		call	funAlarme			
		clrf	PCLATH

		;TECLA QUE CHAMA A FUNÇÃO HORAS E MINUTOS
	btfsc	PORTB,3
	goto	$+4
	btfss	PORTB,3
	goto	$-1
	goto 	exibirHHMM

	bcf	PORTA,4					
	bcf	PORTA,3
	bcf PORTA,2
	bsf	PORTA,5					

	pageselw	hex7seg
	rrf 		segu,w				
	call 		hex7seg				
	clrf		PCLATH
	movwf		PORTD				

				movf	alarm,w		
				xorlw	0			
				btfss	STATUS,Z	
				goto	$+3			
				bcf		PORTD,7		
				goto	$+2			
				bsf		PORTD,7		

	call	atraso				

	bcf	PORTA,5					
	bcf PORTA,3
	bcf PORTA,2
	bsf	PORTA,4					
	
	pageselw	hex7seg
	movf		segd,w				
	call 		hex7seg				
	clrf		PCLATH
	movwf		PORTD				

	call	atraso				

	bcf	PORTA,5					
	bcf PORTA,4
	bcf PORTA,2
	bsf	PORTA,3					

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
	
	bcf	PORTA,5					
	bcf PORTA,4
	bcf PORTA,3
	bsf	PORTA,2					

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
	bcf		PORTA,5
	bcf		PORTA,4
	bcf		PORTA,3
	bsf		PORTA,2

;se for 2 passa para o ajuste de hora limitado
		btfsc	PORTB,0
		goto	$+12
		movf	horaD,w
		xorlw	2
		btfss	STATUS,Z
		goto	$+5
		btfss	PORTB,0
		goto	$-1
		clrf	horaU
		goto 	ajustHoraU2
	;passa para o ajuste de hora
		btfss	PORTB,0
		goto	$-1
		goto	ajustHoraU

	;limita a decrementação em 2(de 0 vai para 2)
		movf	horaD,w
		xorlw	0
		btfss	STATUS,Z
		goto	$+7
		btfsc	PORTB,1
		goto	$+10
		btfss	PORTB,1
		goto	$-1
		movlw	2		
		movwf	horaD
	;decrementar
		btfsc	PORTB,1
		goto	$+4
		btfss	PORTB,1
		goto	$-1
		decf	horaD

	;limita a incrementação em 2(de 2 vai para 0) 
		movf	horaD,w
		xorlw	3
		btfss	STATUS,Z
		goto	$+2
		clrf	horaD
	;incrementar
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

		btfsc	PORTB,0
		goto	$+4
		btfss	PORTB,0
		goto	$-1
		goto	ajustminD

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
	;decrementação
		btfsc	PORTB,1
		goto	$+4
		btfss	PORTB,1
		goto	$-1
		decf	horaU

	;limita a incrementação
		movf	horaU,w
		xorlw	10
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
ajustHoraU2
	bcf		PORTA,5
	bcf		PORTA,4
	bcf		PORTA,2
	bsf		PORTA,3

		btfsc	PORTB,0
		goto	$+4
		btfss	PORTB,0
		goto	$-1
		goto	ajustminD

	;lógica para limitar Hora
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

	
	goto	ajustHoraU2

ajustminD
	bcf		PORTA,5
	bcf		PORTA,3
	bcf		PORTA,2
	bsf		PORTA,4
	;botão para ajust de unidades de minutos
		btfsc	PORTB,0
		goto	$+4
		btfss	PORTB,0
		goto	$-1
		goto	ajustminU
	
		;limita a decrementação
		movf	minD,w
		xorlw	0
		btfss	STATUS,Z
		goto	$+7
		btfsc	PORTB,1
		goto	$+10
		btfss	PORTB,1
		goto	$-1
		movlw	5		
		movwf	minD
	;decrementar
		btfsc	PORTB,1
		goto	$+4
		btfss	PORTB,1
		goto	$-1
		decf	minD

	;limita a incrementação
		movf	minD,w
		xorlw	6
		btfss	STATUS,Z
		goto	$+2
		clrf	minD
	;incrementar
		btfsc	PORTB,2
		goto	$+4
		btfss	PORTB,2
		goto	$-1
		incf	minD

		pageselw	hex7seg
		movf	minD,w
		call	hex7seg
		clrf	PCLATH
		movwf	PORTD

	call	atraso
goto ajustminD

ajustminU
	bcf		PORTA,4
	bcf		PORTA,3
	bcf		PORTA,2
	bsf		PORTA,5
	;volta a exibir HHMM
		btfsc	PORTB,0
		goto	$+6
		btfss	PORTB,0
		goto	$-1
		goto	ajualarmhoraD

	;limita a decrementação
		movf	minU,w
		xorlw	0
		btfss	STATUS,Z
		goto	$+7
		btfsc	PORTB,1
		goto	$+10
		btfss	PORTB,1
		goto	$-1
		movlw	9		
		movwf	minU
	;decrementar
		btfsc	PORTB,1
		goto	$+4
		btfss	PORTB,1
		goto	$-1
		decf	minU

	;incrementar
		btfsc	PORTB,2
		goto	$+4
		btfss	PORTB,2
		goto	$-1
		incf	minU
	;limita a incrementação 
		movf	minU,w		
		xorlw	10			
		btfss	STATUS,Z	
		goto	$+2		
		clrf	minU			

	pageselw	hex7seg
	movf	minU,w
	call	hex7seg
	clrf	PCLATH
	movwf	PORTD

	call	atraso
goto ajustminU

ajualarmhoraD

	bcf		PORTA,5
	bcf		PORTA,4
	bcf		PORTA,3
	bsf		PORTA,2
	;LÓGICA PARA ALTERNAR NO VALOR DE alarmUhora entre 1 e 2
;se for 2 passa para o ajuste de hora limitado
		btfsc	PORTB,0
		goto	$+12
		movf	alarmDhora,w
		xorlw	2
		btfss	STATUS,Z
		goto	$+5
		btfss	PORTB,0
		goto	$-1
		clrf	alarmUhora
		goto 	ajualarmhoraU2
	;passa para o ajuste de hora
		btfss	PORTB,0
		goto	$-1
		goto	ajualarmhoraU

	;limita a decrementação
		movf	alarmDhora,w
		xorlw	0
		btfss	STATUS,Z
		goto	$+7
		btfsc	PORTB,1
		goto	$+10
		btfss	PORTB,1
		goto	$-1
		movlw	2		
		movwf	alarmDhora
	;decrementar
		btfsc	PORTB,1
		goto	$+4
		btfss	PORTB,1
		goto	$-1
		decf	alarmDhora

	;incrementar
		btfsc	PORTB,2
		goto	$+4
		btfss	PORTB,2
		goto	$-1
		incf	alarmDhora
	;limita a incrementação 
		movf	alarmDhora,w
		xorlw	3
		btfss	STATUS,Z
		goto	$+2
		clrf	alarmDhora
		
	pageselw	hex7seg
	movf	alarmDhora,w
	call	hex7seg
	clrf	PCLATH
	movwf	PORTD

	call	atraso


goto ajualarmhoraD

ajualarmhoraU
	bcf		PORTA,5
	bcf		PORTA,4
	bcf		PORTA,2
	bsf		PORTA,3

		btfsc	PORTB,0
		goto	$+4
		btfss	PORTB,0
		goto	$-1
		goto	ajualarmDmin

		movf	alarmUhora,w
		xorlw	0
		btfss	STATUS,Z
		goto	$+7
		btfsc	PORTB,1
		goto	$+10
		btfss	PORTB,1
		goto	$-1
		movlw	9		
		movwf	alarmUhora
	;decrementar
		btfsc	PORTB,1
		goto	$+4
		btfss	PORTB,1
		goto	$-1
		decf	alarmUhora

	;incrementar
		btfsc	PORTB,2
		goto	$+4
		btfss	PORTB,2
		goto	$-1
		incf	alarmUhora
	;limita a incrementação
		movf	alarmUhora,w
		xorlw	10
		btfss	STATUS,Z
		goto	$+2
		clrf	alarmUhora

		pageselw	hex7seg
		movf	alarmUhora,w
		call	hex7seg
		clrf	PCLATH
		movwf	PORTD

		call	atraso

	
	goto	ajualarmhoraU
ajualarmhoraU2
	bcf		PORTA,5
	bcf		PORTA,4
	bcf		PORTA,2
	bsf		PORTA,3

		btfsc	PORTB,0
		goto	$+4
		btfss	PORTB,0
		goto	$-1
		goto	ajualarmDmin

	;lógica para limitar Hora
		movf	alarmUhora,w
		xorlw	0
		btfss	STATUS,Z
		goto	$+7
		btfsc	PORTB,1
		goto	$+10
		btfss	PORTB,1
		goto	$-1
		movlw	3		
		movwf	alarmUhora
	;decrementar
		btfsc	PORTB,1
		goto	$+4
		btfss	PORTB,1
		goto	$-1
		decf	alarmUhora

	;incrementar
		btfsc	PORTB,2
		goto	$+4
		btfss	PORTB,2
		goto	$-1
		incf	alarmUhora
	;limita a incrementação
		movf	alarmUhora,w
		xorlw	4
		btfss	STATUS,Z
		goto	$+2
		clrf	alarmUhora

		pageselw	hex7seg
		movf	alarmUhora,w
		call	hex7seg
		clrf	PCLATH
		movwf	PORTD

		call	atraso

	
	goto	ajustHoraU2

ajualarmDmin
	bcf		PORTA,5
	bcf		PORTA,3
	bcf		PORTA,2
	bsf		PORTA,4
	;botão para ajust de unidades de minutos
		btfsc	PORTB,0
		goto	$+4
		btfss	PORTB,0
		goto	$-1
		goto	ajualarmUmin
	
		;limita a decrementação
		movf	alarmDmin,w
		xorlw	0
		btfss	STATUS,Z
		goto	$+7
		btfsc	PORTB,1
		goto	$+10
		btfss	PORTB,1
		goto	$-1
		movlw	5		
		movwf	alarmDmin
	;decrementar
		btfsc	PORTB,1
		goto	$+4
		btfss	PORTB,1
		goto	$-1
		decf	alarmDmin

	;limita a incrementação
		movf	alarmDmin,w
		xorlw	6
		btfss	STATUS,Z
		goto	$+2
		clrf	alarmDmin
	;incrementar
		btfsc	PORTB,2
		goto	$+4
		btfss	PORTB,2
		goto	$-1
		incf	alarmDmin

		pageselw	hex7seg
		movf	alarmDmin,w
		call	hex7seg
		clrf	PCLATH
		movwf	PORTD

	call	atraso
goto ajualarmDmin

ajualarmUmin
	bcf		PORTA,4
	bcf		PORTA,3
	bcf		PORTA,2
	bsf		PORTA,5
	;volta a exibir HHMM
		btfsc	PORTB,0
		goto	$+6
		btfss	PORTB,0
		goto	$-1
		movlw	00000001b
		xorwf	T1CON,f
		goto	exibirHHMM

	;limita a decrementação
		movf	alarmUmin,w
		xorlw	0
		btfss	STATUS,Z
		goto	$+7
		btfsc	PORTB,1
		goto	$+10
		btfss	PORTB,1
		goto	$-1
		movlw	9		
		movwf	alarmUmin
	;decrementar
		btfsc	PORTB,1
		goto	$+4
		btfss	PORTB,1
		goto	$-1
		decf	alarmUmin

	;limita a incrementação
		movf	alarmUmin,w		
		xorlw	10			
		btfss	STATUS,Z
		goto	$+2	
		clrf	alarmUmin
	;incrementar
		btfsc	PORTB,2
		goto	$+4
		btfss	PORTB,2
		goto	$-1
		incf	alarmUmin

	pageselw	hex7seg
	movf	alarmUmin,w
	call	hex7seg
	clrf	PCLATH
	movwf	PORTD

	call	atraso

goto ajualarmUmin

contagens

	;botão que chama a subrotina ajustHoraD
		movlw	00000001b
		btfsc	PORTB,0
		goto	$+5
		btfss	PORTB,0
		goto	$-1
		xorwf	T1CON,f
		call 	ajustHoraD
		
		;ativa o buser quando o alarme manda
		movf	buser,w
		xorlw	2
		btfss	STATUS,Z
		goto	$+4	
		bsf		PORTC,1
		movlw	1
		movwf	buser

	;desativa o alarme e o buzer
		movf	alarm,w
		xorlw	2
		btfss	STATUS,Z
		goto	$+10
		movlw	00000010b
		btfsc	PORTB,5
		goto	$+7
		btfss	PORTB,5
		goto	$-1
		xorwf alarm,f
		clrf	buser
		bcf		PORTC,1
		goto	$+7
		movlw	00000001b
		btfsc	PORTB,5
		goto	$+4
		btfss	PORTB,5
		goto	$-1
		xorwf alarm,f

	;silencia o buzer e mantem o alarme funcionando
		movf	buser,w
		xorlw	1
		btfss	STATUS,Z
		goto	$+2	
		btfsc	PORTB,4
		goto	$+8
		btfss	PORTB,4
		goto	$-1
		movlw	0
		movwf	buser
		movlw	2
		movwf	alarm
		bcf		PORTC,1
		
	clrc						
	rrf 	segu,w				
	xorlw	10					
	btfss	STATUS,Z			
	goto	$+3
	clrf 	segu				
	incf	segd				

	movf	segd,w				
	xorlw 	6					
	btfss	STATUS,Z			
	goto	$+3
	clrf	segd			
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

	movf	horaD,w			
	xorlw	2				
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
	org	600h
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

funAlarme
	;faz a comparação entre o valor na entrada de alarm com o horário atual, até que seja 0
		movf	alarmDhora,w
		movwf	temp		
		movf	horaD,w		
		subwf	temp		
		btfss	STATUS,Z	
		goto	$+23		

		movf	alarmUhora,w
		movwf	temp
		movf	horaU,w
		subwf	temp
		btfss	STATUS,Z
		goto	$+17

		movf	alarmDmin,w
		movwf	temp
		movf	minD,w
		subwf	temp
		btfss	STATUS,Z
		goto	$+11

		movf	alarmUmin,w
		movwf	temp
		movf	minU,w
		subwf	temp
		btfss	STATUS,Z
		goto	$+5	
		movlw	2		
		movwf	buser	
		movlw	2
		movwf	alarm
	return
	
	end
