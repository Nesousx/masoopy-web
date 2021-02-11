---
title: Automatically download subtitles with Plex
date: 2018-04-19 07:15:33.000000000 +02:00
categories:
- plex
tags:
- plex
permalink: "/automatically-download-subtitles-with-plex/"
FeaturedImage: "/images/2021/02/auto_dl_sub_plex.png"
---
Today, there is hundreds (if not thousands) of TV shows and movies. I enjoy a lot of them, and I enjoy them in their original version. Unfortunately, I am not fluent in every languages. Fortunately enough, we have [autmomatic subtitles for Kodi](https://www.masoopy.com/automatically-download-subtiles/) and a similar system of automatic subtitles for Plex. Let's see how to use it.

### In plugins, we trust

1. Open your web browser and go to your Plex server, [most probably here](https://app.plex.tv/desktop#).
2. Browse to the plugins section (left sidebar) :

![Plex_plugins_howto](/images/2018/04/Plex_plugins_howto.png)

1. Now, click "Install plugins" :

![Plex_plugins_install](/images/2018/04/Plex_plugins_install.png)

1. Then, go to "More", then "All Available Plugins", wait for the page to load (it might take a few moments) :

![Plex_plugins_all_howto](/images/2018/04/Plex_plugins_all_howto.png)

1. Once the page has finished loading, search for "Sub-zero". Click on the thumbnail and install the plugin.

![Plex_subzero_install](/images/2018/04/Plex_subzero_install.png)

NB : on my picture, you can see, that the plugin is already installed, but it should be pretty obvious which button to press on a new install. ;)

That's it, the plugin is now installed, it is time to set it up!

### Configure Sub-zero to automatically download subtitles

1. Go to Settings > Server > Agents, an overwhelmning 3 clicks process :

![Plex_agents_howto-1](/images/2018/04/Plex_agents_howto-1.png)

1. Now, in "Movies" : "Plex Movie" and "The Movie Database", check the "Sub-zero" boxes.
2. Repeat the same operation for "Shows" : "TheTVDB" and "The Movie Database".

Now, as long as your media libraries are using those standard agents, you'll be fine. Sub-zero will be executed.

Finally, we should tweak Sub-zero settings in order to make sure it finds the best subtitles. Let's do it!

1. Another 3 clicks process, go back to Home screen > Plugins > Mouse over the the Sub-zero thumbnail and click the "Gear icon".

![Plex_subzero_config_howto](/images/2018/04/Plex_subzero_config_howto.png)

1. From here, just fill in the fields according to your needs. I highly advise you to create and use accounts from [OpenSubtitles](https://www.opensubtitles.org) and [Addic7ed](http://www.addic7ed.com/).

Moreover, if you are automating your media binge watching, then you really should configure the Sonarr and Radarr section. It will greatly improve the way subtitles are matched to your media.

From now on you can force a full sub-zero sync from the plugin page, of simply forget it and it will automatically scan the library in the background (every night, by default).

