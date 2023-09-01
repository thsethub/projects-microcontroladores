
_main:

;aula1.mpas,32 :: 		begin
;aula1.mpas,33 :: 		TRISB  := 0;
	CLRF       TRISB+0
;aula1.mpas,34 :: 		PORTB  := %00000000;
	CLRF       PORTB+0
;aula1.mpas,35 :: 		TRISC  := 0;
	CLRF       TRISC+0
;aula1.mpas,36 :: 		PORTC  := 0;
	CLRF       PORTC+0
;aula1.mpas,37 :: 		val    := 0;
	CLRF       _val+0
	CLRF       _val+1
	CLRF       _val+2
	CLRF       _val+3
;aula1.mpas,38 :: 		ch     :='0';
	MOVLW      48
	MOVWF      _ch+0
;aula1.mpas,39 :: 		duty   :=25;
	MOVLW      25
	MOVWF      _duty+0
;aula1.mpas,40 :: 		bt     :=0;
	CLRF       _bt+0
;aula1.mpas,41 :: 		v      :=0;
	CLRF       _v+0
	CLRF       _v+1
;aula1.mpas,42 :: 		txt1 := 'Microcontrolador';
	MOVLW      77
	MOVWF      _txt1+0
	MOVLW      105
	MOVWF      _txt1+1
	MOVLW      99
	MOVWF      _txt1+2
	MOVLW      114
	MOVWF      _txt1+3
	MOVLW      111
	MOVWF      _txt1+4
	MOVLW      99
	MOVWF      _txt1+5
	MOVLW      111
	MOVWF      _txt1+6
	MOVLW      110
	MOVWF      _txt1+7
	MOVLW      116
	MOVWF      _txt1+8
	MOVLW      114
	MOVWF      _txt1+9
	MOVLW      111
	MOVWF      _txt1+10
	MOVLW      108
	MOVWF      _txt1+11
	MOVLW      97
	MOVWF      _txt1+12
	MOVLW      100
	MOVWF      _txt1+13
	MOVLW      111
	MOVWF      _txt1+14
	MOVLW      114
	MOVWF      _txt1+15
	CLRF       _txt1+16
;aula1.mpas,43 :: 		txt2 := '';
	CLRF       _txt2+0
;aula1.mpas,44 :: 		txt3 := '';
	CLRF       _txt3+0
;aula1.mpas,45 :: 		txt4 := 'example';
	MOVLW      101
	MOVWF      _txt4+0
	MOVLW      120
	MOVWF      _txt4+1
	MOVLW      97
	MOVWF      _txt4+2
	MOVLW      109
	MOVWF      _txt4+3
	MOVLW      112
	MOVWF      _txt4+4
	MOVLW      108
	MOVWF      _txt4+5
	MOVLW      101
	MOVWF      _txt4+6
	CLRF       _txt4+7
;aula1.mpas,46 :: 		txt5 := 'Foi';
	MOVLW      70
	MOVWF      _txt5+0
	MOVLW      111
	MOVWF      _txt5+1
	MOVLW      105
	MOVWF      _txt5+2
	CLRF       _txt5+3
;aula1.mpas,48 :: 		adc_init();
	CALL       _ADC_Init+0
;aula1.mpas,49 :: 		Lcd_Init();                        // Inicia o LCD
	CALL       _Lcd_Init+0
;aula1.mpas,50 :: 		PWM1_Start(); //INICIO DO PWM
	CALL       _PWM1_Start+0
;aula1.mpas,51 :: 		PWM1_init(5000);
	BCF        T2CON+0, 0
	BCF        T2CON+0, 1
	BCF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      199
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;aula1.mpas,52 :: 		UART1_Init(9600);
	MOVLW      25
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;aula1.mpas,53 :: 		Lcd_Cmd(_LCD_CLEAR);               // Limpa display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;aula1.mpas,54 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;aula1.mpas,55 :: 		sound_init(PORTC,1);
	MOVLW      PORTC+0
	MOVWF      FARG_Sound_Init_snd_port+0
	MOVLW      1
	MOVWF      FARG_Sound_Init_snd_pin+0
	CALL       _Sound_Init+0
;aula1.mpas,56 :: 		LCD_Out(1,1,txt1);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt1+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;aula1.mpas,59 :: 		while TRUE do                      // Endless loop
L__main2:
;aula1.mpas,61 :: 		if (UART1_Data_Ready() <> 0) then
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L__main7
;aula1.mpas,63 :: 		ch:=UART1_READ();
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _ch+0
;aula1.mpas,64 :: 		LCD_Out(1,1,txt1);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt1+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;aula1.mpas,65 :: 		UART1_Write(ch);
	MOVF       _ch+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;aula1.mpas,66 :: 		UART1_Write(10);
	MOVLW      10
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;aula1.mpas,67 :: 		UART1_Write(13);
	MOVLW      13
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;aula1.mpas,71 :: 		if  ch='a'  then
	MOVF       _ch+0, 0
	XORLW      97
	BTFSS      STATUS+0, 2
	GOTO       L__main10
;aula1.mpas,73 :: 		PORTB.1:=1  ;
	BSF        PORTB+0, 1
;aula1.mpas,74 :: 		end;
L__main10:
;aula1.mpas,76 :: 		if  ch='A'  then
	MOVF       _ch+0, 0
	XORLW      65
	BTFSS      STATUS+0, 2
	GOTO       L__main13
;aula1.mpas,78 :: 		PORTB.1:=0  ;
	BCF        PORTB+0, 1
;aula1.mpas,79 :: 		end;
L__main13:
;aula1.mpas,81 :: 		if  ch='O'  then
	MOVF       _ch+0, 0
	XORLW      79
	BTFSS      STATUS+0, 2
	GOTO       L__main16
;aula1.mpas,83 :: 		if PORTB.3 = 1  then
	BTFSS      PORTB+0, 3
	GOTO       L__main19
;aula1.mpas,84 :: 		PORTB.3 := 0
	BCF        PORTB+0, 3
	GOTO       L__main20
;aula1.mpas,85 :: 		else
L__main19:
;aula1.mpas,86 :: 		PORTB.3 := 1
	BSF        PORTB+0, 3
L__main20:
;aula1.mpas,87 :: 		end;
L__main16:
;aula1.mpas,89 :: 		if ch='m' then
	MOVF       _ch+0, 0
	XORLW      109
	BTFSS      STATUS+0, 2
	GOTO       L__main22
;aula1.mpas,91 :: 		if PORTB = %00000000 then
	MOVF       PORTB+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main25
;aula1.mpas,93 :: 		txt2:='00000000';
	MOVLW      48
	MOVWF      _txt2+0
	MOVLW      48
	MOVWF      _txt2+1
	MOVLW      48
	MOVWF      _txt2+2
	MOVLW      48
	MOVWF      _txt2+3
	MOVLW      48
	MOVWF      _txt2+4
	MOVLW      48
	MOVWF      _txt2+5
	MOVLW      48
	MOVWF      _txt2+6
	MOVLW      48
	MOVWF      _txt2+7
	CLRF       _txt2+8
;aula1.mpas,94 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;aula1.mpas,95 :: 		lcd_out(1,1,txt1);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt1+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;aula1.mpas,96 :: 		lcd_out(2,1,txt2);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;aula1.mpas,97 :: 		end;
L__main25:
;aula1.mpas,98 :: 		if PORTB = %00000010 then
	MOVF       PORTB+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L__main28
;aula1.mpas,100 :: 		txt2:='00000010';
	MOVLW      48
	MOVWF      _txt2+0
	MOVLW      48
	MOVWF      _txt2+1
	MOVLW      48
	MOVWF      _txt2+2
	MOVLW      48
	MOVWF      _txt2+3
	MOVLW      48
	MOVWF      _txt2+4
	MOVLW      48
	MOVWF      _txt2+5
	MOVLW      49
	MOVWF      _txt2+6
	MOVLW      48
	MOVWF      _txt2+7
	CLRF       _txt2+8
;aula1.mpas,101 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;aula1.mpas,102 :: 		lcd_out(1,1,txt1);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt1+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;aula1.mpas,103 :: 		lcd_out(2,1,txt2);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;aula1.mpas,104 :: 		end;
L__main28:
;aula1.mpas,105 :: 		if PORTB = %00001010 then
	MOVF       PORTB+0, 0
	XORLW      10
	BTFSS      STATUS+0, 2
	GOTO       L__main31
;aula1.mpas,107 :: 		txt2:='00001010';
	MOVLW      48
	MOVWF      _txt2+0
	MOVLW      48
	MOVWF      _txt2+1
	MOVLW      48
	MOVWF      _txt2+2
	MOVLW      48
	MOVWF      _txt2+3
	MOVLW      49
	MOVWF      _txt2+4
	MOVLW      48
	MOVWF      _txt2+5
	MOVLW      49
	MOVWF      _txt2+6
	MOVLW      48
	MOVWF      _txt2+7
	CLRF       _txt2+8
;aula1.mpas,108 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;aula1.mpas,109 :: 		lcd_out(1,1,txt1);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt1+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;aula1.mpas,110 :: 		lcd_out(2,1,txt2);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;aula1.mpas,111 :: 		end;
L__main31:
;aula1.mpas,112 :: 		if PORTB = %00001000 then
	MOVF       PORTB+0, 0
	XORLW      8
	BTFSS      STATUS+0, 2
	GOTO       L__main34
;aula1.mpas,114 :: 		txt2:='00001000';
	MOVLW      48
	MOVWF      _txt2+0
	MOVLW      48
	MOVWF      _txt2+1
	MOVLW      48
	MOVWF      _txt2+2
	MOVLW      48
	MOVWF      _txt2+3
	MOVLW      49
	MOVWF      _txt2+4
	MOVLW      48
	MOVWF      _txt2+5
	MOVLW      48
	MOVWF      _txt2+6
	MOVLW      48
	MOVWF      _txt2+7
	CLRF       _txt2+8
;aula1.mpas,115 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;aula1.mpas,116 :: 		lcd_out(1,1,txt1);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt1+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;aula1.mpas,117 :: 		lcd_out(2,1,txt2);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;aula1.mpas,118 :: 		end;
L__main34:
;aula1.mpas,119 :: 		end;
L__main22:
;aula1.mpas,121 :: 		if ch='M' then
	MOVF       _ch+0, 0
	XORLW      77
	BTFSS      STATUS+0, 2
	GOTO       L__main37
;aula1.mpas,123 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;aula1.mpas,124 :: 		LCD_Out(2,1,txt5);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt5+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;aula1.mpas,125 :: 		lcd_out(1,1,txt1);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt1+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;aula1.mpas,126 :: 		end;
L__main37:
;aula1.mpas,128 :: 		if ch='S' then
	MOVF       _ch+0, 0
	XORLW      83
	BTFSS      STATUS+0, 2
	GOTO       L__main40
;aula1.mpas,130 :: 		sound_play(3000,1000);
	MOVLW      184
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	MOVLW      11
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVLW      232
	MOVWF      FARG_Sound_Play_duration_ms+0
	MOVLW      3
	MOVWF      FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;aula1.mpas,131 :: 		end;
L__main40:
;aula1.mpas,133 :: 		if  ch='D' then
	MOVF       _ch+0, 0
	XORLW      68
	BTFSS      STATUS+0, 2
	GOTO       L__main43
;aula1.mpas,135 :: 		v:=ADC_Read(0);
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _v+0
	MOVF       R0+1, 0
	MOVWF      _v+1
;aula1.mpas,136 :: 		wordtostr(v,txt2);
	MOVF       R0+0, 0
	MOVWF      FARG_WordToStr_input+0
	MOVF       R0+1, 0
	MOVWF      FARG_WordToStr_input+1
	MOVLW      _txt2+0
	MOVWF      FARG_WordToStr_output+0
	CALL       _WordToStr+0
;aula1.mpas,137 :: 		UART1_Write_Text(txt2);
	MOVLW      _txt2+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;aula1.mpas,138 :: 		UART1_Write(10);
	MOVLW      10
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;aula1.mpas,139 :: 		UART1_Write(13);
	MOVLW      13
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;aula1.mpas,140 :: 		end;
L__main43:
;aula1.mpas,142 :: 		if  ch='T' then
	MOVF       _ch+0, 0
	XORLW      84
	BTFSS      STATUS+0, 2
	GOTO       L__main46
;aula1.mpas,144 :: 		temp:=adc_read(2);
	MOVLW      2
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _temp+0
	MOVF       R0+1, 0
	MOVWF      _temp+1
	CLRF       _temp+2
	CLRF       _temp+3
;aula1.mpas,145 :: 		temp:=(temp*5*100)/1023;
	MOVF       _temp+0, 0
	MOVWF      R0+0
	MOVF       _temp+1, 0
	MOVWF      R0+1
	MOVF       _temp+2, 0
	MOVWF      R0+2
	MOVF       _temp+3, 0
	MOVWF      R0+3
	MOVLW      5
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Mul_32x32_U+0
	MOVLW      100
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Mul_32x32_U+0
	MOVLW      255
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      _temp+0
	MOVF       R0+1, 0
	MOVWF      _temp+1
	MOVF       R0+2, 0
	MOVWF      _temp+2
	MOVF       R0+3, 0
	MOVWF      _temp+3
;aula1.mpas,146 :: 		inttostr(temp,txt4);
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       R0+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txt4+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;aula1.mpas,147 :: 		UART1_Write_Text(txt4);
	MOVLW      _txt4+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;aula1.mpas,148 :: 		UART1_Write(10);
	MOVLW      10
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;aula1.mpas,149 :: 		UART1_Write(13);
	MOVLW      13
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;aula1.mpas,150 :: 		end;
L__main46:
;aula1.mpas,152 :: 		if ch='t' then
	MOVF       _ch+0, 0
	XORLW      116
	BTFSS      STATUS+0, 2
	GOTO       L__main49
;aula1.mpas,154 :: 		if PORTC.5 = 1  then
	BTFSS      PORTC+0, 5
	GOTO       L__main52
;aula1.mpas,155 :: 		PORTC.5 := 0
	BCF        PORTC+0, 5
	GOTO       L__main53
;aula1.mpas,156 :: 		else
L__main52:
;aula1.mpas,157 :: 		PORTC.5 := 1
	BSF        PORTC+0, 5
L__main53:
;aula1.mpas,158 :: 		end;
L__main49:
;aula1.mpas,160 :: 		if ch='c' then
	MOVF       _ch+0, 0
	XORLW      99
	BTFSS      STATUS+0, 2
	GOTO       L__main55
;aula1.mpas,162 :: 		ligacooler:=0;
	CLRF       _ligacooler+0
	CLRF       _ligacooler+1
;aula1.mpas,163 :: 		PWM1_Set_Duty(0);
	CLRF       FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;aula1.mpas,164 :: 		end;
L__main55:
;aula1.mpas,166 :: 		if ch='C' then
	MOVF       _ch+0, 0
	XORLW      67
	BTFSS      STATUS+0, 2
	GOTO       L__main58
;aula1.mpas,168 :: 		ligacooler:=1;
	MOVLW      1
	MOVWF      _ligacooler+0
	CLRF       _ligacooler+1
;aula1.mpas,169 :: 		PWM1_Set_Duty(duty);
	MOVF       _duty+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;aula1.mpas,170 :: 		PWM1_start();
	CALL       _PWM1_Start+0
;aula1.mpas,171 :: 		end;
L__main58:
;aula1.mpas,173 :: 		if ligacooler = 1 then
	MOVLW      0
	XORWF      _ligacooler+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main80
	MOVLW      1
	XORWF      _ligacooler+0, 0
L__main80:
	BTFSS      STATUS+0, 2
	GOTO       L__main61
;aula1.mpas,175 :: 		if duty < 255 then
	MOVLW      255
	SUBWF      _duty+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__main64
;aula1.mpas,177 :: 		if ch='+' then
	MOVF       _ch+0, 0
	XORLW      43
	BTFSS      STATUS+0, 2
	GOTO       L__main67
;aula1.mpas,179 :: 		duty:= duty+10;
	MOVLW      10
	ADDWF      _duty+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      _duty+0
;aula1.mpas,180 :: 		PWM1_Set_Duty(duty);
	MOVF       R0+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;aula1.mpas,181 :: 		end;
L__main67:
;aula1.mpas,182 :: 		end;
L__main64:
;aula1.mpas,183 :: 		end;
L__main61:
;aula1.mpas,185 :: 		if ligacooler = 1 then
	MOVLW      0
	XORWF      _ligacooler+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main81
	MOVLW      1
	XORWF      _ligacooler+0, 0
L__main81:
	BTFSS      STATUS+0, 2
	GOTO       L__main70
;aula1.mpas,187 :: 		if    duty>5 then
	MOVF       _duty+0, 0
	SUBLW      5
	BTFSC      STATUS+0, 0
	GOTO       L__main73
;aula1.mpas,189 :: 		if  ch='-' then
	MOVF       _ch+0, 0
	XORLW      45
	BTFSS      STATUS+0, 2
	GOTO       L__main76
;aula1.mpas,191 :: 		duty:=duty-10;
	MOVLW      10
	SUBWF      _duty+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      _duty+0
;aula1.mpas,192 :: 		PWM1_Set_Duty(duty);
	MOVF       R0+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;aula1.mpas,193 :: 		end;
L__main76:
;aula1.mpas,194 :: 		end;
L__main73:
;aula1.mpas,195 :: 		end;
L__main70:
;aula1.mpas,196 :: 		end;
L__main7:
;aula1.mpas,198 :: 		Delay_ms(100);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L__main78:
	DECFSZ     R13+0, 1
	GOTO       L__main78
	DECFSZ     R12+0, 1
	GOTO       L__main78
	NOP
	NOP
;aula1.mpas,199 :: 		end;
	GOTO       L__main2
;aula1.mpas,200 :: 		end.
L_end_main:
	GOTO       $+0
; end of _main
