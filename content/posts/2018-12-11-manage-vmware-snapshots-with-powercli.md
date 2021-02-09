---
title: Manage VMware snapshots with PowerCLI
date: 2018-12-11 08:48:46.000000000 +01:00
categories:
- wiki
tags:
- automation
- powercli
permalink: "/manage-vmware-snapshots-with-powercli/"
FeaturedImage: "/images/2018/12/Manage-VMware-snapshots-with-PowerCLI.png"
---
Manually taking a snapshot under VMware is easy : connect to the HTML5 Web UI, find the server from the list, right click, select Snapshot, Name it... However, when you have to do it several times in a row, it becomes really frustrating. Let's see how to improve that.

## Here comes PowerCLI

VMware released an awesome (and I am Linux guy) tool to manage your virtual machines from the command line. It is called [PowerCLI](https://communities.vmware.com/community/vmtn/automationtools/powercli), is based on PowerShell and honestly it really works like a charm.

it can be installed on [Windows, Linux, Macos](https://www.virtuallyghetto.com/2016/09/vmware-powercli-for-mac-os-x-linux-more-yes-please.html) and of course [inside a Docker container](https://hub.docker.com/r/vmware/powerclicore/). I'll let the installation part up to you, there is plenty of guides available on internet, but I'll share my scripts.

## My current workflow

I often change / refine / try to improve my workflow. However, for current workflow for managing updates on our Linux servers is like below :

- Make a snapshot of every server with PowerCLI, and give them a relevant name ;
- Apply update with Ansible (and reboot them if required) ;
- Delete snapshots after 2 days if everything is OK.

With no further ado, here are my scripts :

Create snapshots :

```text
Connect-VIServer -server vcenter.domain.com $vmlist = "srv-1", "srv-2", "srv-3" foreach($VM in $VMlist) { New-Snapshot -VM $vm -Name Before_Update -confirm:$false -runasync:$true } Disconnect-VIServer -Confirm:$false
```

Delete snapshots :

```text
Connect-VIServer -server vcenter.domain.com $vmlist = "srv-1", "srv-2", "srv-3" foreach($VM in $VMlist) { Get-Snapshot -VM $vm | where {$_.Name -match "Before_Update"} | Remove-Snapshot -RunAsync -Confirm:$False } Disconnect-VIServer -Confirm:$false
```

Let me walk you through what it does.

- First line, connects to the VMware server and will pompt for credentials.
- Then I declare an array or server, simply replace and add as many servers as you like.
- Simple foreach loop, goes through every server of the above defined array and does its job. Make sure to check official docs for more info about extra flags.
- NB : I use a relevant name, here "Before_Update" for my snapshots. It makes it easier to manage them since I know their name.
- Finally, we disconnect from the server.

I hope those little scripts will make you life a little easier, and hopefully your job a little less boring. Automating is the way to go!

&nbsp;

