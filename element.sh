#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
EXIT() {
  exit
  }

NO_ARGUMENTS() {
  echo Please provide an element as an argument.
}
NO_ELEMENT() {
  echo I could not find that element in the database.
}

PRINT() {
  echo "The element with atomic number $ATOMIC_VALUE is $NAME_VALUE ($SYMBOL_VALUE). It's a $TYPE, with a mass of $MASS amu. $NAME_VALUE has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
}

if [[ $1 =~ ^[0-9]+$ ]]
  then  
    ATOMIC_VALUE=$($PSQL "SELECT atomic_number FROM elements WHERE '$1' = atomic_number;")
    SYMBOL_VALUE=$($PSQL "SELECT symbol FROM elements WHERE '$1' = atomic_number;")
    NAME_VALUE=$($PSQL "SELECT name FROM elements WHERE '$1' = atomic_number;")
    TYPE=$($PSQL "SELECT type FROM properties JOIN types ON properties.type_id = types.type_id WHERE '$ATOMIC_VALUE'=atomic_number;")
    MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE '$ATOMIC_VALUE'=atomic_number;")
    MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE '$ATOMIC_VALUE'=atomic_number;")
    BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE '$ATOMIC_VALUE'=atomic_number;")
    PRINT
  elif [[ -z $1 ]]
    then
      NO_ARGUMENTS
  else
    SYMBOL_VALUE=$($PSQL "SELECT symbol FROM elements WHERE '$1' = symbol OR '$1' = name;")
    NAME_VALUE=$($PSQL "SELECT name FROM elements WHERE '$1' = name OR '$1' = symbol;")
    ATOMIC_VALUE=$($PSQL "SELECT atomic_number FROM elements WHERE '$1' = symbol or '$1' = name;")
      if [[ -z $SYMBOL_VALUE && -z $NAME_VALUE && -z $ATOMIC_VALUE ]]
        then 
          NO_ELEMENT
        else
          TYPE=$($PSQL "SELECT type FROM properties JOIN types ON properties.type_id = types.type_id WHERE '$ATOMIC_VALUE'=atomic_number;")
          MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE '$ATOMIC_VALUE'=atomic_number;")
          MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE '$ATOMIC_VALUE'=atomic_number;")
          BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE '$ATOMIC_VALUE'=atomic_number;")
          PRINT
      fi
fi


