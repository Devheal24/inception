*This project has been created as part of the 42 curriculum by mgarnier.*

---
<a id="top"></a>

<h1 align="center"><p style="font-size: 70px;"><span style="color:white">Inception</span></h1>

## <span style="color:white">Summary</span>
- [Description](#description)
- [Architecture](#architecture)
- [Instructions](#instructions)
- [Resources](#resources)
- [AI](#ai)
- [Project description](#project-description)

---

# <span style="color:white">Description</span>

Inception is a 42 school project whose goal is to learn Docker in depth —
containers, networking, volumes, secrets — by designing, building and
securing a small multi-service infrastructure entirely by hand, with no
pre-built service images and no `latest` tag.  
Every service runs in its own container, built from a custom Dockerfile on
a lightweight Alpine base image.

The stack is orchestrated with a single `docker-compose.yml` and made up of
three containers:
- **NGINX**, the only entry point, serving everything over TLS (v1.3 only)
  with a self-signed certificate for `mgarnier.42.fr`.
- **WordPress** with **php-fpm** (no web server bundled in this container),
  bootstrapped and configured on first boot with WP-CLI.
- **MariaDB**, holding the WordPress database, with no web server either.

Containers communicate over a dedicated Docker network, restart
automatically on failure, and are subject to CPU/memory limits. Database
and website data are kept in two named Docker volumes pinned to
`/home/mgarnier/data` on the host, so they survive container recreation.
Credentials (database passwords, WordPress admin password) are handled with
Docker secrets rather than plain environment variables.

<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

## <span style="color:white">Architecture</span>

```text
inception/
|
├── Makefile
├── README.md
├── srcs
│   └── docker-compose.yml
└── TODO.md
```
<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

---

# <span style="color:white">Instructions</span>

Clone the repository, then move into it:

```bash
git clone git@github.com:Devheal24/inception.git
cd inception
```

Before the first `make`, the environment must be set up (`.env` file and
`secrets/` folder) — see [`DEV_DOC.md`](DEV_DOC.md#set-up-the-environment-from-scratch-prerequisites-configuration-files-secrets).

`make` builds and starts the whole stack (equivalent to `make all`).

| Command | What it does |
|---|---|
| `make` / `make all` | Build the images and start the containers |
| `make build` | Build the images without starting the containers |
| `make up` | Build (if needed) and start the containers in the background |
| `make down` | Stop and remove the containers |
| `make stop` | Stop the containers without removing them |
| `make start` | Start previously stopped containers |
| `make restart` | Restart the containers |
| `make logs` | Follow the logs of all containers |
| `make ps` | List the status of the project's containers |
| `make clean` | Alias for `make down` |
| `make fclean` | Remove containers, named volumes and images |
| `make re` | `make fclean` followed by `make all` |

<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

---

# <span style="color:white">Resources</span>

[DOCKER TUTORIAL](https://blog.stephane-robert.info/docs/conteneurisation/)

[TRAINING DOCKER](https://github.com/stephrobert/containers-training/blob/main/README.md)

[ALPINE IMAGE](https://alpinelinux.org/releases/)

[NGINX TUTORIAL](https://blog.stephane-robert.info/docs/services/web/nginx/)

[HADOLINT](https://github.com/hadolint/hadolint)  
lints Dockerfiles for bad practices:  
`docker run --rm -i hadolint/hadolint < path/to/Dockerfile`.

[TRIVY](https://trivy.dev/docs/latest/getting-started/installation/)  
scans built images for known OS/package vulnerabilities:  
`trivy image --severity HIGH,CRITICAL <image>`.

<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

---

# <span style="color:white">AI</span>

**ChatGPT** helps me learn some Docker commands, and how to write a Dockerfile and a docker-compose.

**Claude** helps me write DEV_DOC.md and USER_DOC.md, gathering all the information I found and regrouping it into an organized document.  
He also helped me to regularly test my program and point out errors.

<p align="right" style="font-size: 10px;"><a
href="#top">return Title</a></p>

---

# <span style="color:white">Project description</span>

Docker is a containerization platform: it packages an application with its
dependencies into lightweight, isolated containers that share the host's
kernel instead of needing a full guest OS.

Besides this README, the project also has:  
[`DEV_DOC.md`](DEV_DOC.md) (environment setup and day-to-day
commands),  
[`ENV_DOC.md`](ENV_DOC.md) (tooling installation),  
[`USER_DOC.md`](USER_DOC.md) (using the running stack),  
[`TODO.md`](TODO.md) (learning notes and glossary).

### Virtual Machines vs Docker :
A virtual machine has its own OS, whereas containers share the host's kernel, which makes them much lighter.  
Its security is handled through namespaces and cgroups.  
What is it?  
<details>
<summary>Namespaces</summary>
Namespaces are isolation tools that partition specific system resources for each application or process.

Here is the list of namespaces and their functions:

- **PID Namespace** 	(Process isolation)  
- **Network Namespace** (Network isolation)  
- **Mount Namespace** 	(Filesystem isolation)  
- **UTS Namespace** 	(Hostname isolation)  
- **IPC Namespace** 	(Inter-process communication isolation)  
- **User Namespace** 	(Permission isolation)
</details>

<details>
<summary>Cgroups</summary>
Cgroups are tools that limit and account for resource usage.

- CPU power
- Memory size
- Disk I/O
- Number of processes (PIDs)
</details>

### Secrets vs Environment Variables :
Environment variables are visible to anyone who can inspect the container: `docker inspect`, `docker exec ... env`, or the process's own `/proc/<pid>/environ` all expose them in plain text, and they can end up logged or leaked to child processes.  
Docker secrets are mounted as files (by default under `/run/secrets/<secret_name>`) only inside the containers that request them, and are never stored in the image, in `docker inspect` output, or in `docker exec ... env`. Note: this project runs plain `docker compose` (no Swarm), so the secret files are mounted read-only as-is rather than encrypted at rest/in transit — that extra guarantee only applies to true Swarm-mode secrets (encrypted Raft store, replicated across manager nodes).  
That is why credentials such as database and WordPress admin passwords are passed to the containers as secrets rather than as environment variables in this project.

### Docker Network vs Host Network :
Docker Network allows multiple containers to connect to each other and to the outside world.  
Docker automatically creates networks, so containers can communicate in isolation or be connected together depending on the purpose.  
Host Network is a default network created by Docker; it creates a direct link between the host and the container.

### Docker Volumes vs Bind Mounts :
There are 3 different types of Docker Volumes, each with its own characteristics:  
<details>
<summary>Standard volume</summary>

This one is created with the command: <code>docker volume create volume_name</code>.  
Data persists even if the container is removed.  
To remove this volume: `docker volume rm volume_name`.  
To remove unused volumes: `docker volume prune`.  
It is possible to create a local NFS volume to share data between different containers; here is the corresponding command:  
<pre>docker volume create \
  --driver local \
  --opt type=nfs \
  --opt o=addr=127.0.0.1,nolock,soft,rw \
  --opt device=:/path/nfs \
  my_nfs_volume</pre>
</details>
<details>
<summary>Bind mount</summary>

This one first requires creating a local (host) folder.  
Then launch the container with the command: <code>docker run -it --rm -v $(pwd)/folder_name:/app/data alpine sh</code>.  
The two folders are linked together, making it possible to share files between the host and the container through them.
</details>
<details>
<summary>tmpfs</summary>

This one is created when the container runs, via the command: <code>docker run -it --rm --tmpfs /folder_name:rw,size=64m alpine sh</code>.  
It is an internal container volume, stored in RAM only, and it is destroyed at the same time as the container.
</details>

<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

---
