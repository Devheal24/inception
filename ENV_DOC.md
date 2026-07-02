<a id="top"></a>

<h1 align="center"><p style="font-size: 70px;"><span style="color:white">Installing the Docker environment on Debian</span></h1>

## <span style="color:white">Summary</span>
- [System preparation](#system-preparation)
- [Sudo user configuration](#sudo-user-configuration)
- [Installing Docker Engine](#installing-docker-engine)
- [Adding the user to the Docker group](#adding-the-user-to-the-docker-group)
- [Docker Compose verification](#docker-compose-verification)
- [Docker test](#docker-test)
- [Installing Trivy](#installing-trivy)
- [Installing Firefox (if missing)](#installing-firefox-if-missing)
- [Final verification](#final-verification)

---

# <span style="color:white">System preparation</span>

Update the packages:

```bash
sudo apt update
sudo apt upgrade -y
```

Install the required tools:

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

<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

---

# <span style="color:white">Sudo user configuration</span>

If the current user doesn't have sudo rights:

Switch to root:

```bash
su -
```

Add the user to the sudo group:

```bash
usermod -aG sudo $USER
```

Refresh the group:

```bash
newgrp sudo
```
Exit the shell:

```bash
exit
```

Then check:

```bash
sudo whoami
```

Expected result:

```text
root
```

If not:

```bash
reboot
```

<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

---

# <span style="color:white">Installing Docker Engine</span>

Add the Docker GPG key:

```bash
sudo install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/debian/gpg \
| sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

Add the official Docker repository:

```bash
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/debian \
$(. /etc/os-release && echo $VERSION_CODENAME) stable" \
| sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Install Docker and its plugins:

```bash
sudo apt update

sudo apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin
```

<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

---

# <span style="color:white">Adding the user to the Docker group</span>

Create the group if necessary:

```bash
sudo groupadd docker
```

Add the user:

```bash
sudo usermod -aG docker $USER
```

Reload the groups:

```bash
newgrp docker
```

Test:

```bash
docker ps
```

<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

---

# <span style="color:white">Docker Compose verification</span>

Check that Compose V2 is installed:

```bash
docker compose version
```

Expected result:

```text
Docker Compose version v2.x.x
```

<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

---

# <span style="color:white">Docker test</span>

Run a test container:

```bash
docker run hello-world
```

<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

---

# <span style="color:white">Installing Trivy</span>

Add the Trivy repository:

```bash
sudo apt install -y wget gnupg

wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key \
| sudo gpg --dearmor -o /usr/share/keyrings/trivy.gpg
```

Add the source:

```bash
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] \
https://aquasecurity.github.io/trivy-repo/deb \
$(lsb_release -sc) main" \
| sudo tee /etc/apt/sources.list.d/trivy.list
```

Install Trivy:

```bash
sudo apt update

sudo apt install -y trivy
```

Check:

```bash
trivy --version
```

<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

---

# <span style="color:white">Installing Firefox (if missing)</span>

Check:

```bash
firefox --version
```

If missing:

```bash
sudo apt install -y firefox-esr
```

<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

---

# <span style="color:white">Final verification</span>

```bash
docker --version
docker compose version
trivy --version
firefox --version
```

The environment is ready to build and test the Docker project.

<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

---
