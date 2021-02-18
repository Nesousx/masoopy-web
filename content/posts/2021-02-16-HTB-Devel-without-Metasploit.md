---
title: "HTB - Devel without MetaSploit"
date: 2021-02-16T15:26:14+01:00
draft: true
categories: ["hacking", "write-ups"]
tags: [HTB]
featuredImage: "/images/2021/02/Devel_Logo.png"
aliases:
   - /htb-devel-without-metasploit/
   - /htb-devel/
---

## Intro
Pretty fast and obvious box. Let me guide through my pwn:

## Target
[HTB - Devel](https://app.hackthebox.eu/machines/3)

## Recon
Usual recon here, based on logo and info :

* Windows box ;
* Misc : FTP, [Arbitrary file upload](https://owasp.org/www-community/vulnerabilities/Unrestricted_File_Upload).

## Enum
We run our classic `nmap` scan:

```text
sudo nmap -T4 -A -p- -oA nmap $target_ip
```

```text
# Nmap 7.91 scan initiated Tue Feb 16 14:42:03 2021 as: nmap -T4 -A -p- -oA nmap $target_ip
Nmap scan report for $target_ip
Host is up (0.023s latency).
Not shown: 65533 filtered ports
PORT   STATE SERVICE VERSION
21/tcp open  ftp     Microsoft ftpd
| ftp-anon: Anonymous FTP login allowed (FTP code 230)
| 03-18-17  01:06AM       <DIR>          aspnet_client
| 03-17-17  04:37PM                  689 iisstart.htm
|_03-17-17  04:37PM               184946 welcome.png
| ftp-syst:
|_  SYST: Windows_NT
80/tcp open  http    Microsoft IIS httpd 7.5
| http-methods:
|_  Potentially risky methods: TRACE
|_http-server-header: Microsoft-IIS/7.5
|_http-title: IIS7
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Device type: general purpose|phone|specialized
Running (JUST GUESSING): Microsoft Windows 8|Phone|2008|7|8.1|Vista|2012 (92%)
OS CPE: cpe:/o:microsoft:windows_8 cpe:/o:microsoft:windows cpe:/o:microsoft:windows_server_2008:r2 cpe:/o:microsoft:windows_7 cpe:/o:microsoft:windows_8.1 cpe:/o:microsoft:windows_vista::- cpe:/o:microsoft:windows_vista::sp1 cpe:/o:microsoft:windows_server_2012
Aggressive OS guesses: Microsoft Windows 8.1 Update 1 (92%), Microsoft Windows Phone 7.5 or 8.0 (92%), Microsoft Windows 7 or Windows Server 2008 R2 (91%), Microsoft Windows Server 2008 R2 (91%), Microsoft Windows Server 2008 R2 or Windows 8.1 (91%), Microsoft Windows Server 2008 R2 SP1 or Windows 8 (91%), Microsoft Windows 7 (91%), Microsoft Windows 7 Professional or Windows 8 (91%), Microsoft Windows 7 SP1 or Windows Server 2008 R2 (91%), Microsoft Windows 7 SP1 or Windows Server 2008 SP2 or 2008 R2 SP1 (91%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

TRACEROUTE (using port 21/tcp)
HOP RTT      ADDRESS
1   23.39 ms 10.10.14.1
2   23.58 ms $target_ip

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Tue Feb 16 14:43:43 2021 -- 1 IP address (1 host up) scanned in 100.14 seconds
```

Our scan reveals an open FTP and a web server. Based on our initial recon, I guess we'll have to upload a malicious file via FTP and run it via the IIS web server! 

Before attacking, we'll check `searchsploit` for anything interesting, but nothing will come up.

Let's start exploiting directly!

## Exploitation
The server is running IIS, so let's try to upload an `aspx` shell. 

A quick search brought me to [this one](https://raw.githubusercontent.com/tennc/webshell/master/fuzzdb-webshell/asp/cmd.aspx), I uploaded it inside the root of the web dir, and it worked !

![Initial Web Shell](/images/2021/02/Devel_Initial_Shell.png)

Unfortunately, we are not `SYSTEM` and can't even access user's flag which seems to be called `babis`. It's time to escalate our privileges! But first, we should do recon from inside, let's upload the `winpeas.bat` file and execute as below :

```text
"C:\inetpub\wwwroot\winPEAS.bat log" 
```

This will generate a lot of info about Windows version, patches applied (or not), user rights, etc. This is a goldmine!

### PrivEsc
Now, [from what I learned](http://www.fuzzysecurity.com/tutorials/16.html), a good way to escalate privileges is to look for missing patches and related vuln that would give those wanted priv.

Our WinPEAS log file showed the following:

```text
"Microsoft Windows 7 Enterprise   " 
   [i] Possible exploits (https://github.com/codingo/OSCP-2/blob/master/Windows/WinPrivCheck.bat)
MS11-080 patch is NOT installed XP/SP3,2K3/SP3-afd.sys)
MS16-032 patch is NOT installed 2K8/SP1/2,Vista/SP2,7/SP1-secondary logon)
MS11-011 patch is NOT installed XP/SP2/3,2K3/SP2,2K8/SP2,Vista/SP1/2,7/SP0-WmiTraceMessageVa)
MS10-59 patch is NOT installed 2K8,Vista,7/SP0-Chimichurri)
MS10-21 patch is NOT installed 2K/SP4,XP/SP2/3,2K3/SP2,2K8/SP2,Vista/SP0/1/2,7/SP0-Win Kernel)
MS10-092 patch is NOT installed 2K8/SP0/1/2,Vista/SP1/2,7/SP0-Task Sched)
MS10-073 patch is NOT installed XP/SP2/3,2K3/SP2/2K8/SP2,Vista/SP1/2,7/SP0-Keyboard Layout)
MS17-017 patch is NOT installed 2K8/SP2,Vista/SP2,7/SP1-Registry Hive Loading)
MS10-015 patch is NOT installed 2K,XP,2K3,2K8,Vista,7-User Mode to Ring)
MS08-025 patch is NOT installed 2K/SP4,XP/SP2,2K3/SP1/2,2K8/SP0,Vista/SP0/1-win32k.sys)
MS06-049 patch is NOT installed 2K/SP4-ZwQuerySysInfo)
MS06-030 patch is NOT installed 2K,XP/SP2-Mrxsmb.sys)
MS05-055 patch is NOT installed 2K/SP4-APC Data-Free)
MS05-018 patch is NOT installed 2K/SP3/4,XP/SP1/2-CSRSS)
MS04-019 patch is NOT installed 2K/SP2/3/4-Utility Manager)
MS04-011 patch is NOT installed 2K/SP2/3/4,XP/SP0/1-LSASS service BoF)
MS04-020 patch is NOT installed 2K/SP4-POSIX)
MS14-040 patch is NOT installed 2K3/SP2,2K8/SP2,Vista/SP2,7/SP1-afd.sys Dangling Pointer)
MS16-016 patch is NOT installed 2K8/SP1/2,Vista/SP2,7/SP1-WebDAV to Address)
MS15-051 patch is NOT installed 2K3/SP2,2K8/SP2,Vista/SP2,7/SP1-win32k.sys)
MS14-070 patch is NOT installed 2K3/SP2-TCP/IP)
MS13-005 patch is NOT installed Vista,7,8,2008,2008R2,2012,RT-hwnd_broadcast)
MS13-053 patch is NOT installed 7SP0/SP1_x86-schlamperei)
MS13-081 patch is NOT installed 7SP0/SP1_x86-track_popup_menu)
```

Inside this list, I narrowed it down in order to match the system I was attacking : `Windows 7 Enterprise 6.1.7600 N/A Build 7600`, which is `SP0` according to a quick web search.

Then I "randomly" (not totally randoms : it matches the target's OS) tried the `MS11-011` vuln, without luck. 

Then, I tried [MS10-059](https://github.com/SecWiki/windows-kernel-exploits/tree/master/MS10-059).  For this one, I had to run a listener on my attack box, then run the malicious file like shown below :

![Devel S10-059](/images/2021/02/Devel_MS10_059.png)

NB : I simply uploaded the malicious file via FTP to the `wwwroot` dir.

And it got me `SYSTEM` :

![Devel SYSTEM](/images/2021/02/Devel_SYSTEM.png)

Now getting `user` and `root` flags was just a matter of browsing to the correct directories and printing the content of the files:

![Devel User Flag](/images/2021/02/Devel_User_Flag.png)

![Devel Root Flag](/images/2021/02/Devel_Root_Flag.png)

## Outro

After my [debacle](https://www.masoopy.com/htb-netmon/) from the last box, it felt awesome to be able to pwn this one easily. I feel my efforts are starting to pay off and that I begin to get the "hang of it". Hacker's mind in coming, and it is good!