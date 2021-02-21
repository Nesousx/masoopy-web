#/usr/bin/env bash

## Create post skeleton for Box write-ups
## !!! Work In Progress !!!

## Usage : ./writeup.sh PLATFORM Box_Name

### Variables

platform="$1"
box="$2"
year="`date +%Y`"
month="`date +%m`"
day="`date +%d`"

### Write it for me!

enum=( \
    "Usual \`nmap\` scan :" \ 
    "We run our classic \`nmap\` scan :" \
    "Let's start a full \`nmap\` scan :" \
    )
random=$$$(date +%s)
blabla_enum=${enum[$random % ${#enum[@]}]}

### Create dir for pics

mkdir -p ./static/images/$year/$month

### Populate template

cat <<EOF > ./content/posts/$year-$month-$day-$platform-$box.md
---
title: "$platform - $box without MetaSploit"
date: $year-$month-$day
draft: true
categories: ["hacking", "write-ups"]
tags: [$platform]
featuredImage: "/images/$year/$month/${box}_Logo.png"
---
## Intro

## Target
[$platform - $box](URL)

## Recon

## Enum
$blabla_enum

\`\`\`text
sudo nmap -T4 -A -p- -oA scan \$target_ip
\`\`\`
\`\`\`text

\`\`\`

## Exploitation

## Outro
EOF