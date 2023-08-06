# UFRPE - Universidade Federal Rural de Pernambuco
# DC - Arquitetura e Organização de Computadores
# Projeto 01 - Assembly MIPS

# Aluno(s): Aildson Ferreira, Arthur Macedo, Alison Ferreira

.data
	# Mudar o valor das strings e observar o valor final em $s0
	#	caso $v0 termine com o valor 0, as strings são iguais;
	#	caso seja 1 ou -1, as strings são diferentes, porém:
	#		se 1, str_1 tem um caractere alfabeticamente maior que str_2;
	#		se -1, str_1 tem um caractere alfabeticamente menor que str_2.
	str_1: .asciiz "strcmp" 
	str_2: .asciiz "strcmp"

.text
	main:
		la $a1, str_2					# Carrega o endereço de str_2 em $a1
		la $a0, str_1					# Carrega o endereço de str_1 em $a0
		
		jal strcmp						# Chama a função strcmp

		addu $s0, $zero, $v0			# Escreve o resultado de strcmp em $s0

		addiu $v0, $zero, 10			# Escreve em $v0 o número de serviço 10 <exit>
		syscall							# Chama o serviço <exit>
	
	strcmp:
		comparison:
			lb $t0, 0($a1)				# Carrega o char atualmente lido de str_2 em $t0 
			lb $t1, 0($a0)				# Carrega o char atualmente lido de str_1 em $t1

			bne $t0, $t1, different		# Verifica se $t0 e $t1 são diferentes (str_2[n] != str_1[n])
			beq $t0, $zero, equal		# Verifica se chegou ao final da comparação (\0)

			addiu $a1, $a1, 1			# Adiciona 1 ao endereço de $a1 (str_2[n + 1])
			addiu $a0, $a0, 1			# Adiciona 1 ao endereço de $a0 (str_1[n + 1])
	
			j comparison				# Looping de comparação

		different:
			slt $t2, $t1, $t0			# Verifica se $t1 é menor que $t0 (str_1[n] < str_2[n])			

			bne $t2, $zero, negative	# Verifica se $t2 é diferente de 0, então desvia
			beq $t2, $zero, positive	# Verifica se $t2 é igual a 0, então desvia

			negative:
				addiu $v0, $zero, -1	# Escreve -1 em $v0 (str_1[n] < str_2[n])
				j end_comparison		# Desvia para o fim da função

			positive:
				addiu $v0, $zero, 1		# Escreve -1 em $v0 (str_1[n] > str_2[n])
				j end_comparison		# Desvia para o fim da função

		equal:
			addu $v0, $zero, $zero		# Escreve 0 em $v0 (str_2 == str_1)
			j end_comparison			# Desvia para o fim da função

		end_comparison:
			jr $ra						# Sai da função