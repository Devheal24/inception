<a id="top"></a>

<h1 align="center"><p style="font-size: 70px;"><span style="color:white">Developer Documentation</span></h1>

## <span style="color:white">Summary</span>
- [Set up the environment from scratch (prerequisites, configuration files, secrets)](#set-up-the-environment-from-scratch-prerequisites-configuration-files-secrets)
- [Build and launch the project using the Makefile and Docker Compose](#build-and-launch-the-project-using-the-makefile-and-docker-compose)
- [Use relevant commands to manage the containers and volumes](#use-relevant-commands-to-manage-the-containers-and-volumes)
- [Identify where the project data is stored and how it persists](#identify-where-the-project-data-is-stored-and-how-it-persists)

---

# <span style="color:white">Set up the environment from scratch (prerequisites, configuration files, secrets)</span>

### Prerequisites

This project is meant to be built and run on a Debian machine (virtual or
physical, local or remote) with Docker Engine, the Docker Compose v2 plugin,
and (optionally) Trivy for image scanning.  
See [`ENV_DOC.md`](ENV_DOC.md) for the full step-by-step environment setup.

### Configuration files

Non-secret configuration lives in `srcs/.env`, tracked by git (it holds no
password, so there is nothing sensitive to keep out of the repository).
It already has real, working default values — nothing to copy or
generate before the first `make up`.

It defines things like `MYSQL_DATABASE`/`MYSQL_USER`, `DOMAIN_NAME`,
`WP_TITLE`, `WP_ADMIN`/`WP_ADMIN_EMAIL`, `WP_USER`/`WP_USER_EMAIL`. It
intentionally does **not** hold any password — each password-shaped line
is commented out, pointing to the `secrets/*.txt` file that actually
provides that value (see [Secrets](#secrets) below).

The base Alpine image is **not** in `.env`: it is hardcoded, pinned to a
specific tested digest, directly in `srcs/docker-compose.yml`'s six
`build.args` (one per service: nginx, wordpress, mariadb, adminer, redis,
static_webpage).  
This is deliberate — even though `.env` is tracked here, its
purpose is per-deployment config (domain name, WordPress titles/usernames),
not a fixed build constant; putting the Alpine digest in the tracked
compose file guarantees every developer and the grader build from the
exact same, tested base image regardless of `.env`.  
Every Dockerfile in this project uses `apk` and other Alpine-specific tooling, so pointing it
at a different distro (e.g. Debian) or even a different Alpine tag/digest
would break the build — don't edit those six lines in `docker-compose.yml`.

### Secrets

Passwords are kept out of `.env` and out of the container's environment
variables entirely, using Docker secrets. Each of the following files must
be created locally under `secrets/` (one password per file, no trailing
content) before the first `make up` — none of them are provided by the
repository:

| File | Used for |
|---|---|
| `secrets/db_password.txt` | MariaDB `wpuser` password |
| `secrets/db_root_password.txt` | MariaDB root password |
| `secrets/wp_admin_password.txt` | WordPress admin (`WP_ADMIN`) password |
| `secrets/wp_user_password.txt` | WordPress second, non-admin user (`WP_USER`) password |

Create the folder and the (empty) files with:
```sh
mkdir -p secrets && touch secrets/db_password.txt secrets/db_root_password.txt secrets/wp_admin_password.txt secrets/wp_user_password.txt
```
Then fill each file with its password (one line, no trailing newline needed).

They are referenced in `srcs/docker-compose.yml`'s top-level `secrets:`
block and mounted read-only inside the containers at `/run/secrets/<name>`,
where the setup scripts (`mariadb/tools/setup.sh`,
`wordpress/tools/setup.sh`) read them.

### Host data directories

The three named volumes (see below) are pinned to
`/home/mgarnier/data/mariadb`, `/home/mgarnier/data/wordpress` and
`/home/mgarnier/data/backup` on the host. These directories must exist
**and** be owned by the same UID/GID as each container's non-root
`appuser` before the first start, otherwise the container will get
permission errors writing to its volume:

```bash
mkdir -p /home/mgarnier/data/mariadb /home/mgarnier/data/wordpress /home/mgarnier/data/backup
# match each image's appuser uid:gid, check with: docker compose exec <service> id
```

(`backup` is the exception: it runs as root — see [Resources > BONUS](README.md#bonus-in-srcsrequirementsbonus) in the README for why — so its data directory's ownership doesn't matter.)

<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

---

# <span style="color:white">Build and launch the project using the Makefile and Docker Compose</span>

Docker Compose is a YAML file (`.yml`) used to define and manage
multi-container applications. It gathers everything the stack needs to
work: services, networks, volumes, secrets, commands and environment
variables, and it drives the container lifecycle (start / stop / rebuild).

In this project, the compose file lives at `srcs/docker-compose.yml` and is
driven through the root `Makefile`, so that everything can be built and
started with a single command from the repository root:

```bash
make        # equivalent to: make all -> build images and start containers
```

Under the hood, `make` wraps these Docker/Docker Compose commands:

- `docker build -t <image>:<tag> .`: build a single image from a Dockerfile.
- `docker compose build`: build or rebuild all the services' images.
- `docker compose build --no-cache`: rebuild images without using the build cache.
- `docker compose up`: create and start the services.
- `docker compose up -d`: start the services in detached mode (background).

See the [Instructions](README.md#instructions) section of the README for
the full list of available `make` targets (`up`, `down`, `stop`, `start`,
`restart`, `logs`, `ps`, `clean`, `fclean`, `re`).

### About `image:` in `docker-compose.yml`

Each service (`nginx`, `wordpress`, `mariadb`, `adminer`, `redis`,
`static_webpage`) sets both `image: <service-name>` and its own `build:`
context.  
When a service defines `build:`, Compose never pulls `image:` from a registry — it always builds from the local Dockerfile and simply tags the result with that name.  
`image:` here is only a label for the locally built image, not a Docker Hub reference, so this doesn't violate the "no pre-built images" rule.  
This can be checked directly: `docker history nginx` shows the image's layers coming from the pinned Alpine base and
this project's own `RUN`/`COPY` instructions, with no trace of the official `nginx` image.

<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

---

# <span style="color:white">Use relevant commands to manage the containers and volumes</span>

### Containers

- `docker ps`: list running containers (`-a` = all containers, including stopped ones).
- `docker inspect <container>`: display detailed information about a container.
- `docker logs <container>` (`-f` = follow logs in real time).
- `docker exec -it <container> <command>`: run a command inside a running container.
- `docker start <container>` / `docker stop <container>` / `docker restart <container>`.
- `docker kill <container>`: force stop a container.
- `docker rm <container>`: remove a stopped container.

Equivalent commands scoped to this project's stack, via Docker Compose:

- `docker compose ps`: list the project's services and their status.
- `docker compose logs` (`-f` = follow logs of all services).
- `docker compose exec <service> <command>`: run a command inside a running service.
- `docker compose restart` / `docker compose stop` / `docker compose start`.
- `docker compose config`: validate and display the fully merged Compose configuration.

### Volumes

- `docker volume ls`: list all volumes.
- `docker volume inspect <volume>`: display detailed information about a volume (including where its data actually lives on the host).
- `docker volume rm <volume>`: remove an unused volume.
- `docker volume prune`: remove all unused volumes.

<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

---

# <span style="color:white">Identify where the project data is stored and how it persists</span>

A container's filesystem is made of the image's read-only layers plus a
thin writable layer on top. That writable layer is tied to the container's
lifecycle: once the container is removed (`docker rm`), everything written
to it is lost. A Dockerfile's `VOLUME` instruction marks a directory that
should instead be mounted from outside the container, so its data survives
even after the container is removed.

This project uses three **named** Docker volumes (not bind mounts) for that
purpose, declared in `srcs/docker-compose.yml`:

| Volume | Mounted in container at | Backed by (host path) |
|---|---|---|
| `mariadb_data` | `/var/lib/mysql` (mariadb) | `/home/mgarnier/data/mariadb` |
| `wordpress_data` | `/var/www/html` (wordpress) | `/home/mgarnier/data/wordpress` |
| `backup_data` | `/backups` (backup) | `/home/mgarnier/data/backup` |

All three volumes are configured with `driver: local` and `driver_opts`
(`type: none`, `o: bind`, `device: <host path>`), which pins their data to
a fixed location under `/home/mgarnier/data` on the host, while still being
managed as proper named volumes by Docker (as required by the subject for
`mariadb_data`/`wordpress_data` — raw bind mounts are not allowed for
those two; `backup_data` follows the same pattern for consistency, though
it isn't itself a subject requirement). Their actual location can always
be checked with `docker volume inspect <volume-name>`.

<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

---
