---
title: Using Unifi controller on Docker
date: 2018-11-10 18:04:27.000000000 +01:00
categories:
- linux
tags: []
permalink: "/using-unifi-controller-on-docker/"
FeaturedImage: "/images/2021/02/unifi.png"
---
Following a post on [Reddit](https://www.reddit.com/r/Ubiquiti/comments/9umu34/controller_w_dockercompose_nginx_reverseproxy/), I decided to share my config used to run the Unifi controller. Doing so, you won't have to purchase a [Unifi Cloud Controller](https://amzn.to/2T2mLnS).

Spoiler alert... [I no longer use Unifi hardware](https://www.masoopy.com/all-your-devices-are-belong-to-ubiquity/), and I'll share why in a future post.

### System Overview

I have 2 servers :

- local server at home, which runs the Unifi controller in a Docker swarm setup ;
- remote server online, which runs the NGiNX reverse proxy.

The local server uses firewall rules (via PFSense) in order to filter incoming requests, so that it only accepts request from the remote server.

### Home server

As explained above, my local server runs the Unifi server in Docker swarm "mode", here is the config :

```text
version: '3'

services:
  unifi:
    image: linuxserver/unifi
    deploy:
     replicas: 1
    hostname: unifi.domain.com
    ports:
      - "3478:3478/udp"
      - "10001:10001/udp"
      - "8080:8080"
      - "8081:8081"
      - "8443:8443"
      - "8843:8843"
      - "8880:8880"
      - "6789:6789"
    environment:
      - PUID=1000 
      - PGID=1000
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - ./config:/config
    networks:
     default:
         aliases:
          - unifi
```

As you can see, I expose quite a lot of ports, however they are almost all available only from my local network.

The only exception being the port 8443 that is open to my remote server (via PFSense firewall).

For more information about the Docker image, please check [their official page](https://hub.docker.com/r/linuxserver/unifi/).

### Remote server

For the nginx part, I do not use the [jwilder version](https://hub.docker.com/r/jwilder/nginx-proxy/), because as far as I know, it requires ports to be exposed.

I'll start by showing my container config. This is a docker-compose.yml file :

```text
version: '2'

services:
  nginx:
    image: nginx
    container_name: nginx
    ports:
      - "443:443"
      - "80:80"
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - ./conf.d:/etc/nginx/conf.d
      - /etc/letsencrypt:/etc/nginx/ssl
      - /srv/data/ssl/dhparam.pem:/etc/nginx/cert/dhparam.pem
    restart: unless-stopped
    networks:
      default:
        aliases:
          - nginx

networks:
  default:
    external:
      name: br0
```

Let's explain a little bit what it does :

- I only expose ports 80 and 443 ;
- [The nginx (official)](https://hub.docker.com/_/nginx/) image mounts volumes /etc/letsencrypt directory + [DH param](https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html) file from host as well, into my container and the conf.d directory (which holds my virtual hosts) ;
- I create network aliases and separate networks for my "group of apps".

The network thing is very important. Remember, when I told you that I do not want to expose too many ports. Creating separate networks allow me to do so.

I have all my "web" apps, on the same network (br0, on this example). Which means, the reverse proxy can reach any other container by using its alias (even when containers's IP change). This is kind of Docker's internal DNS system.

I see two main benefits by not exposing the ports when my "backend" containers and my reverse proxy containers are running both on the same host &nbsp;:

1. I can use the same "internal" ports on all my backend containers (often 80 or 443);
2. I only expose 80 and 443 from my remote server to the rest of the world!

### Setting up nginx virtual host

Now, that I have shared the reverse proxy container, let's see how it is connecting to my local computer.

This is a nginx vhost config which resides in ./conf.d (symlinked from ./conf.d/vhost) :

```text
server {
       listen 80;
       server_name unifi.domain.com;
       return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl;
    ssl_certificate /etc/nginx/ssl/live/domain.com/fullchain.pem;
    ssl_certificate_key /etc/nginx/ssl/live/domain.com/privkey.pem;

    ssl_dhparam /etc/nginx/cert/dhparam.pem;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_prefer_server_ciphers on;
    ssl_ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS;

    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    server_name unifi.domain.com;
    access_log on;
    location / {
        proxy_pass https://domain.com:8443;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-for $remote_addr;
        port_in_redirect off;
        proxy_connect_timeout 300;
    }
}
```

As you can see, the proxy pass directive uses: https://domain.com:8443. Like I explained previously, domain.com points to my home server and port 8443 is only open from my remote server.

If the Unifi controller were running on the same host, then the proxy pass would point to the the network alias of that container without exposing any port. It would look something like below:

```text
&nbsp; &nbsp;proxy_pass https://unifi:8443;
```

Finally, unifi.domain.com points to my remote server and force redirects to the httpS URL, using wildcard certs from Let's Encrypt.

### Getting it all httpS!

I generated my wildard certificate thanks to [Let's Encrypt Docker image](https://hub.docker.com/r/certbot/dns-cloudflare/).

Finally SSL certs are automagically renewed via a systemd "job" than runs the official letsencrypt container and renew my cert (wildcard), like below :

```text
docker run -v /etc/letsencrypt/:/etc/letsencrypt/ certbot/dns-cloudflare renew --dns-cloudflare --email my@email.com --agree-tos --dns-cloudflare-credentials /etc/letsencrypt/cloudflare.ini
```
