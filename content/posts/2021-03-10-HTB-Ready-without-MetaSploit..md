---
title: "HTB - Ready without MetaSploit"
date: 2021-03-10
draft: true
categories: ["hacking", "write-ups"]
tags: [HTB]
featuredImage: "/images/2021/03/Ready_Logo.png"
---
## Intro

## Target
[HTB - Ready](https://app.hackthebox.eu/machines/304)

## Recon
From logo and box' info we learn that :

## Enum
Let's start a full `nmap` scan :

```text
sudo nmap -sC -sV -oA scans/$target_ip
```
```text
Starting Nmap 7.91 ( https://nmap.org ) at 2021-03-10 17:09 CET
Nmap scan report for ready.htb (10.129.111.161)
Host is up (0.026s latency).
Not shown: 998 closed ports
PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 8.2p1 Ubuntu 4 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey:
|   3072 48:ad:d5:b8:3a:9f:bc:be:f7:e8:20:1e:f6:bf:de:ae (RSA)
|   256 b7:89:6c:0b:20:ed:49:b2:c1:86:7c:29:92:74:1c:1f (ECDSA)
|_  256 18:cd:9d:08:a6:21:a8:b8:b6:f7:9f:8d:40:51:54:fb (ED25519)
5080/tcp open  http    nginx
| http-robots.txt: 53 disallowed entries (15 shown)
| / /autocomplete/users /search /api /admin /profile
| /dashboard /projects/new /groups/new /groups/*/edit /users /help
|_/s/ /snippets/new /snippets/*/edit
| http-title: Sign in \xC2\xB7 GitLab
|_Requested resource was http://ready.htb:5080/users/sign_in
|_http-trane-info: Problem with XML parsing of /evox/about
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 13.48 seconds
```

## Exploitation

Create a git account : bob / plop1234 ;
Create repo ; 
Clone repo : git clone http://ready.htb:5080/bob/test.git ;
Test payload, and upload it!

### Getting Initial Shell

### PrivEsc

## Outro
