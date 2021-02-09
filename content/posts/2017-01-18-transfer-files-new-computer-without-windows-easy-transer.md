---
title: Microsoft let you down, Windows Easy Transfer is dead
date: 2017-01-18 00:43:07.000000000 +01:00
categories:
- windows
tags: []
permalink: "/transfer-files-new-computer-without-windows-easy-transer/"
FeaturedImage: "/images/2021/02/easy_trasnfer_is_dead.png"
---
Christmas is just over, you bought a fresh new computer and planned to run Windows Easy Transfer in order to move your data to the new computer? Plan again! Wndows Easy Transfer is dead and will not help you! Hopefully if you are here, unlike Microsoft I will help you.

## The good old Windows Easy Transfer

Until Windows 8.1, transfering files from an old Windows computer to a new one, was an easy process. All you had to do was fire up the official Microsoft Tool called Windows Easy Transfer (aka [WET](https://en.wikipedia.org/wiki/Windows_Easy_Transfer)). I am a Linux user, but I used this tool several times in order to move data for friends and familly, I am the familly geek. The one that gets call every now and then when something computerish (I insist on the ish) doesn’t work as expected.

## Microsoft killed it!

However, I have been surprised to discover, only a few days ago, that this tool no longer exists in Wndows 10. Microsoft replaced it with [Laplink PC Mover Express](http://www.laplink.com/index.php/fre/individuals/pcmover-for-windows/pcmover-express). The not so funny part is that this tool is NOT free (not free, as yes you have to pay for it even you already paid an expensive Windows licence).

Supposedly there was a free version during the first months of Windows 10, but it is no longer the case. Which means if you happen to buy a new computer and decide to move old files from the old one to the new one, then you’ll have no official / free / included solution available. That is a shame Mr. Microsoft!

## Alternatives to Windows Easy Transfer

Luckily enough for us, many other software editor decided to go down that road and are now offering similar software. Most of them are paid software but some of them are free.

It is important to note / know, that it is very highly recommended to keep the same username on the old and new computer.

### EaseUS TODO PCTrans

This is my favorite tool. I might be biased, because I already use their partition manager software.

Installation is fine and the software doesn’t try to install any additional crapeware like toolbars, or to make you switch to some other browser… This is much appreciated.

Once the program is installed on both computer, you can run it.

The program itself is pretty straightforward and do what’s needed take a backup of your files (and up to only 2 applications) on the old computer. Then you can restore this backup on the new computer.

Backup/restore can be done via external disks (faster and prefered method), or directlty by the network (from old computer to new computer).

I highly recommend to use the free version in order to backup your user directory located at :

C:UsersYourUsername

NB : change your username

Then, for applications, just use a tool like NInite to install as many as possible applications possible. If some of your applications are not available on NInite, you can add up to 2 applications with EaseUS TODO PCTrans. For the rest install them “manually”.

Please note that data related to applications is located in the folder you have just backuped. That’s to say, if you are using Firefox, then as soon as you install Firefox (even if you install it manually), it will look for its data inside the above folder&nbsp; and your session will be automagically restored with all your extension, browsing history, etc.

### Manual way

This is another good method. More advanced, but one that will works everywhere, everytime. But also one that requires a bit more work and hardware. Let’s call it the expert’s way.

For this method, you need to download any Linux Live CD. For example, go for Ubuntu as it is the most common one.

- Burn it to a DVD or make an USB bootable key.
- Boot the Live disk/key on the old computer.
- Once it has completely booted, you should be brought to a desktop, like the Windows desktop.
- Plug-in an external hard drive (the drive must have enough space to store the data you want to transfer).
- From here, there should be several icons on your desktop. We are particularly interested about 2 of them. The first one being the one for your WIndows disk and the second one being the one from the exterdan hard drive you have just plugged.
- Once, you figure out which is what. You just have to browse your old “Windows” disk and find the folder corresponding to your user. It should end like this:

Users/YouUsername

NB: make sure to change accordingly to your real username

- Once you have found this folder, right click on it and click Copy.
- Then, just like you would do with WIndows, browse to the external disk and right click on some blank space and click Paste.
- Once the copy is over. Shut off the computer, plug the bootable disk/key to the new computer.
- Proceed like before, but this time you’ll copy the data FROM the external disk TO the new Windows disk.
- Once copy is over, shutdown computer, unplug key/disks.

Then you can normally turn on computer, and install missing apps with Ninite. Don’t worry about app configuration, it will come back the same way it was on the old computer as soon as you run them.

That’s it, you can now easily transfer your files from Windows 10 computer without the without Easy Transfer tool. If you wish to learn more about the Linux method, I can share with you my “real” method, based on command lines.

Just drop me a comment!

