---
title: "Upgrading Shells!"
date: 2021-05-21T11:13:05+01:00
categories: []
tags: []
---
Upgrading shells

## python method
`python -c 'import pty; pty.spawn("/bin/bash")'`

## script method
`SHELL=/bin/bash script -q /dev/null`

## common stuff
* Then type CTRL+Z ;
* Type `stty raw -echo;fg` then `reset`.

NB: If asked "terminal type", enter `xterm-color`.

Also, make sure to use / test with sh, bash, etc. And python, python2, python3, etc.