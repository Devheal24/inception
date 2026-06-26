*This project has been created as part of the 42 curriculum by mgarnier.*

# <h1 align="center"><p style="font-size: 70px;"><span style="color:green">Inception</span></h1>

## Summary
- [Description](#description)
- [Architecture](#architecture)
- [Instructions](#instructions)
- [Resources](#resources)
- [AI](#ai)
- [Project description](#project-description)

# <span style="color:white">Description</span>

This project is 

## Architecture

```text
inception/
|
├── Makefile
├── README.md
├── srcs
│   └── docker-compose.yml
└── TODO.md
```

# <span style="color:white">Instructions</span>

`make`

# <span style="color:white">Resources</span>


# AI

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

### Docker Volumes vs Bind Mounts :
