# TODO

## Notions à apprendre

### Qu'est ce que ?
- une image Docker ?  
C'est comme une classe qui définit la structure mais ne s'exécute pas elle-même (read-only).  
Elle contient un système de fichiers de base (OS minimal),  
des dépendances et bibliothèques,  
le code de l'application,  
les variables d'environnement,  
la commande de démarrage.

- layers  
Une image utilise un système de couches = layers.  
Layer 1 = image de base,  
Layer 2 = cache apt,  
Layer 3 = nginx installé,  
Layer 4 = fichiers d'application.  
Avantages = partage, cache, téléchargements, immutabilité.

- un conteneur ?  
C'est une instance éphémère d'une image en cours d'exécution.  
Il contient son propre système de fichiers (copie de l'image + layer d'écriture),  
son espace réseau,  
son arborescence de processus (PID),  
son hostname.

- cycle de vie d'un conteneur  
`docker create` = created,  
`docker start` = running,  
`docker run` = running (create + start),  
`docker pause` = paused (SIGSTOP),  
`docker unpause` = unpaused,  
`docker stop` = arrêter proprement (SIGTERM puis SIGKILL après 10s),  
`docker kill` = arrêter immédiatement (SIGKILL),  
`docker restart` = running->arrêter->running,  
`docker rm` = deleted.

- un docker compose ?

comment daemons fonctionne et pourquoi c'est une bonne ou mauvaise idée de les utiliser ?

- PID 1:  
Processus principal d'un conteneur qui reçoit les signaux (SIGTERM, SIGKILL),  
doit gérer les processus orphelins (reaping),  
Sa propre mort = arrêt du conteneur.

- bonnes pratiques pour les dockerfiles.

- NGINX, protocoles TLSv1.2 et TLSv1.3

- php-fpm

- MariaDB

- latest tag

- docker secrets

- credentials, API keys

- pourquoi le port 443

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
