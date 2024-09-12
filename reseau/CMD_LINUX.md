[< back](../README.md)
# LINUX

## A. RESEAU

En Linux, les fonctionnalités similaires à celles de `netsh` sont souvent gérées par différentes commandes et utilitaires. Voici une documentation équivalente pour les principales commandes Linux utilisées pour la gestion réseau :

### 1. **`ip`**
La commande **`ip`** est l'outil principal pour la gestion des interfaces réseau, des adresses IP, des routes, etc.

- **Afficher les interfaces réseau** :
  ```bash
  ip link show
  ```

- **Afficher les adresses IP des interfaces** :
  ```bash
  ip addr show
  ```

- **Ajouter une adresse IP à une interface** :
  ```bash
  sudo ip addr add 192.168.0.67/24 dev eth0
  ```

- **Supprimer une adresse IP d'une interface** :
  ```bash
  sudo ip addr del 192.168.0.67/24 dev eth0
  ```

- **Afficher les routes** :
  ```bash
  ip route show
  ```

- **Ajouter une route** :
  ```bash
  sudo ip route add 192.168.1.0/24 via 192.168.0.1
  ```

- **Supprimer une route** :
  ```bash
  sudo ip route del 192.168.1.0/24
  ```

### 2. **`iptables` et `nftables`**
Les commandes **`iptables`** et **`nftables`** sont utilisées pour la gestion des règles de pare-feu.

#### `iptables` (version plus ancienne et encore largement utilisée) :
- **Afficher les règles actuelles** :
  ```bash
  sudo iptables -L
  ```

- **Ajouter une règle pour autoriser le port 81 en TCP** :
  ```bash
  sudo iptables -A INPUT -p tcp --dport 81 -j ACCEPT
  ```

- **Supprimer une règle** :
  ```bash
  sudo iptables -D INPUT -p tcp --dport 81 -j ACCEPT
  ```

- **Sauvegarder les règles** (la méthode peut varier selon les distributions) :
  ```bash
  sudo iptables-save > /etc/iptables/rules.v4
  ```

#### `nftables` (plus récent, recommandé pour les systèmes modernes) :
- **Afficher les règles actuelles** :
  ```bash
  sudo nft list ruleset
  ```

- **Ajouter une règle pour autoriser le port 81 en TCP** :
  ```bash
  sudo nft add rule ip filter input tcp dport 81 accept
  ```

- **Supprimer une règle** :
  ```bash
  sudo nft delete rule ip filter input handle <rule_handle>
  ```

### 3. **`ss`**
La commande **`ss`** est utilisée pour afficher les sockets réseau (remplaçant de `netstat`).

- **Afficher les sockets ouverts** :
  ```bash
  ss -tuln
  ```

- **Afficher les connexions réseau** :
  ```bash
  ss -tn
  ```

### 4. **`ufw`**
**`ufw`** (Uncomplicated Firewall) est un frontend simplifié pour `iptables`.

- **Activer `ufw`** :
  ```bash
  sudo ufw enable
  ```

- **Désactiver `ufw`** :
  ```bash
  sudo ufw disable
  ```

- **Autoriser le port 81** :
  ```bash
  sudo ufw allow 81/tcp
  ```

- **Interdire le port 81** :
  ```bash
  sudo ufw deny 81/tcp
  ```

- **Afficher le statut de `ufw`** :
  ```bash
  sudo ufw status
  ```

### 5. **`route`**
La commande **`route`** est utilisée pour afficher et modifier la table de routage (remplacée par `ip route` dans les systèmes modernes).

- **Afficher la table de routage** :
  ```bash
  route -n
  ```

- **Ajouter une route** :
  ```bash
  sudo route add -net 192.168.1.0/24 gw 192.168.0.1
  ```

- **Supprimer une route** :
  ```bash
  sudo route del -net 192.168.1.0/24
  ```

### 6. **`nmcli`**
**`nmcli`** est un outil en ligne de commande pour interagir avec **NetworkManager**.

- **Afficher les connexions réseau** :
  ```bash
  nmcli connection show
  ```

- **Créer une nouvelle connexion** :
  ```bash
  nmcli connection add type ethernet ifname eth0 con-name my-connection
  ```

- **Modifier une connexion existante** :
  ```bash
  nmcli connection modify my-connection ipv4.addresses 192.168.0.67/24
  ```

- **Activer une connexion** :
  ```bash
  nmcli connection up my-connection
  ```

- **Désactiver une connexion** :
  ```bash
  nmcli connection down my-connection
  ```

### Documentation et aide :
Pour obtenir de l'aide sur une commande spécifique, vous pouvez utiliser les options `--help` ou consulter les pages de manuel (`man`).

- **Afficher l'aide d'une commande** :
  ```bash
  ip --help
  ip addr --help
  ip route --help
  ```

- **Afficher la page de manuel d'une commande** :
  ```bash
  man ip
  man ip-address
  man ip-route
  man iptables
  man nft
  ```

### Conclusion :
Les commandes Linux couvrent une large gamme de fonctionnalités pour gérer la configuration réseau, les pare-feu, les sockets, et plus encore. Elles offrent une flexibilité importante pour administrer des réseaux et dépanner des problèmes de connectivité. La commande **`ip`** est l'un des outils les plus polyvalents pour la gestion des interfaces et des routes, tandis que **`iptables`** et **`nftables`** sont utilisés pour la gestion des règles de pare-feu. Pour des interfaces plus simples, **`ufw`** peut être un bon choix.



## B. Jonction IP de poste / localhost

Pour créer une redirection de port sous Linux, similaire à ce que vous feriez avec `netsh` sur Windows, vous pouvez utiliser **`iptables`**. Voici comment configurer cela pour permettre à une application écoutant sur `127.0.0.1:4200` d'être accessible via l'adresse IP `192.168.0.92` sur le même port (`4200`).

### Utiliser `iptables` pour la redirection de port

1. **Ouvrir une session terminal** avec les privilèges root ou utiliser `sudo` pour les commandes suivantes.

2. **Ajouter une règle de redirection de port** avec `iptables` :

   ```bash
   sudo iptables -t nat -A PREROUTING -p tcp --dport 4200 -j DNAT --to-destination 127.0.0.1:4200
   sudo iptables -t nat -A POSTROUTING -p tcp --dport 4200 -j MASQUERADE
   ```

   Ces commandes font les choses suivantes :
   - La première commande redirige tout le trafic entrant sur le port `4200` de votre machine (`192.168.0.92`) vers `127.0.0.1:4200`.
   - La deuxième commande fait en sorte que les réponses soient correctement acheminées.

3. **Vérifier les règles `iptables`** pour s'assurer que les redirections ont été ajoutées correctement :

   ```bash
   sudo iptables -t nat -L -n -v
   ```

   Cette commande affichera les règles NAT en place, et vous devriez voir les règles que vous venez d'ajouter.

4. **Sauvegarder les règles `iptables`** (si vous souhaitez que ces règles persistent après un redémarrage) :

   - Sur certaines distributions, vous pouvez utiliser `iptables-save` :

     ```bash
     sudo iptables-save | sudo tee /etc/iptables/rules.v4
     ```

   - Sur d'autres distributions, vous pourriez avoir besoin d'installer des utilitaires comme `iptables-persistent` pour gérer cela plus facilement :

     ```bash
     sudo apt-get install iptables-persistent
     ```

### Conclusion

Avec ces configurations, vous devriez pouvoir accéder à votre application Angular, qui écoute sur `127.0.0.1:4200`, depuis l'extérieur via l'adresse `192.168.0.92:4200`. Vous pouvez tester cela en accédant à `http://192.168.0.92:4200` depuis un autre appareil sur le même réseau local.

Assurez-vous également que l'application Angular est configurée pour accepter des connexions à partir de toutes les interfaces (`0.0.0.0`), comme mentionné précédemment, pour qu'elle puisse répondre aux requêtes venant de l'extérieur.