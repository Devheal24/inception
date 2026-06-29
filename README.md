*This project has been created as part of the 42 curriculum by mgarnier.*

<a if="top"></a>

# <h1 align="center"><p style="font-size: 70px;"><span style="color:white">Inception</span></h1>

## <span style="color:white">Summary</span>
- [Description](#description)
- [Architecture](#architecture)
- [Instructions](#instructions)
- [Resources](#resources)
- [AI](#ai)
- [Project description](#project-description)

---

# <span style="color:white">Description</span>

This project is 

<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

## <span style="color:white">Architecture</span>

```text
inception/
|
├── Makefile
├── README.md
├── srcs
│   └── docker-compose.yml
└── TODO.md
```
<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

---

# <span style="color:white">Instructions</span>

`make`

<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

---

# <span style="color:white">Resources</span>

[DOCKER TUTORIAL](https://blog.stephane-robert.info/docs/conteneurisation/)

[TRAINING DOCKER](https://github.com/stephrobert/containers-training/blob/main/README.md)

[ALPINE](https://alpinelinux.org/releases/)

[NGINX](https://hub.docker.com/_/nginx?tag=stable-alpine3.23-perl)

[HADOLINT](https://github.com/hadolint/hadolint)

[TRIVY](https://trivy.dev/docs/latest/getting-started/installation/)

<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

---

# <span style="color:white">AI</span>

<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

# <span style="color:white">Project description</span>

### Virtual Machines vs Docker :
Une machine virtuelle aura son propre OS alors que les conteneurs partagent le Kernel de l'hôte, ce qui leur confère une plus grande légèreté.  
Sa sécurité est gérée via des namespaces et des cgroups.  
What is it ?  
<details>
<summary>Namespaces</summary>
Les namespaces sont des outils d'isolation qui permettent de cloisonner des ressources spécifiques du système pour chaque application ou processus.

Voici la liste des namespaces et leurs fonctions:

- **PID Namespace** 	(Isolation des processus)  
- **Network Namespace** (Isolation réseau)  
- **Mount Namespace** 	(Isation du Système de Fichiers)  
- **UTS Namespace** 	(Isolation du Nom d'Hôte)  
- **IPC Namespace** 	(Isolation de la Communication Inter-Processus)  
- **User Namespace** 	(Isolation des Permissions)
</details>

<details>
<summary>Cgroups</summary>
Les Cgroups sont des outils qui limitent et comptabilisent les ressources.

- puissance CPU
- taille Mémoire
- lecture disque I/O
- nombre de processus (PIDs)
</details>

### Secrets vs Environment Variables :

### Docker Network vs Host Network :
Docker Network allows to connect multiple contener between them and the outside.  
Docker automaticaly create networks, thus conteners can communicate isolated or connected depends of the purpose.  
Host Network is a default network created by Docker, it create a link between the host and the container.

### Docker Volumes vs Bind Mounts :
Il existe 3 différents types de Docker Volume avec chacun ses particularités:  
<details>
<summary>Volume standard</summary>

Celui-ci est créé via la commande: <code>docker volume create `name_of_volume`</code>.  
Les données persistent même si le conteneur est supprimé.  
Pour supprimer ce volume: `docker volume rm nom_du_volume`.  
Pour supprimer les volumes inutilisés: `docker volume prune`.  
Il est possible de créer un volume NFS local pour partager des données entre différents conteneurs, voici la commande correspondante:  
<pre>docker volume create \
  --driver local \
  --opt type=nfs \
  --opt o=addr=127.0.0.1,nolock,soft,rw \
  --opt device=:/path/nfs \
  mon_volume_nfs</pre>
</details>
<details>
<summary>Bind mount</summary>

Celui-ci nécessite au préalable la création d'un dossier local (hôte).  
Puis lancer le conteneur avec la commande: <code>docker run -it --rm -v $(pwd)/nom_du_dossier:/app/data alpine sh</code>.  
Les 2 dossiers sont liés entre eux et il est possible de partager des fichiers entre l'hôte et le conteneur via ces dossiers.
</details>
<details>
<summary>tmpfs</summary>

Celui-ci est créé lors du run du conteneur via la commande: <code>docker run -it --rm --tmpfs /nom_du_dossier:rw,size=64m alpine sh</code>.  
Il s'agit d'un volume en interne du conteneur, en mémoire vive uniquement et qui sera détruit en même temps que le conteneur.
</details>

<p align="right" style="font-size: 10px;"><a href="#top">return Title</a></p>

---