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


