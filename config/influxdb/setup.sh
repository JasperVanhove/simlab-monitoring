#!/bin/bash

# Load environment variables from the .env file
set -o allexport
source .env
set +o allexport

echo "Starting Setup for influxdb."
docker-compose -f ../../docker-compose.yml up -d influxdb

# Starting installation setup influxDB
echo "Starting installation setup for influxDB..."

docker-compose -f ../../docker-compose.yml exec influxdb influx setup \
  --username ${ADMIN_USERNAME} \
  --password ${ADMIN_PASSWORD} \
  --org ${ORGANIZATION_NAME} \
  --bucket ${BUCKET_NAME} \
  --force

# Check the exit status of the influx setup command
if [ $? -eq 0 ]; then
  echo "InfluxDB setup was successful!"
  org_id_output=$(docker-compose -f ../../docker-compose.yml exec influxdb influx org list)
  echo "Organisation ID: $(echo "$org_id_output" | awk 'NR == 2 {print $1}')"

  echo "Creating API Token for Grafana..."

  auth_create_output=$(docker-compose -f ../../docker-compose.yml exec influxdb influx auth create \
    --org ${ORGANIZATION_NAME} \
    --description "Grafana API Token" \
    --read-buckets)

  grafana_token=$(echo "$auth_create_output" | awk 'NR == 2 {print $5}')
  if [ -n "$grafana_token" ]; then
    echo "Creation Successfull!"
    echo "Grafana API Token: $grafana_token"
  else
    echo "Failed to extract the token from the command output."
    # Handle the error here
  fi

  auth_create_output=$(docker-compose -f ../../docker-compose.yml exec influxdb influx auth create \
    --org ${ORGANIZATION_NAME} \
    --description "Telegraf API Token" \
    --write-buckets \
    --read-buckets)

  telegraf_token=$(echo "$auth_create_output" | awk 'NR == 2 {print $5}')
  if [ -n "$telegraf_token" ]; then
    echo "Creation Successfull!"
    echo "Telegraf API Token: $telegraf_token"
  else
    echo "Failed to extract the token from the command output."
    # Handle the error here
  fi

else
  echo "InfluxDB setup failed. Check the command for errors."
  # You can add more error handling or take appropriate actions here
fi

echo "#################################################"
echo "Setup for influxdb is completed."
echo "Please copy the Organisation ID and Telegraf API Token to the .env file in the telegraf directory."
echo "When you are done, please run the setup.sh script in the main directory."
echo "#################################################"

