---
title: How to set up correct Freenas jail permissions
date: 2017-07-30 12:14:03.000000000 +02:00
categories:
- linux
tags: []
permalink: "/set-correct-freenas-jail-permissions/"
FeaturedImage: "/images/2021/02/freenas.png"
---
[Freenas](http://www.freenas.org/) is a great software, allowing you to turn a PC into a NAS. Is it totally free and open source, which we really like.

## Freenas overview

Like any “market” NAS, Freenas allows you to install third party software such as bitorrent client, or newsgroups client. One of my favorite tools for downloading media (once again, make sure this is legal where you live) is actually a suite of tools based on newsgroups. The are called:

- sabnzbd : it will manage download of items, restart the download, if it fails, etc. We will call it the downloader, like [nzbget](https://www.masoopy.com/nzbget-as-a-replacement-of-sabnzbdplus/).
- couchpotato: tell him which movie you want, and it will automatically look for it and send it to the “downloader” as soon as the movie becomes available.
- sonarr : just like couchpotato, but for TV Shows.

NB : I’ll try to write a more elaborate guide about those great pieces of software.

## Freenas jail permissions

First of all, [thanks to this guide](https://forums.freenas.org/index.php?threads/how-to-giving-plugins-write-permissions-to-your-data.27273/) for the starting base. Now, let’s me show you my twist.

Let’s assume you have one (or several jails) for the software mentioned above. It is a pain in the *** so set up Freenas jail permissions correctly, but I’ll help.

First of all, ssh to your Freenas server and enter the desired jail with the following commands:

`jls sudo jexec X`

where X is the jail’s number.

From here, check the media user uid and gid by issuing:

`grep media /etc/passwd`

Now you should create a media group and user from the Freenas web admin (make sure the uid / gid of this user matches the one from the jail. It should be both 816 for gid and uid. See screenshot below:

![[Freenas jail permissions](/images/2017/07/Capture-d%E2%80%99e%CC%81cran-2017-07-30-a%CC%80-13.57.21-300x300.png)](/images/2017/07/Capture-d%E2%80%99e%CC%81cran-2017-07-30-a%CC%80-13.57.21.png)

Now, back in the jail, we will replace the regular user of a said service with the media user.

For example, if we want to make sure that couchpotato runs with the media user, we will do the following:

`service couchpotato onestop`  
`sysrc 'couchpotato_user=media'`

Then, we have to change ownership of all the files that belong to the previous coucpotato user to the new media one.

In order to locate all those files, issue:

`find / -user couchpotato`


`chown -R media:media /folder/name`

When you think, you are done, just do a last “find” like shown before to make sure there is nothing left. Then you can start the service again

`service couchpotato start`

Rinse and repeat for all the desired services / jail.

NB : in case, the media user doesn’t exists in the jail, just create it.

Last but not least, add storage to you jail. This storage must be the wanted folder for example that contains all your media and it must be owned by media:media with 775 permissions.

## Fine tuning

Now, if you want to fine tune this, I highly advise you to add you own user to the media group from the Freenas GUI. Also make sure to have adequate permissions for groups. Something like 775 works fine and is not too insecure.

This way, you’ll still be able to browse and modify your files with your regular user.

I hope this quick & dirty guide will help you to fix Freenas jail permissions. This is quite and advanced guide, and I took many shortcut to describe the step I used to configure my server. Do not hesitate to post a comment if you need extra details.

