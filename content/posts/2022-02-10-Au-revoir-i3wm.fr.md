---
title: "Au revoir i3 !"
date: 2022-02-10T00:48:07+01:00
categories: [linux]
tags: ["tiling", "DE"]
FeaturedImage: "/images/2022/02/au_revoir_i3.png"
---

Après de nombreuses années passées à utiliser [i3](https://i3wm.org/), je l'ai enfin quitté ! J'étais pourtant très heureux avec lui, et je n'avais pas grand-chose à lui reprocher. Cependant, je suis allé voir ailleurs, c'était juste pour le fun, j'ai rencontré [Pop! OS](https://pop.system76.com/), j'ai redécouvert un environnement de bureau moderne, et je suis resté !

## Un simple gestionnaire de fenêtres

J'ai toujours aimé mes distributions de Linux légères et construites sur mesure. C'est pourquoi j'ai utilisé des distributions serveurs sur lesquelles j'installais manuellement les paquets dont j'ai besoin : Debian (à mes débuts), Fedora (une valeur sûre vers laquelle je revenais régulièrement), Ubuntu (bravo et merci à Canonical pour voir autant aider à démocratiser Linux), et surtout Arch Linux.

Je n'utilisais donc pas d'environnement de bureau, mais un simple gestionnaire de fenêtres : i3. 

Pour vulgariser, les environnements de bureau, sous Linux, permettent de gérer graphiquement les actions du quotidien : ils contiennent l'explorateur de dossiers, le montage automatique des disques USB, une barre des tâches, un menu "Démarrer", etc. En anglais, on les appelle, "DE" pour Desktop Environments, pour n'en citer que quelque uns, ils se nomment Gnome, KDE, ou encore XFCE. Chacun de ces "DE" possède son propre gestionnaire de fenêtres ("WM" = Window Managers) : XFCE utilise XFwm, KDE utilise KWin.

De mon côté, je n'utilisais pas ces fameux "DE", juste le "WM". Donc, pas de montage automatique des clefs USB, pas d'explorateur de fichiers, etc. Je faisais tout "à la main", en ligne de commande. Je n'aime pas que mon bureau m'affiche des pop-up, ou me fasse perdre le "focus" sur la fenêtre dans laquelle je travaille. J'aime avoir le "contrôle" en permanence de mon environnement. C'est chouette, mais cela a un coût : plus de gestion manuelle, moins d'intégrations entre applications, etc.

## Le tiling, un choix de vie

Pour en revenir à i3, en plus d'être un choix assez radical, c'est aussi un fonctionnement très différent des "WM" classiques. En effet, il s'agit d'un "tiling WM". C'est à dire que chaque fenêtre crée a une taille et en placement prédéfinis, et que par défaut, ces fenêtres ne se chevauchent jamais et vont toujours remplir la totalité de l'écran. 

Par exemple, la première fenêtre remplira tout l'écran, avec la seconde fenêtre l'écran sera divisé en 2 zones de même taille, avec la troisième fenêtre l'écran sera divisé en 3, etc. A noter que c'est toujours la zone de la dernière fenêtre crée qui se divise en 2.

Je pense qu'une petite vidéo s'impose :
 
![Aperçu du tiling](/images/2022/02/tiling_demo_cut.gif)

Le gros avantage de ce système, c'est que tout se gère au clavier : changer le placement des fenêtres, naviguer entre elles, les redimensionner, etc. Avec un peu d'habitude, c'est hyper pratique et très fonctionnel !

Côté inconvénient, pas grand-chose de flagrant, mis à part le sentiment de ne pas avoir un système homogène ou cohérent. C'est un système que j'ai construit moi-même, brique par brique, à coups de scripts. Pourtant, j'ai toujours aimé "[customiser](https://www.reddit.com/r/unixporn/)" mon système au maximum en appliquant des thèmes, en utilisant des couleurs identiques partout (en ce moment, j'aime beaucoup la palette de couleurs [Nord](https://www.nordtheme.com/)). Mais, je ne sais pas, il me manquait quelque chose...

## La redécouverte d'un "DE" moderne

Depuis, [Enlightement avec les penguins](http://xpenguins.seul.org/images/epenguins.jpg) qui tombaient sur mes fenêtres, j'ai développé un amour fou pour les différents "DE". C'est pourquoi, je suis toujours à l'écoute des différentes distro Linux, tout particulièrement celles qui possèdent un "DE" original.

Lorsque j'ai entendu parler de Pop! OS avec un Gnome "modifié" utilisant un système de tiling, j'ai eu très envie de l'essayer.

Le système de tiling, [Pop Shell](https://github.com/pop-os/shell) peut être installé sur n'importe quel distro en tant qu'extension Gnome. 

Les premières heures demandent tout de même un peu configuration afin d'obtenir un comportement très proche d'i3 :
* il faut [remettre les mêmes raccourcis clavier](https://github.com/pop-os/shell/issues/142#issuecomment-663079699) ;
* il faut remettre des exceptions pour avoir certaines fenêtres toujours flottantes. Cela se fait directement via Pop Shell ;
* il faut [supprimer le pop up de changement de bureau virtuel](https://extensions.gnome.org/extension/4401/move-workspace-switcher-popup/) et les [animations superflues](https://extensions.gnome.org/extension/4290/disable-workspace-switch-animation-for-gnome-40) ;
* il faut installer l'extension [Auto Move Windows](https://extensions.gnome.org/extension/16/auto-move-windows/), afin que les fenêtres "se souviennent" de leur positionnement. Par exemple, j'utilise Firefox sur le bureau viruel 1, et je veux donc qu'il s'ouvre toujours ici. Pour ce qui est des applis de "communication", Telegram, Discord, seront sur le bureau virtuel 2, Steam sur le 10, etc.

_À noter qu'il existe aussi [cette extension](https://github.com/andyrichardson/simply-workspaces) pour reproduire le fonctionnement de [Polybar](https://wiki.archlinux.org/title/Polybar) sous i3. Malheureusement, cela ne fonctionne pas comme prévu chez moi, et je ne sais pas pourquoi._

Une fois la config faite, je me sentais à nouveau comme chez moi. La mémoire des muscles a pris le relais, et j'utilisais mon OS comme avant ! Il y a tout de même une légère lenteur dans l'apparition des fenêtres par rapport à i3, mais rien de vraiment gênant. 

_NB : sur le gif plus haut, on peut voir une grosse lenteur, mais elle n'est aussi importante dans une utilisation normale. J'ai fait la vidéo avec plusieurs VMs lancées, dont une VM en PCI passthrough avec un Windows dedans pour jouer, et pendant l'update du système..._

Du coup, pour le prix de cette légère lenteur, je récupère un OS un peu mieux ficelé avec des fioritures fun. Par exemple, si je clique que la date dans la barre des tâches, je vois le calendrier avec mes événements et tâches synchronisés depuis mon [NextCloud](https://nextcloud.com/fr_FR/). 

Je peux gérer mes contacts directement depuis une interface dédiée et intégrée dans Gnome.

Je règle directement via les options de Gnome le "mode nuit" (autrefois, je le lançais [redshift](https://doc.ubuntu-fr.org/redshift) via un script bash au démarrage de la session).

J'utilise un navigateur de fichiers pour monter / démonter les clefs USB, etc.

Je peux envoyer / recevoir des SMS et piloter mon PC via mon téléphone grâce à [GSConnect](https://github.com/GSConnect/gnome-shell-extension-gsconnect/wiki) tant que je suis sur le même réseau WiFi. 

_Auparavant, j'utilisais [Pushbullet](https://www.pushbullet.com/) pour l'envoi réception des SMS. Cela fonctionnait très bien, et même si mon téléphone n'était pas en WiFI. Par contre, il fallait un compte Google et envoyer mes données sur leurs serveurs..._

Le launcher intégré de Pop! OS permet de remplacer allégrement [Rofi](https://wiki.archlinux.org/title/Rofi), ce qui me permet de lancer n'importe quelle application en tapant les premières lettres de son nom. Encore une fois, c'est hyper pratique et un gain de temps incroyable de ne pas avoir à chercher une appli dans un menu pour la lancer.

## Derniers mots

Au final, pas de changements fondamentaux. Je trouve que c'est un bon compromis entre la gestion rapide au clavier et la facilité d'usage de l'interface graphique. Je n'ai pas non plus perdu en praticité, mettre une clef USB ne me fait pas perdre le focus et les nouvelles fenêtres que j'ouvre ne viennent pas cacher les fenêtres actuelles.

Bref, un nouveau "DE" adopté... Jusqu'au prochain !

