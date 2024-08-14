#!/bin/bash
> ./email.txt
#Проверяем дубликат процесса 
if [ -s file.pid ]
   then 
       echo "Программа уже запущена. Дождитесь завершения"
           exit
   else
        echo "Копии программы обнаруженно небыло" 
	echo "$$" > ./file.pid
fi

# Путь к лог-файлу
LOG_APACHE="./apache.log"

#Формируем временной период
START_DATE=$(head -n1 $LOG_APACHE | awk '{print $4}' | cut -d'[' -f2-)
END_DATE=$(tail -n1 $LOG_APACHE | awk '{print $4}' | cut -d'[' -f2-)
echo "\nОтчет за период с $START_DATE до $END_DATE\n" >> ./email.txt

echo "\nСписок IP адресов (с наибольшим кол-вом запросов):" >> ./email.txt
    cat $LOG_APACHE | awk '{print $1}'  | sort | uniq -c | sort -nr | head -n 10 >> ./email.txt

echo "\nСписок запрашиваемых URL (с наибольшим кол-вом запросов):" >> ./email.txt
    cat $LOG_APACHE | awk '{print $7}' | sort | uniq -c | sort -nr | head -n 10 >> ./email.txt

echo "\nОшибки веб-сервера/приложения:" >> ./email.txt
    cat $LOG_APACHE | grep ' 50[0-9] ' >> ./email.txt

echo "\nСписок всех кодов HTTP ответа:" >> ./email.txt
    cat $LOG_APACHE | awk '{print $9}' | sort | uniq -c | sort -nr >> ./email.txt
# Отправка пиьсма    
    echo "Отправка письма" | mail -s "Report" -A ./email.txt -r stealthbro@mail.ru stealthbro@mail.ru

#Очищаем pid файл
> ./file.pid
