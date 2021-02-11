---
title: Automatically run Kodi at boot
date: 2017-08-29 09:49:06.000000000 +02:00
categories:
- wiki
tags:
- kodi
permalink: "/automatically-run-kodi-boot/"
FeaturedImage: "/images/2021/02/kodi.png"
---
You have some hardware dedicated to Kodi and wish to create a “clean” media center solution hooked to your TV? Great idea! Find out how to automatically run Kodi at boot on any platform.

## Automatically run Kodi at boot with Windows

This method is similar to the Steam Shell mode.. but with Kodi.

First of all, make sure you can can log into the Windows desktop automatically. In order to do so:

- Click Start button (from the Windows desktop) > Run and enter the following command:

`control userpasswords2`

![](/images/2017/08/Controluserpasswords21.gif)

- Make sure “Users must enter a username and password to use this computer” is unchecked. If not, do it.

![](/images/2017/08/auto_logon_windows.png)

- If prompted, enter the username / password you want to automatically log in with.

Now, that autologin is set-up, we will do what’s necessary in order to automatically run Kodi at boot.

- Again, Click Start Button > Run and enter the following command:

`regedit`

![](/images/2017/08/regedit.png)

- From here, browse to :

`HKEY_LOCAL_MACHINESOFTWAREMicrosoftWindows NTCurrentVersionWinlogon`

- Right click on the right pane and select “Create a new string”.
- Name it “Shell”, and in the value field enter the full path to your Kodi executable, for example: “C:Program FilesKodiKodi.exe”
- You are done, reboot and check everything is working as expected!

NB: Do not remove the quotes when entering the path to Kodi executable in the Shell variable.

NB2 : In order to find the full path to Kodi executable, just launch the explorer and browse to the folder where it is installed, then clic on the “top bar”. The paths will appear, you can copy / paste from there. Don’t forget to append the application name (kodi.exe) to the path you just copied.

## Automatically run Kodi at boot with Linux / RPI

In order automatically run Kodi at boot we will have to first add a new user to your system.

- Open a terminal prompt and type the following command:

`sudo adduser --disabled-password --disabled-login --gecos "" kodi && sudo usermod -a -G cdrom,audio,video,plugdev,netdev,users,dialout,dip,input kodi`

Now, the easiest way to autostart Kodi is to use a light session manager that’ll start Kodi itselfs.

- Again, in a command prompt, enter the following, depending on your Linux version:

### Ubuntu / Debian / LXDE / Mint:

`sudo apt-get install -y lightdm`

### Fedora / RHEL / CentOS:

`sudo dnf -y install lightdm`

Now, edit the following file **/etc/lightdm/lightdm.conf** with your favorite text editor (as root / by running sudo), and make sure the [Seat:*] section looks like below:

`[Seat:*] autologin-user=kodi autologin-session=kodi`

Reboot your computer and make sure it works.

## Voilà, enjoy!

That's it, you should now have a computer automagically starting Kodi at boot. Make this your entertainement station and enjoy binge watching frm the couch.

