---
title: Install the Latest Kodi on ChromeOS
date: 2017-01-29 12:00:17.000000000 +01:00
categories:
- chromebook
tags: []
permalink: "/install-latest-kodi-chromeos/"
FeaturedImage: "/images/2016/04/Chromebook.jpg"
---
Android promised several months ago to add [Android support to ChromeOS devices](https://sites.google.com/a/chromium.org/dev/chromium-os/chrome-os-systems-supporting-android-apps?hl=en&rd=1). However, this is taking ages… For now, if you want to use Kodi on ChromeOS, your only solution is to use Crouton in order to install the latest Kodi on ChromeOS.

NB : you can find on older version of this tutorial in order to [install Kodi on a Chromebook](https://www.masoopy.com/install-kodi-chromebook/).

## Prepare the beast

In order to install Kodi on Chrome OS, we’ll need to install a proper Linux system. Don’t worry, this is done easily thanks to the [crouton](https://github.com/dnschneid/crouton) script.

**NB : be aware that turning developer’s mode ON, will delete ALL your data on the device!**

First of all you have to turn on the developer’s mode on your device. Let’s do it!

1. While the computer is powered on. Press Esc + Refesh + Power ;
2. Device will reboot with a warning message, hit CTRL + D to continue;
3. Then hit Enter to confirm the Developer’s mode;
4. Device will reboot again, hit again CTRL + D to proceed.

NB : every time you see that bugging screen at boot, you can pass it with CTRL+D

What really bugs me with developers mode, is that you have to press CTRL+D on each cold boot or it’ll emits a double bip, and takes more time to boot (so that you can read and re read, and re re read, the warning screen).

## Set up linux with crouton

Now that you are in developer’s mode, you are ready to install Linux with crouton. But what is Crouton? Crouton is a tool that will enable to create “chroot” installation a various Linux distribution. Basically, a “chroot” is a bit like a virtual machine, or box that sits inside your computer and allows you to run another (or several) “virtual” computer inside your physical one.

In our case, it will allow us to install a “real” Linux inside the ChromeOS. Which means we will have a full standard working computer&nbsp;inside the limited ChromeOS computer.

Your computer should be “brand new”, with no data at all in it. Set ip up as usual with your Google account and Wi-Fi settings. Then, the fun starts.

- Open Chrome browser;
- Download the latest version of crouton, [right here](http://goo.gl/fd3zc);
- Hit CTRL + ALT + T (it will open a new scary tab in Chrome), this is called a terminal emulator;![[shell](/images/2017/01/chromebook_shell-300x169.jpg)](/images/2016/04/chromebook_shell.jpg)
- Enter

shell

The “shell” appearance should slightly change;![[shell root](/images/2017/01/chromebook_shell_root-300x169.jpg)](/images/2016/04/chromebook_shell_root.jpg)

Please note the “ **-n kodi** ” flag (see next step) which allows us to name our chroot “kodi”. If you already have followed our previous guide, then you replace kodi by another name since it has to be unique. You can choose anything you like, just avoid spaces in the name. Then, you’ll have to use that name you just set up everywhere in this guide instead of the default “kodi” name.

Another solution, would be to delete the old **kodi** “chroot”. However, I would only do that if it doesn’t work at all.&nbsp;In order to do so, enter the following command:

sudo delete-chroot kodi

Ok, so you either deleted your old Kodi “chroot” or decided to rename the one we are about to create to something else.

- Enter the following command to create the “chroot”.

sudo sh ~/Downloads/crouton -r sid -t xfce -n kodi

Wait for the process to complete, it will take a few minutes and text will scroll on your screen. Don’t close the tab, but you can keep you using your computer / navigating on other tabs.

At some point, inside the tab we ran the previous command, **it will ask you for a login and password**. Enter anything you like, it doesn’t have to be your Google credentials. Actually, it is even better if you use any other credentials. You’ll then use them to log in Linux. The way it works, when you are prompted for your password, nothing will seem to happen. This is expected. Just enter you password once, hit Enter and confirm it.

Now, to run the Linux you just installed, you have to enter another command inside the “shell” tab.

Hit:

sudo enter-chroot -n kodi

You are now inside the “chroot’. It is a bit like a virtual machine, or like you installed a brand new computer inside your Chrome OS device. Which means, you now have 2 devices in one : Chrome OS is there, always, unchanged. And an extra “Linux” system you can run when you want to.

Let’s see how to install latest Kodi on Chrome OS, our last step.

## Install Latest Kodi on Chrome OS

You’ll notice that the prompt line start with (kodi). It means you are&nbsp;“inside” the kodi chroot we just installed.

Enter the following command :

sudo apt-get install -y kodi

Once it is done, just exit the chroot by typing “ **exit** ” or hitting **CTRL+D** on you keyboard.

## And… that’s it !

Now every time you want to run Kodi, open a Shell in Chrome by hitting **CTRL+ALT+T** and just type :

sudo enter-chroot -n kodi

then

startxfce4

Instead of those 2 commands, you would also directly try to only use:

sudo startxfce4

from the “shell” tab.

And it’ll run the XFCE dsktop in the “chroot” we just installed.

You can now run Kodi from the Menu inside the Multimedia category. I will say that is a pretty advanced tutorial, but if you have the “guts” to do it, then it’ll allow you to do huge things with a pretty cheap and decent piece of hardware that are Chrome OS.

This tutorial applies to any Chrome OS laptop and the beauty of having Linux on your Chrome OS is that you can do anything. This is a regular Kodi, in a regular Linux, no limitation at all.

I was afraid that Chrome OS would be pretty much locked down but actually once you activated that scary developer mode, you can do almost anything with ChromeOS, from installing Android apps, to Windows OS, and of course Linux.

You could even use a VPN with your Chromebook in order to add an extra layer of anonymity and security, and even (in some case) bypass geographical content locking. This is can be done really easily with [IPVanish](https://www.ipvanish.com/?a_aid=streamee&a_bid=48f95966) for example (a tutorial will be written soon).

NB : you can switch from/to ChromeOS and from/to Linux by hitting CTRL + ALT + SHIFT + Forward (or Backward). Forward and Backward are the keys on the right of the Esc key. You might have to press it a couple of times, for it to work.

