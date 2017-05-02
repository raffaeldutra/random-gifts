# Simples script para sorteio de brindes

### Em caso de houver um arquivo chamado lista.csv

Caso existir uma lista.csv no mesmo diretorio, será feito o sorteio baseado em número aleatório extraindo o nome do participante da lista.

```shell
./gift.sh
```

Script funcionará até atender todos os números da lista

### Em caso de não haver um arquivo lista.csv 

Pra rodar apenas é necessário passar a quantidade de participantes no evento, por exemplo:

```shell
./gift.sh 20
```

Caso o número já tenha sido sorteado, ele irá para um próximo aleatório até sair o exato número de participantes.

Esperamos que com isso, tenhamos um bom ganho de tempo :-)

!(https://travis-ci.org/raffaeldutra/random-gifts.svg?branch=master)
