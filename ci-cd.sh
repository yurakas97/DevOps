#!/bin/bash

cd /home/$USER/project
mkdir -p .github/workflows

tee .github/workflows/deploy.yml << 'EOF'

name: Deploy to Server

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Deploy to server via SSH
        uses: appleboy/ssh-action@v1.0.3
        with:
          host: ${{ secrets.SERVER_IP }}
          username: ${{ secrets.SSH_USER }}
          key: ${{ secrets.SSH_PRIVATE_KEY }}
          script: |
            cd /home/${{ secrets.SSH_USER }}/project

            echo "Stopping and removing old containers..."
            docker compose down

            echo "Cleaning up old Docker images..."
            docker system prune -af

            echo "Updating project from GitHub..."
            cd ..
            rm project -r
            git clone https://github.com/yurakas97/test.git
            mkdir project
            cp -r test/* project/
            rm test -r
            cd project

            echo "Building and starting new containers.."
            docker compose up -d --build
            
            EOF
