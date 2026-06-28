# TODO

## Summary
- [Notions](#notions-à-apprendre)
- [Commands](#commands)
- [A faire](#a-faire)

## Notions à apprendre

### Qu'est ce que ?
- une image Docker ?  
C'est un modèle immutable(read-only) utilisé pour créer des conteneurs.  
Comme une classe qui définit la structure mais ne s'exécute pas elle-même.  
Elle contient un système de fichiers de base (OS minimal),  
des dépendances et bibliothèques,  
le code de l'application,  
les variables d'environnement,  
la commande de démarrage.

- layers  
Une image utilise un système de couches = layers.  
Un layer correspond à chaque instruction (RUN, COPY, ADD, etc) du Dockerfile.  
Exemple:  
<code>FROM debian:bookworm  
RUN apt update && apt install -y nginx  
COPY ./website /usr/share/nginx/html  
CMD ["nginx", "-g", "daemon off;"]</code>  
Layer 1 = Debian  
Layer 2 = installation de nginx  
Layer 3 = copie du site  
Layer 4 = métadonnées (CMD...)  
Avantages = partage, cache, téléchargements, immutabilité, reconstruction rapide.

- un conteneur ?  
C'est une instance éphémère d'une image en cours d'exécution.  
Il contient son propre système de fichiers (système de fichiers basé sur l'image + une couche d'écriture (writable layer)),  
son espace réseau,  
son arborescence de processus (PID),  
son hostname.

- cycle de vie d'un conteneur  
`docker create` = created,  
`docker start` = running,  
`docker run` = running (create + start),  
`docker pause` = suspend l'exécution des processus,  
`docker unpause` = unpaused,  
`docker stop` = arrêter proprement (SIGTERM puis SIGKILL après 10s),  
`docker kill` = arrêter immédiatement (SIGKILL),  
`docker restart` = running->arrêter->running,  
`docker rm` = deleted.

- un docker compose ?  
C'est un fichier .yml (YAML) qui permet de définir et gérer des applications multi-conteneurs.  
Il contient toutes les ressources nécessaire au bon fonctionnement de la structure tel que:  
Les services, les réseaux, les volumes, les secrets, les commandes et les variables d'environnement.  
Il définit le cycle de vie (démarrage/arrêt/rebuild).

- YAML  
YAML Ain't Markup Language = format de sérialisation de données de type `.yml` privilégiant la lisibilité humaine.

- un Dockerfile ?  
C'est un fichier texte contenant les instructions pour construire une image `Docker` de manière reproductible.  
<u>Bonnes pratiques</u>:  
Utiliser des images de base officielles et légères (Alpine/Debian)  
Créer un fichier `.dockerignore` (nodes_modules,.git)  
Minimiser les couches : regrouper les RUN  
Multi-stages build : images finales plus petites  
Ne pas exécuter en root : `USER node`
Combiner apt update && apt install dans le même RUN
Supprimer les caches inutiles
Épingler les versions lorsque c'est pertinent

- daemons Docker ?  
Le daemon Docker est le coeur du système.  
Ecoute sur le socket Unix `/var/run/docker.sock`.  
Gère les images, conteneurs, réseaux et volumes.  
S'exécute en `root` par défault (attention sécurité)  
Communique avec `containerd` pour l'exécution.

- PID 1:  
Processus principal d'un conteneur qui reçoit les signaux (SIGTERM, SIGKILL),  
doit gérer les processus orphelins (reaping).  
Si pas gérer correctement, le conteneur peut ne pas s'arrêter proprement.
Sa propre mort = arrêt du conteneur.

- bonnes pratiques pour les dockerfiles.  
✅ Partition dédiée pour /var/lib/docker  
✅ Rotation des logs configurée  
✅ Utilisateurs non-root dans les conteneurs  
n'ajouter au groupe `docker` que les utilisateurs de confiance, ou utiliser le mode `rootless`.  
✅ Ressources limitées (CPU/RAM)  
✅ Images officielles et régulièrement mises à jour  
✅ Health checks sur tous les services  
✅ Monitoring actif (Prometheus, Grafana)  
✅ Backups automatisés des volumes  

- NGINX, protocoles TLSv1.2 et TLSv1.3

- php-fpm

- MariaDB

- latest tag

- docker secrets

- credentials, API keys

- pourquoi le port 443

## Commands

### **DOCKER**

- `docker version`: display the Docker client and server versions.
- `docker info`: display detailed information about the Docker daemon.
- `docker images`: list all local images.
- `docker image ls`: list all local images.
- `docker image inspect <image>`: display detailed information about an image.
- `docker image rm <image>`: remove an image.
- `docker pull <image>`: download an image from a registry.
- `docker push <image>`: push an image to a registry.

- `docker ps`: list running containers. `-a` = all containers.
- `docker inspect <container>`: display detailed information about a container.
- `docker logs <container>`: display container logs. `-f` = follow logs in real time.
- `docker exec -it <container> <command>`: execute a command inside a running container.
- `docker run -d -p <host_port:container_port> <image>`: create and start a container. `-d` = detached mode (background), `-p` = port mapping.
- `docker start <container>`: start a stopped container.
- `docker stop <container>`: stop a running container.
- `docker restart <container>`: restart a container.
- `docker kill <container>`: force stop a container.
- `docker rm <container>`: remove a stopped container. `$(docker ps -aq)` = remove all containers.

- `docker build -t <image>:<tag> .`: build an image from a Dockerfile.
- `docker builder prune`: remove unused build cache.

- `docker volume ls`: list all volumes.
- `docker volume inspect <volume>`: display detailed information about a volume.
- `docker volume rm <volume>`: remove an unused volume.
- `docker volume prune`: remove all unused volumes.

- `docker system df`: display Docker disk usage.
- `docker system prune`: remove unused containers, networks and dangling images.
- `docker system prune -a`: remove all unused images, containers, networks and build cache.

---

### **DOCKER COMPOSE**

- `docker compose up`: create and start services.
- `docker compose up -d`: start services in detached mode.
- `docker compose down`: stop and remove services.
- `docker compose down -v`: also remove associated volumes.
- `docker compose build`: build or rebuild services.
- `docker compose build --no-cache`: rebuild images without using cache.
- `docker compose ps`: list running services.
- `docker compose logs`: display logs for all services. `-f` = follow logs.
- `docker compose exec <service> <command>`: execute a command inside a running service.
- `docker compose restart`: restart all services.
- `docker compose stop`: stop services without removing them.
- `docker compose start`: start previously stopped services.
- `docker compose config`: validate and display the merged Compose configuration.

---

### **DOCKER NETWORK**

- `docker network ls`: list all available networks.
- `docker network create <network>`: create a custom network.
- `docker network inspect <network>`: display detailed information about a network.
- `docker network connect <network> <container>`: connect a container to a network.
- `docker network disconnect <network> <container>`: disconnect a container from a network.
- `docker network rm <network>`: remove a network.
- `docker network prune`: remove all unused networks.

---

### **SECURITY TESTS**

- `trivy image --severity HIGH,CRITICAL <image>`: scan an image for high and critical vulnerabilities.
- `trivy fs .`: scan the current directory for vulnerabilities and secrets.
- `docker scout quickview <image>`: display a quick security overview of an image.
- `docker scout cves <image>`: list known vulnerabilities (CVEs) found in an image.
- `docker bench security`: run Docker security best-practice checks.


## A faire

créer une machine virtuelle sous Debian

• Un conteneur Docker contenant NGINX avec TLSv1.2 ou TLSv1.3 uniquement.

• Un conteneur Docker contenant WordPress et php-fpm (qui doit être installé et configuré), sans NGINX.

• Un conteneur Docker contenant MariaDB, sans NGINX.

• Un volume contenant votre base de données WordPress.

• Un second volume contenant les fichiers de votre site web WordPress.

• Vous devez utiliser des volumes nommés Docker pour ces deux espaces de stockage persistants. Les montages de type « bind » ne sont pas autorisés pour ces volumes.

• Les deux volumes nommés doivent stocker leurs données dans le répertoire `/home/login/data` sur la machine hôte. Remplacez « login » par le nom d’utilisateur de l’apprenant.

• Un conteneur docker-network qui établit la connexion entre vos conteneurs.

Vos conteneurs doivent redémarrer en cas de panne.

Boucles infinis interdites.

2 utilisateurs dans la database de WordPress

configurer le nom du domaine qu'il pointe vers mon adresse locale (mgarnier.42.fr) et le stocker dans le .env.

latest tag interdit.

utiliser environement variables + stocker dans un .env.

les credentials, API keys et password doivent etre sauvegardé localement et ignoré par git.

documenter les *.md
