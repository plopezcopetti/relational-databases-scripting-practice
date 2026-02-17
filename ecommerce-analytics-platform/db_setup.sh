#!/bin/bash
set -e

DB_NAME=$1
DB_USER=$2

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
PSQL="psql -X --username=$DB_USER --dbname=$DB_NAME -v ON_ERROR_STOP=1 -t --no-align -c"
psql -X --username="$DB_USER" --dbname="$DB_NAME" -v ON_ERROR_STOP=1 -f ./schema.sql

# Seed suppliers data
for i in {1..15}
do 
  $PSQL "INSERT INTO suppliers(name, country, reliability_score)
         VALUES('Supplier$i', 'USA', ROUND((1 + RANDOM()*4)::numeric, 2));"
done

# Seed customers data for the past 2 years
for i in {1..75}
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

# Seed products data
for i in {1..100}
do
  SUPPLIER_ID=$($PSQL "SELECT supplier_id FROM suppliers ORDER BY RANDOM() LIMIT 1;")
  CATEGORY=$($PSQL "SELECT (ARRAY['electronics', 'photography', 'home', 'office', 'fashion', 'sports']) [floor(RANDOM()*6 + 1)::int];")

  $PSQL "INSERT INTO products(name, category, price, stock_quantity, supplier_id)
         VALUES(
          'Product$i',
          '$CATEGORY',
          ROUND((RANDOM()*450 + 5)::numeric, 2),
          (RANDOM()*500)::int,
          $SUPPLIER_ID
         );"
done
