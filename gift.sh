#!/usr/bin/env bash
#Rafael Dutra <raffaeldutra@gmail.com>

nameImplementation=0

if [ ! -f "lista.csv" 2>/dev/null ]; then
    nameImplementation=1

    echo "Arquivo lista.csv nao foi encontrada, usando numeros aleatorios..."

    if [ "x$1" == "x" ]; then
        echo "Passe o total de participantes"
        exit 1
    fi
fi


if [ ${nameImplementation} -eq 1 ]; then
    declare number="${1}"
else
    declare number="$(wc -l | sed 's| ||g' < lista.csv)"
fi

declare today="$(date +%Y-%m-%d)"

function getNameFromCsv {
    personNumber="${1}"

    #Caso tenha uma lista de nomes apenas, comentar linha abaixo
    #Caso tenha uma planilha com mais colunas, atentar para o campo do parametro do comando cut
    #pois ali que sera determinado qual coluna deve ser filtrado
    #echo "$(cat lista.csv | grep -i "participante" | cut -d , -f3 | sed "${personNumber}!d")"

    #Caso tenha apenas um input de nomes, comentar linha acima e descomentar esta abaixo
    echo "$(cat lista.csv 2>/dev/null | sed "${personNumber}!d")"
}

function getNextNumber {
    echo $(((RANDOM % ${number})  + 1))
}

function getResponse {
    nextNumber="${1}"

    if [ ${nameImplementation} -eq 0 ]; then
        echo "Pessoa sorteada: $(getNameFromCsv ${nextNumber})"
    else
        echo "Numero sorteado: ${nextNumber}"
    fi
}

function numberAlreadyExists {
    nextNumber="${1}"

    if [ ! -f "${today}.log" ]; then
        echo "$(getResponse ${nextNumber})" | tee -a "${today}.log"
        exit 1
    fi

    if [ ${nameImplementation} -eq 0 ]; then
        if [ $(cat "${today}.log" | grep -w "$(getNameFromCsv ${nextNumber})" >/dev/null) ]; then
            exists=0
        else
            exists=1
        fi
    else
        if [ $(cat "${today}.log" | grep -w "${nextNumber}" >/dev/null) ]; then
            exists=0
        else
            exists=1
        fi
    fi
}

firstNumber="$(getNextNumber)"

numberAlreadyExists ${firstNumber}

if [ ${exists} -eq 0 ]; then
    starting=1
    totalCount=0

    while [ "${starting}" -eq 1 -a "${totalCount}" -le "${number}" ]; do
        if [ "${totalCount}" -eq "${number}" ]; then
            echo "Todos as pessoas foram sorteados, saindo.."
            starting=0
        fi

        newNumber="$(getNextNumber)"

        numberAlreadyExists "${newNumber}"

        if [ "${exists}" -eq 1 ]; then
            echo "$(getResponse ${newNumber})" | tee -a "${today}.log"
            starting=0
        fi

        totalCount=$((totalCount+1))
    done
else
    echo "$(getResponse ${firstNumber})" | tee -a "${today}.log"
fi
