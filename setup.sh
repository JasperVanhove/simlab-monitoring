#!/bin/bash
# Starting monitoring stack
echo "Starting Setup of the monitoring stack."
docker-compose up -d

# Check the status of the containers
echo "Check the status of the containers."
if (docker ps --no-trunc | tail -n +2 | wc -l) | grep -q "4"; then
    echo "All Containers are running."
else
    echo "Some containers are not running."
fi

# Create an Influx DB bucket