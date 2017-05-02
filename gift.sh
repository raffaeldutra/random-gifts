#!/usr/bin/env bash
#Rafael Dutra <raffaeldutra@gmail.com>

if [ "x$1" == "x" ]
then
    echo "Passe o total de participantes"
    exit 1
fi

declare number="$1"
declare today=$(date +%Y-%m-%d)

function getNextNumber() {
    echo $(((RANDOM % ${number})  + 1))
}

function numberAlreadyExists() {
    nextNumber="${1}"

    if [ ! -f ${today}.log ]
    then
        echo "Numero sorteado: ${nextNumber}" | tee -a ${today}.log
        exit 1
    fi

    cat ${today}.log | grep -w ${nextNumber} >/dev/null && exists=0 || exists=1
}

firstNumber=$(getNextNumber)

numberAlreadyExists ${firstNumber}

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
            echo "Numero sorteado: ${newNumber}" | tee -a ${today}.log
            starting=0
        fi

        totalCount=$((totalCount+1))
    done
else 
    echo "Numero sorteado: ${firstNumber}" | tee -a ${today}.log
fi
