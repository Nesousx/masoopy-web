---
title: Install GLPI on Ubuntu 18.04 with MariaDB and NGinX
date: 2018-12-04 08:18:42.000000000 +01:00
categories:
- linux
tags:
- asset management
permalink: "/install-glpi-on-ubuntu-18-04-with-mariadb-and-nginx/"
FeaturedImage: "/images//2018/12/Install-GLPI-on-Ubuntu-18.04-with-MariaDB-and-NGinX.png"
---
[GLPI](https://glpi-project.org/) is an asset management software. It can handle automatic inventory of your assets (workstations, servers, printers, etc.) ticketing, and much more. Let's see how to install it under Ubuntu with MariaDB and NGinX.

## Prepare your system

Simply install the requirements :

```text
sudo apt install nginx php7.0-fpm mariadb-server php7.0-curl php7.0-gd php7.0-mysql php7.0-cli php7.0-imap php7.0-ldap php7.0-apcu php7.0-xmlrpc php7.0-mbstring php7.0-xml php7.0-xmlrpc
```

Create the self signed certificates :

```text
cd /etc/ssl/certs sudo openssl req -x509 -newkey rsa:4096 -keyout private/gpli.domain.com.key -out glpi.domain.com.cert -days 3650 -nodes -subj '/CN=glpi.domain.com'
```

NB :

- Replace " **glpi.domain.com**" with your desired domain name (3 times!).
- The certificate is valid for 10 years ( **3650 days** ).
- The certificate will be located in **/etc/ssl/certs** and the key in **/etc/ssl/certs/private**.

Create the dhparam file for NGINX :

```text
cd /etc/ssl/certs
sudo openssl dhparam -out dhparam.pem 4096
```

Your system is now "well prepared", let's move on to the the setup of the various services.

## Prepare MySQL / MariaDB

Let's secure our database : MySQL / MariaDB installation :

```text
sudo mysql_secure_installation
```

Answer "yes" to all questions, and define a secure root password!

NB : you'll probably run into an error, where mysql / mariadb won't start. If you check journalctl, it will say something about apparmor denying the execution of mariadb. Run the following command and reboot (yes, reboot)!

```text
sudo aa-disable /usr/sbin/mysqld
```

Now, connect to mysql with "root" user and create the database + user for your GLPI installation :

```text
sudo mysql -u root -p
```

NB : make sure to connect to MySQL using "root", otherwise, you might run into issues.

```text
CREATE USER 'glpi'@'%' IDENTIFIED BY 'My-Aw3s0mE-P@SSW0rD'; CREATE DATABASE glpi; GRANT ALL PRIVILEGES ON glpi.* TO 'glpi'@'%';
```

## Prepare NGiNX

NGiNX is the web server, let's prepare it.

Remove the default website :

```text
sudo unlink /etc/nginx/sites-enabled/default
```

Now, we are going to create the "virtual-host" for NGiNX, in order to serve the GLPI website :

```text
sudo nano /etc/nginx/sites-available/glpi
```

Then paste the following :

```text
server { listen 80; 
server_name glpi.domain.com; 
return 301 https://$server_name$request_uri; } 

server { listen 443 ssl; server_name glpi.domain.com; 

ssl_certificate /etc/ssl/glpi.domain.com.cert; 
ssl_certificate_key /etc/ssl/private/glpi.domain.com.key; 
ssl_dhparam /etc/ssl/dhparam.pem; ssl_protocols TLSv1 TLSv1.1 TLSv1.2; 
ssl_prefer_server_ciphers on; ssl_ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS; 

root /var/www/glpi; index index.php; 
location / {try_files $uri $uri/ index.php;} 

location ~ .php$ { fastcgi_pass 127.0.0.1:9000; 
fastcgi_index index.php; 
include /etc/nginx/fastcgi_params; 
fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name; 
include fastcgi_params; fastcgi_param SERVER_NAME $host; } }
```

Then we create a symlink from the "available" directory to the "enabled" directory.

```text
sudo ln -s /etc/nginx/sites-available/glpi /etc/nginx/sites-enabled/glpi.conf
```

## Install the application

We'll prepare the required folders :

```text
mkdir -p /etc/glpimkdir -p /var/lib/glpimkdir -p /var/log/glpimkdir -p /var/www/glpi
```

Browse to [GLPI Github release page](https://github.com/glpi-project/glpi/releases), and copy link from latest version, then download it directly on your server in your home directory :

```text
cd wget https://github.com/glpi-project/glpi/releases/download/9.3.3/glpi-9.3.3.tgz
```

NB : use the .tgz file and replace version number with the latest one.

Extract the files :

```text
tar xzvf glpi-*.tgz
```

This should extract all the files into the glpi folder.

We are now going to the move the files to the appropriate folders so that our installation doesn't contain everything in the web directory (which is not secure).

Go to the glpi folder :

```text
cd ~/glpi
```

Then execute the following commands :

```text
mv config /etc/glpi/ mv files/ /var/lib/glpimv * /var/www/glpi
```

Now, gives the necessary rights :

```text
chown -R www-data: /etc/glpichown -R www-data: /var/lib/glpi chown -R www-data: /var/www/glpi
```

Everything should be ready, let's move on the next part!

## GLPI, follow the wizard

From now, on simply open a web browser and go to the IP address of your server, simply specifying the HTTPS protocol, this should be something like :

https://glpi.domain.com

NB : make sure to declare glpi.domain.com in some DNS server.

From now, on, simply follow the instruction on your screen...

Enter the database information :

- Server : localhost
- User : glpi
- Password : My-Aw3s0mE-P@SSW0rD

Select (or create) the database called "GLPI" ;

Windows like install, hit the "next" button until it is completed.

NB : your install might crash at some point with a timeout. Fear not, it is not blocking. Wait about 2 minutes, then keep on following the guide.

When it is done, browse to the main URL, and you should be brought to a brand new login page.

Log in with the default "admin" account which is " **glpi/glpi**". Once logged, in remember to change password for all the default accounts (and/or disable some of them), and remove the file install.php from your **/var/www/glpi/install** directory.

You are now all set, enjoy GPLI!

