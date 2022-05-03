#/usr/bin/env bash

## Create post skeleton for Box write-ups
## !!! Work In Progress !!!

## Usage : ./fr_writeup.sh PLATFORM Box_Name

### Variables

platform="$1"
box="$2"
year="`date +%Y`"
month="`date +%m`"
day="`date +%d`"

### Write it for me!

recon=( \
    "Petite reconnaissance basique en fonction des logos et autres infos :" \ 
    "Un aperçu rapide de la box, révèle les infos suivantes :" \
    "Grâce au logo et à la description, nous apprenons que :" \
    )
random=$$$(date +%s)
blabla_recon=${recon[$random % ${#recon[@]}]}

enum=( \
    "Petit scan \`nmap\` habituel :" \ 
    "Lançons notre scan \`nmap\`:" \
    "Comme toujours, un scan \`nmap\` :" \
    )
random=$$$(date +%s)
blabla_enum=${enum[$random % ${#enum[@]}]}

### Create dir for pics

mkdir -p ./static/images/$year/$month

### Populate template

cat <<EOF > ./content/posts/$year-$month-$day-$platform-${box}-sans-MetaSploit.md
---
title: "$platform - $box sans MetaSploit"
date: $year-$month-$day
draft: true
categories: ["hacking", "Guides"]
tags: [$platform]
featuredImage: "/images/$year/$month/${box}_Logo.png"
---
## Intro

## Cible
[$platform - $box](URL)

## Reconnaissance
$blabla_recon

## Énumération
$blabla_enum

\`\`\`text
sudo nmap -sC -sV -oA scans\\$target_ip
\`\`\`
\`\`\`text

\`\`\`

## Exploitation

### Obtenir un premier shell

### PrivEsc

## Outro
EOF
