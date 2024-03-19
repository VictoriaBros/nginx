#!/bin/bash

# vars
PROJECT_NAME=nginx
SERVICE_DNS=qa.streambix.com
WILDCARD_DNS=*.qa.streambix.com
ORG_NAME=victoriabros
ORG_EMAIL=technology@victoriabros.com
NETWORK="${ORG_NAME}_net"

printf "# configure Nginx\n"
printf "# request letsencrypt certificate once\n"
printf "$ docker run --rm \n\
    -p 443:443 \n\
    -p 80:80 \n\
    --name letsencrypt \n\
    -v /etc/letsencrypt:/etc/letsencrypt \n\
    -v /var/lib/letsencrypt:/var/lib/letsencrypt \n\
    certbot/certbot:latest \n\
    certonly --non-interactive --standalone --email $ORG_EMAIL --agree-tos --no-eff-email -d $SERVICE_DNS"

printf "\n\n# build nginx image\n"
printf "$ docker build -f docker/Dockerfile.nginx -t $ORG_NAME/$PROJECT_NAME:latest ."


printf "\n\n# create corporate network for service discovery\n"
printf "$ docker network create -d bridge $NETWORK"

printf "\n\n# manually add network to existing required docker instances\n"
printf "# --net victoriabros_net\n"

printf "\n\n# start nginx container\n"
printf "# nginx should redirect any requests on port 80 or 443\n"
printf "$ curl -v https://$SERVICE_DNS\n$ curl -v http://$SERVICE_DNS\n"
printf "$ docker run -d \n\
  -p 80:80 \n\
  -p 443:443 \n\
  --name nginx \n\
  --net $NETWORK \n\
  -v /etc/letsencrypt:/etc/letsencrypt \n\
  -v /usr/share/nginx/html:/usr/share/nginx/html \n\
  $ORG_NAME/$PROJECT_NAME:latest"

printf "\n\n# letsencrypt certificate renewal\n"
# nginx.conf has provisions for letsencrypt .well-known path for the webroot verification method.
# run command on cron periodically and cert will be renewed before expiring.
printf "$ docker run --rm --name letsencrypt \n\
    -v /etc/letsencrypt:/etc/letsencrypt \n\
    -v /var/lib/letsencrypt:/var/lib/letsencrypt \n\
    -v /usr/share/nginx/html:/usr/share/nginx/html \n\
    certbot/certbot:latest \n\
    certonly --non-interactive --webroot -w /usr/share/nginx/html --email $ORG_EMAIL --agree-tos --no-eff-email -d $SERVICE_DNS"

# To create SSL for Wildcard domain name(s)
printf "\n\n# letsencrypt certificate for wildcard domain name(s)\n"
printf "$ docker run --rm -it \n \
    -p 443:443 \n \
    -p 80:80 \n \
    --name letsencrypt \n \
    -v /etc/letsencrypt:/etc/letsencrypt \n \
    -v /var/lib/letsencrypt:/var/lib/letsencrypt \n \
    certbot/certbot:latest \n \
    certonly --manual  --force-renewal --email $ORG_EMAIL --agree-tos --server https://acme-v02.api.letsencrypt.org/directory --preferred-challenges=dns --no-eff-email -d $SERVICE_DNS -d $WILDCARD_DNS"


printf "\n\n# REMEMBER TO add DNS TXT to domain provider (following the prompt below)
# Please deploy a DNS TXT record under the name:
# _acme-challenge.<domain-you-created-newly.com>.
# with the following value:
# <some-value>\n"
