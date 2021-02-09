---
title: Resume video playing with Kodi
date: 2017-07-19 15:29:33.000000000 +02:00
categories:
- kodi
tags: []
permalink: "/resume-video-playing-kodi/"
FeaturedImage: "/images/2021/02/resume_video_kodi.png"
---
Recently, I noticed a weird behaviour where Kodi no longer asks me to resume playing. Let me show you how to force that feature so that it works again.

## Get your hands dirty

Unfortunately you will have to go inside the [advancedsettings.xml](http://kodi.wiki/view/HOW-TO:Modify_automatic_watch_and_resume_points) file.

Locate the file in question and open it with a regular text editor (like notepad, not Word). Depending on your system, here is where you’ll find the file:

- Android –> `Android/data/org.xbmc.kodi/files/.kodi/userdata/` (see note)
- iOS –> `/private/var/mobile/Library/Preferences/Kodi/userdata/`
- Linux –> `~/.kodi/userdata/`
- Mac –> `/Users/<your_user_name>/Library/Application Support/Kodi/userdata/` (see note)
- LibreELEC –> `/OpenELEC /storage/.kodi/userdata/`
- Windows —> `Start` – type `%APPDATA%kodiuserdata` – press `Enter`

NB: if the file doesn’t exists, create it. if it is already there, be careful in the next step when you paste date (ie: do not make duplicate lines).

Once, you found the file, just paste the following into it:

```text
<advancedsettings> 
<video>
<playcountminimumpercent>90</playcountminimumpercent> 
<ignoresecondsatstart>180</ignoresecondsatstart> 
<ignorepercentatend>8</ignorepercentatend> 
</video> 
</advancedsettings>
```

## Enjoy!

Save the file, restart Kodi, test it…

And.. that’s all folk!

