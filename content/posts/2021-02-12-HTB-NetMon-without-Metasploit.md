---
title: "HTB - NetMon without MetaSploit"
date: 2021-02-12T14:56:25+01:00
categories: ["hacking", "write-ups"]
tags: [HTB]
featuredImage: "/images/2021/02/NetMon_Logo.png"
aliases:
    - /htb-netmon-without-metasploit/
    - /htb-netmon/
---
An easy box according to HTB ranking and a not so easy one according to [this site](https://docs.google.com/spreadsheets/u/1/d/1dwSMIAPIam0PuRBkCiDI88pU3yzrqqHkDtBngUHNCw8/htmlview#). For me, it was really painful. Let me overshare!

## Recon

Quick recon based on HTB logo and info :

* Windows box ;
* Misc info : web, PowerShell, file misconfiguration ;
* Probably runs PRTG NetWork Monitor tool.

## Enum

```text
sudo nmap -T4 -A -p- -oA nmap $target_ip
```
```text
Starting Nmap 7.91 ( https://nmap.org ) at 2021-02-12 15:25 CET
Nmap scan report for $target_ip
Host is up (0.056s latency).
Not shown: 65522 closed ports
PORT      STATE SERVICE      VERSION
21/tcp    open  ftp          Microsoft ftpd
| ftp-anon: Anonymous FTP login allowed (FTP code 230)
| 02-02-19  11:18PM                 1024 .rnd
| 02-25-19  09:15PM       <DIR>          inetpub
| 07-16-16  08:18AM       <DIR>          PerfLogs
| 02-25-19  09:56PM       <DIR>          Program Files
| 02-02-19  11:28PM       <DIR>          Program Files (x86)
| 02-03-19  07:08AM       <DIR>          Users
|_02-25-19  10:49PM       <DIR>          Windows
| ftp-syst:
|_  SYST: Windows_NT
80/tcp    open  http         Indy httpd 18.1.37.13946 (Paessler PRTG bandwidth monitor)
|_http-server-header: PRTG/18.1.37.13946
| http-title: Welcome | PRTG Network Monitor (NETMON)
|_Requested resource was /index.htm
|_http-trane-info: Problem with XML parsing of /evox/about
135/tcp   open  msrpc        Microsoft Windows RPC
139/tcp   open  netbios-ssn  Microsoft Windows netbios-ssn
445/tcp   open  microsoft-ds Microsoft Windows Server 2008 R2 - 2012 microsoft-ds
5985/tcp  open  http         Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Not Found
47001/tcp open  http         Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Not Found
49664/tcp open  msrpc        Microsoft Windows RPC
49665/tcp open  msrpc        Microsoft Windows RPC
49666/tcp open  msrpc        Microsoft Windows RPC
49667/tcp open  msrpc        Microsoft Windows RPC
49668/tcp open  msrpc        Microsoft Windows RPC
49669/tcp open  msrpc        Microsoft Windows RPC
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.91%E=4%D=2/12%OT=21%CT=1%CU=31327%PV=Y%DS=2%DC=T%G=Y%TM=6026908
OS:3%P=x86_64-pc-linux-gnu)SEQ(SP=105%GCD=1%ISR=10B%TI=I%CI=I%II=I%TS=A)SEQ
OS:(SP=105%GCD=1%ISR=10B%TI=I%CI=I%II=I%SS=S%TS=A)OPS(O1=M54DNW8ST11%O2=M54
OS:DNW8ST11%O3=M54DNW8NNT11%O4=M54DNW8ST11%O5=M54DNW8ST11%O6=M54DST11)WIN(W
OS:1=2000%W2=2000%W3=2000%W4=2000%W5=2000%W6=2000)ECN(R=Y%DF=Y%T=80%W=2000%
OS:O=M54DNW8NNS%CC=Y%Q=)T1(R=Y%DF=Y%T=80%S=O%A=S+%F=AS%RD=0%Q=)T2(R=Y%DF=Y%
OS:T=80%W=0%S=Z%A=S%F=AR%O=%RD=0%Q=)T3(R=Y%DF=Y%T=80%W=0%S=Z%A=O%F=AR%O=%RD
OS:=0%Q=)T4(R=Y%DF=Y%T=80%W=0%S=A%A=O%F=R%O=%RD=0%Q=)T5(R=Y%DF=Y%T=80%W=0%S
OS:=Z%A=S+%F=AR%O=%RD=0%Q=)T6(R=Y%DF=Y%T=80%W=0%S=A%A=O%F=R%O=%RD=0%Q=)T7(R
OS:=Y%DF=Y%T=80%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%T=80%IPL=164%UN=0%
OS:RIPL=G%RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=80%CD=Z)

Network Distance: 2 hops
Service Info: OSs: Windows, Windows Server 2008 R2 - 2012; CPE: cpe:/o:microsoft:windows

Host script results:
| smb-security-mode:
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
| smb2-security-mode:
|   2.02:
|_    Message signing enabled but not required
| smb2-time:
|   date: 2021-02-12T14:28:15
|_  start_date: 2021-02-12T14:02:36

TRACEROUTE (using port 8888/tcp)
HOP RTT      ADDRESS
1   59.00 ms 10.10.14.1
2   59.12 ms $target_ip

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 152.62 seconds
```
We find a few interesting services :

* FTP server (21/tcp) : Microsoft ftpd, with anonymous login enabled ;
* Web server (80/tcp) : Indy httpd 18.1.37.13946 (Paessler PRTG bandwidth monitor) ;
* Remote powershell (5985/tcp) ;
* SMB and Netbios related services on ports 135/tcp, 139/tcp and 445/tcp ;
* HTTPAPI httpd 2.0 (SSDP/UPnP) on 47001/tcp ;
* Several high ports fo RPC.

Nikto scan reveals `PRTG` version `18.1.37.13946`, and the webpage displays a login page.

![Netmon Login](/images/2021/02/NetMon_PRTG_Login.png)

Default and common credentials won't work here.

Looking up `PRTG` on `searchploit` won't give us much : an authenticated RCE and a DoS exploit... and yes it works! But as fas I know, it is useless in our case. It means we'll have to dig deeper. Before that, let's continue to sratch the surface for other services, we are looking for an easy win! :)

We can also enumerate smb shares :

```text
nmap -p 445 --script=smb-enum-shares.nse,smb-enum-users.nse $target_ip
```
but nothing comes up!

Let's explore the FTP server. Here, we have access to quite a lot of files such as :

* Program Files ;
* Program Files (x86) (we now know that our OS is 64 bits) ;
* Users, Windows, Inetpub, etc.

In the `Users\Public` folder we will find our user flag.

![NetMon User Flag](/images/2021/02/NetMon_user_flag.png)

Now, I am guessing that the most relevant folder will be `/Program Files (x86)/PRTG Network Monitor` in which we might find useful info such as installation logs, and maybe even credentials if we are super lucky.

So far, we haven't found much... My guess is still with PRTG logs or something similar. I will then explore PRTG folder for anything interesting, and also common places we might have access to.

In order to make exploration more easier, I am using `FileZilla`.

## Exploitation

Enumerating username in the "Forgot password" page, tells us that the default `ptrgadmin` user exists :

![NetMon Forgot Password OK](/images/2021/02/NetMon_forgot_pass_OK.png)

Notice the slightly different error message when testing with a fake username (username == `zjdpdjpo`) :

![NetMon Forgot Password NOK](/images/2021/02/NetMon_forgot_pass_NOK.png)

While researching on internet where PRTG stores its credentials, I came across a few pages where it seems that our version leaks clear text password in the `ProgramData` folder. Now, I tried to access this folder from my FTP client and couldn't do it... I have been stuck here for HOURS! So I cheated, and checked official walk through. It turns out, I made a typo... and one can access the said folder and get some juicy files, especially `PRTG Configuration.old.bak`. Inside this file, we'll find Graal (or, do we?) :

![NetMon Credentials](/images/2021/02/NetMon_credentials.png)

Once again, and I have no idea why this time (probably another typo?) I also went stuck for too long. The password in the backup file ends in 2018, but unfortunately it doesn't work. One can assume it is an old password, and the year has changed, so has the password. Hence, I tried to replace the year with 2019, 2020, 2021 and even 2022 (current year + 1)... Nothing worked... I was really feeling down and cheated, again. It happens that the second password I tested was the correct one! I tried it again, and this time, it worked and I was finally inside the admin panel!

Now that we are authenticated, it is finally time to check our [Authenticated RCE we found earlier](https://www.exploit-db.com/exploits/46527).

We need to grab our authenticated cookie, `Burp Suite` can do that easily, then run the following command :

```text
./prtg-exploit.sh -u http://$target_ip -c "_ga=GA1.4.XXXXXXX.XXXXXXXX; _gid=GA1.4.XXXXXXXXXX.XXXXXXXXXXXX; OCTOPUS1813713946=XXXXXXXXXXXXXXXXXXXXXXXXXXXXX; _gat=1"
```
Once it is done, the script should have created a new admin user called `pentest`.

Now, remember we also found a remote powershell running? Time to use it! I found that using a Powershell's docker was pretty easy :

```text
docker run -it  quickbreach/powershell-ntlm
```

From here, we connect to our remote machine :

```text
Enter-PSsession -ComputerName $target_ip -Authentication Negotiate -Credential pentest
```

One we are in as `SYSTEM`, we simply browse to the flag dir and display it :

![NetMon Root Flag](/images/2021/02/NetMon_root_flag.png)

## Conclusion

While everything seemed pretty straightforward I spent way more time than I care to admit for stupid mistakes on my side. Which in the end made it a very exhausting box for me. Once again, we saw how nasty a few misconfiguration + CVE can be!

