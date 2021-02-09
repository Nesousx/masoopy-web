---
title: How to burn an iso file to USB stick
date: 2017-09-14 06:52:00.000000000 +02:00
categories:
- wiki
tags:
- wiki
permalink: "/how-to-burn-an-iso-file-to-usb-stick/"
FeaturedImage: "/images/2021/02/burn_iso_2_usb.png"
---
Let's see how to "burn" an image file (or .iso file) to an USB stick and make it bootable.

**NB: please note that in every case, all the data on your USB stick will be erased!!**

## Windows

Under Windows, simply download, install and run [Rufus](https://rufus.akeo.ie/). Then follow the on-screen instructions.

## Macos

Much like Windows, on Macos, you can use a tool called [Etcher](https://etcher.io/) and follow the on-screen instructions.

## Linux

Now, it becomes a little harder / funnier. You have two main solutions:

- command-line (aka cli) ;
- visually.

### Visually

From, you need to install (again, visually, or via cli). Try to click on the following link: [install unetbootin](apt:unetbootin), or browse the menu of your operating system to "Software center" or "Add/remove program" place. Once there, search for a software called "unetbootin" and install it.

Once it is installed, run it and follow the on-screen insctructions.

You can also install the tool via the command-like, like below.

Open a terminal window, and enter the following command:

With Ubuntu (or Ubuntu related distribution, such as Mint):

`sudo apt-get install -y unetbootin`

With Fedora (or Fedora related distribution, such as CentOS):

`sudo dnf install -y unetbootin`

Once it is installed, run it from the menu, and again, follow on-screen instructions.

### Via CLI

It might sound scary, but it is actually quite easy and very efficient.

Now, we will see how to completely burn your iso file to the USB stick, doing everything in command line and with no additional tool.

1. Fire up new terminal window ;
2. Plug-in your USB stick ;
3. Find out the name of your USB stick with the command:

`lsblk`

It should like this:

![Capture-d-e-cran-2017-09-13-a--13.46.40](/images/2017/09/Capture-d-e-cran-2017-09-13-a--13.46.40.png)

Now, check the size, and make sure it matches the one from your USB stick. Double check it is the right one (for example you can try to run the previous command with and without the USB stick, and see what "disk" appears/disappears).

In my case, it is sda (use the one without the number at the end), and we we see that it is 7.5G (which is sold as a 8GB disk). Since it is a device, you want to add /dev/ in front of it in order to have the real location.

**Which means the USB stick is located at /dev/sda**.

Once you have figured out the name, write it down (or memorize it).

1. Now enter the following command (make sure to replace what needs to be replaced according to your needs). This command will erase the USB disk. If you write the wrong disk name, it will wipe the wrong disk. be EXTRA careful.

`sudo dd if=/path/to/your/file.iso of=/path/of/usb bs=2M`

Now, what you need to replace is:

- "/path/to/your/file.iso", by the actual location of the image file;
- "/path/of/usb", by the USB stick location (without the number). This disk will be erased. Again, be careful.

It should take from a few minutes (like 5 to 10min), depending the speed of USB disk, port, etc.

Once it is finish, enter one last command:

`sudo umount /path/of/usb`

and again, replace it with the correct value.

Once, you have access to command line again, that's done. You can remove your USB stick.

