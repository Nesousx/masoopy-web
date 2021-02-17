---
title: "Going from WordPress to Hugo and GitHub Actions!"
date: 2021-02-15T15:48:01+01:00
categories: ["web"]
tags: [hugo]
permalinks: "Going from WordPress to Hugo and GitHub Actions!"
FeaturedImage: "/images/2021/02/hugo_gtmetrix.png"
---
I finally did it! After years thinking about it, I finally migrated my Wordpress website to a static website! It was painful, but I am really happy I did it.

## Why change?

I got fed up with Wordpress being full of "stuff", loading a webpage took ages (well, seconds..., but still too much) while my content is mostly text and a few small images. 

Moreover, I wanted to be able to write my posts using Markdown. 

Also, Wordpress and all its plugin have a lot of vuln, and it is a constant game of cat and mouse to stay up to date. 

Last but not least, I hadn't blogged for years and when I decided to blog again, I discovered the Gutenberg Experience : this was the last straw to my Wordpress' adventure!

## What for?

I could have used [Ghost](https://ghost.org/), which I did at some point. I went from Wordpress to Ghost, to Wordpress again... but I really didn't want to host it myself. It is based on `node.js`, a technology I prefer to avoid like Java, Flash, or even Windows...

Then, I remembered using [Jekyll](https://jekyllrb.com/) a while ago, I also know that Github now allows users to host their content with Jekyll. I am not a big fan of Ruby either (call me tech hater, or something). Too many dependencies, and gems, and stuff to install.

Anyways, I was going for it, and I converted all my post to Markdown (back to that a bit later). After playing with it locally, I wasn't really happy with it... too many stuff to install on my host system, plus I felt that I was limited to only a handful of themes if I wanted use Github (which was my plan all along).

So I looked for a Jekyll like, but in Python. A language I have been trying to learn for years. It would be great to blog again and learn Python at the same time. I found [Hyde](http://hyde.github.io/index.html). However, looking at it, it seemed that the project was not very live / current and bit too "niche". I suspected I would face a lot of issues with my low level of Python. In the end, it would be counterproductive. I am trying to [learn hacking](https://www.masoopy.com/starting-my-hacking-journey-hopefully/) and blog again. If I also need to learn Python in depth, I'll probably never succeed. I was back at the beginning!

And I found [Hugo](https://gohugo.io/)! Hugo, on the paper, it exactly what I am looking for :

* static web site generator ;
* allows me to write in markdown ;
* light and current : it uses the Go programming language ;
* can be hosted on Github ;
* bonus point : can be automated with Github Actions!

Let's give it a go, dare I say!

## Converting Wordpress to markdown

I did this step, pretty early : when I planned to use Jekyll. Converting any Wordpress website to Markdown IS painful. It can be automated in some way (hello, regex!) but there is a lot of proofreading and manual fixing.

### Exporting Wordpress Data

The first step consists in exporting your data from official `Wordpress Export Tool` to XML format. The tool can be found in `Tools` then `Export` then select `All Content`.

### Converting to Wordpress

For this part, I ran the following command :

```text
pelican-import -m markdown --wpfile -o posts ./masoopy.WordPress.2021-01-31.xml
```

Before, that, I had to install a ton of programs in order to have `pelican`, and all the required components. It was ugly and painful.

### Manual fixing

Now that, I had all my posts exported in Markdown, there was some manual fixing left such as removing several lines of unwanted data inside the [front matter](https://gohugo.io/content-management/front-matter/).

You can find a [dirty script here](https://raw.githubusercontent.com/Nesousx/masoopy-web/main/clean_post.sh), and the command I used to run it :

```text
find content/ -type f -name "*.md" -exec clean_post.sh {} \;
```
Then, there was some more regex, in order to change images paths, proofreading to make sure everything was correct, some more manual editing here and then. Proofreading again, manual fixing again... removing a few old low quality content, etc.

After a bunch of hours everything looked good, and I decided to go live!

## Host and forget!

Like I said, I planned to host this on Github, hence removing the need to pay for hosting. I have recently decided to stop paying for dedicated and host everything at home! However, I didn't want to open 80 and 443 to everyone, I didn't want to pay for hosting either. Github was the perfect solution : free hosting, and good hosting with free CDNs. Add to this CloudFlare and you have first class hosting for literally 0€ a month!

What is even cooler, is that you can have Hugo working with [Github Actions](https://github.com/peaceiris/actions-hugo)! 

### Create GitHub Actions script

In order to do so, I created the following file inside my `Hugo folder` :

```text
name: github pages

on:
  push:
    branches:
      - main  # Set a branch name to trigger deployment

jobs:
  deploy:
    runs-on: ubuntu-18.04
    steps:
      - uses: actions/checkout@v2
        with:
          submodules: true  # Fetch Hugo themes (true OR recursive)
          fetch-depth: 0    # Fetch all history for .GitInfo and .Lastmod

      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: '0.79.1'

      - name: Build
        run: hugo --minify

      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.HUGO_TOKEN }}
          publish_dir: ./public
          cname: www.masoopy.com
```

**Do not write the token itself**, write `HUGO_TOKEN`!

Which is located at : `.github/workflows/gh-pages.yml` and needs to be added and committed to your repo.

### Create Github Token

You also need to [create a token in your Github account](https://github.com/settings/tokens) and call it whatever you want, mine is called `hugo_masoopy`. 

![Create GitHub Token](/images/2021/02/hugo_account_token.png)

### Add token to your website's repo

Then, you have to go to your website's repo `Settings` and `Secrets` section, the URL looks like below :

```text
https://github.com/your-username/your-repo/settings/secrets/actions
```

And here, you'll have the token you created in the previous step. Now the name you chose matters and must match the one from the script you created in the first step. Mine is `HUGO_TOKEN`.

![Allow Repo Secret](/images/2021/02/hugo_repo_secret.png)

### It's always DNS!

Set your `CNAME` inside that file, create a `CNAME` for `your-username.github.io` on your DNS admin interface for your own domain.

## Now what?

Now, we write! We can write our posts inside VSCode, and commit our changes to our repo. Once we push the changes, Github Actions will do it's magic, and will publish the new content :

![Github in Actions](/images/2021/02/hugo_github_actions.png)

Last but not least, we now have a pretty fast and clean website that Google, and hopefully you'll like too! It is static, has no ads, no analytics. Just content!

Unfortunately, I do not have the "before" screenshots, but I love the "after" ones :

![PageSpeed Mobile](/images/2021/02/hugo_pagespeed_mobile.png)
![PageSpeed Computer](/images/2021/02/hugo_pagespeed_computer.png)

It was part automated and part manual work, but it was fun. I am very happy with the final result and proud to host this simple website! I hope you'll like it as much as I do. Do not hesitate to contact me on Twitter if you have anything to ask regarding this new website.



