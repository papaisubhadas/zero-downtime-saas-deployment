#!/bin/bash

set -e

APP_DIR=~/zero-downtime-saas-deployment
STATE_FILE=~/active_env
LOG_FILE=~/deploy.log

echo "===== DEPLOYMENT STARTED =====" >> $LOG_FILE
date >> $LOG_FILE

# Default to blue if state file missing
if [ ! -f "$STATE_FILE" ]; then
    echo "blue" > $STATE_FILE
fi

ACTIVE_ENV=$(cat $STATE_FILE)

if [ "$ACTIVE_ENV" == "blue" ]; then
    NEW_ENV="green"
    NEW_PORT=8082
    OLD_ENV="blue"
    OLD_PORT=8081
else
    NEW_ENV="blue"
    NEW_PORT=8081
    OLD_ENV="green"
    OLD_PORT=8082
fi

echo "Active: $ACTIVE_ENV" >> $LOG_FILE
echo "Deploying to: $NEW_ENV" >> $LOG_FILE

cd $APP_DIR

# Remove old container if exists
docker rm -f ${NEW_ENV}-app 2>/dev/null || true

# Build image
docker build -t saas-app:latest ./app

# Run new container
docker run -d -p ${NEW_PORT}:80 --name ${NEW_ENV}-app saas-app:latest

# Wait before health check
sleep 5

# 🔴 TEMP: Force failure for rollback testing
if curl -f http://localhost:${NEW_PORT}/fail; then
    echo "Health check passed" >> $LOG_FILE

    # Switch traffic
    sudo sed -i "s/${OLD_PORT}/${NEW_PORT}/g" /etc/nginx/sites-available/saas-app
    sudo systemctl reload nginx

    echo $NEW_ENV > $STATE_FILE

    echo "Traffic switched to $NEW_ENV" >> $LOG_FILE
    echo "===== DEPLOYMENT SUCCESS =====" >> $LOG_FILE

else
    echo "Health check FAILED" >> $LOG_FILE

    # Ensure old container running
    if ! docker ps | grep -q ${OLD_ENV}-app; then
        docker start ${OLD_ENV}-app
    fi

    # Rollback NGINX
    sudo sed -i "s/${NEW_PORT}/${OLD_PORT}/g" /etc/nginx/sites-available/saas-app
    sudo systemctl reload nginx

    # Remove failed container
    docker rm -f ${NEW_ENV}-app

    echo "Rollback completed. Traffic restored to $OLD_ENV" >> $LOG_FILE
    echo "===== DEPLOYMENT FAILED =====" >> $LOG_FILE

    exit 1
fi