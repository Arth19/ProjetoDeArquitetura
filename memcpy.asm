# UFRPE - Universidade Federal Rural de Pernambuco
# DC - Arquitetura e Organiza��o de Computadores
# Projeto 01 - Assembly MIPS

# Aluno(s): Aildson Ferreira, Arthur Macedo, Alison Ferreira

.data
	source: .asciiz "mem"
	destination: .asciiz "strcpy" 	
	num: .word 3

.text
	main:
		la $a1, source					# Carrega o endere�o de <source> em $a1
		la $a0, destination				# Carrega o endere�o de <destination> em $a0
		lw $a2, num						# Escreve em $a2 o conte�do em <num>

		jal memcpy						# Chama a fun��o memcpy

		addu $a0, $zero, $v0			# Escreve em $a0 o endere�o devolvido pela fun��o
		addiu $v0, $zero, 4				# Escreve em $v0 o n�mero de servi�o 4 <print string>
		syscall							# Chama o servi�o <print string>

		addiu $v0, $zero, 10			# Escreve em $v0 o n�mero de servi�o 10 <exit>
		syscall							# Chama o servi�o <exit>

		memcpy:
			addu $t1, $zero, $zero		# Escreve $zero em $t1 (garante que $t0 est� inicializado com 0)

			copy:
				beq $t1, $a2, end_memcpy	# Verifica se $t1 � igual a $a2, ent�o desvia (checa se o total de bytes foi copiado)

				lb $t0, 0($a1)				# Carrega em $t0 o primeiro byte de $a1
				sb $t0, 0($a0)				# Escreve o byte de $t0 em um espa�o de mem�ria de $a0

				addiu $a1, $a1, 1			# Adiciona 1 ao endere�o de $a1 (Src[n + 1])
				addiu $a0, $a0, 1			# Adiciona 1 ao endere�o de $a0 (Dest[n + 1])
				addiu $t1, $t1, 1			# Incrementa a quantidade de caracteres comparados

				j copy						# Looping de c�pia

			end_memcpy:
				subu $v0, $a0, $t1		# Escreve em $v0 o endere�o de mem�ria que come�a o bloco <destination>	
				jr $ra					# Sai da fun��o