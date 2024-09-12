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