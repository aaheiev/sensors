#!/bin/bash
set -e

# Check that GRAFANA_PASS is set
if [ -z "${GRAFANA_DB_PASS_FILE}" ]; then
  echo "Environment variable GRAFANA_DB_PASS_FILE is not set."
  exit 1
fi


GRAFANA_PASS=$(cat $GRAFANA_DB_PASS_FILE)


if ! psql -U "$POSTGRES_USER" -tAc "SELECT 1 FROM pg_roles WHERE rolname='grafana'" | grep -q 1; then
  echo "Creating user 'grafana'"
  createuser -U "$POSTGRES_USER" grafana
  psql -U "$POSTGRES_USER" -c "ALTER USER grafana WITH PASSWORD '${GRAFANA_PASS}';"
fi

if ! psql -U "$POSTGRES_USER" -tAc "SELECT 1 FROM pg_database WHERE datname='grafana'" | grep -q 1; then
  echo "Creating database 'grafana'"
  createdb -U "$POSTGRES_USER" -O grafana grafana
fi
