---
title: "THM - Skynet without MetaSploit"
date: 2021-02-27
draft: true
categories: ["hacking", "write-ups"]
tags: [THM]
featuredImage: "/images/2021/02/Skynet_Logo.png"
---
## Intro

## Target
[THM - Skynet](https://tryhackme.com/room/skynet)

## Recon
Not much recon here. Contrary to our previous targets which were "training boxes", this one is doesn't hold your hand. Let's directly enumerate it!

## Enum
Usual `nmap` scan :

```text
sudo nmap -T4 -A -p- -oA scan $target_ip
```
```text
| smb-os-discovery:
|   OS: Windows 6.1 (Samba 4.3.11-Ubuntu)
|   Computer name: skynet
|   NetBIOS computer name: SKYNET\x00
|   Domain name: \x00
|   FQDN: skynet
|_  System time: 2021-02-27T02:05:39-06:00
| smb-security-mode:
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
| smb2-security-mode:
|   2.02:
|_    Message signing enabled but not required
| smb2-time:
|   date: 2021-02-27T08:05:39
|_  start_date: N/A

TRACEROUTE (using port 995/tcp)
HOP RTT      ADDRESS
1   31.41 ms 10.11.0.1
2   31.82 ms 10.10.223.240

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Sat Feb 27 09:05:36 2021 -- 1 IP address (1 host up) scanned in 51.35 seconds
```
we find the following `Samba` shares :

![SMB List](/images/2021/02/Skynet_SMB_List.png)

Enumerating them further will reveal juicy info inside `anonymous` such as passwords' list and a message telling us that all employees are required to change their passwords.


`Nikto` and `gobuster` will reveal a `SquirrelMail version 1.4.23 [SVN]` installation :

![SquirreMail Login](/images/2021/02/Skynet_Squirremail_Login.png)

## Exploitation
Now, using `Burp`, we'll try some [credentials stuffing](https://en.wikipedia.org/wiki/Credential_stuffing) in order to login. From our first SMB recon, we discovered a plausible user : `milesdyson`, and a list of passwords. 

In the intruder's tab set up a `sniper` attack, using `milesdyson` as user and the password field as the only payload :

![Burp Payload](/images/2021/02/Skynet_Burp_Intruder_1.png)

Now, load the password list found during SMB enumeration :

![Burp Password](/images/2021/02/Skynet_Burp_Intruder_2.png)

And finally, we add a "grep condition" in order to filter our results :

![Burp grep](/images/2021/02/Skynet_Burp_Intruder_3.png)

After a little while, we find a working set of credentials: 

![Burp Pass Found](/images/2021/02/Skynet_Burp_Intruder.png)

and we are in Miles' mailbox !

Now, reading Miles' email, we'll find a password for Samba :

![Samba Pass](/images/2021/02/Skynet_SMB_Pass.png)

We can now use is in order to connect to the Samba share, like so : `smbclient \\\\skynet.thm\\milesdyson -U milesdyson`

![Samba Miles List](/images/2021/02/Skynet_SMB_Miles.png)

Exploring the share will reveal an odd file called `important.txt`. Inside this file, we learn the existence of new `CMS` located at : `http://skynet.thm/45kra24zxs28v3yd/`.

Further scanning reveals admin page :

![Samba Nikto CMS](/images/2021/02/Skynet_Nikto_CMS.png)

Doing a quick search, we'll find the `Cuppa CMS` is vulnerable to [RFI/LFI](https://www.exploit-db.com/exploits/25971).

### Getting Initial Shell
We craft the URL to match our target, replacing `cuppa` by `administrator`, set up a `listener` and get initial shell :

![Skynet Initial Shell](/images/2021/02/Skynet_Initial_Shell.png)

We harvest `user's flag` in `milesdyson`'s home folder :

![Skynet User Flag](/images/2021/02/Skynet_User_Flag.png)

### PrivEsc

We download our classic tools to the box and launch them. Unfortunately here, I didn't find anything obvious. I tried a few probable exploits, such as `dirtyc0w`, and a few others, but nothing worked.

Finally, I paid closer attention to kernel version, and notice that `4.8.0-58-generic` might be [vulnerable](https://www.exploit-db.com/exploits/43418).

After a few quick step of download, compile, "send" to target, I was ready to run it, and BOOM! it worked:

![Skynet Root Shell](/images/2021/02/Skynet_Root_Shell.png)

Now, we collect `root's flag` :

![Skynet Root Flag](/images/2021/02/Skynet_Root_Flag.png)

## Outro
