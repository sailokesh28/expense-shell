#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"

LOGS_FOLDER="/var/log/Expense-logs"
LOG_FILE=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE_NAME="$LOGS_FOLDER/$LOG_FILE-$TIMESTAMP.log"
VALIDATE(){
    if [ $? -ne 0 ]
    then
        echo -e "$2.......$R FAILURE"
        exit 1
    else
         echo -e "$2.......$G SUCCESS"
    fi
}

    
CHECK_ROOT(){
if [ $USERID -ne 0 ]
then
  
    echo "Error: You Must Have Sudo Access to Execute This Script"
    exit 1 #other than 0
fi
}
mkdir -p /var/log/Expense-logs
echo "Script Started Executed at: $TIMESTAMP" &>>$LOG_FILE_NAME

CHECK_ROOT

dnf install mysql-server -y &>>LOG_FILE_NAME
VALIDATE $? "Insatlling MySql Server"

systemctl enable mysqld &>>LOG_FILE_NAME
VALIDATE $? "Enabling MySql Server"

systemctl start mysqld &>>LOG_FILE_NAME
VALIDATE $? "Starting MySql Server"

mysql_secure_installation --set-root-pass ExpenseApp@1
VALIDATE $? "Setting Root Password"