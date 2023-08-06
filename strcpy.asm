# UFRPE - Universidade Federal Rural de Pernambuco
# DC - Arquitetura e Organização de Computadores
# Projeto 01 - Assembly MIPS

# Aluno(s): Aildson Ferreira, Arthur Macedo, Alison Ferreira

.data
	source: .asciiz "strcpy"
	destination: .space 32
	
.text
	main:
		la $a1, source					# Carrega o endereço de <source> em $a1
		la $a0, destination				# Carrega 32 bytes em $a0 (inicializa <destination[32]>) 

		jal strcpy						# Chama a função strcpy

		addu $a0, $zero, $v0			# Escreve em $a0 o endereço devolvido pela função
		addiu $v0, $zero, 4				# Escreve em $v0 o número de serviço 4 <print string>
		syscall							# Chama o serviço <print string>

		addiu $v0, $zero, 10			# Escreve em $v0 o número de serviço 10 <exit>
		syscall							# Chama o serviço <exit>
	
	strcpy:
		copy:
			lb $t0, 0($a1)				# Carrega um char da string em $t0 ($t0 = source[0 + $a1])

			beq $t0, $zero, end_copy	# Verifica se o char é nulo (\0), se sim, encerra o looping

			sb $t0, 0($a0)				# Escreve o char de $t0 num espaço de memória de $a0 (destination[0 + $a0] = $t0)
			addiu $a1, $a1, 1			# Adiciona 1 ao endereço de $a1 (source[n + 1])
			addiu $a0, $a0, 1			# Adiciona 1 ao endereço de $a0 (destination[n + 1])
			addiu $t1, $t1, 1			# Atualiza a quantidade de posições alteradas na memória

			j copy						# Looping de cópia
		
		end_copy: 
			subu $v0, $a0, $t1			# Escreve em $v0 o endereço de memória que começa a string <destination>
			jr $ra						# Sai da função
