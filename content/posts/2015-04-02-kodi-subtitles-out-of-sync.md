---
title: Kodi subtitles out of sync
date: 2015-04-02 15:09:26.000000000 +02:00
categories:
- kodi
tags:
- kodi
- kodi xbmc
- subtitles
- xbmc
permalink: "/kodi-subtitles-out-of-sync/"
FeaturedImage: "/images/2021/02/kodi_sub_out_sync.png"
---
[#Kodi](https://www.masoopy.com/tag/kodi/) [#subtitles](https://www.masoopy.com/tag/subtitles/) out of sync?! Yes it happens! Most of the time it can be fixed thanks to the GUI, but sometimes you want to be able to resync them for more or less than 10 seconds, here is what you need to do.

- Locate advancedsettings.xml. Based on your OS, it will be in the following locations:

**Windows:**

Click Start Menu, then Run and enter the following command :

%APPDATA%kodiuserdata

**Mac OS:**

Browse to:

/Users/YourPseudo/Library/Application Support/kodi/userdata/

NB : make sure to replace YourPseudo by your real pseudo / username.

**Linux based (including OpenElec):**

Browse to:

$HOME/.kodi/userdata/

- Search and replace the desired value, as follow:

10

for example, if you want 60 secondes, edit like this:

60

- Restart Kodi.
