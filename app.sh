#!/bin/bash

source ./.env

# Define a function to bring services up
docker-prod() {
    echo "Starting Production services clean..."
    docker compose -f docker-compose-prod.yml down --volumes --rmi all --remove-orphans
    # docker compose -f docker-compose-prod.yml --build --no-cache
    docker compose -f docker-compose-prod.yml up --build -d
    echo "Production services started."
}

docker-dev() {
    echo "Starting Development services..."
    docker compose -f docker-compose-dev.yml down --volumes --rmi all --remove-orphans
    # docker compose -f docker-compose-dev.yml --build --no-cache
    docker compose -f docker-compose-dev.yml up --build -d
    echo "Development started."
}
docker-dev-node() {
    echo "Starting Development services..."
    docker compose -f docker-compose-dev-node.yml down --volumes --rmi all --remove-orphans
    # docker compose -f docker-compose-dev-node.yml --build --no-cache
    docker compose -f docker-compose-dev-node.yml up --build -d
    echo "Development started."
}
docker-remove() {
    echo "Remove all versions and services..."
    docker compose -f docker-compose-dev.yml down --volumes --rmi all --remove-orphans
    docker compose -f docker-compose-dev-node.yml down --volumes --rmi all --remove-orphans
    docker compose -f docker-compose-prod.yml down --volumes --rmi all --remove-orphans
    docker compose -f docker-compose-prod-scale.yml down --volumes --rmi all --remove-orphans
    echo "All data removed"
}

# PM2 
pm2-deploy(){
    echo "Deploying $APP_NAME PM2 Cluster - Nodes"
    npx pm2 start pm2.config.js
    echo "Deployment successful $APP_NAME"
}
pm2-restart(){
    echo "Deploying $APP_NAME PM2 Cluster - Nodes"
    npx pm2 restart $APP_NAME
    echo "Deployment successful $APP_NAME"
}
pm2-kill(){
    echo "Stopping $APP_NAME PM2 Cluster"
    npx pm2 kill
    echo "Successfully stopped $APP_NAME"
}

# Check for the first argument to determine which function to run
case "$1" in
    docker-dev)
        docker-dev
        ;;
    docker-dev-node)
        docker-dev-node
        ;;
    docker-remove)
        docker-remove
        ;;
    docker-prod)
        docker-prod
        ;;

    # PM2
    pm2-deploy)
        pm2-deploy
        ;;
    pm2-restart)
        pm2-restart
        ;;
    pm2-stop)
        pm2-kill
        ;;
    *)
        echo "Invalid Input: '$1'"
        echo "Expected Input for Docker - 'docker-dev' | 'docker-dev-node' | 'docker-remove' | 'docker-clean' | 'docker-prod' | 'docker-prod-up'"
        echo "Expected Input for PM2 - 'pm2-deploy' | 'pm2-restart' | 'pm2-stop'"
        exit 1
        ;;
esac
