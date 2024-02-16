#!/bin/bash
read -p "Enter the Domain name: " DOMAIN
read -p "Enter the email to notifty about certs: " EMAIL

apt-get install -y apt-transport-https software-properties-common wget
mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | tee -a /etc/apt/sources.list.d/grafana.list
apt-get update && apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
apt-get update
apt-get install grafana -y
apt-get install terraform -y

cat grafana.ini >> /etc/grafana/grafana.ini
systemctl daemon-reload
systemctl restart grafana-server

apt-get install snapd
snap install core
snap refresh core
snap install --classic certbot
ln -s /snap/bin/certbot /usr/bin/certbot
certbot certonly --standalone --non-interactive -d $DOMAIN --email $EMAIL --agree-tos --no-eff-email
ln -s /etc/letsencrypt/live/subdomain.mysite.com/privkey.pem /etc/grafana/grafana.key
ln -s /etc/letsencrypt/live/subdomain.mysite.com/fullchain.pem /etc/grafana/grafana.crt
chgrp -R grafana /etc/letsencrypt/*
chmod -R g+rx /etc/letsencrypt/*
chgrp -R grafana /etc/grafana/grafana.crt /etc/grafana/grafana.key
chmod 400 /etc/grafana/grafana.crt /etc/grafana/grafana.key
