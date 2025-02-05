sudo usermod -aG sudo $USER

cd $HOME
mkdir project && cd project
sudo apt install npm

echo "checking node and npm"

sleep 2
npm -v
node -v
sleep 5

echo "instaling nvm"

sleep 2
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
source ~/.bashrc

echo "checking nvm"
sleep 2
command -v nvm
sleep 5

echo "updating versions"

sleep 2
nvm install 18
nvm use 18

echo "new version node"
node -v
sleep 5

sudo apt update
sudo apt install nginx -y
sleep 5

echo "creating backend"
mkdir backend && cd backend
npm init -y
npm install express cors dotenv

echo "creating server js"
sleep 2

cat > server.js << 'EOF'
require('dotenv').config();
const express = require('express');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Маршрут API
app.get('/api/message', (req, res) => {
    res.json({ message: "Hello from backend! MUTHERFUCKER!!!!" });
});

// Запуск сервера
app.listen(PORT, () => {
    console.log(`🚀 Server is running on http://localhost:${PORT}`);
});
EOF

echo "creating Dockerfile"
sleep 2

cat > Dockerfile << 'EOF'
# Використовуємо офіційний образ Node.js
FROM node:18

# Встановлюємо робочу директорію
WORKDIR /app

# Копіюємо package.json та встановлюємо залежності
COPY package*.json ./
RUN npm install

# Копіюємо код
COPY . .

# Виставляємо порт
EXPOSE 3000

# Запускаємо сервер
CMD ["node", "server.js"]
EOF

cd ..

echo "creating docker compose"
sleep 2

cat > docker-compose.yml << 'EOF'
services:
  backend:
    build: ./backend
    container_name: backend
    restart: always
    ports:
      - "3000:3000"
EOF

echo "creating frontend"
sleep 3
mkdir frontend && cd frontend

echo "creating index html"
sleep 2

cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Frontend</title>
</head>
<body>
    <h1>Frontend</h1>
    <button id="fetchMessage">Get Message</button>
    <p id="message"></p>

    <script src="script.js"></script>
</body>
</html>
EOF

echo "creating script js"
sleep 2

cat > script.js << 'EOF'
document.getElementById("fetchMessage").addEventListener("click", async () => {
    try {
        const response = await fetch("https://yurakas97.xyz/api/message");
        const data = await response.json();
        document.getElementById("message").innerText = data.message;
    } catch (error) {
        console.error("Error fetching message:", error);
        document.getElementById("message").innerText = "Error fetching data.";
    }
});
EOF

echo "creating nginx"
sleep 2

cat > nginx.conf << 'EOF'
server {
    listen 80;
    server_name localhost;

    location / {
        root /usr/share/nginx/html;
        index index.html;
    }
}
EOF

echo "creating Dockerfile"
sleep 2

cat > Dockerfile << 'EOF'
# Використовуємо офіційний образ Nginx
FROM nginx:latest

# Копіюємо конфігурацію Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Копіюємо файли сайту
COPY . /usr/share/nginx/html

# Виставляємо порт
EXPOSE 80

# Запускаємо Nginx
CMD ["nginx", "-g", "daemon off;"]
EOF


echo "docker copmope build"
sleep 3
sudo docker compose up -d --build

echo "setting up frontend nginx"
sleep 2

sudo tee /etc/nginx/sites-available/frontend << 'EOF'
# Використовуємо офіційний образ Nginx
FROM nginx:latest

# Копіюємо конфігурацію Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Копіюємо файли сайту
COPY . /usr/share/nginx/html

# Виставляємо порт
EXPOSE 80

# Запускаємо Nginx
CMD ["nginx", "-g", "daemon off;"]
EOF

sudo ln -s /etc/nginx/sites-available/frontend /etc/nginx/sites-enabled/

echo "checking nginx configuration"
sleep 2
sudo nginx -t
sudo systemctl restart nginx

echo "installing certbot..."
sleep 3
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d yurakas97.xyz

echo "finishing..."
sleep 3
sudo chown -R www-data:www-data /home/$USER/project/frontend
sudo chmod -R 755 /home/$USER/project/frontend
sudo mv /home/$USER/project/frontend/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html

sudo systemctl restart nginx

echo "Done"
sleep 2

echo "use - https://yurakas97.xyz - to access the frontend page"

