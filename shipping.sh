#!/bin/bash

source ./common.sh
app_name=shipping

check_root
echo "Please enter root password to setup"
read -s MYSQL_ROOT_PASSWORD

app_setup
maven_setup
systemd_setup

dnf install mysql -y  &>>$LOG_FILE
VALIDATE $? "Install MySQL"

mysql -h mysql.rajdevops.fun -u root -p$MYSQL_ROOT_PASSWORD -e 'use cities' &>>$LOG_FILE
if [ $? -ne 0 ]
then
    mysql -h mysql.rajdevops.fun -uroot -pRoboShop@1 < /app/db/schema.sql &>>$log_file
    VALID $? "Loading schema to IP"
    mysql -h mysql.rajdevops.fun -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$log_file
    VALID $? "Loading userdata to IP"
    mysql -h mysql.rajdevops.fun -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$log_file
    VALID $? "Loading MasterData to IP"
else
    echo -e "Data is already loaded into MySQL ... $Y SKIPPING $N"
fi

systemctl restart shipping &>>$LOG_FILE
VALIDATE $? "Restart shipping"

print_time