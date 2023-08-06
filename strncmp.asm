# UFRPE - Universidade Federal Rural de Pernambuco
# DC - Arquitetura e Organiza��o de Computadores
# Projeto 01 - Assembly MIPS

# Aluno(s): Aildson Ferreira, Arthur Macedo, Alison Ferreira

.data
	# Mudar o valor das strings, a quantidade de caracteres para compara��o e observar o valor final em $s0
	#	caso $v0 termine com o valor 0, as strings s�o iguais;
	#	caso seja 1 ou -1, as strings s�o diferentes, por�m:
	#		se 1, str_1 tem um caractere alfabeticamente maior que str_2;
	#		se -1, str_1 tem um caractere alfabeticamente menor que str_2.
	str_1: .asciiz "strncmp" 
	str_2: .asciiz "strncmp"
	num: .word 4

.text
	main:
		la $a1, str_2					# Carrega o endere�o de str_2 em $a1
		la $a0, str_1					# Carrega o endere�o de str_1 em $a0
		lw $a2, num						# Escreve em $a2 o conte�do em <num>
		
		jal strncmp						# Chama a fun��o strncmp

		addu $s0, $zero, $v0			# Escreve o resultado de strncmp em $s0

		addi $v0, $zero, 10				# Escreve em $v0 o n�mero de servi�o 10 <exit>
		syscall							# Chama o servi�o <exit>
	
	strncmp:
		comparison:
			lb $t0, 0($a1)				# Carrega o char atualmente lido de str_2 em $t0 
			lb $t1, 0($a0)				# Carrega o char atualmente lido de str_1 em $t1

			beq $t2, $a2, equal			# Verifica a quantidade de caracteres comparados

			bne $t0, $t1, different		# Verifica se $t0 e $t1 s�o diferentes (str_2[n] != str_1[n])
			beq $t0, $zero, equal		# Verifica se chegou ao final da compara��o (\0)

			addiu $a1, $a1, 1			# Adiciona 1 ao endere�o de $a1 (str_2[n + 1])
			addiu $a0, $a0, 1			# Adiciona 1 ao endere�o de $a0 (str_1[n + 1])
			addiu $t2, $t2, 1			# Incrementa a quantidade de caracteres comparados
	
			j comparison				# Looping de compara��o

		different:
			slt $t3, $t1, $t0			# Verifica se $t1 � menor que $t0 (str_1[n] < str_2[n])			

			bne $t3, $zero, negative	# Verifica se $t3 � diferente de 0, ent�o desvia
			beq $t3, $zero, positive	# Verifica se $t3 � igual a 0, ent�o desvia

			negative:
				addiu $v0, $zero, -1	# Escreve -1 em $v0 (str_1[n] < str_2[n])
				j end_comparison		# Desvia para o fim da fun��o

			positive:
				addiu $v0, $zero, 1		# Escreve -1 em $v0 (str_1[n] > str_2[n])
				j end_comparison		# Desvia para o fim da fun��o

		equal:
			addu $v0, $zero, $zero		# Escreve 0 em $v0 (str_2 == str_1)
			j end_comparison			# Desvia para o fim da fun��o

		end_comparison:
			jr $ra						# Sai da fun��o