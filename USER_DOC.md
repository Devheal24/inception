<a id="top"></a>

<h1 align="center"><p style="font-size: 70px;"><span style="color:white">User Documentation</span></h1>

## <span style="color:white">Summary</span>
- [Understand what services are provided by the stack](#understand-what-services-are-provided-by-the-stack)
- [Start and stop the project](#start-and-stop-the-project)
- [Access the website and the administration panel](#access-the-website-and-the-administration-panel)
- [Locate and manage credentials](#locate-and-manage-credentials)
- [Check that the services are running correctly](#check-that-the-services-are-running-correctly)

---

# <span style="color:white">Understand what services are provided by the stack</span>

The stack is made of seven containers: three mandatory ones and four bonus
ones.

Mandatory:
- **NGINX** is the only entry point to the stack. It is a web server / reverse
  proxy that serves everything over TLS (v1.3 only) on port 443, using a
  self-signed certificate for `mgarnier.42.fr`. It serves static files
  directly and forwards `.php` requests to WordPress.
- **WordPress + php-fpm**: WordPress is the CMS/blogging software that
  powers the site; `php-fpm` (PHP FastCGI Process Manager) is the process
  that actually executes WordPress's PHP code and talks to NGINX over the
  internal Docker network (port 9000) — there is no web server in this
  container, NGINX is the only one exposed to the outside.
- **MariaDB** is the relational database engine (a MySQL-compatible fork)
  that stores everything WordPress needs: posts/pages, users, settings.
  Like WordPress, it has no web server in its container and is only
  reachable from other containers on the internal Docker network.

Bonus, none of them publish their own host port:
- **Adminer** is a lightweight database admin GUI, reached through NGINX at
  **https://mgarnier.42.fr/adminer.php** — use it to browse/edit the
  MariaDB database directly.
- **Redis** is an in-memory object cache for WordPress (via the
  `redis-cache` plugin), transparent to visitors — it has no exposed URL.
- **A static webpage**, a second, independent site served through NGINX at
  **https://mgarnier.42.fr/mywebpage/**.
- **Backup** runs a nightly cron job that dumps the MariaDB database and
  archives the WordPress files into `~/data/backup` — it has no exposed
  URL either, it only connects out to `mariadb`.

<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

---

# <span style="color:white">Start and stop the project</span>

From the repository root, the whole stack is managed through the
`Makefile`:

- `make` / `make up`: build (if needed) and start all the containers in the background.
- `make down`: stop and remove the containers.
- `make stop`: stop the containers without removing them.
- `make start`: start containers that were previously stopped (without recreating them).
- `make restart`: restart the containers.

These targets wrap the underlying Docker Compose commands:

- `docker compose up` / `docker compose up -d` (detached/background mode).
- `docker compose down` (`-v` also removes the associated volumes — this
  deletes the WordPress site and its database, use with care).
- `docker compose stop` / `docker compose start` / `docker compose restart`.

<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

---

# <span style="color:white">Access the website and the administration panel</span>

The site is served at **https://mgarnier.42.fr**. For the hostname to
resolve on your machine, it needs an entry in `/etc/hosts` pointing to the
host running the stack:

```
127.0.0.1 mgarnier.42.fr
```

The TLS certificate is self-signed, so the browser will show a security
warning on first visit — this is expected, accept the exception to continue.

The WordPress administration panel is at **https://mgarnier.42.fr/wp-admin**.
Two accounts exist:
- `WP_ADMIN` (administrator role) — full access to the admin panel (themes,
  plugins, users, settings...).
- `WP_USER` (author role) — can write and publish posts, but cannot manage
  the site itself.

Both usernames are set in `srcs/.env`; their passwords are in
`secrets/wp_admin_password.txt` (admin) and `secrets/wp_user_password.txt`
(author) — see [Locate and manage credentials](#locate-and-manage-credentials).

<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

---

# <span style="color:white">Locate and manage credentials</span>

All passwords live in the `secrets/` folder at the project root, one
password per file, and are never stored in `.env` or in a container's
environment variables:

| File | Credential |
|---|---|
| `secrets/db_password.txt` | MariaDB `wpuser` password |
| `secrets/db_root_password.txt` | MariaDB root password |
| `secrets/wp_admin_password.txt` | WordPress admin password |
| `secrets/wp_user_password.txt` | WordPress second (author) user password |

To change a credential: edit the corresponding file (plain text, single
line), then wipe the persisted data and rebuild so the new value is
picked up:

```bash
make purge-data
make all
```

WordPress/MariaDB only set up users and passwords on their *first* run
(checked by looking for an existing data directory), and that data lives
in bind-mounted host directories that survive `make re` (`down -v` only
removes the Docker volume object, not the host files behind it) — so
`make re` alone leaves the old credentials in place.  
`make purge-data` actually deletes the host-side MariaDB/WordPress data, so the next
`make all` bootstraps a fresh install with the new values.  
This is destructive: it loses all site content and database data, not just the
credentials.

`secrets/` is listed in `.gitignore` — these files must stay local and
never be committed.

<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

---

# <span style="color:white">Check that the services are running correctly</span>

- `make ps` (or `docker compose ps`): lists the project's containers and
  their status. A healthy stack shows all seven containers as `Up`, with
  `mariadb`, `wordpress`, `adminer` and `redis` additionally showing
  `(healthy)` once their startup checks pass (`nginx`, `static_webpage`
  and `backup` have no healthcheck defined — `backup` has nothing
  depending on it staying up, so there's nothing to gate).
- `docker ps` (`-a` to include stopped containers) gives the same kind of
  status information at the whole-machine level, not just for this project.
- `make logs` (or `docker compose logs -f`): follow the logs of every
  container in real time — useful to see what a service is doing or why it
  failed to start.
- `docker logs <container>` (`-f` to follow): logs for a single container.

<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

---
