.data
    # Estrutura do cardápio
    cardapio: .space 240   # Reservando espaço para 20 itens
    item_codigo: .word 0     # Código do item
    item_preco: .word 0      # Preço do item
    item_descricao: .asciiz "Pizza" # Descrição do item

    # Estrutura das mesas
    mesas: .space 420      # Reservando espaço para 15 mesas
    mesa_codigo: .word 0     # Código da mesa
    mesa_status: .word 0     # Status da mesa (0 para desocupada, 1 para ocupada)
    mesa_nome: .space 50     # Nome do responsável pela mesa
    mesa_telefone: .space 15 # Telefone de contato
    mesa_pedidos: .space 12  # Registro de pedidos
    mesa_saldo: .space 60    # Reservando espaço para o saldo devedor de 15 mesas (4 bytes por mesa)
    header: .asciiz "Relatório de Consumo - Mesa "  # Cabeçalho para o relatório de consumo

    msg_erro: .asciiz "Erro: A conta ainda tem um saldo pendente e não pode ser fechada.\n"
    
    # Dados de teste
    mesa_nome_teste: .asciiz "Joao"
    mesa_telefone_teste: .asciiz "123456789"

.text
main:
    # Testando a função adicionar_item
    li $a0, 1                # Código do item
    li $a1, 10               # Preço do item
    la $a2, item_descricao   # Endereço da descrição do item
    jal adicionar_item

    # Testando a função adicionar_mesa
    li $a0, 1                # Código da mesa
    la $a1, mesa_nome_teste  # Endereço do nome do responsável
    la $a2, mesa_telefone_teste # Endereço do telefone de contato
    jal adicionar_mesa
    
    # Testando a função adicionar_pedido
    li $a0, 1                # Código da mesa
    li $a1, 1                # Código do item pedido
    li $a2, 2                # Quantidade do item pedido
    jal adicionar_pedido

    li $a0, 1                # Código da mesa
    li $a1, 1                # Código do item pedido (mesmo item para testar a atualização)
    li $a2, 3                # Quantidade do item pedido
    jal adicionar_pedido
    
    # Testando a função adicionar_pagamento
    li $a0, 1                # Código da mesa
    li $a1, 50               # Valor do pagamento
    jal adicionar_pagamento

    # Testando a função gerar_relatório
    li $a0, 1                # Código da mesa
    jal gerar_relatorio
    
    # Testando a função fechar_conta
    li $a0, 1                # Código da mesa 1
    jal fechar_conta
    
    # Código para terminar a execução
    li $v0, 10
    syscall

adicionar_item:
    # Argumentos:
    # $a0 = código do item
    # $a1 = preço do item
    # $a2 = endereço da descrição do item

    # Calculando o índice para armazenar o item no cardápio
    sub $a0, $a0, 1          # Subtrair 1 do código para obter o índice
    li $t0, 12              # Cada item tem 12 bytes
    mul $t1, $a0, $t0       # Multiplicar o índice pelo tamanho do item para obter o deslocamento

    # Armazenando o código do item
    sw $a0, cardapio($t1)

    # Armazenando o preço do item
    addi $t1, $t1, 4        # Avançar 4 bytes para armazenar o preço
    sw $a1, cardapio($t1)

    # Armazenando a descrição do item
    addi $t1, $t1, 4        # Avançar mais 4 bytes para armazenar a descrição
    sw $a2, cardapio($t1)

    # Retornar
    jr $ra

adicionar_mesa:
    # Argumentos:
    # $a0 = código da mesa
    # $a1 = endereço do nome do responsável
    # $a2 = endereço do telefone de contato

    # Calculando o índice para armazenar a mesa
    sub $a0, $a0, 1          # Subtrair 1 do código para obter o índice
    li $t0, 28              # Cada mesa tem 28 bytes
    mul $t1, $a0, $t0       # Multiplicar o índice pelo tamanho da mesa para obter o deslocamento

    # Armazenando o código da mesa
    sw $a0, mesas($t1)

    # Definindo o status da mesa como ocupada
    addi $t1, $t1, 4        # Avançar 4 bytes para armazenar o status
    li $t2, 1               # Status ocupada
    sw $t2, mesas($t1)

    # Armazenando o nome do responsável
    addi $t1, $t1, 4        # Avançar mais 4 bytes para armazenar o nome
    sw $a1, mesas($t1)

    # Armazenando o telefone de contato
    addi $t1, $t1, 4        # Avançar mais 4 bytes para armazenar o telefone
    sw $a2, mesas($t1)

    # Retornar
    jr $ra

adicionar_pedido:
    # Argumentos:
    # $a0 = código da mesa
    # $a1 = código do item pedido
    # $a2 = quantidade do item pedido

    # Calculando o índice para localizar a mesa
    sub $a0, $a0, 1          # Subtrair 1 do código para obter o índice
    li $t0, 28              # Cada mesa tem 28 bytes
    mul $t1, $a0, $t0       # Multiplicar o índice pelo tamanho da mesa para obter o deslocamento

    # Localizando a área de pedidos da mesa
    addi $t1, $t1, 16       # Avançar 16 bytes (4 para código, 4 para status, 4 para nome, 4 para telefone)

    # Loop para verificar os pedidos existentes
    loop_pedidos:
        lw $t2, 0($t1)          # Carregar o código do item pedido
        beq $t2, $zero, novo_pedido # Se o espaço estiver vazio, adicionar um novo pedido
        beq $t2, $a1, atualizar_pedido # Se o item já foi pedido, atualizar a quantidade
        addi $t1, $t1, 8        # Avançar para o próximo pedido
        j loop_pedidos

    novo_pedido:
        # Adicionar um novo pedido
        sw $a1, 0($t1)          # Armazenar o código do item
        sw $a2, 4($t1)          # Armazenar a quantidade
        j fim

    atualizar_pedido:
        # Atualizar a quantidade do pedido existente
        lw $t3, 4($t1)          # Carregar a quantidade atual
        add $t3, $t3, $a2       # Adicionar a nova quantidade
        sw $t3, 4($t1)          # Armazenar a quantidade atualizada

    fim:
        # Retornar
        jr $ra

adicionar_pagamento:
    # Argumentos:
    # $a0 = código da mesa
    # $a1 = valor do pagamento

    # Calculando o índice para localizar o saldo devedor da mesa
    sub $a0, $a0, 1          # Subtrair 1 do código para obter o índice
    li $t0, 4               # Cada saldo tem 4 bytes
    mul $t1, $a0, $t0       # Multiplicar o índice pelo tamanho do saldo para obter o deslocamento

    # Atualizando o saldo devedor
    lw $t2, mesa_saldo($t1) # Carregar o saldo devedor atual
    sub $t2, $t2, $a1       # Subtrair o valor do pagamento
    sw $t2, mesa_saldo($t1) # Armazenar o saldo devedor atualizado

    # Retornar
    jr $ra
    

gerar_relatorio:
    # Argumentos:
    # $a0 = código da mesa

    # Calculando o índice para localizar a mesa
    sub $a0, $a0, 1          # Subtrair 1 do código para obter o índice
    li $t0, 28              # Cada mesa tem 28 bytes
    mul $t1, $a0, $t0       # Multiplicar o índice pelo tamanho da mesa para obter o deslocamento

    # Imprimir cabeçalho do relatório
    li $v0, 4
    la $a0, header
    syscall

    # Localizando a área de pedidos da mesa
    addi $t1, $t1, 16       # Avançar 16 bytes (4 para código, 4 para status, 4 para nome, 4 para telefone)

    # Inicializando o valor total da conta
    li $t7, 0

    calc_total:
        lw $t2, 0($t1)          # Carregar o código do item pedido
        beq $t2, $zero, fim_calc # Se o espaço estiver vazio, terminar o cálculo

        # Obter o preço do item do cardápio
        li $t3, 12              # Cada item do cardápio tem 12 bytes
        mul $t4, $t2, $t3       # Calculando o deslocamento para o item no cardápio
        lw $t5, cardapio($t4)   # Carregando o preço do item

        # Multiplicar o preço pelo número de itens pedidos
        lw $t6, 4($t1)          # Carregar a quantidade do item pedido
        mul $t8, $t5, $t6       # Multiplicar preço pela quantidade
        add $t7, $t7, $t8       # Adicionar ao valor total

        addi $t1, $t1, 8        # Avançar para o próximo pedido
        j calc_total

    fim_calc:
        # Imprimir o valor total da conta
        li $v0, 1               # syscall para imprimir inteiro
        move $a0, $t7
        syscall

        # Imprimir o saldo total já pago
        lw $t9, mesa_saldo($t1) # Carregar o saldo já pago
        li $v0, 1               # syscall para imprimir inteiro
        move $a0, $t9
        syscall

        # Calcular e imprimir o saldo devedor
        sub $s0, $t7, $t9       # Saldo devedor = valor total - saldo já pago
        li $v0, 1               # syscall para imprimir inteiro
        move $a0, $s0
        syscall

        # Retornar
        jr $ra

fechar_conta:
        # Argumentos:
        # $a0 = código da mesa

        # Calculando o índice para localizar a mesa
        sub $a0, $a0, 1          # Subtrair 1 do código para obter o índice
        li $t0, 28              # Cada mesa tem 28 bytes
        mul $t1, $a0, $t0       # Multiplicar o índice pelo tamanho da mesa para obter o deslocamento

        # Verificar o saldo devedor
        lw $t2, mesa_saldo($t1)
        bnez $t2, conta_nao_quitada  # Se o saldo não for zero, a conta não foi quitada

        # Definir o status da mesa como "Desocupada"
        sw $zero, mesas($t1)

        # Limpar o nome do responsável e o telefone de contato
        addi $t1, $t1, 8        # Avançar 8 bytes (4 para código, 4 para status)
        sw $zero, 0($t1)        # Limpar nome
        addi $t1, $t1, 4
        sw $zero, 0($t1)        # Limpar telefone

        # Limpar todos os registros de consumo da mesa
        addi $t1, $t1, 4
        li $t3, 0               # Inicializar contador
    limpar_pedidos:
        beq $t3, 20, fim_limpar # Se todos os 20 pedidos foram limpos, terminar
        sw $zero, 0($t1)        # Limpar código do item pedido
        sw $zero, 4($t1)        # Limpar quantidade do item pedido
        addi $t1, $t1, 8
        addi $t3, $t3, 1
        j limpar_pedidos

    fim_limpar:
        # Retornar
        jr $ra

    conta_nao_quitada:
        # Carregar a mensagem de erro
        la $a0, msg_erro
        # Definir o código de syscall para imprimir string
        li $v0, 4
        # Chamar syscall
        syscall
        # Retornar
        jr $ra


