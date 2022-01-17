---
title: "Gaming under Linux"
date: 2021-10-11
categories: ["linux", "gaming"]
tags: ["vfio"]
featuredImage: "/images/2021/10/Gaming_Under_Linux.png"
draft: true
---

Recently, I had an itch to scratch : playing under Linux at 4K 60FPS. Spoiler : it didn't really work. This post will talk about gaming under Linux in general, and present to you what I did, and why I did it. For the technical part, follow my [VFIO passthrough tutorial with Pop! OS](https://www.masoopy.com/)
.
## 2021: year of the Linux's Desktop

I have been playing under Linux quite successfully for some times now. I was using [Lutris](https://lutris.net/) and Steam Proton for most games. For anyone interested, it works very well and is a very viable solution for most games, even most recent ones.

However, most "competitive online games" require anti-hack technologies such as [EAC](https://www.easy.ac/en-us/) which are not compatible. [Thanks to the Steam Deck](https://www.rockpapershotgun.com/steam-deck-compatibility-conundrum-partially-solved-with-easy-anti-cheat-support), we might finally seem Linux as a viable desktop solution, [or not](https://www.reddit.com/r/thedivision/comments/puetrd/the_division_2_maintenance_september_24th_2021/) (see posts from XPS1647, and take it with a pinch of salt)!

Since some of them were part of the [Geforce Now](https://www.nvidia.com/en-us/geforce-now/) program, I could play inside a Chromium browser under Linux. 

There was still two issues though : 

* a limited choice of game is available in Geforce Now ;
* there is no 4K gaming.

## Windows to the rescue

The only solutions I could think of involved using Windows, such as :

* Create a dedicated (or virtual) Windows machine and exclusively stream it to my Linux desktop ;
* Create a VFIO virtual machine and play natively on it.

While the first solution seemed more fun and more "Linux only", I only encountered issues and bad experience. Even with a local wired network, streaming wasn't pleasant at all, and image quality felt modified and washed out. I could clearly feel / see / sense some kind of image/video compression. It didn't feel like a native game.

This is why I decided to go down the VFIO's road [once again](https://connect.ed-diamond.com/Linux-Pratique/lp-077/jouer-aux-jeux-videos-sous-gnu-linux-ou-presque).

## VFIO one more time

I decided to create a good old machine, and yes is means buying hardware, more specifically a GPU, during those times! I was quite lucky and could find a "decently" priced RTX 3080!

The idea now was to have a Linux host running Qemu/KVM/libvirt and a Windows guest. In order to play with my Windows guest, I "only" had to switch input from my screen and "profile" from my Logitech keyboard and mouse.

