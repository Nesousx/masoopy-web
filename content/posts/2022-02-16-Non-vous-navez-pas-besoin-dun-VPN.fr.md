---
title: "Non, vous n'avez pas besoin d'un VPN !"
date: 2022-02-16T00:48:07+01:00
categories: [polémique]
tags: ["VPN", "monétisation"]
FeaturedImage: "/images/2022/02/pas_de_VPN.png"
---

Depuis plusieurs années les VPN (Virtual Private Network) ont le vent en poupe. Ils sont recommandés à tour de bras sur Youtube et par beaucoup d'autres médias.À les écouter, un VPN est indispensable, mais je ne suis pas d'accord. Non, vous n'avez pas besoin d'un VPN ! Peu d'entre nous ont osé s'élever contre le diktat du VPN Panaméen, mais je ne suis [pas](https://www.canardpc.com/hardware/la-page-de-la-rage/vous-navez-pas-besoin-dun-vpn) le [seul](https://www.youtube.com/watch?v=ckZGQ5cLIfs).

## Les promesses vs la réalité

### Anonymat
  
Promesse : Les VPN vous promettent de protéger votre confidentialité, vos achats en ligne, vous rendre anonyme, etc.

Réalité : Les données sont chiffrées entre la société fournissant le VPN et vous-même. Cela veut dire que votre FAI ne verra effectivement plus du tout ce que vous faites sur Internet. Par contre, le vendeur de VPN, lui, aura la possibilité de tout voir. En général, ces sociétés se trouvent dans des paradis fiscaux et ont des lois beaucoup moins strictes que nos FAI Français (par exemple, pas de RGPD). Du coup, si quelqu'un doit avoir accès aux données de navigation, ne vaut-il pas mieux que ce soit votre FAI ?

Côté anonymat, c'est uniquement vrai pour l'adresse IP qui n'est plus la "votre" (et encore, dans le cas des IPs dédiées, ce point est un moins valable). [Les sites web continuent de vous traquer](https://www.cnil.fr/fr/nouvelles-methodes-de-tracage-en-ligne-quelles-solutions-pour-se-proteger) via les cookies, votre navigateur, OS, résolution d'écran, etc.

### Le "no-log"

Promesse : Aucun log n'est conservé.

Réalité : Vous me direz que les vendeurs de VPN ne conservent aucun log. C'est en effet la promesse faite. En pratique, c'est invérifiable, et comme on dit, les promesses n'engagent que ceux qui les croient. Quand bien même les log seraient réellement supprimés à la seconde où ils sont générés, rien n'empêche un pirate (ou un état) de capter / dupliquer ces logs avant leur destruction. Qui plus est, [il y eu des ratés avérés](https://vpnleaks.com/).

### Une sécurité renforcée

Promesse : Vous surfez sans danger sur Internet.

Réalité : Le "P" de VPN pour Private, n'a rien à voir avec la vie privée. Bien au contraire, il signifie que vous invitez les autres utilisateurs du VPN chez vous, dans votre réseau privé et leur donnez accès à vos données. Normalement, un VPN est bien configuré de sorte que chaque utilisateur soit "bloqué" dans son coin et ne puisse pas voir ses compères. Malheureusement, mais ce n'est pas toujours il y a eu des [erreurs de configuration](https://www.cloudbric.com/blog/2020/09/virtual-private-network-data-leakage/) et [des failles](https://www.theregister.com/2020/07/17/ufo_vpn_database/) qui ont permis de donner un accès complet à votre réseau local aux autres usagers.

En admettant que la configuration du VPN du côté vendeur soit béton, alors le seul point qui vous protège, c'est lors de l'usage de point d'accès WiFi ouverts (type McDo, hôtels, etc). De nos jours, avec les offres data assez conséquentes et valables dans de multiples pays, est-ce vraiment bien nécessaire de passer par des hotspots ?

### Accès au contenu géolocalisé

Promesse : Vous pouvez accéder à du contenu provenant d'autres pays.

Réalité : C'est probablement vrai, mais en le faisant, il y a de fortes chances que vous enfreignez les conditions d'utilisation du service. Contourner HADOPI ? C'est également illégal... À noter qu'il existe d'autres solutions "plus propres" pour ces usages.

## Le mot de la fin

Dans la très grande majorité des cas, vous n'avez pas besoin de VPN ! EN tous cas, pas d'un VPN "Youtube". Si vous utilisez un VPN, il s'agit probablement du VPN fourni par votre employeur ou d'un VPN perso que vous utilisez pour accéder à vos serveurs @home ou équivalent.

Si vous avez vraiment besoin d'un VPN, je ne peux que vous recommander de [le monter vous-même](https://www.awoui.com/post/cr%C3%A9er-votre-propre-vpn-avec-wireguard-sur-docker), ou bien de le prendre via des sociétés plus sérieuses, je pense notamment à [Freedome]https://www.f-secure.com/fr/home/products/freedome de F-Secure.