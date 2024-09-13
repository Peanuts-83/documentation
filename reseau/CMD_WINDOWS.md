[< back](../README.md)
# WINDOWS

## A. Reseau

### 1. netsh

La commande **`netsh`** (Network Shell) est un utilitaire en ligne de commande de Windows qui permet de configurer, d'administrer et de diagnostiquer divers paramètres réseau directement depuis le terminal. Elle est utile pour gérer les interfaces réseau, les configurations IP, les pare-feu, le proxy, et bien d'autres éléments.

### Syntaxe de base :
```bash
netsh [contexte] [commande] [arguments]
```
- **Contexte** : Désigne une zone spécifique du réseau ou une fonctionnalité (comme `interface`, `firewall`, `wlan`, etc.).
- **Commande** : La tâche spécifique à exécuter (comme `add`, `set`, `show`).
- **Arguments** : Paramètres associés à la commande, tels que des interfaces réseau, des adresses IP, des ports, etc.

### Commandes communes et leur utilisation :

#### 1. **Interface réseau**
Vous pouvez configurer les interfaces réseau, comme l'attribution d'adresses IP ou la gestion de la passerelle.

- **Afficher les interfaces réseau** :
  ```bash
  netsh interface show interface
  ```
  Cela affiche toutes les interfaces réseau disponibles sur la machine.

- **Configurer une adresse IP statique** :
  ```bash
  netsh interface ip set address name="Ethernet" static 192.168.0.xx 255.255.255.0 192.168.0.1
  ```
  Cela configure l'interface **Ethernet** avec l'adresse IP `192.168.0.xx`, un masque de sous-réseau de `255.255.255.0`, et une passerelle par défaut de `192.168.0.1`.

#### 2. **Pare-feu Windows (Firewall)**
La gestion du pare-feu est l'une des fonctionnalités principales de `netsh`. Vous pouvez ajouter ou supprimer des règles, activer/désactiver le pare-feu, etc.

- **Afficher l'état du pare-feu** :
  ```bash
  netsh advfirewall show allprofiles
  ```
  Cela montre l'état du pare-feu pour tous les profils (Domaine, Privé, Public).

- **Activer/Désactiver le pare-feu** :
  ```bash
  netsh advfirewall set allprofiles state on
  netsh advfirewall set allprofiles state off
  ```

- **Ajouter une règle pour ouvrir un port** :
  ```bash
  netsh advfirewall firewall add rule name="Ouvrir le port 81" dir=in action=allow protocol=TCP localport=81
  ```

#### 3. **Proxy de port (portproxy)**
La fonction de **port forwarding** ou **portproxy** permet de rediriger le trafic réseau d'un port à un autre, souvent utilisé pour acheminer du trafic local à partir de certaines adresses IP/ports.

- **Ajouter une redirection de port** :
  ```bash
  netsh interface portproxy add v4tov4 listenport=81 listenaddress=192.168.0.xx connectport=81 connectaddress=127.0.0.1
  ```
  Cela redirige le trafic entrant sur `192.168.0.xx:81` vers `127.0.0.1:81`.

- **Voir toutes les redirections de port** :
  ```bash
  netsh interface portproxy show all
  ```

- **Supprimer une redirection de port** :
  ```bash
  netsh interface portproxy delete v4tov4 listenport=81 listenaddress=192.168.0.xx
  ```

#### 4. **Wi-Fi (WLAN)**
`netsh` est aussi utilisé pour la gestion des réseaux Wi-Fi sur une machine.

- **Lister les réseaux Wi-Fi disponibles** :
  ```bash
  netsh wlan show networks
  ```

- **Afficher le profil d'une connexion Wi-Fi enregistrée** :
  ```bash
  netsh wlan show profile name="nom_du_reseau" key=clear
  ```
  Cette commande affiche les détails d'un réseau Wi-Fi spécifique, y compris la clé de sécurité si `key=clear` est spécifié.

#### 5. **IP et DNS**
Pour configurer les adresses IP et les serveurs DNS :

- **Configurer un serveur DNS** :
  ```bash
  netsh interface ip set dns name="Ethernet" static 8.8.8.8
  ```
  Configure l'interface **Ethernet** avec le serveur DNS de Google (`8.8.8.8`).

- **Réinitialiser le catalogue DNS (flush)** :
  ```bash
  netsh int ip reset
  ```

### Contextes disponibles :
Voici quelques-uns des principaux **contextes** que vous pouvez utiliser avec `netsh` :

- **`advfirewall`** : Gérer le pare-feu Windows.
- **`interface`** : Configurer les interfaces réseau, les adresses IP, etc.
- **`wlan`** : Gérer les connexions Wi-Fi.
- **`http`** : Configurer le comportement HTTP pour des applications spécifiques.
- **`ras`** : Configurer les connexions d'accès à distance.
- **`routing`** : Gérer les tables de routage.

### Quelques exemples pratiques :

- **Activer DHCP pour une interface** :
  ```bash
  netsh interface ip set address name="Ethernet" source=dhcp
  ```

- **Configurer une passerelle par défaut** :
  ```bash
  netsh interface ip set address name="Ethernet" gateway=192.168.0.1
  ```

- **Voir la configuration IP d'une interface spécifique** :
  ```bash
  netsh interface ip show config name="Ethernet"
  ```

### Aide et documentation :
Pour obtenir de l'aide sur une commande spécifique ou un contexte particulier, vous pouvez utiliser l'option `/?` :

```bash
netsh [contexte] [commande] /?
```

Exemple pour afficher de l'aide sur la gestion des interfaces réseau :
```bash
netsh interface ip /?
```

### Conclusion :
`netsh` est un outil puissant et flexible pour gérer la configuration réseau sur Windows. Il offre des capacités de gestion fine pour la plupart des fonctionnalités réseau telles que les interfaces, le pare-feu, le Wi-Fi, les redirections de port, etc., ce qui en fait un utilitaire indispensable pour l'administration réseau sous Windows.



## B. Jonction IP de poste / localhost

Pour rendre votre application Docker accessible depuis le réseau extérieur, voici les étapes à suivre :

### 1. **Vérifier la configuration du port dans Docker**
Assurez-vous que votre conteneur Docker expose le port correctement. Par exemple, si votre application écoute sur le port 81 à l'intérieur du conteneur et vous souhaitez qu'elle soit accessible via ce port à l'extérieur, vérifiez que vous avez bien mappé le port avec l'option `-p` lors du démarrage du conteneur.

Si ce n'est pas déjà le cas, vous pouvez démarrer votre conteneur avec la commande suivante (ou vous assurer que l'exposition de port est correcte dans `docker-compose` si vous l'utilisez) :

```bash
docker run -d -p 81:81 nom_de_limage
```

### 2. **Autoriser le trafic via le pare-feu Windows**
Il est possible que Windows bloque le trafic entrant sur le port 81 par défaut. Vous devez donc ajouter une règle pour autoriser ce trafic dans le **pare-feu Windows** :

1. Ouvrez le **Panneau de configuration** > **Système et sécurité** > **Pare-feu Windows Defender**.
2. Cliquez sur **Paramètres avancés** dans la colonne de gauche.
3. Dans la fenêtre des **paramètres avancés**, sélectionnez **Règles de trafic entrant** dans la colonne de gauche.
4. Cliquez sur **Nouvelle règle** dans la colonne de droite.
5. Choisissez **Port** comme type de règle, cliquez sur **Suivant**, puis entrez `81` pour le port TCP spécifique.
6. Autorisez la connexion et donnez un nom à la règle, comme "Docker Port 81".

### 3. **Configurer le routage sur WSL**
Dans WSL 2, les conteneurs Docker et les applications exécutées n'ont pas un accès direct au réseau externe. Vous devrez configurer le routage pour permettre au trafic d'accéder à votre application depuis le réseau extérieur.

Exécutez cette commande dans PowerShell en mode administrateur pour créer une règle de redirection entre le réseau WSL et l'interface réseau externe :

```powershell
netsh interface portproxy add v4tov4 listenport=81 listenaddress=192.168.0.xx connectport=81 connectaddress=127.0.0.1
```

Cela signifie que tout le trafic venant sur `192.168.0.xx:81` sera redirigé vers `127.0.0.1:81`, là où votre application est accessible en local sur Windows.

### 4. **Vérifier l'ouverture du port sur votre routeur**
Si vous voulez accéder à l'application depuis un réseau extérieur (par exemple, via Internet), vous devez configurer une **redirection de port (port forwarding)** sur votre routeur. Vous pouvez rediriger le port 81 de votre IP externe vers le port 81 de votre PC (192.168.0.xx).

Voici les étapes générales (varient selon le modèle de routeur) :
1. Accédez à l'interface d'administration de votre routeur.
2. Recherchez une section liée à la redirection de port ou au NAT.
3. Configurez une règle pour rediriger le port 81 de l'IP publique vers `192.168.0.xx:81`.

### 5. **Test**
À ce stade, votre application devrait être accessible depuis d'autres appareils sur le réseau local via l'adresse `192.168.0.xx:81`. Si vous avez configuré la redirection de port sur votre routeur, elle sera également accessible depuis l'extérieur via votre IP publique (en vérifiant que le port est ouvert).

Assurez-vous de tester avec l'URL suivante depuis une autre machine sur le même réseau local :

```
http://192.168.0.xx:81
```

Si vous souhaitez tester à distance (Internet), obtenez votre IP publique (par exemple via `whatismyip.com`) et essayez :

```
http://[votre_ip_publique]:81
```
