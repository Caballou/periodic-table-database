#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# delete element from properties
DELETEPROP=$($PSQL "DELETE FROM properties WHERE atomic_number = 1000")
# delete element from elements
DELETEELEM=$($PSQL "DELETE FROM elements WHERE atomic_number = 1000")

if [[ -z $1 ]]
then
  # if the user enter a invalid argument
  echo "Please provide an element as an argument."
else

  if [[ $1 =~ ^[0-9]+$ ]]
  then
    # get atomic_number, symbol and name for the 
    # element enter as an argument if the user enter atomic_number
    ATOMICNUM=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number='$1'")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number='$1' OR symbol='$1' OR name='$1'")
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number='$1' OR symbol='$1' OR name='$1'")
  else
    # get atomic_number, symbol and name for the 
    # element enter as an argument if the user enter symbol or name
    ATOMICNUM=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1'")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1' OR name='$1'")
    NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$1' OR name='$1'")
  fi

  if [[ -z $ATOMICNUM || -z $SYMBOL || -z $NAME ]]
  then
    # if the element is not found
    echo "I could not find that element in the database."
  else
    # get type_id from properties
    TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = '$ATOMICNUM'")
    
    # get type from types with type_id
    TYPE=$($PSQL "SELECT type FROM types WHERE type_id = '$TYPE_ID'")
    
    # get atomic_mass, melting_point_celsius and boiling_point_celsius from properties
    MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = '$ATOMICNUM'")
    MELT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = '$ATOMICNUM'")
    BOIL=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = '$ATOMICNUM'")

    # final message! n.n
    echo "The element with atomic number $(echo $ATOMICNUM | sed -r 's/^ *//g') is $(echo $NAME | sed -r 's/^ *//g') ($(echo $SYMBOL | sed -r 's/^ *//g')). It's a $(echo $TYPE | sed -r 's/^ *//g'), with a mass of $(echo $MASS | sed -r 's/^ *//g') amu. $(echo $NAME | sed -r 's/^ *//g') has a melting point of $(echo $MELT | sed -r 's/^ *//g') celsius and a boiling point of $(echo $BOIL | sed -r 's/^ *//g') celsius."

    #Thank you for use my periodic table! By Caballou 🐴
  fi
fi