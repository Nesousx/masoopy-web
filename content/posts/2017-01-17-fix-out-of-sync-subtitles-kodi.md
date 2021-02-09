---
title: Fix out of sync subtitles with Kodi
date: 2017-01-17 16:04:58.000000000 +01:00
categories:
- kodi
tags: []
permalink: "/fix-out-of-sync-subtitles-kodi/"
FeaturedImage: "/images/2021/02/fix_oos_sub_kodi.png"
---
## Oh, man!

[#Kodi](https://www.masoopy.com/tag/kodi/) [#subtitles](https://www.masoopy.com/tag/subtitles/) out of sync?! Yes it happens! Most of the time it can be fixed thanks to the GUI, but sometimes you want to be able to resync them for more or less than 10 seconds, here is what you need to do.

## File to edit

Locate `advancedsettings.xml`. Based on your OS, it will be in the following locations:

### Windows

Click Start Menu, then Run and enter :

```text
%APPDATA%kodiuserdata
```

then press `enter`.

### Mac OS

Browse to:

```text
/Users/YourPseudo/Library/Application Support/kodi/userdata/
```

NB : make sure to replace YourPseudo by your real pseudo / username.

### Linux based (including OpenElec)

Browse to:

```text
$HOME/.kodi/userdata/
```

Search and replace the desired value, as follow:

`10`

for example, if you want 60 secondes, edit like this:

`60`

## One last step...

Restart Kodi!
