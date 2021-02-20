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

blabla_enum_1="Usual \`nmap\` scan :"
blabla_enum_2="We run our classic \`nmap\` scan :"
blabla_enum_3="Let's start a full \`nmap\` scan :"

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
featuredImage: "/images/$year/$month/$box_Logo.png"
---
## Intro

## Target
[$platform - $box](URL)

## Recon

## Enum
${blabla_enum_}`shuf -i 1-3 -n1`

\`\`\`text
sudo nmap -T4 -A -p- -oA scan \$target_ip
\`\`\`
\`\`\`text

\`\`\`

## Exploitation

## Outro
EOF