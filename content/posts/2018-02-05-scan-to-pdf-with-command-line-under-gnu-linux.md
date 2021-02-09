---
title: Scan to PDF with command line under GNU/Linux
date: 2018-02-05 12:01:12.000000000 +01:00
categories:
- linux
tags:
- linux
permalink: "/scan-to-pdf-with-command-line-under-gnu-linux/"
FeaturedImage: "/images/2021/02/scan_pdf_cli.png"
---
After years of not-so-good services, I deciced to replace my old Canon MG5550 printer/scanner combo. Instead, I bought a simple black and white laser printer/scanner, and I have never been so happy with a "printer".

## More info about the printer

Recently, I needed to go through quite some paperwork and I knew it would be a hassle (and pricey) do it with my actual hardware. Moreover, I was never happy with it: it was not reliable under Linux, there was no auto document feeder, etc.

So, I was looking for a new tool with the following requirements:

- Linux support ;
- Auto document feeder ;
- Networked ;
- Laser (for reduced cost of use) ;
- Color not required.

After a few searchs, I came across this model :

<iframe style="width: 120px; height: 240px;" src="//ws-eu.amazon-adsystem.com/widgets/q?ServiceVersion=20070822&amp;OneJS=1&amp;Operation=GetAdHtml&amp;MarketPlace=FR&amp;source=ss&amp;ref=as_ss_li_til&amp;ad_type=product_link&amp;tracking_id=streamgen-21&amp;marketplace=amazon&amp;region=FR&amp;placement=B00MFG58N6&amp;asins=B00MFG58N6&amp;linkId=a9da148dc72c165cc9077005972d268d&amp;show_border=false&amp;link_opens_in_new_window=true" frameborder="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>

It matches all my requirements, moreover it is just a little bigger than my previous printer which is a good point. I didn't want a huge piece of plastic sitting on my desk.

Installing it under Linux / Macos and Windows was pretty straighforward. However, the only thing I did struggle with a bit was to find a good Linux program to scan document to PDF (I didn't want to use Gimp and convert file manually to PDF).

## Scan document to PDF with Linux

This is why I wrote a simple script (inspired from various pieces found on Internet).

What the script does :

- scan one or several pages from the automatic document feeder and merge them into a single PDF file (optimized in size).

### Requirements

- scanimage tool (part of sane backends and/or tools package) ;
- libtiff-tools (or something similar in name) ;
- imagemagick ;
- ghoscript.

### The script

<script src="https://gist.github.com/anonymous/e28fa1754502eae9240def351a83e6e4.js"></script>

**NB** : You'll probably have to change the "device" part (-d flag) of the the scanimage command, in order to match your real device.

### Usage

The script has be used has follow :  
`scan2pdf.sh path/to/save/your_file.pdf`

### Tips

In order to make things lazier, I am using an alias in my [ZSH](https://en.wikipedia.org/wiki/Z_shell) config:

Add the following line, to your .zshrc:

`alias scan2pdf="bash ~/path/to/scripts/scan2pdf.sh"`

**NB** : in case your are using bash, add the above line to yout .bashrc file, and source the .bashrc file.

Which now, means I can scan a document like this, from anywhere:

`scan2pdf path/to/save/your_file.pdf`

That's it!

Please bear in my mind that the script is pretty simple and stupid. It works very well for me, but it can be easily tweaked to your needs. If you do so, do not hesitate to share it with us.

