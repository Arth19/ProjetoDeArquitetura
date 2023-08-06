# UFRPE - Universidade Federal Rural de Pernambuco
# DC - Arquitetura e Organização de Computadores
# Projeto 01 - Assembly MIPS

# Aluno(s): Aildson Ferreira, Arthur Macedo, Alison Ferreira

.data
	source: .asciiz "cat"
	destination: .asciiz "str" 

.text
	main:
		la $a1, destination				# Carrega o endereço de <destination> em $a1
		la $a0, source					# Carrega o endereço de <source> em $a0
		
		jal strcat						# Chama a função strcat

		addu $a0, $zero, $v0			# Escreve em $a0 o endereço devolvido pela função		
		addiu $v0, $zero, 4				# Escreve em $v0 o número de serviço 4 <print string>
		syscall							# Chama o serviço <print string>

		addiu $v0, $zero, 10			# Escreve em $v0 o número de serviço 10 <exit>
		syscall							# Chama o serviço <exit>
	
	strcat:
		read:
			lb $t0, 0($a0)				# Carrega um char da string em $t0 ($t0 = destination[0 + $a1])
			beq $t0, $zero, concat		# Verifica se o char é nulo (\0), se sim, inicia a concatenação

			addiu $a0, $a0, 1			# Adiciona 1 ao endereço de $a0 (destination[n + 1])
			addiu $t1, $t1, 1			# Incrementa o registrador auxiliar de varredura

			j read						# Looping de leitura de str_1

		concat:
			lb $t0, 0($a1)				# Carrega em $t0 o primeiro char de $a1
			beq $t0, $zero, end_concat	# Verifica se $t0 é o char nulo, então desvia
			
			sb $t0, 0($a0)				# Escreve o char de $t0 em um espaço de memória de $a0
			sb $zero, 0($a1)			# Escreve zero na atual posição de $a1 (evitar sobrescrita)

			addiu $a1, $a1, 1			# Adiciona 1 ao endereço de $a1
			addiu $a0, $a0, 1			# Adiciona 1 ao endereço de $a0 
			addiu $t1, $t1, 1			# Incrementa o registrador auxiliar de varredura

			j concat					# Looping de escrita de str_2
		
		end_concat:
			subu $v0, $a0, $t1			# Escreve em $v0 o endereço de memória que começa a string resultante
			jr $ra						# Sai da função