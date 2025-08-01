#!/bin/bash

source ./common.sh
app_name=payment

check_root
app_setup
python_setup
systemd_setup

systemctl restart payment &>>$LOG_FILE
VALIDATE $? "Restart payment"

print_time