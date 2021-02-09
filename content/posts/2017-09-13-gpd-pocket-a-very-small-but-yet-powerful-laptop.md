---
title: GPD Pocket, a very small but yet powerful laptop
date: 2017-09-13 09:37:34.000000000 +02:00
categories:
- hardware
tags:
- gadget
permalink: "/gpd-pocket-a-very-small-but-yet-powerful-laptop/"
FeaturedImage: "/images/2021/02/gpd.png"
---
Let me present you my latest gadget, the GPD Pocket a full HD 7" quad core laptop, with 8GB RAM and 128GB storage. It runs Windows 10 and more importantly (to me), it also runs Linux!

## Quick specs

- Intel Atom® [x7-Z8750](http://ark.intel.com/products/93362/Intel-Atom-x7-Z8750-Processor-2M-Cache-up-to-2_56-GHz) Processor (quad core)
- 8GB RAM
- 128 GB storage (eeprom based)
- 7000 mAh battery (12 hours announced battery life)
- FHD 7" touch screen (1920x1200)

## Look and usage

I love the look! It is small, lightweight, and seems sturdy.

I just feel like carrying it around all the time. Just throw it in my backpack and forget it until I need it.

However, while it can be handy to have a "real" computer (as opposed to a phone or tablet) always with you, it is still a gadget.

Still if you only browse internet and do light computer usage, you could use this computer as your main computer, plugged to an external display, keyboard and mouse. Then, as soon as you leave home, unplug the beast and carry it around.

You could also use [the GPD as a mobile "pentest" station](https://www.evilsocket.net/2017/08/15/gpd-pocket-7-impressions-gnulinux-installation-and-offensive-setup/), for war driving, and that kind of stuff. This is what Simone is doing, and it is pretty cool!

## Install Ubuntu on GPD Pocket

In order to use it, I totally removed Windows and installed Ubuntu "custom" images from [here](http://apt.nexus511.net/). Let's see how to do it.

1. From your "regular" computer, grab the desired image from their [repo](https://gpd-iso.dandinoo.com/) ;
2. ["Burn" iso to USB stick](https://www.masoopy.com/how-to-burn-an-iso-file-to-usb-stick/);
3. Plug-in the USB Stick into the GPD and hit Del while powering it on in order to access the BIOS ;
4. Follow the steps on screen, when asked something about using UEFI only, say yes.
5. Wait for installation to complete, when asked removed USB stick and reboot computer.

The installation is over and you should now be able to login with the user you created during the installation.

Now, any time you want to update your machine, simple open a terminal and issue the following command:

`sudo apt update && sudo apt install gpdpocket`

While updating packages, pay attention to messages from your operating system. It might tell you that some packages were held back (especially kernel packages), if it does, "force install". For example it says package kernel-plop and kernel-bob were held back, then issue the following command:

`sudo apt-get install kernel-plop kernel-bob`

At the time of writing, the latest version seems to have fixed the issue with USB-C data, [making it now usable](https://twitter.com/Nexus511/status/906534190669332480). However, I havn't teste it yet, due to lack of hardware.

So far, we have a pretty cool tool running GNU/Linux, but unfortunately it is not perfect.

## Why you actually shouldn't buy it

The keyboard is really small, and the layout kinda sucks. It is is a non standard layout and it'll drive you crazy some (many?) times. I keep hitting the letter Q instead of TAB while in the terminal and it pisses me off...

The trackpoint looks like a thinkpad trackpoint but it is far less accurate... and you will do everything you can to avoid it. Some people will use the touchscreen, but I prefer to avoid mouses anyway and I daily use [tiling window managers](https://github.com/Airblader/i3).

If you start running some apps, it will be noisy... Of course you could [flash the BIOS](https://www.reddit.com/r/GPDPocket/comments/6q74en/unlocked_gpd_pocket_bios/)... but this might not be a good idea.

Indeed, GPD people seem to offer pretty poor support on BIOS, and unsupported BIOSes are... unsupported and NOT reliable from what I've read.

Moreover, when it breaks, or if you have hardware issue, support once again is less than average, [it seems](https://www.reddit.com/r/GPDPocket/comments/6sk56m/warning_gpd_kicking_support_back_to_dealer/)...

For all those reasons, you'd better to think twice, especially if you compulsive shopping disorder with this kind of devices like I do.

However, if you still wanna buy it, [go there](https://www.indiegogo.com/projects/gpd-pocket-7-0-umpc-laptop-ubuntu-or-win-10-os-laptop--2#/)!

