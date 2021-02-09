---
title: Hello FastMail, Goodbye ProtonMail
date: 2019-03-05 09:58:54.000000000 +01:00
categories:
- general
tags: []
permalink: "/hello-fastmail-goodbye-protonmail/"
FeaturedImage: "/images/2019/03/Hello-FastMail-Goodbye-ProtonMail.png"
---
<!-- wp:paragraph -->

After a bit more than a year using ProtonMail, I couldn't bear it anymore... I was really pissed by its lack of "usability". Even though I had almost 1 year left, I made the switch to FastMail, and I couldn't have been happier. Let me explain.

<!-- /wp:paragraph -->

<!-- wp:heading -->

## ProtonMail isn't bad...

<!-- /wp:heading -->

<!-- wp:paragraph -->

However, there is a few issues, that overtime really grew over me.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

First and foremost, the non standard protocols! ProtonMail doesn't use IMAP(s)/SMTP(s). This means I can't easily configure it with classic mail clients, such as Thunderbird, or mutt, etc. Nor can I use it so send (alert) emails from my servers, for example.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

EDIT : Following this article, ProtonMail's team contacted. I forgot to mention that there is a proprietary bridge so that you can use a "classic" client. However, once of my use case would be to send some email via CLI from my server. As far a I know, it won't work for this use case since the CLI app requires a GUI to be installed.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

I knew it from the beginning and was okay with it. So, I had to use the proprietary applications. Webmail for the computer, and Android app on the phone. But here, came another issue. When I am on my computer (which is most of my awake time), I will only use the webmail. When I receive a new email, I mark it as read on the webmail. However the notification and the "email", won't clear from the phone until I open the app. As soon as I open the app, the mail disappears because it was already sorted from the webmail... Unfortunately, it also means that my phone had a constant blinking LED for this "already seen" email. This really really bugged me!

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

Another small, but frustrating issue I had, was about 2FA. It will ask for your credentials + 2FA code EVERY time you close your browser tab/window (update the browse, reboot the computer, mistake, etc.), then you need to log in again with both regular credentials + 2FA code... This might be secure ("auth token" not being stored), but it is not convenient at all. I wish there could be an optional "Remember me for X days" mode.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

Last but not least, I love aliases and I use a lot of them for my emails. For example, my main email is denis@domain.com. For Amazon I will use denis+amazon@domain.com; for Wordpress, I will use denis+wordpress@domain.com and so on. Now this is not ProtonMail fault, but many websites won't accept a "+" sign in the email address! Which is really stupid, by the way. The workaround, could be to be able to use a [catch-all email address.](https://protonmail.com/support/knowledge-base/catch-all/) It would allow me to use aliases like amazon@domain.com or wordpress@domain.com. This can be done with ProtonMail. However it comes with the most expensive version ($24 / month).

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

NB :Maybe (to be verified) the Business version can do it as well ($6,25 / month).

<!-- /wp:paragraph -->

<!-- wp:heading -->

## FastMail solved all my issues

<!-- /wp:heading -->

<!-- wp:paragraph -->

All the issues from above had been solved with FastMail.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

It uses an SMTP(s)/IMAP(s), and it is even pushing a [new open source protocol](https://fastmail.blog/2014/12/23/jmap-a-better-way-to-email/), which could benefit everyone.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

I no longer have the notification issue. When I read a mail on the webmail, it clears the notification from my phone.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

The 2FA code can be remembered for several days.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

The catch-all alias is available from the $5 / month plan.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

Both emails' providers use features such as DKIM, SPF and DMARC.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

Icing on the cake, I can even link my NextCloud's calendar to my FastMail account. When I receive a new appointment via email it is automatically added to my calendar.

<!-- /wp:paragraph -->

<!-- wp:heading -->

## Closing thoughts

<!-- /wp:heading -->

<!-- wp:paragraph -->

I have been using FastMail for about a month and a half now, and I am really happy with. Actually I couldn't be happier since I left ProtonMail...

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

However, one must not forget that ProtonMail targets "privacy" and "security" aware users. However, ProtonMail being not open source, it is kind of hard to evaluate how secure it is. I would tend to think that ProtonMail to ProtonMail messaging IS secure. However, ProtonMail to rest-of-the-world isn't more secure than any regular email (due to the way "emails" work).

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

EDIT : Another edit after talking to ProtonMail's team. I was mistaken on that point.[A ProtonMail user can send encrypted mail to a non ProtonMail user](https://protonmail.com/support/knowledge-base/encrypt-for-outside-users/). However, I far as I understand it, this is not a "real" email. It only sends a "real" email with a link to the encrypted message that is then stored and opened on the ProtonMail's server. We are, imho, outside of the scope of "just emails". This is however a convenient feature and I should have mentioned.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

Now, still on the security side. FastMail can be used with PGP and it will make it pretty secure (and open source).

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

Of course, I'd like to mention that I am using a custom domain for my emails. I have been doing so for many years. If I can give you only one piece of advice today, it will be to do the same. Having your own domain for email gives you so many freedom in the way you manage your emails. You can go to any provider, or even self host your email without ever having to "change" your email address(es). It is a really great peace of mind!

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

Eventually if I can give you two pieces of advice. It will be (1) to use your own domain and (2)[go with FastMail](https://www.fastmail.com/settings/referrals?u=4b014090).

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

NB : using the above link will give you 10% off and give me some extra credits as well.

<!-- /wp:paragraph -->

