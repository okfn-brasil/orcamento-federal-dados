#!/bin/sh
# Prepara dados vindos do Siga Brasil para colocá-los no OpenSpending
FILEPATH=$1
FILENAME=${FILEPATH%.*}

ANO=1
MES=2
AUTORIZADO=10
PAGO=11
RP_PAGO=12

SEM_ZEROS=/tmp/$FILENAME-semzeros.csv
COM_ANOMES=/tmp/$FILENAME-anomes.csv
RESULTADO=$FILENAME-resultado.csv

# Remove linhas com mês igual a 00
csvgrep -c $MES -m "00" -d ";" -i $FILEPATH > $SEM_ZEROS

# Adiciona coluna Ano-Mês
ANOMES=`csvcut -c $ANO,$MES $SEM_ZEROS | tail -n +2 | sed 's/,/-/g'`
echo "Ano-Mês\n$ANOMES" > $COM_ANOMES

# Junta a coluna Ano-Mês com o CSV original
csvjoin $SEM_ZEROS $COM_ANOMES |
# Remove colunas Mês e Ano
csvcut -C $MES,$ANO > $RESULTADO
