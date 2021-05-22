---
title: "Upgrading Shells!"
date: 2021-05-21T11:13:05+01:00
categories: []
tags: []
---
Here are a few ways to upgrade a basic shell to a better interactive one !

## Use a method depending on what is installed on the remote system

### Python
`python -c 'import pty; pty.spawn("/bin/bash")'`


### Script
`SHELL=/bin/bash script -q /dev/null`

## Common stuff
* Then type CTRL+Z ;
* Type `stty raw -echo;fg` then `reset`.

NB: If asked "terminal type", enter `xterm-color`.

Also, make sure to use / test with sh, bash, etc. And python, python2, python3, etc.