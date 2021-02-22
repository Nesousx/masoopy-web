---
title: "Blogging With VSCode"
date: 2021-02-22T20:49:23+01:00
draft: true
categories: ["web"]
tags: [hugo]
FeaturedImage: "/images/2021/02/VSCode.png"
---
In a previous post, I explained [why I left Wordpress and how I did the move to Hugo](https://www.masoopy.com/going-from-wordpress-to-hugo-and-github-actions/). Now, let me explain how I write my articles.

## Blogging in Markdown
One of the main reason that me want to change what I used to do for several years was [Markdown](https://daringfireball.net/projects/markdown/). I love the simplicity of this format, and it gives me great flexibility! I can start writing an article at home in my IDE, and continue it on my mobile phone, or from any computer using an SSH access. The final articles are flat files, no DB, no fuss!

## Why VSCode?
I started doing it with `vim`, like the rest of my "code" (I don't code, just write some bash and `ansible`), but lately I wanted something a bit less CLI for this kind of tasks. While I still use `vim` when I need to play with pattern of text, I now prefer an IDE with a GUI for projects with multiple files.

After trying a few of them, I decided to use [VSCode](https://code.visualstudio.com/). It is free, looks modern, has a [Nord theme](https://www.nordtheme.com/), and plenty of extensions!

## Extensions for blogging
Since an IDE first role, isn't to write text, but code, this is where the vast amount of extensions that VSCode has to offer come useful!

Here are the ones I use :

* Spell check extension, a must-have for grammar and syntax spellchecking : [LanguageTool Linter for Visual Studio Code](https://github.com/davidlday/vscode-languagetool-linter) ;
* Since I am writing bits of code here and there, it avoids typo in those : [Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker) ;
* [Nord Theme](https://github.com/arcticicestudio/nord-visual-studio-code).

And, that's it!

## Writing pipeline
Has I have already explained, my blogging pipeline is now automated : I write, and it is automatically published once I push to the repo.

Now, the cool thing with `VSCode` (and many IDEs, or `vim` even), is that I can set up and integrate git into it! It means that VSCode will monitor changes and propose to commit + push them in just a few clicks! This is super convenient and pretty cool.

## Just write!
This whole new setup allow me to "just write"! I don't have to deal with online editor, or updates done to them, I do not depend on someone's logic for using a WYSIWYG editor.

Last but not least, the day I want to change, I am pretty sure I'll find tons of way to convert Markdown to anything I like by that time!
