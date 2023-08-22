#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo "Welcome to My Salon, how can I help you?"

MAIN_MENU() {
  
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "\n1) cut\n2) color\n3) trim\n4) style"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) PHONE_MENU ;;
    2) PHONE_MENU ;;
    3) PHONE_MENU ;;
    4) PHONE_MENU ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
}

PHONE_MENU() {

  # get customer phone number
  echo -e "\nWhat's your phone number"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  # if customer doesn't exist in database
  if [[ -z $CUSTOMER_NAME ]]
  then
    # get new name
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    #insert new customer
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi

  # get customer id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone ='$CUSTOMER_PHONE'")
  # get service name
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
  # get time for a service appointment
  echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
  read SERVICE_TIME
  # Insert appointment time
  INSERT_SERVICE_TIME=$($PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES('$SERVICE_TIME', '$CUSTOMER_ID', '$SERVICE_ID_SELECTED')")
  # Print confirmation of reservation
  echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU
