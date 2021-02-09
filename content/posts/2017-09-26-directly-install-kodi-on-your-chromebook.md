---
title: Directly Install Kodi on your Chromebook
date: 2017-09-26 13:56:38.000000000 +02:00
categories:
- chromebook
tags:
- kodi
permalink: "/directly-install-kodi-on-your-chromebook/"
FeaturedImage: "/images/2016/04/Chromebook.jpg"
---
Thanks to [Zach](https://www.masoopy.com/install-latest-kodi-chromeos/#comment-3496118744), we now have a great way to install Kodi on our Chromebook.

## Switch your Chromebook to developper's mode

In order to install Kodi on Chrome OS, we’ll need to install a proper Linux system. Don’t worry, this is done easily thanks to the [crouton](https://github.com/dnschneid/crouton) script.

**NB : be aware that turning developer’s mode ON, will delete ALL your data on the device!**

First of all you have to turn on the developer’s mode on your device. Let’s do it!

1. While the computer is powered on. Press Esc + Refesh + Power ;
2. Device will reboot with a warning message, hit CTRL + D to continue;
3. Then hit Enter to confirm the Developer’s mode;
4. Device will reboot again, hit again CTRL + D to proceed.

NB : every time you see that bugging screen at boot, you can pass it with CTRL+D

What really bugs me with developers mode, is that you have to press CTRL+D on each cold boot or it’ll emits a double bip, and takes more time to boot (so that you can read and re read, and re re read, the warning screen).

## Install Kodi on your Chromebook

Now that you are in developer’s mode, you are ready to install Linux with crouton. But what is Crouton? Crouton is a tool that will enable to create “chroot” installation a various Linux distribution. Basically, a “chroot” is a bit like a virtual machine, or box that sits inside your computer and allows you to run another (or several) “virtual” computer inside your physical one.

In our case, it will allow us to install a “real” Linux inside the ChromeOS. Which means we will have a full standard working computer&nbsp;inside the limited ChromeOS computer. We will call this, our Kodi instance.

Your computer should be “brand new”, with no data at all in it. Set ip up as usual with your Google account and Wi-Fi settings. Then, the fun starts.

- Open Chrome browser;
- Download the latest version of crouton, [right here](http://goo.gl/fd3zc);
- Hit CTRL + ALT + T (it will open a new scary tab in Chrome), this is called a terminal emulator;![[shell](/images/2017/09/chromebook_shell-300x169.jpg)](/images/2016/04/chromebook_shell.jpg)
- Enter

`shell`

The “shell” appearance should slightly change;![[shell root](/images/2017/09/chromebook_shell_root-300x169.jpg)](/images/2016/04/chromebook_shell_root.jpg)

- Enter the following command to create the “chroot”.

`sudo sh ~/Downloads/crouton -t kodi -n kodi`

NB : with -t being the "target" and -n the name of the instance.

Wait for the process to complete, it will take a few minutes and text will scroll on your screen. Don’t close the tab, but you can keep you using your computer / navigating on other tabs.

At some point, inside the tab we ran the previous command, **it will ask you for a login and password**. Enter anything you like, it doesn’t have to be your Google credentials. Actually, it is even better if you use any other credentials. You’ll then use them to log in Linux. The way it works, when you are prompted for your password, nothing will seem to happen. This is expected. Just enter you password once, hit Enter and confirm it.

Wait for the process to finish.

## And… that’s it !

Now every time you want to run Kodi, open a Shell in Chrome by hitting **CTRL+ALT+T** and just type :

`sudo startkodi`

That's it! Kodi should start up, and run with the sound and everything working as expected!

**NB** : please note that in order to have sound, your sound must be turned on both on the "ChromeOS" side, and the Kodi instance.

NB : you can switch from/to ChromeOS and from/to Kodi instance by hitting CTRL + ALT + SHIFT + Forward (or Backward). Forward and Backward are the keys on the right of the Esc key. You might have to press it a couple of times, for it to work.

