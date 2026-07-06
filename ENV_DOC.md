<a id="top"></a>

<h1 align="center"><p style="font-size: 70px;"><span style="color:white">Installing the Docker environment on Debian</span></h1>

## <span style="color:white">Summary</span>
- [System preparation](#system-preparation)
- [Sudo user configuration](#sudo-user-configuration)
- [Installing Docker Engine](#installing-docker-engine)
- [Adding the user to the Docker group](#adding-the-user-to-the-docker-group)
- [Link between host and VM](#link-between-host-and-vm)
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

## LINK BETWEEN HOST AND VM

**Objective:**  
Use an SSH key stored on the host machine from within a virtual machine.  
The private key remains exclusively on the host.

### On the host

**1. Retrieve the host's IP address:**
```bash
ifconfig | awk '/inet 10\./ {print $2}'
```

**2. Create a TCP relay on a port between 1024 and 49151:**
```bash
socat TCP-LISTEN:<port>,reuseaddr,fork UNIX-CONNECT:$SSH_AUTH_SOCK
```

**3. ⚠️ Keep this terminal open.**

---

### On the VM

**1. Install `socat` on the virtual machine:**
```bash
sudo apt install socat
```

**2. Remove the old socket (if it exists):**
```bash
rm -f /tmp/ssh-agent.sock
```

**3. Create a local socket that forwards to the host:**
```bash
socat UNIX-LISTEN:/tmp/ssh-agent.sock,fork TCP:<host_IP>:<port>
```

**4. ⚠️ Keep this terminal open.**

**5. Enable the SSH agent in the VM from a new terminal:**
```bash
export SSH_AUTH_SOCK=/tmp/ssh-agent.sock
```

---

## Test the connection

**1. Verify that the VM can see the SSH key:**
```bash
ssh-add -l
```

**2. Test the SSH connection:**
```bash
ssh -T <repository_host>
```

**3. If authentication succeeds:**
```bash
git clone <git_repository>
```

**4. You can stop the `socat` processes on both the host and the VM (the connection will be terminated).**

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
