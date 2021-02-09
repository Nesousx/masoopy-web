---
title: All your devices are belong to Ubiquity
date: 2018-11-20 16:48:01.000000000 +01:00
categories:
- hardware
tags:
- unifi
permalink: "/all-your-devices-are-belong-to-ubiquity/"
FeaturedImage: "/images/2021/02/unifi.png"
---
I love tech and I love to try new tech stuff. Recently, I have been playing with some network gear from Ubiquiti. For a reasonable price, you'll get enterprise grade gear. Is it really that good? Let's check my non-unboxing review.

## A bit of background

I am a frequent reader of Mr Troy Hunt and when I read his article a few years ago about the [Unifi suite](https://www.troyhunt.com/ubiquiti-all-the-things-how-i-finally-fixed-my-dodgy-wifi/) that made want to try it again, a little. Just a little.

Indeed, I used to work with network gear, mostly Ubiquiti and Ruckus... The thing is, the company I was working at was offering a service : basically WiFi hot spots, based on a custom coded application + a bunch of open source tools. However, on the hardware part, our client would follow (or not) our recommendations. It ended in some companies or individual using very cheap Ubiquiti gear on pretty harsh conditions (think outdoor and ports with huge boats). I was a system administrator, but also worked the helpdesk (small startup for the win!). I was pretty quickly discouraged by all the issues I had on those cheapo setup, and all the calls I received during summertime. Add to this a very weak broadband connection shared among all customers, and it was really a hell.

Moreover, there was the horrible Java Unifi controller solution, years ago, before Docker was all the hype. I never liked to set it up, always afraid something weird will come up with Java. I have Java anxiety, but this is another story.

On the other hand, we had Ruckus systems (indoors), without any issue, and also more Unifi APs (indoors) as well, that we never had any issue with!

But as always... you remember the bad and forget the good.

## It took me two years...

So two years after reading the article and coming back to it regularly, I decided to give Ubiquiti another go. After all, Troy is a semi god, how could he be wrong?

I bought the following stuff :

- 1 x [Unifi Secure Gateway](https://amzn.to/2OYbba8)
- 1 x [Unifi 8 ports PoE switch](https://amzn.to/2QWFS0Z)
- 1 x [Unifi AP-AC Pro](https://amzn.to/2DNJmjs)

First of all, build quality feels really good, and it seems sturdy. We are very far away from cheap plastic equipment sounding (and feeling) hollow.

Installing it was really easy. It is literally "plug and play". I plugged the USG WAN to my ISP's modem, and the USG LAN 1 to the Unifi switch, then all my devices to the switch, and the Unifi AP to the switch port n°8 (on my model, it is the only port that supports PoE).

I had already prepared the [Unifi controller in a Docker container](https://www.masoopy.com/using-unifi-controller-on-docker/), so I browsed to the web interface and it magically saw all my devices : USG, switch and AP.

## I fall in love for the eye candy interface and ease of use

The web interface is pretty and easy to use. You have a main "Dashboard" in which you see all your equipment along with pertinent information such as device name, IP, firmware version, etc. And also possible actions, like issue a reboot, update a firmware, etc. This is very convenient.

![[](/images/2018/11/unifi_dashboard-1-300x73.png)](/images/2018/11/unifi_dashboard-1.png)

From there, I "adopted" them one by one. It literally takes one click !

NB : Adopting a device is the Ubiquiti's way to "unify" all your devices, so that they are linked to your controller and you can manage them.

One the adoption was done, I could upgrade all my devices. Once again, it takes only one click (per device) !

Again, the web interface is really really nice, everything is very well integrated. You can see at a glance every devices connected to your network with a wire or via WiFi. I even discovered that my main computer was connected to both WiFi and ethernet... I probably forgot to disconnect WiFi after doing some tests a few days ago.

If you have several access points or switches, then you'll know every clients that are connected to them. This means that you can guess where your users are physically located. If for example, you have 2 APs, one called "garage", located in the garage, and one called "kitchen", located in the kitchen and you see that "Bobby's Iphone" is connected to the Kitchen's AP, then Bobby is probably in the kitchen.. or he forgot his phone inside the fridge (not so probable)...

Another nifty feature is the "DPI" stats. It is pretty useless, but so cool that I couldn't live without it now that I know it exists. Basically, it is a graphic summary of what every device "does" on the network, and shows percentage of every activity like streaming, game, web browsing, etc.

![[Unifi DPI](/images/2018/11/unifi_dpi-300x161.png)](/images/2018/11/unifi_dpi.png)

I am not talking about the fact that, "it just works". I didn't had any single issue with WiFi range, signal, or anything else.

## Nothing is perfect

On the "downsides", I was bit disappointed to see that Ubiquiti only offers SNMP v1 "out of the box". Yup, no v2c... and not even v3! However, while the interface only mentions v1, it also works out of the box with v2c (I didn't check if it was read-only or not). [For v3, this is another boring story](https://www.youtube.com/watch?v=Dm-Z2ig6XMo)...

As I already said, I could have used and love a more "advanced mode" out of the box. The advanced [configuration of the USG via config.gateway.json feels counter intuitive](https://help.ubnt.com/hc/en-us/articles/215458888-UniFi-USG-Advanced-Configuration).

I was also disappointed by the fact that the devices run VERY hot. They are fan-less (which is "cool", pun intended), but they are also very very hot. I am not sure how it would perform during summer, or during long periods.

## ... and another week later

I decided I won't use it and had everything returned to Amazon.

My use case is pretty specific : I use an [OpenVPN client to watch US Netflix](https://www.masoopy.com/watch-netflix-us-from-anywhere-in-the-world/) and it redirects my TV through that VPN, while my other devices use my ISP. This can be done with the USG, however, it is really painful!

Moreover, I am also using [suricata](https://suricata-ids.org/) on my [pfsense](https://www.pfsense.org/) router, and as far as I know, it wouldn't be possible with just the USG.

On the hardware side, I own a pretty decent setup :

- 1 x router with CPU that supports AES-NI on pfsense
- 1 x Meraki MR33
- 1 x Netgear switch (to be replaced with Meraki MS120)

With my current setup I miss the integration of everything. I have to browse to one page for the router, another one for the switch and a third one for the AP. Hopefully, soon enough I will be able to manage the switch and the AP at the same place. But still, the router will be left alone.

In the end, I have been very pleased with both Ubiquiti's hardware and software. I am glad I decided to give it another shot, even if I don't use it myself (for now). I would definitely recommend it and even set it up myself, just to enjoy one more time the slick interface.

