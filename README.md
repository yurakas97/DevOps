# DevOps

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
