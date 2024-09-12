[< back](../README.md)
# DOCKER COMPOSE

Docker Compose est un outil pour définir et exécuter des applications multi-conteneurs Docker en utilisant un fichier de configuration YAML. Voici une documentation des principales commandes Docker Compose.

Pour approfondir, [la chaine YouTube de Xavki](https://www.youtube.com/@xavki) est une référence pour la compréhension du devops.

### Commandes Docker Compose Principales

#### 1. **`docker-compose --version`**
Affiche la version de Docker Compose installée sur votre système.
```bash
docker-compose --version
```

#### 2. **`docker-compose up`**
Crée et démarre les conteneurs définis dans le fichier `docker-compose.yml`. Cette commande construit les images si nécessaire, crée les réseaux et les volumes, et lance les conteneurs.

- **Syntaxe** :
  ```bash
  docker-compose up [options]
  ```

- **Options courantes** :
  - `-d` : Démarre les conteneurs en arrière-plan (détaché).
  - `--build` : Reconstruit les images avant de démarrer les conteneurs.
  - `--no-deps` : Ne pas démarrer les services liés.

- **Exemples** :
  ```bash
  docker-compose up
  docker-compose up -d
  docker-compose up --build
  ```

#### 3. **`docker-compose down`**
Arrête et supprime les conteneurs, les réseaux, les volumes, et les images définis dans le fichier `docker-compose.yml`.

- **Syntaxe** :
  ```bash
  docker-compose down [options]
  ```

- **Options courantes** :
  - `--volumes` ou `-v` : Supprime les volumes associés aux conteneurs.
  - `--rmi all` : Supprime toutes les images associées aux services.

- **Exemples** :
  ```bash
  docker-compose down
  docker-compose down -v
  docker-compose down --rmi all
  ```

#### 4. **`docker-compose start`**
Démarre les conteneurs existants qui ont été précédemment arrêtés.

- **Syntaxe** :
  ```bash
  docker-compose start [services]
  ```

- **Exemple** :
  ```bash
  docker-compose start
  docker-compose start web db
  ```

#### 5. **`docker-compose stop`**
Arrête les conteneurs en cours d'exécution sans les supprimer.

- **Syntaxe** :
  ```bash
  docker-compose stop [services]
  ```

- **Exemple** :
  ```bash
  docker-compose stop
  docker-compose stop web db
  ```

#### 6. **`docker-compose restart`**
Redémarre les conteneurs en les arrêtant puis en les redémarrant.

- **Syntaxe** :
  ```bash
  docker-compose restart [services]
  ```

- **Exemple** :
  ```bash
  docker-compose restart
  docker-compose restart web db
  ```

#### 7. **`docker-compose build`**
Construit ou reconstruit les images définies dans le fichier `docker-compose.yml`.

- **Syntaxe** :
  ```bash
  docker-compose build [options] [services]
  ```

- **Options courantes** :
  - `--no-cache` : Ne pas utiliser le cache lors de la construction des images.

- **Exemples** :
  ```bash
  docker-compose build
  docker-compose build --no-cache
  ```

#### 8. **`docker-compose logs`**
Affiche les logs des conteneurs.

- **Syntaxe** :
  ```bash
  docker-compose logs [options] [services]
  ```

- **Options courantes** :
  - `-f` ou `--follow` : Suivre les logs en temps réel.
  - `--tail` : Affiche uniquement les derniers logs.

- **Exemples** :
  ```bash
  docker-compose logs
  docker-compose logs -f
  docker-compose logs --tail=100
  ```

#### 9. **`docker-compose exec`**
Exécute une commande dans un conteneur en cours d'exécution.

- **Syntaxe** :
  ```bash
  docker-compose exec [options] <service> <commande>
  ```

- **Options courantes** :
  - `-T` : Désactive le pseudo-tty (utile pour des commandes non interactives).

- **Exemples** :
  ```bash
  docker-compose exec web /bin/bash
  docker-compose exec -T web ls /app
  ```

#### 10. **`docker-compose run`**
Exécute une commande dans un nouveau conteneur basé sur le service spécifié. Contrairement à `docker-compose exec`, cette commande crée un nouveau conteneur.

- **Syntaxe** :
  ```bash
  docker-compose run [options] <service> <commande>
  ```

- **Options courantes** :
  - `--rm` : Supprime le conteneur après l'exécution de la commande.

- **Exemples** :
  ```bash
  docker-compose run web /bin/bash
  docker-compose run --rm web ls /app
  ```

#### 11. **`docker-compose ps`**
Affiche les conteneurs en cours d'exécution pour les services définis dans le fichier `docker-compose.yml`.

- **Syntaxe** :
  ```bash
  docker-compose ps
  ```

#### 12. **`docker-compose config`**
Affiche la configuration des services dans le fichier `docker-compose.yml`, combinant toutes les configurations, y compris celles des fichiers de configuration supplémentaires.

- **Syntaxe** :
  ```bash
  docker-compose config
  ```

#### 13. **`docker-compose port`**
Affiche le port du conteneur auquel un port d'hôte est mappé.

- **Syntaxe** :
  ```bash
  docker-compose port <service> <port>
  ```

- **Exemple** :
  ```bash
  docker-compose port web 80
  ```

### Conclusion

Les commandes Docker Compose permettent de gérer les conteneurs et les services de manière cohérente et organisée à l'aide d'un fichier de configuration unique. Vous pouvez créer, démarrer, arrêter, et gérer des applications multi-conteneurs en utilisant ces commandes pour simplifier le processus de développement et de déploiement. Pour plus d'options et d'exemples, vous pouvez consulter la [documentation officielle de Docker Compose](https://docs.docker.com/compose/).