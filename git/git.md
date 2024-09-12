[< back](../README.md)
# GIT

Voici une documentation détaillée des principales commandes Git.

En complément, voci un lien vers un repo de test de commandes git : [Experimetations Git](https://github.com/Peanuts-83/Git-HowTo)

### Commandes Git Principales

#### 1. **`git init`**
Initialise un nouveau dépôt Git dans le répertoire courant.
```bash
git init
```

Après avoir créé un dépôt distant, ces commandes Git spécifiques : `git remote`, `git remote add`, et `git push -u` permettent de lier local et distant.

#### 1a. **`git remote`**

La commande `git remote` est utilisée pour gérer les dépôts distants associés à votre dépôt local. Un dépôt distant est un autre dépôt Git situé sur un serveur (comme GitHub, GitLab, ou Bitbucket) qui est lié à votre dépôt local.

- **Afficher les dépôts distants** :
  ```bash
  git remote
  ```
  Cette commande affiche la liste des noms des dépôts distants configurés pour le dépôt local.

- **Afficher les informations détaillées sur les dépôts distants** :
  ```bash
  git remote -v
  ```
  L'option `-v` (verbose) montre les URLs associées aux dépôts distants pour les opérations de `fetch` et `push`.

#### 1b. **`git remote add`**

La commande `git remote add` est utilisée pour ajouter un nouveau dépôt distant à votre dépôt local. Cela vous permet de spécifier un nom pour le dépôt distant et l'URL à laquelle il est accessible.

- **Syntaxe** :
  ```bash
  git remote add <nom-distant> <url>
  ```

- **Paramètres** :
  - `<nom-distant>` : Le nom que vous souhaitez attribuer au dépôt distant. Par convention, le nom par défaut est `origin`.
  - `<url>` : L'URL du dépôt distant. Cela peut être une URL HTTP(s), SSH, ou un chemin de dépôt Git.

- **Exemple** :
  ```bash
  git remote add origin https://github.com/username/repository.git
  ```
  Cela ajoute un dépôt distant nommé `origin` avec l'URL spécifiée.

#### 1c. **`git push -u`**

La commande `git push -u` est utilisée pour envoyer les commits de votre branche locale vers le dépôt distant et définir la branche distante par défaut pour votre branche locale.

- **Syntaxe** :
  ```bash
  git push -u <nom-distant> <branche>
  ```

- **Paramètres** :
  - `<nom-distant>` : Le nom du dépôt distant, par exemple `origin`.
  - `<branche>` : Le nom de la branche que vous souhaitez pousser vers le dépôt distant.

- **Options** :
  - `-u` ou `--set-upstream` : Définit la branche distante comme la branche par défaut pour les futures opérations `git push` et `git pull` sur la branche locale spécifiée. Cela permet à Git de savoir à quel dépôt distant et branche pousser ou tirer les modifications sans avoir à spécifier ces informations à chaque fois.

- **Exemple** :
  ```bash
  git push -u origin main
  ```
  Cela pousse la branche locale `main` vers le dépôt distant `origin` et définit `origin/main` comme la branche distante par défaut pour `main`. À partir de ce moment, vous pouvez simplement utiliser `git push` ou `git pull` sans avoir à spécifier le dépôt distant et la branche.


#### 2. **`git clone`**
Clone un dépôt existant depuis une URL dans un nouveau répertoire local.
```bash
git clone <url-du-dépôt>
```

#### 3. **`git add`**
Ajoute des fichiers ou des modifications au cache (staging area) pour la prochaine validation (commit).
```bash
git add <fichier>
git add .
```

#### 4. **`git commit`**
Valide les modifications ajoutées au cache avec un message de commit.
```bash
git commit -m "Message de commit"
```

#### 5. **`git status`**
Affiche l'état des fichiers dans le répertoire de travail et le cache.
```bash
git status
```

#### 6. **`git log`**
Affiche l'historique des commits dans le dépôt.
```bash
git log
```

#### 7. **`git diff`**
Affiche les différences entre les fichiers du répertoire de travail et le cache ou entre différents commits.
```bash
git diff
```

#### 8. **`git branch`**
Affiche les branches locales ou crée/supprime des branches.
```bash
git branch          # Liste les branches locales
git branch <nom>    # Crée une nouvelle branche
git branch -d <nom> # Supprime une branche
```

#### 9. **`git checkout`**
Change de branche ou restaure des fichiers du répertoire de travail.
```bash
git checkout <branche>   # Change de branche
git checkout <fichier>   # Restaure un fichier à partir du cache
```

#### 10. **`git merge`**
Fusionne des modifications d'une branche dans la branche courante.
```bash
git merge <branche>
```

#### 11. **`git pull`**
Télécharge les modifications depuis le dépôt distant et les fusionne avec la branche courante.
```bash
git pull
```

#### 12. **`git push`**
Envoie les commits locaux vers un dépôt distant.
```bash
git push
```

### Commandes Avancées

#### 1. **`git merge --squash`**
Fusionne les modifications d'une branche dans la branche courante en combinant tous les commits en un seul commit.
```bash
git merge --squash <branche>
```
- Cette commande prépare les modifications de la branche spécifiée pour un commit unique. Après l'exécution de `git merge --squash`, vous devrez faire un `git commit` pour finaliser la fusion.

- **Exemple** :
  ```bash
  git checkout main
  git merge --squash feature-branch
  git commit -m "Fusion de la branche feature-branch avec squash"
  ```

#### 2. **`git reset`**
Réinitialise la branche courante à un commit précédent. Cela peut également être utilisé pour modifier le cache ou le répertoire de travail.

- **`git reset --soft <commit>`** : Réinitialise la branche à `<commit>` tout en conservant les modifications dans le cache.
  ```bash
  git reset --soft <commit>
  ```

- **`git reset --mixed <commit>`** : Réinitialise la branche à `<commit>` et supprime les modifications du cache tout en conservant les modifications dans le répertoire de travail.
  ```bash
  git reset --mixed <commit>
  ```

- **`git reset --hard <commit>`** : Réinitialise la branche à `<commit>` et supprime toutes les modifications dans le cache et le répertoire de travail.
  ```bash
  git reset --hard <commit>
  ```

- **Exemple** :
  ```bash
  git reset --hard HEAD~1
  ```

  Cela réinitialise la branche courante au commit précédent et supprime les modifications non validées.

#### 3. **`git revert`**
Crée un nouveau commit qui annule les modifications d'un commit précédent sans modifier l'historique du dépôt.

- **`git revert <commit>`** : Annule les modifications apportées par `<commit>` et crée un nouveau commit avec les modifications inversées.
  ```bash
  git revert <commit>
  ```

- **Exemple** :
  ```bash
  git revert a1b2c3d4
  ```

  Cela annule les changements introduits par le commit `a1b2c3d4` et crée un nouveau commit avec les modifications inversées.

### Conclusion

Ces commandes Git vous permettent de gérer et manipuler votre dépôt de manière efficace. La commande **`git merge --squash`** est utile pour combiner plusieurs commits en un seul avant de les fusionner dans la branche principale, tandis que **`git reset`** et **`git revert`** offrent des moyens différents pour revenir à des états antérieurs dans l'historique des commits. `git reset` est plus radical et modifie l'historique, alors que `git revert` est plus sûr pour annuler des changements tout en conservant l'historique des commits.
