---
title: "THM - DailyBugle without MetaSploit"
date: 2021-03-17
categories: ["hacking", "write-ups"]
tags: [THM]
featuredImage: "/images/2021/03/DailyBugle_Logo.png"
---
## Intro
This box looks promising, featuring a real life CMS, [Joomla](https://www.joomla.org/), and one that is quite often in the wild too! It is even a CMS I used several years ago, for one of my blog!

Let's see right now, if we can get in!

## Target
[THM - DailyBugle](https://tryhackme.com/room/dailybugle)

## Recon
Quick recon according to logo and info :

* Linux ;
* Joomla CMS, SQLi ;
* Privesc via yum.

## Enum
Usual `nmap` scan :

```text
sudo nmap -sC -sV -oA scans/$target_ip
```
```text
Starting Nmap 7.91 ( https://nmap.org ) at 2021-03-17 13:45 CET
Nmap scan report for $target_ip ($target_ip)
Host is up (0.034s latency).
Not shown: 997 closed ports
PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 7.4 (protocol 2.0)
| ssh-hostkey:
|   2048 68:ed:7b:19:7f:ed:14:e6:18:98:6d:c5:88:30:aa:e9 (RSA)
|   256 5c:d6:82:da:b2:19:e3:37:99:fb:96:82:08:70:ee:9d (ECDSA)
|_  256 d2:a9:75:cf:2f:1e:f5:44:4f:0b:13:c2:0f:d7:37:cc (ED25519)
80/tcp   open  http    Apache httpd 2.4.6 ((CentOS) PHP/5.6.40)
|_http-generator: Joomla! - Open Source Content Management
| http-robots.txt: 15 disallowed entries
| /joomla/administrator/ /administrator/ /bin/ /cache/
| /cli/ /components/ /includes/ /installation/ /language/
|_/layouts/ /libraries/ /logs/ /modules/ /plugins/ /tmp/
|_http-server-header: Apache/2.4.6 (CentOS) PHP/5.6.40
|_http-title: Home
3306/tcp open  mysql   MariaDB (unauthorized)

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 16.13 seconds
```

## Exploitation

Manually browsing to the website confirms a Joomla website. Let's run `joomscan` in order to gather more info. We are especially interested about the version. Since we are looking for a known SQL injection.

After a few seconds, it happens our target is running `Joomla 3.7.0` :

![Joomla version](/images/2021/03/DailyBugle_Joomla_Version.png)

According to [exploit-db](https://www.exploit-db.com/exploits/42033), which confirms the `SQLi`, we can now run `sqlmap` like shown below:

```text
sqlmap -u "http://$target_ip/index.php?option=com_fields&view=fields&layout=modal&list[fullordering]=updatexml" --risk=3 --level=5 --random-agent --dbs -p list[fullordering]
```
While having this info is cool, it looks tedious to get what I am looking for.

Doing a little more research for an easy win, I came across a [Python script](https://github.com/stefanlucas/Exploit-Joomla) to exploit this vuln, and it directly returned juicy info :

![User hash](/images/2021/03/DailyBugle_User_Hash.png)

Looking on internet, this hash appears to be bcrypt, so let's try to crack it with hashcat:

```text
hashcat -m 3200 jonah.hash /usr/share/wordlists/rockyou.txt
```

After a little while, it worked :

![User pass](/images/2021/03/DailyBugle_User_Pass.png)

Doing a little more internet research, I found that there is another vuln in Joomla that allows an [admin user to get reverse shell](https://vk9-sec.com/reverse-shell-on-any-cms/)...

### Getting Initial Shell

According to the link above, I edited a php file from an existing theme, replacing it with a `PHP reverse shell` (the one from Kali / Parrot, located in `/usr/share/webshell`), saved it, and called the URL : `http://$target_ip/templates/beez3/index.php` where `beez3` is the theme's name and `index.php` the file I edited.

It got me my foothold :

![Initial Shell](/images/2021/03/DailyBugle_Initial_Shell.png)

We are `www-data` user, (un)fortunately and need to privesc!

### PrivEsc

In order to do so, I downloaded and ran `linpeas.sh` on the target. 

After a little while, it discovered interesting information such as `jjameson` user, a password in Joomla's `configuration.php`, and other things... As always, I was looking for an easy win, and tried to connect via SSH with the credentials I found... and it worked!

I was now, in as `jjameson` with a real shell, stable connection and easy way to come back in!

First command I issued was `sudo -l` in order to see if I could do anything as `root`. It turns out, I was allowed to run `yum`, which was very promising.

A quick look at [GTFObins](https://gtfobins.github.io/gtfobins/yum/#sudo) confirmed another easy win was probably coming. I simply copied/pasted (but also analyzed it, to make sure I understood what it did; there is no learning if you blindly copy/paste) the bits of code, and got a `root shell` :

![Root Shell](/images/2021/03/DailyBugle_Root_Shell.png)

## Outro
I found this box quite "straightforward" and very fun : chaining multiple vulns, in order to get a shell, then user misconfiguration in order to pwn a specific user and finally become `root`! 

I am pretty sure, there are other ways to get `root` on this box (maybe with `kernel`, or `sudo` directly), but for once, I wanted to go the "intended" way.