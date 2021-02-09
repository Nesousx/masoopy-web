---
title: Install Windows programs like a boss with Ninite
date: 2018-11-17 23:36:57.000000000 +01:00
categories:
- windows
tags:
- automation
- ninite
permalink: "/install-windows-programs-like-a-boss-with-ninite/"
FeaturedImage: "/images/2021/02/ninite.png"
---
Do you remember how you used to install programs under Windows several years ago? Next, next, next... Are you still doing it the exact same way today? If that's so, I may have something of interest for you, keep reading !

## Windows' programs' installation is so painful

I don't know about you, but I am quite pissed off with the way "software" works on Windows. Let's say you want to install [VLC](https://www.videolan.org/vlc/) to watch movies, then you have to fire up your web browser, go to VLC website (probably via a search engine), find the correct version (32 or 64 bits), download the product, and install it. Rinse and repeat in order to keep your software updated...

## The Linux way

In order to give an element of comparison, installing a program under Linux is totally different, and more user friendly. You have to fire up your "[software manager program](https://help.ubuntu.com/community/UbuntuSoftwareCenter?action=show&redirect=SoftwareCenterFAQ)", search for VLC, and click install! That's it, VLC will be automatically installed with the most appropriate version (32 or 64 bits), concerning the updates, no need to think about them : your operating system will update it automagically on a regular basis (think of a working Windows update tool that also includes updates for any program that is installed on your system, like VLC or Steam). This is very similar to the way your phone works !

The way Linux manages installation of software is done via "repositories". It is some kind of huge catalog that holds several software in the same "place" and keep them updated. From the user perspective, everything is "centralized" : it means the user can manage all its software needs in one place. However, have in mind, that on the "developer" or "system" side, this is not centralized at all. There are several copies of every software all around the world! Just in case a location "fails", there will be another one available... or just a closer location to the final user in order to reduce download times.

## Please welcome Ninite

Some smart people (a lot smarter than me!) have decided to create similar systems for Windows. Such systems are called [Chocolatey](https://chocolatey.org/), or Ninite. While Chocolatey can be more intimidating, Ninite is very easy to use.

[Just browse to their official website](https://ninite.com/), and simply check the boxes corresponding to the programs you want to install on your system. Once you are done "free shopping", just hit the "Get your Ninite" button at the bottom of the page. This should automatically download a very small file.

![[ninite](/images/2018/11/ninite-1024x564.png)](/images/2018/11/ninite.png)

Now, you just have to run the aforementioned file from your computer, and it'll try to install every software you "included" in it:

- If the program is already installed, and up to date, it will try to install the next one ;
- if the program is already installed but not up to date, it'll download the latest version and update it ;
- If the program is not installed, it will download and install it.

Finally, if you need to update your programs, let's say a few weeks after the initial install, just run the Ninite installer once again. You could also set up a scheduled task to automatically run the Ninite updater once in a while. This is however, not perfect since, the Ninite installer will "pop up" on your screen... only the Pro version as a "silent" mode that runs in the background without bugging you.

## Last but not least...

Ninite "classic" (as compared to Pro version, with silent installer for example) is totally free.

It only contains "approved" apps : which means those apps come without any spyware / adware or any additional unwanted software. Remember when you installed Avast and it automatically checks a box to install Google Chrome as well? It won't happen here!

Finally, Ninite is compatible with every version of Windows (from XP to 10), and the corresponding "server" version.

If you are still reading this article, I believe you are not using Windows... or you are already using Ninite. [Come on, go manage your preferred app in a clever way, now](https://ninite.com/)!

