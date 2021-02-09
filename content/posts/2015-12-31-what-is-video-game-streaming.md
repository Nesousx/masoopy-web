---
title: What is video game streaming?
date: 2015-12-31 08:45:22.000000000 +01:00
categories:
- kodi
tags:
- geforce gamestream
- geforce now
- moonlight
- steam link
permalink: "/what-is-video-game-streaming/"
FeaturedImage: "/images/2021/02/game_streaming.png"
---
Nowadays, one can stream a whole lot of different, more especially music and video. Although it is “pretty” new, video game streaming is becoming more and more present.

## A short technical presentation of video game streaming

Let’s start by defining what a video game is. I can see two big categories of game :

- small games: the ones you play inside your browser, on Facebook, etc.

![[candy_crush](/images/2015/12/candy_crush-300x224.jpg)](/images/2015/12/candy_crush.jpg)

- regular games : the ones you play on a console, or the one you have to install on your computer and require dedicated hardware such as a good video card.

![[witcher-3-griffin-screen](/images/2015/12/witcher-3-griffin-screen-300x169.jpg)](/images/2015/12/witcher-3-griffin-screen.jpg)

Now when we talk about video game streaming, we are talking about the second category, aka regular games. Streaming a video game means playing a game on your computer without having to install it and without having to use dedicated hardware. Usually (without streaming), it is your computer that do all the work and “maths” so that you can play the game. This are really heavy operations, hence the requirements of dedicated hardware and “gaming pc”.

When streaming, all the work is done remotely by a server (more exactly several servers) belonging to the company offering that streaming service. It means, that basically you could play any game (even the most recent one) on any hardware (even a poor old and “weak” laptop).

## This sounds really good, but it is far from perfect

In life, everything as a cost… in streaming too. In order to be able to stream a game, you’ll need a very good [bandwidth](https://en.wikipedia.org/wiki/Bandwidth_%28computing%29) on your internet connection. Gaming is “live”, it is not like a movie you can pause a few seconds until it buffers and start playing again. Moreover, video game streaming uses more bandwidth for the same quality than a movie. This is simply true because a movie runs at 24 frame per second (FPS), while a game runs at 60 frame per second (FPS). Which means you’ll need to download almost 3 times more data for a game than a movie.

Let’s compare bandwidth requirements for [Netflix](https://www.netflix.com/) (a famous video streaming system), with Nvidia [Geforce Now](http://shield.nvidia.com/games/geforce-now) (another famous video game streaming system).

### Netflix

- 0.5 Megabits per second – Required broadband connection speed
- 1.5 Megabits per second – Recommended broadband connection speed
- 3.0 Megabits per second – Recommended for SD quality
- 5.0 Megabits per second – Recommended for HD (720p to 1080p) quality
- 25 Megabits per second – Recommended for Ultra HD quality

### GeForce Now

- 10 Megabits per second – Required broadband connection speed
- 20 Megabits per second – Recommended for 720p 60 FPS quality
- 50 Megabits per second – Recommended for 1080p 60 FPS quality

_NB : Megabits per second = Mbps_

As you can see, streaming a game at 1080p 60 FPS, uses 50 Mbps while a 1080p HD movie, will only require from 5 Mbps to 25 Mbps (25 Mbps being for [Ultra HD resolution which is 4 times superior to the 1080p definition](https://www.masoopy.com/is-kodi-4k-ready/)).

Considering the [average US download speed](http://www.networkworld.com/article/2959544/lan-wan/u-s-internet-connection-speeds-still-lag-behind-other-developed-nations.html)is around 11.9Mbps this bandwidth thing is still a big negative factor. I am not even talking about data caps.

## Fix exists… kinda

Since not everyone can enjoy such a connection speed, an hybrid system has been developed too. It allows you to stream a game from your main computer on another screen like your TV. This way you can enjoy playing a game from your couch on your big TV screen with your home cinema sound system very conveniently. It is still video game streaming but “locally”.

![[not the best fix...](/images/2015/12/worst_diy_car_repairs_18-300x222.jpg)](/images/2015/12/worst_diy_car_repairs_18.jpg)

Remember how we needed around 50 Mbps bandwidth for streaming. We still that, however, your computer, TV and devices that allows streaming are all connected directly. It means no data cap at all applies, and the average speed of a WiFi routeur (the item that ties all your “networked” devices together) runs at 500Mbps (yup, 10 times the requirement)!

However, it will requires buying hardware to hook on your TV and a gaming computer to stream from.

## A little overview of available options

### Stream games from internet

[**Geforce Now**](http://shield.nvidia.com/games/geforce-now) : at that time this is probably the most advanced and only viable video game streaming system.

### Stream games from your local network

**[Steam Link](http://store.steampowered.com/app/353380)**: a small box that you hook on your TV so that you can stream you Steam library from your gaming computer.

![[steam link](/images/2015/12/steam-link-800x416-300x156.jpg)](/images/2015/12/steam-link-800x416.jpg)

**[Geforce GameStream](http://shield.nvidia.com/game-stream)** : Mostly used in Nvidia Shield systems, once plugged on your TV you’ll be able to stream games from your PC to your TV.

**[Moonlight](http://moonlight-stream.com/)** : an open source implementation of Geforce GameStream. You can install it on a Raspberry Pi computer, once hooked to your TV it will allow you to stream games from your PC to your TV.

That’s about it for now! In an other post, I’ll compare those streaming systems and see what the best solution for video game streaming.

Did I miss a system? Do you already stream games, if not why? Please let me know!

