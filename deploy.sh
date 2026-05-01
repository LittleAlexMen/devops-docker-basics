#!/bin/bash

IMAGE_NAME="devops/nginx-server"
CONTAINER_NAME="nginx-cont"
HOST_PORT=54321
CONTAINER_PORT=80

echo "Stopping and removing old container..."
docker stop $CONTAINER_NAME 2>/dev/null
docker rm $CONTAINER_NAME 2>/dev/null

echo "Building image $IMAGE_NAME..."
docker build -t $IMAGE_NAME ./nginx

echo "Starting new container..."
docker run -d \
    --name $CONTAINER_NAME \
    --restart unless-stopped \
    -p $HOST_PORT:$CONTAINER_PORT \
    $IMAGE_NAME

echo "Container started. Checking status..."
docker ps -a --filter "name=$CONTAINER_NAME"

echo "Testing webpage:"
sleep 2
curl -s http://localhost:$HOST_PORT | head -5

echo "Last 10 log lines:"
docker logs --tail 10 $CONTAINER_NAME
