# DevOps

<h2>Environment</h2>

if root:
```bash
sudo adduser newusername
sudo usermod -aG sudo newusername
su - newusername
```

if user:
```bash
sudo usermod -aG sudo newusername
```

run:
```bash
curl -sSL https://raw.githubusercontent.com/yurakas97/DevOps/main/install_devops_tools.sh | bash
```

<h2>Assemble</h2>

```bash
curl -sSL https://raw.githubusercontent.com/yurakas97/DevOps/main/assemble.sh | bash
```
<h2>Assemble</h2>

```bash
mkdir -p .github/workflows
```

```bash
nano .github/workflows/deploy.yml
```

```bash
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
```

