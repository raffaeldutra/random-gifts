#!/usr/bin/env bash
#Rafael Dutra <raffaeldutra@gmail.com>

if [ "x$1" == "x" ]
then
    echo "Passe o total de participantes"
    exit 1
fi

if [ ! -f "lista.csv" ]
then
    echo "Arquivo lista.csv nao foi encontrada, saindo..."
fi

declare number="$1"
declare today=$(date +%Y-%m-%d)

function getNameFromCsv() {
    personNumber="${1}"

    #Caso tenha uma lista de nomes apenas, comentar linha abaixo
    #Caso tenha uma planilha com mais colunas, atentar para o campo do parametro do comando cut
    #pois ali que sera determinado qual coluna deve ser filtrado
    echo "$(cat lista.csv | grep -i "participante" | cut -d , -f3 | sed "${personNumber}!d")"

    #Caso tenha apenas um input de nomes, comentar linha acima e descomentar esta abaixo
    #echo "$(cat lista.csv | sed "${personNumber}!d")"
}

function getNextNumber() {
    echo $(((RANDOM % ${number})  + 1))
}

function numberAlreadyExists() {
    nextNumber="${1}"

    if [ ! -f ${today}.log ]
    then
        echo "Pessoa sorteada: $(getNameFromCsv ${nextNumber})" | tee -a ${today}.log
        exit 1
    fi

    cat ${today}.log | grep -w "$(getNameFromCsv ${nextNumber})" >/dev/null && exists=0 || exists=1
}

firstPerson=$(getNextNumber)

numberAlreadyExists ${firstPerson}

if [ ${exists} -eq 0 ]
then
    starting=1
    totalCount=0

    while [ ${starting} -eq 1 -a ${totalCount} -le ${number} ]
    do
        if [ ${totalCount} -eq ${number} ]
        then
            echo "Todos os numeros foram sorteados, saindo.."
            starting=0
        fi

        newNumber=$(getNextNumber)

        numberAlreadyExists ${newNumber}
    
        if [ ${exists} -eq 1 ]
        then
            echo "Pessoa sorteada: $(getNameFromCsv ${newNumber})" | tee -a ${today}.log
            starting=0
        fi

        totalCount=$((totalCount+1))
    done
else 
    echo "Pessoa sorteada: $(getNameFromCsv ${firstPerson})" | tee -a ${today}.log
fi
