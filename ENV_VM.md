# Installation de l'environnement Docker sur Debian

## Préparation du système

Mettre à jour les paquets :

```bash
sudo apt update
sudo apt upgrade -y
```

Installer les outils nécessaires :

```bash
sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    sudo \
    git \
    vim \
    wget
```

---

# Configuration utilisateur sudo

Si l'utilisateur courant n'a pas les droits sudo :

Passer en root :

```bash
su -
```

Ajouter l'utilisateur au groupe sudo :

```bash
usermod -aG sudo $USER
```

Redémarrer la session :

```bash
exit
```

Puis vérifier :

```bash
sudo whoami
```

Résultat attendu :

```text
root
```

---

# Installation de Docker Engine

Ajouter la clé GPG Docker :

```bash
sudo install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/debian/gpg \
| sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

Ajouter le dépôt Docker officiel :

```bash
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/debian \
$(. /etc/os-release && echo $VERSION_CODENAME) stable" \
| sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Installer Docker et les plugins :

```bash
sudo apt update

sudo apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin
```

---

# Ajouter l'utilisateur au groupe Docker

Créer le groupe si nécessaire :

```bash
sudo groupadd docker
```

Ajouter l'utilisateur :

```bash
sudo usermod -aG docker $USER
```

Recharger les groupes :

```bash
newgrp docker
```

Tester :

```bash
docker ps
```

---

# Vérification Docker Compose

Vérifier que Compose V2 est installé :

```bash
docker compose version
```

Résultat attendu :

```text
Docker Compose version v2.x.x
```

---

# Test Docker

Lancer un conteneur de test :

```bash
docker run hello-world
```

---

# Installation de Trivy

Ajouter le dépôt Trivy :

```bash
sudo apt install -y wget gnupg

wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key \
| sudo gpg --dearmor -o /usr/share/keyrings/trivy.gpg
```

Ajouter la source :

```bash
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] \
https://aquasecurity.github.io/trivy-repo/deb \
$(lsb_release -sc) main" \
| sudo tee /etc/apt/sources.list.d/trivy.list
```

Installer Trivy :

```bash
sudo apt update

sudo apt install -y trivy
```

Vérifier :

```bash
trivy --version
```

---

# Installation de Firefox (si absent)

Vérifier :

```bash
firefox --version
```

Si absent :

```bash
sudo apt install -y firefox-esr
```

---

# Vérification finale

```bash
docker --version
docker compose version
trivy --version
firefox --version
```

L'environnement est prêt pour construire et tester le projet Docker.
