*This project has been created as part of the 42 curriculum by mgarnier.*

---
<a id="top"></a>

<h1 align="center"><p style="font-size: 70px;"><span style="color:white">Inception</span></h1>

## <span style="color:white">Summary</span>
- [Description](#description)
- [Architecture](#architecture)
- [Instructions](#instructions)
- [Resources](#resources)
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
three mandatory containers:
- **NGINX**, the only entry point, serving everything over TLS (v1.3 only)
  with a self-signed certificate for `<login>.42.fr`.
- **WordPress** with **php-fpm** (no web server bundled in this container),
  bootstrapped and configured on first boot with WP-CLI.
- **MariaDB**, holding the WordPress database, with no web server either.

plus four bonus containers, each reachable only over the internal Docker
network (no extra port published on the host):
- **Adminer**, a database admin UI proxied through the main NGINX at
  `/adminer.php`.
- **Redis**, used as WordPress's persistent object cache.
- A **static webpage**, proxied through the main NGINX at `/mywebpage/`.
- **Backup**, a cron job dumping the MariaDB database and archiving the
  WordPress files daily.

Containers communicate over a dedicated Docker network, restart
automatically on failure, and are subject to CPU/memory limits.  
Database, website and backup data are kept in three named Docker volumes
pinned to `/home/<login>/data` on the host, so they survive container
recreation.  
Credentials (database passwords, WordPress admin password) are handled with
Docker secrets rather than plain environment variables.

<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

## <span style="color:white">Architecture</span>

```text
inception/
├── Makefile
├── README.md
├── DEV_DOC.md
├── USER_DOC.md
├── ENV_DOC.md
└── srcs
    ├── docker-compose.yml
    ├── .env
    └── requirements
        ├── nginx
        ├── wordpress
        ├── mariadb
        └── bonus
            ├── adminer
            ├── redis
            ├── static_webpage
            └── backup
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

| Command | What it does |
|---|---|
| `make all` / `make up` | Build the images and start the containers |
| `make clean` / `make down` | Stop and remove the containers |
| `make fclean` | Remove containers, named volumes and images |
| `make re` | `make fclean` followed by `make all` |
| `make build` | Build the images without starting the containers |
| `make start` | Start previously stopped containers |
| `make stop` | Stop the containers without removing them |
| `make restart` | Restart the containers |
| `make` / `make help` | Show the usage help |
| `make logs` | Follow the logs of all containers |
| `make ps` | List the status of the project's containers |
| `make purge-data` | <span style="color:red">**DESTROY** the persisted MariaDB/WordPress data</span> |

<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

---

# <span style="color:white">Resources</span>

### LEARNING

- [DOCKER TUTORIAL](https://blog.stephane-robert.info/docs/conteneurisation/)

- [TRAINING DOCKER](https://github.com/stephrobert/containers-training/blob/main/README.md)

- [ALPINE IMAGE](https://alpinelinux.org/releases/)

- [NGINX TUTORIAL](https://blog.stephane-robert.info/docs/services/web/nginx/)

### SECURITY SCANNERS

- [HADOLINT](https://github.com/hadolint/hadolint)  
lints Dockerfiles for bad practices:  
`docker run --rm -i hadolint/hadolint < path/to/Dockerfile`.

- [TRIVY](https://trivy.dev/docs/latest/getting-started/installation/)  
scans built images for known OS/package vulnerabilities:  
`trivy image --severity HIGH,CRITICAL <image>`.

### BONUS in srcs/requirements/bonus

- [ADMINER](https://www.adminer.org/)  
is a tool for managing content in databases.  
It natively supports MySQL, MariaDB and many others.

- [REDIS](https://redis.io/)  
is an in-memory key-value store, used here as WordPress's persistent
object cache so repeated data (options, transients, translation
files...) is served from memory instead of hitting MariaDB again on
every page load.  
Check it's active and watch it being used:  
`docker exec -it srcs-wordpress-1 sh -c "cd /var/www/html && wp redis <enable or disable>"`  
`time curl -sk https://<localhost or specific_webpage>/ -o /dev/null`

- **BACKUP**  
runs `crond` to dump the MariaDB `wordpress` database and archive the
WordPress files every night, keeping 7 days of backups in a dedicated
`backup_data` volume.  
This is the only container in the project that runs as **root** instead
of a non-root user: busybox's `crond` needs to `setuid`/`setgid` to launch
a job, even when the job's target user is the same as the one already
running `crond` — confirmed by tracing it with `strace`, a non-root
`crond` reads its crontab fine but never actually forks/execs the job.
Root here is low-risk: the container exposes no port and runs no
network-facing service, it only opens an outbound connection to `mariadb`
on a schedule.  
Trigger a backup manually and inspect the result:  
`docker exec srcs-backup-1 /usr/local/bin/backup.sh`  
`docker exec srcs-backup-1 ls -la /backups`  
`docker exec srcs-backup-1 sh -c "zcat /backups/mariadb_*.sql.gz | grep 'CREATE TABLE'"`

### **How AI was used**

- **ChatGPT** helps me learn some Docker commands, and how to write a Dockerfile and a docker-compose.

- **Claude** helps me write DEV_DOC.md and USER_DOC.md, gathering all the information I found and regrouping it into an organized document.  
It also helped me to regularly test my program, point out errors and write my commit.  
For some bonus parts (Redis wiring, nginx config fixes, the backup service's script/crontab), I also asked Claude to write or fix the Dockerfile/docker-compose/nginx.conf code directly, then verified it myself by rebuilding and testing.

<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

---

# <span style="color:white">Project description</span>

Docker is a containerization platform: it packages an application with its
dependencies into lightweight, isolated containers that share the host's
kernel instead of needing a full guest OS.

Besides this README, the project also has:  
[`DEV_DOC.md`](DEV_DOC.md) (environment setup and day-to-day
commands),  
[`ENV_DOC.md`](ENV_DOC.md) (tooling installation),  
[`USER_DOC.md`](USER_DOC.md) (using the running stack).

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

This project's `mariadb_data`/`wordpress_data` are actually a hybrid of the
first two: standard named volumes (managed with `docker volume`) whose
`driver_opts` (`type: none, o: bind, device: <host path>`) point them at a
fixed host directory — combining the named-volume lifecycle with a bind
mount's fixed, known location on disk.  
See [`DEV_DOC.md`](DEV_DOC.md#identify-where-the-project-data-is-stored-and-how-it-persists)
for the actual configuration.

<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

---
