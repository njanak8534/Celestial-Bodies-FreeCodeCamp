#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

GET_RESULT() {
  if [[ -z $1 ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$1" | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME
    do
      TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
      
      TYPE_NAME=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
      MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
      BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
      ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")

      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE_NAME, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."

    done
  fi
}

if [[ $1 ]]
then
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    OUTPUT=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE atomic_number=$1")
  elif [[ $1 =~ ^[a-zA-Z]$ || $1 =~ ^[a-zA-Z][a-zA-Z]$ ]]
  then
    OUTPUT=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE symbol='$1'")
  elif [[ $1 =~ ^[a-zA-Z]*$ ]]
  then
    OUTPUT=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE name='$1'")
  else
    echo "I could not find that element in the database."
  fi
  GET_RESULT $OUTPUT
else
  echo "Please provide an element as an argument."
fi