#/usr/bin/env bash

## Create post skeleton for Box write-ups

### Variables

platform="$1"
box="$2"
year="`date +%Y`"
month="`date +%M`"
day="`date +%d`"


mkdir -p ./static/images/$year/$month

cat <<EOF > ./content/posts/$year-$month-$day-$platform-$box.md
---
title: "$platform - $box without MetaSploit"
date: $year-$month-$day
draft: true
categories: ["hacking", "write-ups"]
tags: [$platform]
featuredImage: "/images/$year/$month/$box_Logo.png"
---
## Target

[$platform - $box](URL)

## Intro

## Recon

## Enum

## Exploitation

## Outro
EOF