#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

SECRET_NUMBER=$(( 1 + $RANDOM % 1000 ))

UPDATE_DATABASE() {
  USERNAME_REQUESTED=$($PSQL "SELECT username FROM user_data WHERE username='$1'")
  if [[ -z $USERNAME_REQUESTED ]]
  then
    INSERT_USER=$($PSQL "INSERT INTO user_data(username, best_game) VALUES('$1', $2)")
  else
    GAMES_PLAYED=$($PSQL "SELECT games_played FROM user_data WHERE username='$1'")
    GAMES_PLAYED=$(( $GAMES_PLAYED + 1 ))

    BEST_GAME=$($PSQL "SELECT best_game FROM user_data WHERE username='$1'")
    if [[ $2 -lt $BEST_GAME ]]
    then
      BEST_GAME=$2
    fi

    UPDATE_GAMES=$($PSQL "UPDATE user_data SET games_played=$GAMES_PLAYED WHERE username='$1'")
    UPDATE_BEST_GAME=$($PSQL "UPDATE user_data SET best_game=$BEST_GAME WHERE username='$1'")
  fi
}

GUESSING_GAME() {
  echo "Guess the secret number between 1 and 1000:"
  GUESS_COUNTER=1;
  read GUESS
  while [[ $GUESS -ne $SECRET_NUMBER ]]
  do
    if [[ ! $GUESS =~ ^[0-9]*$ ]]
    then
      echo "That is not an integer, guess again:"
    elif [[ $GUESS -lt $SECRET_NUMBER ]]
    then
      echo "It's higher than that, guess again:"
    else
      echo "It's lower than that, guess again:"
    fi
    GUESS_COUNTER=$(( $GUESS_COUNTER + 1 ))
    read GUESS
  done
  echo "You guessed it in $GUESS_COUNTER tries. The secret number was $SECRET_NUMBER. Nice job!"
  UPDATE_DATABASE $1 $GUESS_COUNTER
}

echo "Enter your username:"
read USERNAME
USERNAME_REQUESTED=$($PSQL "SELECT username FROM user_data WHERE username='$USERNAME'")
if [[ -z $USERNAME_REQUESTED ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  GUESSING_GAME $USERNAME
else
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM user_data WHERE username='$USERNAME'")
  BEST_GAME=$($PSQL "SELECT best_game FROM user_data WHERE username='$USERNAME'")

  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  GUESSING_GAME $USERNAME
fi
