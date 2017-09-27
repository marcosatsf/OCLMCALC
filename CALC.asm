TITLE	CALCULADORA
.MODEL	SMALL
.STACK	0100H
.DATA
BARRAN		DB	0AH,0DH,'$'
INTROCALC	DB	'CalculadoraMB8086','$'
OP			DB 	'    Operacoes disponiveis:',0AH,0DH,'     a. AND',0AH,0DH,'     b. OR',0AH,0DH,'     c. XOR',0AH,0DH,'     d. NOT',0AH,0DH,'     e. Soma',0AH,0DH,'     f. Subtracao',0AH,0DH,'     g. Multiplicacao',0AH,0DH,'     h. Divisao',0AH,0DH,'     i. Mult por 2',0AH,0DH,'     j. Div por 2',0AH,0DH,'$'
BASENUM		DB	' Bases numericas disponiveis:',0AH,0DH,0AH,0DH,'     1. Decimal [{0,1,2,3,4,5,6,7,8,9},[-32768, +32767]]',0AH,0DH,'     2. Binario [{0,1},MAX 16 BITS]',0AH,0DH,'     3. Hexadecimal [{0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F},MAX 4 CARACTERES]',0AH,0DH,'     4. Quaternario [{0,1,2,3},MAX 8 CARACTERES]',0AH,0DH,'$'		
VAULTD		DW	?
VAULTC		DW	?
OP?			DB	0AH,0DH,' Insira a operacao desejada: $'
BASE?		DB	0AH,0DH,' Insira a base desejada: $'
OPA			DB	' Opcao "a"(AND) escolhida: $'
OPB			DB	' Opcao "b"(OR) escolhida: $'
OPC			DB	' Opcao "c"(XOR) escolhida: $'
OPD			DB	' Opcao "d"(NOT) escolhida: $'
OPE			DB	' Opcao "e"(Soma) escolhida: $'
OPF			DB	' Opcao "f"(Subt) escolhida: $'
OPG			DB	' Opcao "g"(Mult) escolhida: $'
OPH			DB	' Opcao "h"(Div) escolhida: $'
OPI			DB	' Opcao "i"(Mult/2) escolhida: $'
OPJ			DB	' Opcao "j"(Div/2) escolhida: $'
MSG1		DB	0AH,0DH,0AH,0DH,' Digite o primeiro numero: $'
MSG2		DB	' Digite o segundo numero: $'
MSGNOT		DB	0AH,0DH,0AH,0DH,' Digite um numero: $'
MSGBASE		DB	0AH,0DH,0AH,0DH,' Digite a base que deseja a saída: $'
DENOVO		DB	' Deseja realizar outra operacao?',0AH,0DH,0AH,0DH,'     1. Sim',0AH,0DH,'     2. Nao',0AH,0DH,0AH,0DH, ' Digite a opcao: $'
RES 		DB	' O Resultado eh: $'	
VAULTNUM	DW	?
RESAGAIN	DB	?
SHIFT4	DW	4;movo esse valor para o cx
SHIFT2	DW	2;movo esse valor para o cx
VAULTCX	DW ?;para receber hexa, preciso guardar o cx para o shift


.CODE
MAIN PROC

		MOV AX,@DATA	;recebe variáveis globais em AX
		MOV DS,AX	;move as variáveis para DS
		
		CALL	INTERFACEH ;chama a funcao da interface
		
		CALL PULALINHA
		
		LEA	DX,OP	;opcoes menu
		INT 21H
		
		CALL	INTERFACEL
		
		MOV	AH,09H
		LEA	DX,OP?	;mensagem opcao
		INT	21H
		
		MOV	AH,01H	;leitura da opcao escolhida
		INT	21H
		
		CMP	AL,61H	;comeca o switch da escravidao
		JE	a
		CMP	AL,41H	;comeca o switch da escravidao
		JE	a
		CMP AL,62H
		JE	b
		CMP AL,42H
		JE	b
		CMP AL,'c'
		JE	c
		CMP AL,'C'
		JE	c
		CMP AL,'d'
		JE	d
		CMP AL,'D'
		JE	d
		;CMP AL,'e'
		;JE	e
		;CMP AL,'E'
		;JE	e
		;CMP AL,'f'
		;JE	f
		;CMP AL,'F'
		;JE	f
		;CMP AL,'g'
		;JE	g
		;CMP AL,'G'
		;JE	g
		;CMP AL,'h'
		;JE	h
		;CMP AL,'H'
		;JE	h
		;CMP AL,'i'
		;JE	i
		;CMP AL,'I'
		;JE	i
		;CMP AL,'j'
		;JE	j
		;CMP AL,'J'
		;JE	j
		
	a:	CALL OPCAOA
		CALL AGAIN
		JMP EXECUTARDENOVO
		
	b:	CALL OPCAOB
		CALL AGAIN
		JMP EXECUTARDENOVO
	
	c:	CALL OPCAOC
		CALL AGAIN
		JMP EXECUTARDENOVO
		
	d:	CALL OPCAOD
		CALL AGAIN
		JMP EXECUTARDENOVO
	
	
		
	
	
	
	
	
	
	
	
	
	
EXECUTARDENOVO:

		CMP RESAGAIN, 31H
		JE DEUUM
		
		CMP RESAGAIN, 32H
		JE DEUDOIS
		
		
DEUUM:
		
		CALL CLEARSCREEN
		CALL MAIN
		
DEUDOIS:
		
		CALL PULALINHA
		
		MOV	AX,4C00H
		INT	21H
		
MAIN ENDP

;-------------------------------------------------------- OPERACAO A --------------------------------------------------------;

OPCAOA PROC

	CALL CLEARSCREEN		;funcao limpatela
		
	CALL PULALINHA
	
		LEA DX, OPA ;mensagem opcao a		
		MOV AH, 9	;exibe
		INT 21H
		
		CALL PULALINHA
		CALL PULALINHA
		
		LEA DX, BASENUM
		MOV AH, 9
		INT 21H
	
		LEA DX, BASE?
		INT 21H
		
		
		MOV	AH, 01H	;leitura da opcao escolhida
		INT	21H
		
		MOV DL, AL
		
		CMP	DL, 31H	;comeca o switch da escravidao 2.0
		JE	DECIMALA
		CMP DL, 32H
		JE	BINARIOA
		CMP DL,'3'
		JE	HEXADECIMALA
		CMP DL,'4'
		JE	QUATA
		
	DECIMALA:
	
		CALL MENSAGEM01
		
		CALL LEITURADEC	;funcao para ler tipo da base e a base
		
		MOV VAULTNUM,AX
		
		CALL MENSAGEM02
		
		CALL LEITURADEC	;funcao para ler tipo da base e a base
		
		AND VAULTNUM, AX
		
		CALL PULALINHA
		
		MOV AX, VAULTNUM
		
		CALL PRINTBASEESCOLHIDA
		
		CALL PULALINHA
		
		RET ;<-----------------------------mudei para RET para n ter q ficar preocupado com o comprimento das linhas do jmp
	
	BINARIOA:
		
		;CALL PULALINHA
		;CALL PULALINHA
		
		CALL MENSAGEM01
		
		CALL LEITURABIN	 ;funcao para ler BINARIO	
		
		MOV VAULTNUM, BX ;move o primeiro valor lido para variavel
		
		;CALL PRINTBIN
		
		CALL MENSAGEM02
		
		CALL LEITURABIN ;le outro numero
		
		AND BX, VAULTNUM
		
		CALL PULALINHA
		
		CALL MENSAGEMRES
		
		CALL PRINTBIN
		
		CALL PULALINHA
		
		RET
	
	HEXADECIMALA:
		
		CALL MENSAGEM01
		
		CALL LEITURAHEXAD	;funcao para ler tipo da base e a base
		
		MOV VAULTNUM,BX
		
		CALL MENSAGEM02
		
		CALL LEITURAHEXAD	;funcao para ler tipo da base e a base
		
		AND BX,VAULTNUM
		
		CALL PULALINHA
		
		CALL MENSAGEMRES
		
		CALL PRINTHEXADEC
		
		CALL PULALINHA
	
		RET
		
	QUATA:
		
		CALL MENSAGEM01
		
		CALL LEITURAQUAT	;funcao para ler tipo da base e a base
		
		MOV VAULTNUM,BX
		
		CALL MENSAGEM02
		
		CALL LEITURAQUAT ;funcao para ler tipo da base e a base
		
		AND BX,VAULTNUM
		
		CALL PULALINHA
		
		CALL MENSAGEMRES
		
		CALL PRINTQUAT
		
		CALL PULALINHA
	
		RET
		

OPCAOA ENDP

;-------------------------------------------------------- OPERACAO A FIM --------------------------------------------------------;
;-------------------------------------------------------- OPERACAO B --------------------------------------------------------;

OPCAOB PROC
		CALL CLEARSCREEN		;funcao limpatela
		
	CALL PULALINHA
	
		LEA DX, OPB ;mensagem opcao B	
		MOV AH, 9	;exibe
		INT 21H
		
		CALL PULALINHA
		CALL PULALINHA
		
		LEA DX, BASENUM
		MOV AH, 9
		INT 21H
	
		LEA DX, BASE?
		INT 21H
		
		
		MOV	AH, 01H	;leitura da opcao escolhida
		INT	21H
		
		MOV DL, AL
		
		CMP	DL, 31H	;comeca o switch da escravidao 2.0
		JE	DECIMALB
		CMP DL, 32H
		JE	BINARIOB
		CMP DL,'3'
		JE	HEXADECIMALB
		CMP DL,'4'
		JE	QUATB
		
	DECIMALB:
	
		CALL MENSAGEM01
		
		CALL LEITURADEC	;funcao para ler tipo da base e a base
		
		MOV VAULTNUM,AX
		
		CALL MENSAGEM02
		
		CALL LEITURADEC	;funcao para ler tipo da base e a base
		
		OR VAULTNUM, AX
		
		CALL PULALINHA
		CALL MENSAGEMRES
		
		MOV AX, VAULTNUM
		
		CALL PRINTDEC
		
		CALL PULALINHA
		
		RET
	
	BINARIOB:
		
		;CALL PULALINHA
		;CALL PULALINHA
		
		CALL MENSAGEM01
		
		CALL LEITURABIN	 ;funcao para ler BINARIO	
		
		MOV VAULTNUM, BX ;move o primeiro valor lido para variavel
		
		;CALL PRINTBIN
		
		CALL MENSAGEM02
		
		CALL LEITURABIN ;le outro numero
		
		OR BX, VAULTNUM
		
		CALL PULALINHA
		
		CALL MENSAGEMRES
		
		CALL PRINTBIN
		
		CALL PULALINHA
		
		RET
	
	HEXADECIMALB:
		
		CALL MENSAGEM01
		
		CALL LEITURAHEXAD	;funcao para ler tipo da base e a base
		
		MOV VAULTNUM,BX
		
		CALL MENSAGEM02
		
		CALL LEITURAHEXAD	;funcao para ler tipo da base e a base
		
		OR BX,VAULTNUM
		
		CALL PULALINHA
		
		CALL MENSAGEMRES
		
		CALL PRINTHEXADEC
		
		CALL PULALINHA
	
		RET
		
	QUATB:
		
		CALL MENSAGEM01
		
		CALL LEITURAQUAT	;funcao para ler tipo da base e a base
		
		MOV VAULTNUM,BX
		
		CALL MENSAGEM02
		
		CALL LEITURAQUAT ;funcao para ler tipo da base e a base
		
		OR BX,VAULTNUM
		
		CALL PULALINHA
		
		CALL MENSAGEMRES
		
		CALL PRINTQUAT
		
		CALL PULALINHA
		
		RET
	
OPCAOB ENDP

;-------------------------------------------------------- OPERACAO B FIM --------------------------------------------------------;
;-------------------------------------------------------- OPERACAO C --------------------------------------------------------;
OPCAOC PROC
		CALL CLEARSCREEN		;funcao limpatela
		
	CALL PULALINHA
	
		LEA DX, OPC ;mensagem opcao C	
		MOV AH, 9	;exibe
		INT 21H
		
		CALL PULALINHA
		CALL PULALINHA
		
		LEA DX, BASENUM
		MOV AH, 9
		INT 21H
	
		LEA DX, BASE?
		INT 21H
		
		
		MOV	AH, 01H	;leitura da opcao escolhida
		INT	21H
		
		MOV DL, AL
		
		CMP	DL, 31H	;comeca o switch da escravidao 2.0
		JE	DECIMALC
		CMP DL, 32H
		JE	BINARIOC
		CMP DL, '3'
		JE	HEXADECIMALC
		CMP DL,'4'
		JE	QUATC
		
	DECIMALC:
	
		CALL MENSAGEM01
		
		CALL LEITURADEC	;funcao para ler tipo da base e a base
		
		MOV VAULTNUM,AX
		
		CALL MENSAGEM02
		
		CALL LEITURADEC	;funcao para ler tipo da base e a base
		
		XOR VAULTNUM, AX
		
		CALL PULALINHA
		CALL MENSAGEMRES
		
		MOV AX, VAULTNUM
		
		CALL PRINTDEC
		
		CALL PULALINHA
		
		RET
	
	BINARIOC:
		
		;CALL PULALINHA
		;CALL PULALINHA
		
		CALL MENSAGEM01
		
		CALL LEITURABIN	 ;funcao para ler BINARIO	
		
		MOV VAULTNUM, BX ;move o primeiro valor lido para variavel
		
		;CALL PRINTBIN
		
		CALL MENSAGEM02
		
		CALL LEITURABIN ;le outro numero
		
		XOR BX, VAULTNUM
		
		CALL PULALINHA
		
		CALL MENSAGEMRES
		
		CALL PRINTBIN
		
		CALL PULALINHA
		
		RET
	
	HEXADECIMALC:
		
		CALL MENSAGEM01
		
		CALL LEITURAHEXAD	;funcao para ler tipo da base e a base
		
		MOV VAULTNUM,BX
		
		CALL MENSAGEM02
		
		CALL LEITURAHEXAD	;funcao para ler tipo da base e a base
		
		XOR BX,VAULTNUM
		
		CALL PULALINHA
		
		CALL MENSAGEMRES
		
		CALL PRINTHEXADEC
		
		CALL PULALINHA
	
		RET
		
	QUATC:
		
		CALL MENSAGEM01
		
		CALL LEITURAQUAT	;funcao para ler tipo da base e a base
		
		MOV VAULTNUM,BX
		
		CALL MENSAGEM02
		
		CALL LEITURAQUAT ;funcao para ler tipo da base e a base
		
		XOR BX,VAULTNUM
		
		CALL PULALINHA
		
		CALL MENSAGEMRES
		
		CALL PRINTQUAT
		
		CALL PULALINHA
		
		RET
	
OPCAOC ENDP
;-------------------------------------------------------- OPERACAO C FIM --------------------------------------------------------;
;-------------------------------------------------------- OPERACAO D --------------------------------------------------------;
OPCAOD PROC
		CALL CLEARSCREEN		;funcao limpatela
		
	CALL PULALINHA
	
		LEA DX, OPD ;mensagem opcao C	
		MOV AH, 9	;exibe
		INT 21H
		
		CALL PULALINHA
		CALL PULALINHA
		
		LEA DX, BASENUM
		MOV AH, 9
		INT 21H
	
		LEA DX, BASE?
		INT 21H
		
		
		MOV	AH, 01H	;leitura da opcao escolhida
		INT	21H
		
		MOV DL, AL
		
		CMP	DL, 31H	;comeca o switch da escravidao 2.0
		JE	DECIMALD
		CMP DL, 32H
		JE	BINARIOD
		CMP DL, '3'
		JE	HEXADECIMALD
		CMP DL,'4'
		JE	QUATD
		
	DECIMALD:
	
		MOV AH, 9
		LEA DX, MSGNOT
		INT 21H
		
		CALL LEITURADEC	;funcao para ler tipo da base e a base
		MOV VAULTNUM, AX
				
		NOT VAULTNUM		
		
		CALL PULALINHA
		CALL MENSAGEMRES
		
		MOV AX, VAULTNUM
		
		CALL PRINTDEC
		
		CALL PULALINHA
		
		RET
	
	BINARIOD:
		
		MOV AH, 9
		LEA DX, MSGNOT
		INT 21H
		
		CALL LEITURABIN	 ;funcao para ler BINARIO	
	NAOQUEROZERO:
		 
		NOT BX
		
		CALL PULALINHA
		
		CALL MENSAGEMRES
		
		CALL PRINTBIN
		
		CALL PULALINHA
		
		RET
	
	HEXADECIMALD:
		
		MOV AH, 9
		LEA DX, MSGNOT
		INT 21H
		
		CALL LEITURAHEXAD	;funcao para ler tipo da base e a base
		MOV VAULTNUM, BX		
		
		NOT VAULTNUM
		
		CALL PULALINHA
		
		CALL MENSAGEMRES
		
		MOV BX, VAULTNUM
		
		CALL PRINTHEXADEC
		
		CALL PULALINHA
	
		RET
		
	QUATD:
		
		MOV AH, 9
		LEA DX, MSGNOT
		INT 21H
		
		CALL LEITURAQUAT	;funcao para ler tipo da base e a base
		
		NOT BX
		
		CALL PULALINHA
		
		CALL MENSAGEMRES
		
		CALL PRINTQUAT
		
		CALL PULALINHA
		
		RET
	
OPCAOD ENDP
;-------------------------------------------------------- OPERACAO D FIM --------------------------------------------------------;

PRINTBIN PROC

		MOV CX, 16
		MOV AH, 2
	
RETORNO1:

		ROL BX, 1
		
		JNC RETORNO2
;if		
		MOV DL, 31H
		INT 21H
		
		JMP BLA
		
RETORNO2:

		MOV DL, 30H
		INT 21H
		
BLA:	LOOP RETORNO1
		
		RET
		
PRINTBIN ENDP

PRINTDEC PROC
				
		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX		;salva na pilha os registradores usados
		
		OR AX, AX	;prepara comparacao de sinal
		JGE PT1		;se ax >= 0, PT1
		
		PUSH AX		;como ax > 0, salva o numero na pilha

		MOV DL, '-'	;prepara o caracter '-' para sair
		MOV AH, 2H	;prepara exibicao
		INT 21H		;exibe '-'
		
		POP AX		;recupera num
		NEG AX		;troca sinal de ax (ax = -ax)
		
	;obtendo digitos decimais e salvando - os temporariamente na pilha
		
	PT1:			
		XOR CX, CX	;inicializa cx como contador de digitos
		MOV BX, 10	; bx possui o divisor
		
	PT2:
		XOR DX, DX	;inicializa o byte alto do dividendo em 0 ;restante é ax
		DIV BX		;apos execucao, ax = cociente, dx = resto
		
		PUSH DX		;salva o primeiro digito decimal na pilha (1° resto)
		
		INC CX		;contador ++
		OR AX, AX	;quociente == 0? (teste de parada = 0)
		JNE PT2		;nao, continua a repetir o laco
		
		;exibindo os digitos decimais (restos) no monitor, na ordem inversa
		
		MOV AH, 2H	;sim, termina o processo, prepara exibicao dos restos
		
	PT3:		
		POP DX		;recupera digito da pilha colocandoo em dl (dh = 0)
		ADD DL, 30H	;converte valor binario para caracter ASCII
		INT 21H		;exibe
		
		LOOP PT3	;realiza o loop ate cx == 0
		POP DX		;restarura conteudo registradores
		POP CX
		POP BX
		POP AX		;restaura conteudo dos registradores
		
		RET			;retorna

PRINTDEC ENDP

PRINTQUAT PROC

		MOV CX, 0806H
		MOV AH, 2
	
REPETEPRINTQUAT:
		MOV DL,BH
		
		SHR DL,CL
		
		ADD DL,30H

		INT 21H
		MOV VAULTCX,CX
		MOV CX,SHIFT2
		ROL BX,CL
		MOV CX,VAULTCX
		DEC CH
		JNZ REPETEPRINTQUAT
		
		RET
		
PRINTQUAT ENDP

PRINTHEXADEC PROC
		MOV CX, 0404H
		MOV AH, 2
	
REPETEPRINTHEXA:
		MOV DL,BH
		
		SHR DL,CL
		
		CMP DL,0AH
		JAE LETRAHEXD
		
		ADD DL,30H
		JMP NUMEROHEXD
		
	LETRAHEXD:
		ADD DL,37H
	NUMEROHEXD:
		INT 21H
		ROL BX,CL
		DEC CH
		JNZ REPETEPRINTHEXA
		
		RET

PRINTHEXADEC ENDP

LEITURADEC PROC
		
	;ENTRADA DE NUMEROS DECIMALS INICIO
		
		PUSH BX
		PUSH CX
		PUSH DX		;salvando registradores que serao usados
		
		XOR BX, BX	;bx acumula Valor total, inicial em 0
		XOR CX, CX	;cx indicador de cinal (1 = negativo) (inicial = 0)
		
		MOV AH, 1	;LE CARACTER no AL
		INT 21H
		
		CMP AL, '-'	;sinal negativo?
		JE MENOS
		CMP AL, '+'	;sinal positivo?
		JE MAIS
		
		JMP NUM		;se nao é sinal, entao processar caracter
		
MENOS: MOV CX, 1	;negativo == true

MAIS: INT 21H	;le um outro caracter

NUM: AND AX, 000FH	;junta ah a al, converte para binario

		PUSH AX	;salva ax (valor binario)na pilha
		
		MOV AX, 10	;prepara constante 10
		MUL BX		;ax = 10x total, total esta em bx
		POP BX		;retira da pilha o valor salvo, vai para bx
		
		ADD BX, AX	;total = total * 10 + valor binario
		
		MOV AH, 1H
		INT 21H		;le caracter
		
		CMP AL, 0DH	;è o cr?
		JNE NUM		;se nao, processa outro digito em num
		
		MOV AX, BX	;se cr, entao total em ax
		CMP CX, 1	;negativo?
		JNE	SAIDA	;nao
		
		NEG AX		;sim faz seu complemento de 2
		
SAIDA:	
		POP DX
		POP CX
		POP BX		;restaura os conteudos originais
		
		RET			;retorna 
		
	;FIM DA ENTRADA DE NUMEROS DECIMAIS

LEITURADEC ENDP




LEITURABIN PROC
		
		MOV CX, 16	;inicializa contador de digitos
		MOV AH, 1	;funcao dos para entrada pelo teclado
		XOR BX, BX	;zera BX (tera o resultado)
		INT 21H		;entra caracter esta no al
;while
KO:
		CMP AL, 0DH	;é cr?
		JE SALAMANDRA		;se sim termina while
		CMP AL, 0AH
		JE SALAMANDRA
		
		SHL BX,1	;abre espaco para o novo digito
		
		SUB AL, 30H	;se nao elimina 30h 
					;(poderia ser sub al, 30h)
		OR BL, AL	;insere o digito no lsb de bl
		INT 21H		;entra novo caracter
		
		LOOP KO	;controla o maximo de 16 digitos

SALAMANDRA:		
		
		RET			;retorna
		
		
LEITURABIN ENDP

LEITURAHEXAD PROC
		MOV CX, 0004H ;1 hexa = 4 b
		MOV AH, 01H ; recebe caracter
		XOR BX,BX;zera bx
		INT 21H;executa
	ANOTHER_HEXAD:
		CMP AL, 0DH	; é carriage return?
		JE END_READ_HEXAD	;se sim, finaliza
		TEST AL, 40H ; faz AND de AL com 40h para ver se é letra ou numero
		JNZ REAL_HEXADEC ;se é letra, ja pula para o 'real_hexa'
		SUB AL, 30H;caso seja número, tira 00110000	
		JMP INSERE_HEXADEC
		
	REAL_HEXADEC:
		SUB AL, 40H;retira os bits que tornam ele uma letra
		ADD AL, 1001B;soma 9 binário
		
	INSERE_HEXADEC:
		MOV VAULTCX,CX
		MOV CX,SHIFT4
		SHL BX,CL	; left shift 4 vezes
		OR BL,AL	; seta 4 bits 
		INT 21H;executa
		MOV CX,VAULTCX
		LOOP ANOTHER_HEXAD ;volta
	END_READ_HEXAD:	
		RET
LEITURAHEXAD ENDP

LEITURAQUAT PROC
		MOV CX, 0008H ;1 Quaternario = 2 b
		MOV AH, 01H ; recebe caracter
		XOR BX,BX;zera bx
		INT 21H;executa
	ANOTHER_QUAT:
		CMP AL, 0DH	; é carriage return?
		JE END_READ_QUAT	;se sim, finaliza
		
		SUB AL, 30H	
		MOV VAULTCX,CX
		MOV CX,SHIFT2
		SHL BX,CL	; left shift 2 vezes
		OR BL,AL	; seta 2 bits 
		INT 21H;executa
		MOV CX,VAULTCX
		
		LOOP ANOTHER_QUAT ;volta
	END_READ_QUAT:	
		RET
LEITURAQUAT ENDP

CLEARSCREEN PROC

		MOV	AX,0007H	;Codigo para limpar a tela
		INT	10H	;interrupcao da tela

		RET
		
CLEARSCREEN ENDP
		
PULALINHA PROC
		
	MOV	AH,09H	;imprime na tela uma string
	LEA	DX,BARRAN	;pula linha
	INT	21H

	RET
	
PULALINHA ENDP

INTERFACEH	PROC	;Interface de cima
		MOV	AX,0007H	;Codigo para limpar a tela
		INT	10H	;interrupcao da tela
		MOV	AH,09H
		LEA	DX,BARRAN	;pula linha
		INT	21H	;executa
		MOV CX,01EH	;move 30 para o contador->cx	
		MOV	DL,'-'	;barra superior
	BARRASUP:
		MOV	AH,02H	;instrucao para imprimir na tela
		INT	21H	;interrompe, "executa"
		TEST	CX,0FH	;testa utilizando o operador logico AND
		JNZ	NAOZERO	;caso o ZF-zero flag- seja 0 pula para NAOZERO
		
		MOV	VAULTC,CX
		MOV	CX,11H
		MOV	AH,09H	
		MOV	BL,09H
		INT	10H
		MOV	VAULTD,DX	;guarda o dx em bx
		LEA	DX,INTROCALC	;carrega o ponteiro da primeira posicao da string em dx
		INT 21H
		MOV	DX,VAULTD
		MOV	CX,VAULTC
	NAOZERO:
		LOOP	BARRASUP
		
		RET
INTERFACEH ENDP

INTERFACEL	PROC	;Interface de baixo
		MOV	AH,02H
		MOV	CX,02FH
		MOV	DL,'-'
	PRINTBARRA:
		INT	21H
		LOOP	PRINTBARRA
		
		RET
INTERFACEL	ENDP

MENSAGEM01 PROC
		MOV AH, 9
		LEA DX, MSG1
		INT 21H
		RET
MENSAGEM01 ENDP

MENSAGEM02 PROC
		MOV AH, 9
		LEA DX, MSG2
		INT 21H
		RET
MENSAGEM02 ENDP

MENSAGEMRES PROC
		MOV AH, 9
		LEA DX, RES
		INT 21H
		RET
MENSAGEMRES ENDP
PRINTBASEESCOLHIDA PROC
		MOV AH, 9
		LEA DX, MSGBASE
		INT 21H
		
		MOV	AH, 01H	;leitura da opcao escolhida
		INT	21H
		
		MOV DL, AL
		
		CMP	DL, 31H
		JE	DECI
		CMP DL, 32H
		JE	BINA
		CMP DL,'3'
		JE	HEXAD
		CMP DL,'4'
		JE	QUATER
	DECI:
		MOV AX,BX
		CALL PULALINHA
		CALL MENSAGEMRES
		CALL PRINTDEC
		JMP TERMINAPRINTBASEESCOLHIDA
	BINA:
		CALL PULALINHA
		CALL MENSAGEMRES
		CALL PRINTBIN
		JMP TERMINAPRINTBASEESCOLHIDA
	HEXAD:
		CALL PULALINHA
		CALL MENSAGEMRES
		CALL PRINTHEXADEC
		JMP TERMINAPRINTBASEESCOLHIDA
	QUATER:
		CALL PULALINHA
		CALL MENSAGEMRES
		CALL PRINTQUAT
	TERMINAPRINTBASEESCOLHIDA:
		RET
PRINTBASEESCOLHIDA ENDP

AGAIN PROC
	
	CALL PULALINHA
	
	MOV AH, 9
	LEA DX, DENOVO
	INT 21H

	MOV AH, 1
	INT 21H
	
	MOV RESAGAIN, AL
	
	RET
	
AGAIN ENDP

END MAIN
		