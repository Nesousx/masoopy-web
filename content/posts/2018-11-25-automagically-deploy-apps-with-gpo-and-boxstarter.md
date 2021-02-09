---
title: Automagically deploy apps with GPO and Boxstarter
date: 2018-11-25 14:03:32.000000000 +01:00
categories:
- windows
tags:
- automation
permalink: "/automagically-deploy-apps-with-gpo-and-boxstarter/"
FeaturedImage: "/images/2021/02/boxstarter.png"
---
A few days ago, I talked about [Ninite, which is an awesome tool to deploy several Windows apps easily](https://www.masoopy.com/install-windows-programs-like-a-boss-with-ninite/). However, if you want to use it on a Windows domain (likely in your company), you'll have to get the Pro (and paid version). Hopefully, with BoxStarter, you can do it for free. Let me show you how I do it.

## Let's do some scripting!

In my case, I want all my users to have the same "base apps" installed on their systems. It allows my team and I to make sure every user has access to some "must-have" apps like :

- remote access client for support ;
- a good text editor ;
- some video player ;
- etc.

Of course, I want to automate this. No worry, I'll share a little PowerShell script, but thanks to BoxStarter, it will be VERY easy.

We no further ado, here is the script :

```text
### Determine which version of PowerShell is running if ($PSVersionTable.PSversion.Major -eq "2") ## PowerShell V2 { iex ((New-Object System.Net.WebClient).DownloadString('https://boxstarter.org/bootstrapper.ps1')); get-boxstarter -Force } else ## PowerShell V3 { . { iwr -useb http://boxstarter.org/bootstrapper.ps1 } | iex; get-boxstarter -Force } ## List of apps to be installed $apps = "Firefox", "teamviewer.portable", "glaryutilities-free", "vlc", "windirstat", "pidgin", "7zip", "notepadplusplus" foreach($app in $apps) { cinst -y $app }
```

Let me explain a little bit what it does.

Since BoxStarter needs a different command line to be installed depending of the version of PowerShell, we must first determine if we are running PowerShell V3 (Windows 8 to Windows 10), or PowerShell V2 (Windows 7).

Once we found out which version is running, we install the base "framework' for BoxStarter, called BoxStarter Shell.

Finally, we simply declare a list of apps, in which we write the name of all the apps we want to install.

NB: BoxStarter is based on Chocolatey and [all the available packages (= apps) can be found here](https://chocolatey.org/packages), or via the command "choco search package" (once the BoxStarter shell is installed).

Please also note that BoxStarter also allow you to modify Windows settings, such as "Show hidden files", "Acitvate remote desktop", etc.

## How to make sure every user get the script?

The way I distribute those apps is via a GPO defined on the AD server. This is a user based GPO, and it executes itself at session's start.

Which means, you have to create it into : User configuration > Windows settings > Scripts (session start).

From here, make sure to use the 2nd tab on the top in order to use a PowerShell script.

![[BoxStarter GPO](/images/2018/11/boxstarter_GPO-300x162.png)](/images/2018/11/boxstarter_GPO.png)

Then click "Add", and "Open directory' and you'll be brought up to the folder dedicated to this particular GPO :

```text
%SystemRoot%SYSVOLsysvol<domain DNS name>Policies{GUID}ComputerScriptsStartup
```

Just paste your script inside this directory, and select it.

Now, in the "Parameters" field, make sure to add the following line :

```text
-ExecutionPolicy Bypass
```

This line ensures, the script will be run whatever [execution policy](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-6) is in place.

From now on, any user that this GPO applies to will get the apps installed (if not already) and frequently updated.

NB: The very first run can take a little time and resources (in the background), but it should be barely noticeable.

## A note of caution

With any GPO work, care is the word ! This is why I advise you to test, test, test... before putting it into production.

In order to do so, you can create "fake" users and apply that GPO only to those users. You can also create a Testing OU in which you'll put, for example, the IT team, etc.

