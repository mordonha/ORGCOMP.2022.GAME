; Blackout

; Jansen Caik Ferreira Freitas
; Leonardo Minoru Iwashima
; Paulo Marcos Ordonha

jmp main

; Variaveis e constantes
posPersonagem: var #1			; Contem a posicao atual da Nave
posAntPersonagem: var #1		; Contem a posicao anterior da Nave

msg_start: string "PRESS 'SPACE' TO START" ; mensagem de inicio.


; main
main:
	; Tela inicial
	call ApagaTela
	loadn R1, #tela6Linha0	; Endereco onde comeca a primeira linha do cenario!!
	loadn R2, #1536  			; cor teal!
	call ImprimeTela    		;  Rotina de Impresao de Cenario na Tela Inteira
	
	
	; printa a mensagem de inicio.
	loadn R0, #1009			; posicao na tela onde a mensagem sera escrita
	loadn R1, #msg_start	; carrega r1 com o endereco do vetor que contem a mensagem
	loadn R2, #0			; seleciona a cor da mensagem
	call ImprimeStr
	
	loop_espera_iniciar: ; espera o jogador iniciar.

		loadn r0, #0 ; limpa o registrador que recebera input.
		inchar r0 ; tenta receber input.
		
		loadn r1, #' ' ; verifica se o input ocorreu.
		cmp r0, r1
		jeq start ; inicia o jogo.

		jmp loop_espera_iniciar ; continua o loop.
	
	
	start:
	
	; mapa 1	
	call ApagaTela
	loadn R1, #tela7Linha0	; Endereco onde comeca a primeira linha do cenario!!
	loadn R2, #1536  			; cor teal!
	call ImprimeTela2   		;  Rotina de Impresao de Cenario na Tela Inteira
	
	 

    
    loadn R0, #1158			
	store posPersonagem, R0		; Zera Posicao Atual da Nave
	store posAntPersonagem, R0	; Zera Posicao Anterior da Nave
	
	loadn R1, #'*'
	outchar R1, R0 ; Printa personagem 
	
	loadn R0, #0			; Contador para os Mods	= 0
	loadn R2, #0			; Para verificar se (mod(c/10)==0
		
	
	loop:
		; rotina de movimentacao do personagem 
		loadn R1, #5    ; "slowness" (inversamente prop a velocidade)
		mod R1, R0, R1  ; resto p compara
		cmp R1, R2		; if (mod(c/5)==0
		ceq MoveNave	; chama rotina de movimentacao do personagem
		
		; verifica se morreu 
		loadn r6, #2    ; r6=2  
		cmp r6, r7      ; colidiu com parede?
		jeq gameover    ; sim: pula para rotina de game over 
		
		
		; delay do jogo
		call Delay
		inc R0 	;c++
		jmp loop
		
	gameover:
		
		call ApagaTela
		loadn R1, #telaGameOverLinha0	; Endereco onde comeca a primeira linha do cenario!!
		loadn R2, #2304  			; cor vermelha!
		call ImprimeTela2    		;  Rotina de Impresao de Cenario na Tela Inteira
		
		loadn R1, #telaRestartLinha0	; Endereco onde comeca a primeira linha do cenario!!
		loadn R2, #2304  			; cor vermelha!
		call ImprimeTela2    		;  Rotina de Impresao de Cenario na Tela Inteira
		
		restart_loop: ; espera o jogador iniciar.

			loadn r0, #0 ; limpa o registrador que recebera input.
			inchar r0 ; tenta receber input.
			
			loadn r1, #' ' ; verifica se o input ocorreu.
			cmp r0, r1
			jeq restart_game ; pula para reiniciar o jogo.

			jmp restart_loop ; continua o loop.
			
	restart_game:
	
		loadn r1, #255 ; carrega para comparacao.
		espera_soltar_tecla_restart: ; espera a tecla ser solta.
		
		inchar r0
		cmp r1, r0 ; condicao de saida.
		jeq espera_soltar_tecla_restart_exit
		
		jmp espera_soltar_tecla_restart ; continua o loop.
		
	espera_soltar_tecla_restart_exit:
		call LimpaMemoriaTela0
			
		jmp main  ; restarta o game
	
; /main






;************************************************************
;                         FUNÇÕES
;************************************************************

MoveNave:
	push r0
	push r1
	
	call MoveNave_RecalculaPos		; Recalcula Posicao o Personagem
	call MoveNave_ChecaPos          ; Checa em que posição o Personagem tentou ir
	
			
	checa_parede: ; verifica se o jogador colidiu com uma parede
		loadn r6, #2
		cmp r6, r7
		jne checa_continua
		
			jmp MoveNave_Skip;	jmp gameover ; finaliza partida.
			
	checa_continua:
	
		load r0, posPersonagem
		load r1, posAntPersonagem
		cmp r0, r1
		jeq MoveNave_Skip
			call MoveNave_Apaga
			call MoveNave_Desenha		;}.
			
  	MoveNave_Skip:
	
	pop r1
	pop r0
	rts

;--------------------------------
	
MoveNave_Apaga:		; Apaga a Nave preservando o Cenario!
	push R0
	push R1
	push R2
	push R3

	load R0, posAntPersonagem	; R0 = posAnt
	
	; --> R2 = Tela0 + posAnt  ;

	loadn R1, #tela0	; Endereco onde comeca a primeira linha do cenario!!
	add R2, R1, r0	; R2 = Tela0 + posAnt
	
	loadi R3, R2	; R3 = Char (Tela(posAnt))
	
	outchar R3, R0	; Apaga o Obj na tela com o Char correspondente na memoria do cenario
	
	pop R3
	pop R2
	pop R1
	pop R0
	rts
;----------------------------------	
	
MoveNave_RecalculaPos:		; Recalcula posicao do Personagem em funcao das Teclas pressionadas
	push R0
	push R1
	push R2
	push R3

	load R0, posPersonagem
	
	inchar R1				; Le Teclado para controlar o Personagem
	loadn R2, #'a'
	cmp R1, R2
	jeq MoveNave_RecalculaPos_A
	
	loadn R2, #'d'
	cmp R1, R2
	jeq MoveNave_RecalculaPos_D
		
	loadn R2, #'w'
	cmp R1, R2
	jeq MoveNave_RecalculaPos_W
		
	loadn R2, #'s'
	cmp R1, R2
	jeq MoveNave_RecalculaPos_S
	
	;loadn R2, #' '
	;cmp R1, R2
	;jeq MoveNave_RecalculaPos_Tiro
	
  MoveNave_RecalculaPos_Fim:	; Se nao for nenhuma tecla valida, vai embora
	store posPersonagem, R0
	pop R3
	pop R2
	pop R1
	pop R0
	rts
			
  MoveNave_RecalculaPos_A:	; Move Nave para Esquerda
	loadn R1, #40
	loadn R2, #0
	mod R1, R0, R1		; Testa condicoes de Contorno 
	cmp R1, R2
	jeq MoveNave_RecalculaPos_Fim
	dec R0	; pos = pos -1
	jmp MoveNave_RecalculaPos_Fim
		
  MoveNave_RecalculaPos_D:	; Move Nave para Direita	
	loadn R1, #40
	loadn R2, #39
	mod R1, R0, R1		; Testa condicoes de Contorno 
	cmp R1, R2
	jeq MoveNave_RecalculaPos_Fim
	inc R0	; pos = pos + 1
	jmp MoveNave_RecalculaPos_Fim
	
  MoveNave_RecalculaPos_W:	; Move Nave para Cima
	loadn R1, #40
	cmp R0, R1		; Testa condicoes de Contorno 
	jle MoveNave_RecalculaPos_Fim
	sub R0, R0, R1	; pos = pos - 40
	jmp MoveNave_RecalculaPos_Fim

  MoveNave_RecalculaPos_S:	; Move Nave para Baixo
	loadn R1, #1159
	cmp R0, R1		; Testa condicoes de Contorno 
	jgr MoveNave_RecalculaPos_Fim
	loadn R1, #40
	add R0, R0, R1	; pos = pos + 40
	jmp MoveNave_RecalculaPos_Fim	
	
  ;MoveNave_RecalculaPos_Tiro:	
;	loadn R1, #1			; Se Atirou:
;	store FlagTiro, R1		; FlagTiro = 1
;	store posTiro, R0		; posTiro = posNave
;	jmp MoveNave_RecalculaPos_Fim	
;----------------------------------
MoveNave_Desenha:	; Desenha caractere da Nave
	push R0
	push R1
	
	Loadn R1, #'*'	; Nave
	load R0, posPersonagem
	outchar R1, R0
	store posAntPersonagem, R0	; Atualiza Posicao Anterior da Nave = Posicao Atual
	
	pop R1
	pop R0
	rts
	
	
MoveNave_ChecaPos:
	push r0
	push r1
	push r2
	
	
	; --> tela0 + pos ;
	
	load  r0, posPersonagem ; carrega a nova posicao do personagem da memoria. r0 = pos
	loadn r1, #tela0  ; carrega a posicao inicial do mapa da memoria.    r1 = tela0
	
	add r1, r0, r1  ; r1 = tela0 + posicao do jogador

	loadi r2, r1	; r2 = Char (Tela(pos))
	 
	
	loadn r1, #1600 ; checa se o jogador andou para uma parede(cod parede: 64 + cor teal: 1536).
		cmp r2, r1
		jne check_empty 
	
		jmp check_die
		
	;; outros checks poderiam ser feitos aqui
	;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	check_die: ; marca que o jogador colidiu (deve morrer e acabar o jogo).

		loadn r7, #2
		jmp end_check
		
		
	check_empty: ; marca que o jogador andou para um espaco vazio (deve apenas se movimentar).
	
		loadn r7, #0		
	
	end_check:

			
	pop r2 ; resgata os valores dos registradores utilizados na subrotina da pilha.
	pop r1
	pop r0

	rts
	
	
	

;----------------------------------
;----------------------------------
;----------------------------------


;********************************************************
;                       DELAY
;********************************************************		


Delay:
						;Utiliza Push e Pop para nao afetar os Ristradores do programa principal
	Push R0
	Push R1
	
	Loadn R1, #5  ; a
   Delay_volta2:				;Quebrou o contador acima em duas partes (dois loops de decremento)
	Loadn R0, #3000	; b
   Delay_volta: 
	Dec R0					; (4*a + 6)b = 1000000  == 1 seg  em um clock de 1MHz
	JNZ Delay_volta	
	Dec R1
	JNZ Delay_volta2
	
	Pop R1
	Pop R0
	
	RTS							;return

;-------------------------------


	
; IMPRIME TELA2_______________________________________
ImprimeTela2: 	;  Rotina de Impresao de Cenario na Tela Inteira
		;  r1 = endereco onde comeca a primeira linha do Cenario
		;  r2 = cor do Cenario para ser impresso

	push r0	; protege o r3 na pilha para ser usado na subrotina
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	push r5	; protege o r5 na pilha para ser usado na subrotina
	push r6	; protege o r6 na pilha para ser usado na subrotina

	loadn R0, #0  	; posicao inicial tem que ser o comeco da tela!
	loadn R3, #40  	; Incremento da posicao da tela!
	loadn R4, #41  	; incremento do ponteiro das linhas da tela
	loadn R5, #1200 ; Limite da tela!
	loadn R6, #tela0	; Endereco onde comeca a primeira linha do cenario!!
	
   ImprimeTela2_Loop:
		call ImprimeStr2
		add r0, r0, r3  	; incrementaposicao para a segunda linha na tela -->  r0 = R0 + 40
		add r1, r1, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		add r6, r6, r3  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40  porcausa do /0 so no fim !!) --> r1 = r1 + 40
		cmp r0, r5			; Compara r0 com 1200
		jne ImprimeTela2_Loop	; Enquanto r0 < 1200

	pop r6	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts		
; /IMPRIME TELA2_________________________________________		

	
; IMPRIME STRING2________________________________________
ImprimeStr2:	;  Rotina de Impresao de Mensagens:    r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"
	push r0	; protege o r0 na pilha para preservar seu valor
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	push r5	; protege o r5 na pilha para ser usado na subrotina
	push r6	; protege o r6 na pilha para ser usado na subrotina
	
	
	loadn r3, #'\0'	; Criterio de parada
	loadn r5, #' '	; Espaco em Branco

   ImprimeStr2_Loop:	
		loadi r4, r1
		cmp r4, r3		; If (Char == \0)  vai Embora
		jeq ImprimeStr2_Sai
		cmp r4, r5		; If (Char == ' ')  vai Pula outchar do espaco para na apagar outros caracteres
		jeq ImprimeStr2_Skip
		add r4, r2, r4	; Soma a Cor
		outchar r4, r0	; Imprime o caractere na tela
   		storei r6, r4
   ImprimeStr2_Skip:
		inc r0			; Incrementa a posicao na tela
		inc r1			; Incrementa o ponteiro da String
		inc r6
		jmp ImprimeStr2_Loop
	
   ImprimeStr2_Sai:	
	pop r6	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
; /IMPRIME STRING2__________________________________________		

; APAGA TELA________________________________________________
ApagaTela:
	push r0
	push r1
	
	loadn r0, #1200		; apaga as 1200 posicoes da Tela
	loadn r1, #' '		; com "espaco"
	
	   ApagaTela_Loop:	;;label for(r0=1200;r3>0;r3--)
		dec r0
		outchar r1, r0
		jnz ApagaTela_Loop
 
	pop r1
	pop r0
	rts	
; /APAGA TELA________________________________________________

LimpaMemoriaTela0:
	push r0
	push r1
	push r2
	push r3
	
	loadn r0, #1199		; apaga as 1200 posicoes da Tela
	loadn r1, #' '		; com "espaco"
	loadn r2, #tela0
	;loadn r4, #1200
	   ; limpa do final do vetor para o inicio	
	   LimpaMemoria_Loop:	;;label for(r3=1200;r3>0;r3--)
		;add r3, r2, r0  ; r3 = posicao de char[i] na MEM
		;loadn r3, #578
		add r3, r2, r0  ; r3 = posicao de char[i] na MEM
		storei r3, r1   ; MEM[i] = ' ' ; limpa char cm espaco vazio
		dec r0
		loadn r3, #0
		cmp r0, r3
		jne LimpaMemoria_Loop
 
		
 	pop r3
 	pop r2
	pop r1
	pop r0
	rts	
; /APAGA TELA________________________________________________

;************************************************************





;********************************************************
;                       IMPRIME TELA
;********************************************************	

ImprimeTela: 	;  Rotina de Impresao de Cenario na Tela Inteira
		;  r1 = endereco onde comeca a primeira linha do Cenario
		;  r2 = cor do Cenario para ser impresso

	push r0	; protege o r3 na pilha para ser usado na subrotina
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	push r5	; protege o r4 na pilha para ser usado na subrotina

	loadn R0, #0  	; posicao inicial tem que ser o comeco da tela!
	loadn R3, #40  	; Incremento da posicao da tela!
	loadn R4, #41  	; incremento do ponteiro das linhas da tela
	loadn R5, #1200 ; Limite da tela!
	
   ImprimeTela_Loop:
		call ImprimeStr
		add r0, r0, r3  	; incrementaposicao para a segunda linha na tela -->  r0 = R0 + 40
		add r1, r1, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		cmp r0, r5			; Compara r0 com 1200
		jne ImprimeTela_Loop	; Enquanto r0 < 1200

	pop r5	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
				
;---------------------

;---------------------------	
;********************************************************
;                   IMPRIME STRING
;********************************************************
	
ImprimeStr:	;  Rotina de Impresao de Mensagens:    r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"
	push r0	; protege o r0 na pilha para preservar seu valor
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	
	loadn r3, #'\0'	; Criterio de parada

   ImprimeStr_Loop:	
		loadi r4, r1
		cmp r4, r3		; If (Char == \0)  vai Embora
		jeq ImprimeStr_Sai
		add r4, r2, r4	; Soma a Cor
		outchar r4, r0	; Imprime o caractere na tela
		inc r0			; Incrementa a posicao na tela
		inc r1			; Incrementa o ponteiro da String
		jmp ImprimeStr_Loop
	
   ImprimeStr_Sai:	
	pop r4	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	
;------------------------	
	

;-------------------------------





;************************************************************
;                          TELAS
;************************************************************
	
; Declara uma tela vazia para ser preenchida em tempo de execussao:
tela0  : string "                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                "
	

; Declara e preenche tela linha por linha (40 caracteres):
tela1Linha0  : string "                                        "
tela1Linha1  : string "         **  **** **   **  ****         "
tela1Linha2  : string "         ** ***   *** *** ***           "
tela1Linha3  : string "         ** ***   ** * ** ***           "
tela1Linha4  : string "         **  **** **   **  ****         "
tela1Linha5  : string "                                        "
tela1Linha6  : string "                                        "
tela1Linha7  : string "                                        "
tela1Linha8  : string "                                        "
tela1Linha9  : string "                                        "
tela1Linha10 : string "                                        "
tela1Linha11 : string "                                        "
tela1Linha12 : string "                                        "
tela1Linha13 : string "                                        "
tela1Linha14 : string "                                        "
tela1Linha15 : string "                                        "
tela1Linha16 : string "                                        "
tela1Linha17 : string "                                        "
tela1Linha18 : string "                                        "
tela1Linha19 : string "                                        "
tela1Linha20 : string "                                        "
tela1Linha21 : string "                                        "
tela1Linha22 : string "                                        "
tela1Linha23 : string "                                        "
tela1Linha24 : string "                                        "
tela1Linha25 : string "                                        "
tela1Linha26 : string "                                        "
tela1Linha27 : string "                                        "
tela1Linha28 : string "                                        "
tela1Linha29 : string "                                        "



; Declara e preenche tela linha por linha (40 caracteres):
tela2Linha0  : string "                                        "
tela2Linha1  : string "                                        "
tela2Linha2  : string "                                        "
tela2Linha3  : string "                                        "
tela2Linha4  : string "                                        "
tela2Linha5  : string "                                        "
tela2Linha6  : string "         **  **** **   **  ****         "
tela2Linha7  : string "         ** ***   *** *** ***           "
tela2Linha8  : string "         ** ***   ** * ** ***           "
tela2Linha9  : string "         **  **** **   **  ****         "
tela2Linha10 : string "                                        "
tela2Linha11 : string "                                        "
tela2Linha12 : string "                                        "
tela2Linha13 : string "                                        "
tela2Linha14 : string "                                        "
tela2Linha15 : string "                                        "
tela2Linha16 : string "                                        "
tela2Linha17 : string "                                        "
tela2Linha18 : string "                        	               "
tela2Linha19 : string "                                        "
tela2Linha20 : string "                                        "
tela2Linha21 : string "                                        "
tela2Linha22 : string "                                        "
tela2Linha23 : string "                                        "
tela2Linha24 : string "                                        "
tela2Linha25 : string "                                        "
tela2Linha26 : string "                                        "
tela2Linha27 : string "                                        "
tela2Linha28 : string "                                        "
tela2Linha29 : string "                                        "


; Declara e preenche tela linha por linha (40 caracteres):
tela3Linha0  : string "                                        "
tela3Linha1  : string "                                        "
tela3Linha2  : string "                                        "
tela3Linha3  : string "                                        "
tela3Linha4  : string "                                        "
tela3Linha5  : string "                                        "
tela3Linha6  : string "                                        "
tela3Linha7  : string "                                        "
tela3Linha8  : string "                                        "
tela3Linha9  : string "                                        "
tela3Linha10 : string "                                        "
tela3Linha11 : string "         **  **** **   **  ****         "
tela3Linha12 : string "         ** ***   *** *** ***           "
tela3Linha13 : string "         ** ***   ** * ** ***           "
tela3Linha14 : string "         **  **** **   **  ****         "
tela3Linha15 : string "                                        "
tela3Linha16 : string "                                        "
tela3Linha17 : string "                                        "
tela3Linha18 : string "                                        "
tela3Linha19 : string "                                        "
tela3Linha20 : string "                                        "
tela3Linha21 : string "                                        "
tela3Linha22 : string "                                        "
tela3Linha23 : string "                                        "
tela3Linha24 : string "                                        "
tela3Linha25 : string "                                        "
tela3Linha26 : string "                                        "
tela3Linha27 : string "                                        "
tela3Linha28 : string "                                        "
tela3Linha29 : string "                                        "



tela4Linha0  : string "                                        "
tela4Linha1  : string "                                        "
tela4Linha2  : string "                                        "
tela4Linha3  : string "                                        "
tela4Linha4  : string "                                        "
tela4Linha5  : string "                                        "
tela4Linha6  : string "                                        "
tela4Linha7  : string "                                        "
tela4Linha8  : string "                                        "
tela4Linha9  : string "                                        "
tela4Linha10 : string "                                        "
tela4Linha11 : string "                                        "
tela4Linha12 : string "                                        "
tela4Linha13 : string "                                        "
tela4Linha14 : string "                                        "
tela4Linha15 : string "                                        "
tela4Linha16 : string "         **  **** **   **  ****         "
tela4Linha17 : string "         ** ***   *** *** ***           "
tela4Linha18 : string "         ** ***   ** * ** ***           "
tela4Linha19 : string "         **  **** **   **  ****         "
tela4Linha20 : string "                                        "
tela4Linha21 : string "                                        "
tela4Linha22 : string "                                        "
tela4Linha23 : string "                                        "
tela4Linha24 : string "                                        "
tela4Linha25 : string "                                        "
tela4Linha26 : string "                                        "
tela4Linha27 : string "                                        "
tela4Linha28 : string "                                        "
tela4Linha29 : string "                                        "



; Declara e preenche tela linha por linha (40 caracteres):
tela6Linha0  : string "                                        "
tela6Linha1  : string "                                        "
tela6Linha2  : string "                                        "
tela6Linha3  : string "                                        "
tela6Linha4  : string "                                        "
tela6Linha5  : string "                                        "
tela6Linha6  : string "         **  **** **   **  ****         "
tela6Linha7  : string "         ** ***   *** *** ***           "
tela6Linha8  : string "         ** ***   ** * ** ***           "
tela6Linha9  : string "         **  **** **   **  ****         "
tela6Linha10 : string "                                        "
tela6Linha11 : string " ***** *    ***** *** *  * **** * * *** "
tela6Linha12 : string " *   * *    *   * *   * *  *  * * *  *  "
tela6Linha13 : string " *  *  *    *   * *   **   *  * * *  *  "
tela6Linha14 : string " *  *  *    * * * *   **   *  * * *  *  "
tela6Linha15 : string " *   * *    *   * *   * *  *  * * *  *  "
tela6Linha16 : string " ***** **** *   * *** *  * **** ***  *  "
tela6Linha17 : string "                                        "
tela6Linha18 : string " ______________________________________ "
tela6Linha19 : string "                                        "
tela6Linha20 : string "                       by JLP Studios   "
tela6Linha21 : string "                                        "
tela6Linha22 : string "                                        "
tela6Linha23 : string "                                        "
tela6Linha24 : string "                                        "
tela6Linha25 : string "                                        "
tela6Linha26 : string "                                        "
tela6Linha27 : string "                                        "
tela6Linha28 : string "                                        "
tela6Linha29 : string "                                        "



; Declara uma tela vazia para ser preenchida em tempo de execussao:
tela7Linha0  : string "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
tela7Linha1  : string "@                               @      @"
tela7Linha2  : string "@ @@@@@@@                       @      @"
tela7Linha3  : string "@ @@@@@@@                       @      @"
tela7Linha4  : string "@ @@@@@@@                   @   @      @"
tela7Linha5  : string "@                           @   @      @"
tela7Linha6  : string "@                           @   @      @"
tela7Linha7  : string "@@@@@@@@@@@@@               @   @      @"
tela7Linha8  : string "@ @ @ @ @ @ @               @          @"
tela7Linha9  : string "@ @ @ @ @ @ @               @   @      @"
tela7Linha10 : string "@                           @   @      @"
tela7Linha11 : string "@@@@                        @   @      @"
tela7Linha12 : string "@@ @                        @   @      @"
tela7Linha13 : string "@@ @                            @      @"
tela7Linha14 : string "@@                              @      @"
tela7Linha15 : string "@@@@@                           @      @"
tela7Linha16 : string "@                                      @"
tela7Linha17 : string "@                                      @"
tela7Linha18 : string "@                                      @"
tela7Linha19 : string "@                                      @"
tela7Linha20 : string "@                                      @"
tela7Linha21 : string "@                                      @"
tela7Linha22 : string "@                                      @"
tela7Linha23 : string "@                                      @"
tela7Linha24 : string "@                                      @"
tela7Linha25 : string "@                                      @"
tela7Linha26 : string "@                                      @"
tela7Linha27 : string "@                                      @"
tela7Linha28 : string "@                                      @"
tela7Linha29 : string "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"




; Tela GAMEOVER
telaGameOverLinha0  : string "                                        "
telaGameOverLinha1  : string "                                        "
telaGameOverLinha2  : string "                                        "
telaGameOverLinha3  : string "                                        "
telaGameOverLinha4  : string "                                        "
telaGameOverLinha5  : string "                                        "
telaGameOverLinha6  : string "                                        "
telaGameOverLinha7  : string "                                        "
telaGameOverLinha8  : string "                                        "
telaGameOverLinha9  : string "                                        "
telaGameOverLinha10 : string "                                        "
telaGameOverLinha11 : string "                                        "
telaGameOverLinha12 : string "                                        "
telaGameOverLinha13 : string "                                        "
telaGameOverLinha14 : string "                GAME OVER               "
telaGameOverLinha15 : string "                                        "
telaGameOverLinha16 : string "                                        "
telaGameOverLinha17 : string "                                        "
telaGameOverLinha18 : string "                                        "
telaGameOverLinha19 : string "                                        "
telaGameOverLinha20 : string "                                        "
telaGameOverLinha21 : string "                                        "
telaGameOverLinha22 : string "                                        "
telaGameOverLinha23 : string "                                        "
telaGameOverLinha24 : string "                                        "
telaGameOverLinha25 : string "                                        "
telaGameOverLinha26 : string "                                        "
telaGameOverLinha27 : string "                                        "
telaGameOverLinha28 : string "                                        "
telaGameOverLinha29 : string "                                        "

; Tela RESTART
telaRestartLinha0  : string "                                        "
telaRestartLinha1  : string "                                        "
telaRestartLinha2  : string "                                        "
telaRestartLinha3  : string "                                        "
telaRestartLinha4  : string "                                        "
telaRestartLinha5  : string "                                        "
telaRestartLinha6  : string "                                        "
telaRestartLinha7  : string "                                        "
telaRestartLinha8  : string "                                        "
telaRestartLinha9  : string "                                        "
telaRestartLinha10 : string "                                        "
telaRestartLinha11 : string "                                        "
telaRestartLinha12 : string "                                        "
telaRestartLinha13 : string "                                        "
telaRestartLinha14 : string "                                        "
telaRestartLinha15 : string "                                        "
telaRestartLinha16 : string "                                        "
telaRestartLinha17 : string "          PRESS 'SPACE' TO RESTART      "
telaRestartLinha18 : string "                                        "
telaRestartLinha19 : string "                                        "
telaRestartLinha20 : string "                                        "
telaRestartLinha21 : string "                                        "
telaRestartLinha22 : string "                                        "
telaRestartLinha23 : string "                                        "
telaRestartLinha24 : string "                                        "
telaRestartLinha25 : string "                                        "
telaRestartLinha26 : string "                                        "
telaRestartLinha27 : string "                                        "
telaRestartLinha28 : string "                                        "
telaRestartLinha29 : string "                                        "	
;Telas_fim