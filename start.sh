#!/bin/bash

# Change default.conf file with env ${DOMAIN}
sed -i s/DOMAIN/${DOMAIN}/g nginx/conf/default.conf

# Delete exiting certbot target folder (it will create a new one *-0001)
rmdir /etc/letsencrypt/live/${DOMAIN}

# Start Nginx service
mkdir ${WEB_ROOT_PATH}
sudo systemctl enable nginx
sudo systemctl start nginx

# Launch challenge for domain, Nginx must be running with Certbot configuration to resolve
certbot certonly -n --webroot --webroot-path ${WEB_ROOT_PATH} -d ${DOMAIN} --agree-tos --email ${EMAIL}

# Create PFX file from letsencrypt certificates resolved by Certbot, output on desired path that should be mapped with Docker volume
openssl pkcs12 -inkey /etc/letsencrypt/live/${DOMAIN}/privkey.pem -in /etc/letsencrypt/live/${DOMAIN}/cert.pem -export -out ${CERT_PATH} -passout pass:${CERT_PASSWORD}
