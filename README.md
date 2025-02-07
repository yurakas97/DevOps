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
<h2>CI/CD</h2>

at root server

```bash
curl -sSL https://raw.githubusercontent.com/yurakas97/DevOps/main/ci-cd.sh | bash
```

```bash
git add .
git commit -m "message"
git push
```
