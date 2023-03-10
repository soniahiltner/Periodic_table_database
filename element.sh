#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t --no-align  --tuples-only -c"

NOT_FOUND='I could not find that element in the database.'

GET_INFO(){
  if [[ $1 ]]
  then
    echo $1 | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  else
    echo $NOT_FOUND
  fi
}

# if argument
if [[ $1 ]]
then
# if  a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    # get info
    INFO_BY_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, types.type FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE atomic_number = $1")
    GET_INFO $INFO_BY_ATOMIC_NUMBER

  #if  a symbol   
  elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
  then
    INFO_BY_SYMBOL=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, types.type FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE symbol = '$1'")
    GET_INFO $INFO_BY_SYMBOL

  # if  a name
  elif [[ $1 =~ ^[A-Z][a-z]{2,}$ ]]
  then
    INFO_BY_NAME=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, types.type FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE name = '$1'")
    GET_INFO $INFO_BY_NAME
  
  # if not in the database
  else
    echo $NOT_FOUND
  fi

# if no arguments
else
  echo  "Please provide an element as an argument."
fi

