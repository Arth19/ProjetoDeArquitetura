# UFRPE - Universidade Federal Rural de Pernambuco
# DC - Arquitetura e Organiza��o de Computadores
# Projeto 01 - Assembly MIPS

# Aluno(s): Aildson Ferreira, Arthur Macedo, Alison Ferreira

.data
	source: .asciiz "cat"
	destination: .asciiz "str" 

.text
	main:
		la $a1, destination				# Carrega o endere�o de <destination> em $a1
		la $a0, source					# Carrega o endere�o de <source> em $a0
		
		jal strcat						# Chama a fun��o strcat

		addu $a0, $zero, $v0			# Escreve em $a0 o endere�o devolvido pela fun��o		
		addiu $v0, $zero, 4				# Escreve em $v0 o n�mero de servi�o 4 <print string>
		syscall							# Chama o servi�o <print string>

		addiu $v0, $zero, 10			# Escreve em $v0 o n�mero de servi�o 10 <exit>
		syscall							# Chama o servi�o <exit>
	
	strcat:
		read:
			lb $t0, 0($a0)				# Carrega um char da string em $t0 ($t0 = destination[0 + $a1])
			beq $t0, $zero, concat		# Verifica se o char � nulo (\0), se sim, inicia a concatena��o

			addiu $a0, $a0, 1			# Adiciona 1 ao endere�o de $a0 (destination[n + 1])
			addiu $t1, $t1, 1			# Incrementa o registrador auxiliar de varredura

			j read						# Looping de leitura de str_1

		concat:
			lb $t0, 0($a1)				# Carrega em $t0 o primeiro char de $a1
			beq $t0, $zero, end_concat	# Verifica se $t0 � o char nulo, ent�o desvia
			
			sb $t0, 0($a0)				# Escreve o char de $t0 em um espa�o de mem�ria de $a0
			sb $zero, 0($a1)			# Escreve zero na atual posi��o de $a1 (evitar sobrescrita)

			addiu $a1, $a1, 1			# Adiciona 1 ao endere�o de $a1
			addiu $a0, $a0, 1			# Adiciona 1 ao endere�o de $a0 
			addiu $t1, $t1, 1			# Incrementa o registrador auxiliar de varredura

			j concat					# Looping de escrita de str_2
		
		end_concat:
			subu $v0, $a0, $t1			# Escreve em $v0 o endere�o de mem�ria que come�a a string resultante
			jr $ra						# Sai da fun��o