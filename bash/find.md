[< back](../README.md)
# find

La commande **`find`** sous Linux est un outil puissant pour rechercher des fichiers et des répertoires dans le système de fichiers en fonction de divers critères. Voici une documentation détaillée pour la commande `find`, incluant sa syntaxe, ses options principales et des exemples pratiques.

### Syntaxe de Base
```bash
find [chemin] [options] [expression]
```
- **`chemin`** : Le répertoire à partir duquel commencer la recherche. Si vous omettez cette partie, `find` recherche à partir du répertoire actuel.
- **`options`** : Modifie le comportement de la commande `find` (comme spécifier le niveau de profondeur ou les permissions).
- **`expression`** : Critères pour filtrer les fichiers (comme le nom, le type, la taille, etc.).

### Options et Expressions Courantes

#### 1. **Critères de Recherche**

- **`-name`** : Recherche par nom de fichier. Vous pouvez utiliser des jokers comme `*` et `?`.
  ```bash
  find /chemin -name "fichier.txt"
  find /chemin -name "*.log"
  ```

- **`-iname`** : Recherche par nom de fichier en ignorant la casse.
  ```bash
  find /chemin -iname "*.txt"
  ```

- **`-type`** : Recherche par type de fichier. Les types communs incluent :
  - `f` : fichier régulier
  - `d` : répertoire
  - `l` : lien symbolique
  ```bash
  find /chemin -type f
  find /chemin -type d
  find /chemin -type l
  ```

- **`-size`** : Recherche par taille de fichier. Les tailles peuvent être spécifiées en octets (par défaut), ou en kilooctets (`k`), mégaoctets (`M`), etc.
  ```bash
  find /chemin -size +10M    # Fichiers plus grands que 10 Mo
  find /chemin -size -100k   # Fichiers plus petits que 100 Ko
  ```

- **`-mtime`** : Recherche par date de modification. Les valeurs négatives sont pour les fichiers modifiés récemment, et les valeurs positives pour les fichiers modifiés il y a longtemps.
  ```bash
  find /chemin -mtime -7    # Fichiers modifiés au cours des 7 derniers jours
  find /chemin -mtime +30   # Fichiers modifiés il y a plus de 30 jours
  ```

- **`-atime`** : Recherche par date d'accès (similaire à `-mtime` mais pour l'accès).
  ```bash
  find /chemin -atime -1     # Fichiers accédés au cours des dernières 24 heures
  ```

- **`-ctime`** : Recherche par date de changement de statut de fichier (y compris les changements de permissions).
  ```bash
  find /chemin -ctime -10    # Fichiers dont le statut a changé au cours des 10 derniers jours
  ```

#### 2. **Actions**

- **`-print`** : Affiche le chemin des fichiers trouvés (c'est le comportement par défaut si aucune autre action n'est spécifiée).
  ```bash
  find /chemin -name "*.txt" -print
  ```

- **`-exec`** : Exécute une commande sur chaque fichier trouvé. La commande se termine par `\;`.
  ```bash
  find /chemin -name "*.log" -exec rm {} \;   # Supprime les fichiers .log trouvés
  ```

- **`-delete`** : Supprime les fichiers trouvés.
  ```bash
  find /chemin -name "*.tmp" -delete
  ```

- **`-ls`** : Affiche les fichiers trouvés avec des détails similaires à la commande `ls -l`.
  ```bash
  find /chemin -type f -ls
  ```

#### 3. **Exemples Pratiques**

- **Rechercher tous les fichiers `.jpg` dans le répertoire `/home/user`** :
  ```bash
  find /home/user -type f -name "*.jpg"
  ```

- **Trouver tous les fichiers plus grands que 100 Mo** :
  ```bash
  find / -type f -size +100M
  ```

- **Trouver tous les fichiers modifiés dans les 5 derniers jours et les copier dans un autre répertoire** :
  ```bash
  find /chemin/source -type f -mtime -5 -exec cp {} /chemin/destination \;
  ```

- **Trouver tous les répertoires vides** :
  ```bash
  find /chemin -type d -empty
  ```

- **Rechercher des fichiers avec une certaine permission (par exemple, fichiers avec des permissions 777)** :
  ```bash
  find /chemin -type f -perm 0777
  ```

### Options Avancées

- **`-maxdepth`** : Limite la profondeur de la recherche. `-maxdepth 1` recherche uniquement dans le répertoire spécifié sans descendre dans les sous-répertoires.
  ```bash
  find /chemin -maxdepth 1 -name "*.txt"
  ```

- **`-mindepth`** : Spécifie la profondeur minimale à laquelle commencer la recherche.
  ```bash
  find /chemin -mindepth 2 -name "*.txt"
  ```

- **`-prune`** : Exclut des répertoires de la recherche.
  ```bash
  find /chemin -name "exclude_dir" -prune -o -name "*.txt" -print
  ```

### Conclusion

La commande **`find`** est extrêmement flexible et puissante pour localiser des fichiers en fonction de divers critères. Sa capacité à combiner des critères de recherche, à effectuer des actions sur les fichiers trouvés, et à intégrer des expressions complexes en fait un outil indispensable pour l'administration système et les tâches de gestion de fichiers sous Linux. Pour des informations supplémentaires et des options avancées, consultez la page de manuel en utilisant `man find`.