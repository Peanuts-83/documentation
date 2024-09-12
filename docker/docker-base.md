[< back](../README.md)
# DOCKER

Voici une documentation des principales commandes Docker, qui vous aidera à gérer vos conteneurs, images, volumes et réseaux Docker. Docker est un outil de conteneurisation qui facilite le déploiement d'applications dans des conteneurs isolés.

Pour approfondir, [la chaine YouTube de Xavki](https://www.youtube.com/@xavki) est une référence pour la compréhension du devops.

### Commandes Docker de Base

#### 1. **`docker --version`**
Affiche la version de Docker installée sur votre système.
```bash
docker --version
```

#### 2. **`docker info`**
Affiche des informations détaillées sur l'installation de Docker, y compris les conteneurs, images, et la configuration du système.
```bash
docker info
```

### Gestion des Conteneurs

#### 1. **`docker run`**
Crée et exécute un conteneur à partir d'une image. Il peut également exécuter une commande dans le conteneur.
```bash
docker run [options] <image> [commande]
```
- **Exemple** :
  ```bash
  docker run -d -p 80:80 nginx
  ```

  Cela exécute un conteneur en arrière-plan (`-d`) basé sur l'image `nginx`, en mappant le port `80` du conteneur au port `80` de l'hôte.

#### 2. **`docker ps`**
Affiche les conteneurs en cours d'exécution.
```bash
docker ps
```

#### 3. **`docker ps -a`**
Affiche tous les conteneurs, y compris ceux qui ne sont pas en cours d'exécution.
```bash
docker ps -a
```

#### 4. **`docker stop`**
Arrête un ou plusieurs conteneurs en cours d'exécution.
```bash
docker stop <id-conteneur>
```

#### 5. **`docker start`**
Démarre un ou plusieurs conteneurs arrêtés.
```bash
docker start <id-conteneur>
```

#### 6. **`docker restart`**
Redémarre un ou plusieurs conteneurs.
```bash
docker restart <id-conteneur>
```

#### 7. **`docker rm`**
Supprime un ou plusieurs conteneurs arrêtés.
```bash
docker rm <id-conteneur>
```

#### 8. **`docker exec`**
Exécute une commande dans un conteneur en cours d'exécution.
```bash
docker exec [options] <id-conteneur> <commande>
```
- **Exemple** :
  ```bash
  docker exec -it <id-conteneur> /bin/bash
  ```

  Cela ouvre une session interactive (`-it`) avec un shell bash dans le conteneur.

### Gestion des Images

#### 1. **`docker pull`**
Télécharge une image depuis un registre (par défaut, Docker Hub).
```bash
docker pull <image>
```

#### 2. **`docker build`**
Construit une image à partir d'un Dockerfile.
```bash
docker build [options] -t <nom-image>:<tag> <chemin>
```
- **Exemple** :
  ```bash
  docker build -t my-image:latest .
  ```

  Cela construit une image nommée `my-image` avec le tag `latest` à partir du Dockerfile dans le répertoire courant.

#### 3. **`docker images`**
Affiche la liste des images locales.
```bash
docker images
```

#### 4. **`docker rmi`**
Supprime une ou plusieurs images locales.
```bash
docker rmi <id-image>
```

### Gestion des Volumes

#### 1. **`docker volume create`**
Crée un nouveau volume Docker.
```bash
docker volume create <nom-volume>
```

#### 2. **`docker volume ls`**
Affiche la liste des volumes Docker.
```bash
docker volume ls
```

#### 3. **`docker volume inspect`**
Affiche des informations détaillées sur un volume spécifique.
```bash
docker volume inspect <nom-volume>
```

#### 4. **`docker volume rm`**
Supprime un ou plusieurs volumes Docker.
```bash
docker volume rm <nom-volume>
```

### Gestion des Réseaux

#### 1. **`docker network create`**
Crée un nouveau réseau Docker.
```bash
docker network create <nom-réseau>
```

#### 2. **`docker network ls`**
Affiche la liste des réseaux Docker.
```bash
docker network ls
```

#### 3. **`docker network inspect`**
Affiche des informations détaillées sur un réseau spécifique.
```bash
docker network inspect <nom-réseau>
```

#### 4. **`docker network rm`**
Supprime un ou plusieurs réseaux Docker.
```bash
docker network rm <nom-réseau>
```

### Gestion des Logs

#### 1. **`docker logs`**
Affiche les logs d'un conteneur.
```bash
docker logs <id-conteneur>
```

### Autres Commandes Utiles

#### 1. **`docker-compose`**
Outil pour définir et exécuter des applications multi-conteneurs Docker. Utilisez `docker-compose` pour des opérations comme le démarrage, l'arrêt, et la gestion des services définis dans un fichier `docker-compose.yml`.

- **Exemples** :
  - **Démarrer les services** :
    ```bash
    docker-compose up
    ```

  - **Arrêter les services** :
    ```bash
    docker-compose down
    ```

  - **Afficher les logs** :
    ```bash
    docker-compose logs
    ```

#### 2. **`docker system prune`**
Supprime les objets inutilisés pour libérer de l'espace disque.
```bash
docker system prune
```
- **Attention** : Cette commande supprime les conteneurs arrêtés, les images non utilisées, et les volumes non utilisés.

### Conclusion

Ces commandes Docker couvrent les opérations essentielles pour gérer les conteneurs, les images, les volumes et les réseaux. Elles vous permettent de créer, exécuter, configurer et supprimer des ressources Docker efficacement. Pour des informations supplémentaires et des options avancées, consultez la documentation officielle de Docker ou utilisez `docker <commande> --help`.