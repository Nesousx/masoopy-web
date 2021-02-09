---
title: 'Nesatmo : beautiful graphs for Netatmo'
date: 2018-03-27 09:32:28.000000000 +02:00
categories:
- linux
tags: []
permalink: "/nesatmo-beautiful-display-for-netatmo-statistics/"
FeaturedImage: "/images/2021/02/netatmo.png"
---
Netatmo are little, funny, useless devices that monitor "stuff" in your home.

### Netatmo weather

On the weather side, you can buy an indoor / outdoor station :

<iframe style="width: 120px; height: 240px;" src="//ws-na.amazon-adsystem.com/widgets/q?ServiceVersion=20070822&amp;OneJS=1&amp;Operation=GetAdHtml&amp;MarketPlace=US&amp;source=ac&amp;ref=qf_sp_asin_til&amp;ad_type=product_link&amp;tracking_id=kodi-xbmc-20&amp;marketplace=amazon&amp;region=US&amp;placement=B0095HVAKS&amp;asins=B0095HVAKS&amp;linkId=a9a64629f351d03cf319db92e732ec92&amp;show_border=false&amp;link_opens_in_new_window=false&amp;price_color=333333&amp;title_color=0066c0&amp;bg_color=ffffff" frameborder="0" marginwidth="0" marginheight="0" scrolling="no"><br>
</iframe>

The indoor station is connected to your WiFi connection for the "data" part and to a power line for... power!

The outdoor station, runs on batteries and is wirelessly connected to the indoor (aka, base) station. Batteries should last several months.

Usually, I am not much into proprietary solution but I have to admit that this solution is pretty convenient. In my opinion it is way better (on the hardware / convenience part) than something based on RPI / Arduino.

However, the website looks really bad and the graphs suck, see :

![netatmo](/images/2018/03/netatmo-1024x671.png)

This is why I'll show you how to get beautiful graphs.

### Here comes the open source

Thanks to Docker, the Internet and the help of a friend, I hacked together a pretty cool interface to store and visualize your data. It's called Nesatmo and runs under Docker / Grafana / Telegraf and InfluxDB.

I'll assume you already have a Docker / Grafana / InfluxDB setup.

In order to make it work, all you need to do is to pull the following Docker image, like this :

`docker pull nesousx/nesatmo`

Then create a docker-compose.yml file and edit it according to your config :

<script src="https://gist.github.com/Nesousx/fc6967ce7e3ff88e757a6152fd079bbf.js"></script>

You can now create your own Grafana dashboard that could look like this :

![nesatmo](/images/2018/03/nesatmo-1024x542.png)

If you want to get mine, [here it is](https://gist.github.com/Nesousx/3941d33ee6c2282c29fa70e69c54fb1f).

Search and replace the following elements :

- "nesoweath" by your station's name ;
- "indoor" by your indoor's sensor's name ;
- "outdoor" by your outdoor's sensor's name.

I hope this quick guide will help you to get started. Do not hesitate to post a comment if you need additional help, you can also check my [official Docker page](https://hub.docker.com/r/nesousx/nesatmo/).

