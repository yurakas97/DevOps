sudo usermod -aG sudo $USER

cd $HOME
echo "Cloning git repo..."
echo "================================================================================================================================="
sleep 2
sudo git clone https://github.com/yurakas97/test.git

cd test
sudo apt install npm

echo "checking node and npm"

sleep 2
npm -v
node -v
sleep 5

echo "instaling nvm"
echo "================================================================================================================================="

sleep 2
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
source ~/.bashrc

echo "checking nvm"
echo "================================================================================================================================="
sleep 2
command -v nvm
sleep 5

echo "updating versions"
echo "================================================================================================================================="

sleep 2
nvm install 18
nvm use 18

echo "new version node"
echo "================================================================================================================================="
node -v
sleep 4

sudo apt update
sudo apt install nginx -y
sleep 5

echo "setting up backend..."
echo "================================================================================================================================="
sleep 2
cd backend
npm install

cd ..

sudo usermod -aG docker $USER

echo "docker copmope build..."
echo "================================================================================================================================="
sleep 3
sudo docker compose up -d --build

sudo chmod -R 755 /home/$USER/project/frontend
sudo cp /home/$USER/project/frontend/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html

echo "setting up frontend nginx"
sleep 2
echo "================================================================================================================================="

sudo cp nginx-frontend /etc/nginx/sites-available/frontend
sudo ln -s /etc/nginx/sites-available/frontend /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx

echo "installing certbot..."
echo "================================================================================================================================="
sleep 3

sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d yurakas97.xyz

echo "checking nginx configuration"
sleep 2
sudo systemctl restart nginx

echo "Done"
sleep 2

echo "use - https://yurakas97.xyz - to access the frontend page"

