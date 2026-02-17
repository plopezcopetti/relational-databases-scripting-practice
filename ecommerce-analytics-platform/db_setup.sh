#!/bin/bash
DB_NAME=$1
DB_USER=$2

PSQL="psql --username=$DB_USER --dbname=$DB_NAME -t --no-align -c"

# Validating parameters
if [[ -z "$DB_NAME" || -z "$DB_USER" ]]
then
  echo "Usage: ./db_setup.sh <db_name> <db_user>"
  exit 1
fi

# Recreate database (start clean)
dropdb --username="$DB_USER" --if-exists "$DB_NAME"
createdb --username="$DB_USER" "$DB_NAME"

# Apply schema
psql --username="$DB_USER" --dbname="$DB_NAME" -f ./schema.sql

# Seed suppliers data
for i in {1..50}
do 
  $PSQL "INSERT INTO suppliers(name, country, reliability_score)
         VALUES('Supplier$i', 'USA', ROUND((1 + RANDOM()*4)::numeric, 2));"
done

# Seed customers data for the past 2 years
for i in {1..300}
do
  $PSQL "INSERT INTO customers(name, email, country, registration_date, customer_tier)
         VALUES(
           'Customer$i', 
           'customer$i@example.com', 
           'USA', 
           CURRENT_DATE - ((RANDOM()*730)::int),
           NULL        
         );"
done