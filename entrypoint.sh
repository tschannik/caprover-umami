#!/bin/sh
export PGPASSWORD=${POSTGRES_PASSWORD} 


log_and_die() {
    echo "Connection to postgres timed out"
    exit 1
}

# Wait for the database to be ready for connections (up to 60 seconds)
chmod +x ./wait-for-it.sh
sh ./wait-for-it.sh $POSTGRES_HOSTNAME:5432 -t 30 || log_and_die

QUERY_RESULT=$(psql \
  -h $POSTGRES_HOSTNAME \
  -U $POSTGRES_USER \
  -p 5432 \
  -d $POSTGRES_DB \
  -t \
  -c "SELECT * FROM migrations WHERE name='initial'")

if [ $? -ne 0 ] || [ -z "$QUERY_RESULT" ]
then
  echo "Initial migration not found"
  psql -h $POSTGRES_HOSTNAME -U $POSTGRES_USER -p 5432 -d $POSTGRES_DB -f database-setup.sql
else
  echo "Initial migration exists"
fi

yarn start