#!/bin/bash
: '
Написать скрипт, который выведет всех потомков процесса по его PID. 
'


#Имя процесса
PROCNAME=$(ps -P $1 | tail -1 | awk '{ print $6 }')
echo "Потомки процесса $PROCNAME с PID $1:"

# Отображаем информацию о каждом процессе по PID, отданному в pgrep
pgrep -P $1| while read pid; do
    ps -p $pid | tail -1 | awk '{ print $1, $4 }'
done