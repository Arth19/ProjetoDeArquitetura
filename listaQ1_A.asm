.data
    source: .asciiz "Hello, world!"    # String de origem
    destination: .space 50             # Espaço reservado para a string de destino
.text
main:
    la $a0, destination        # Carrega o endereço da string de destino em $a0
    la $a1, source             # Carrega o endereço da string de origem em $a1

    jal strcpy                 # Chama a função strcpy

    # Após a chamada da função strcpy, você pode inspecionar o conteúdo da string 
    # destination para verificar se a cópia foi feita corretamente.

    # Código para terminar a execução
    li $v0, 10
    syscall

strcpy:
    # $a0 é o ponteiro de destino
    # $a1 é o ponteiro de origem

    loop:
        # Carrega byte da origem em $t0
        lb $t0, 0($a1)   # $t0 = *$a1

        # Armazena byte no destino
        sb $t0, 0($a0)   # *$a0 = $t0

        # Verifica se o byte atual é NULL (0)
        # Se for, sai do loop e vai para o final
        beqz $t0, fim    # se $t0 == 0, vai para 'fim'

        # Incrementa os ponteiros
        # Isso move os ponteiros para o próximo byte
        addiu $a0, $a0, 1  # $a0 = $a0 + 1
        addiu $a1, $a1, 1  # $a1 = $a1 + 1

        # Repete o loop
        j loop

    fim:
        # Retorna o ponteiro de destino em $v0
        move $v0, $a0

        # Retorna para a chamada anterior
        jr $ra
