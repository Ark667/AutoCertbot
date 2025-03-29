#!/bin/bash

# Change default.conf file with env ${DOMAIN}
sed -i "s/DOMAIN/${DOMAIN}/g" /etc/nginx/conf.d/default.conf

# Delete exiting certbot target folder (it will create a new one *-0001)
if [ -d "/etc/letsencrypt/live/${DOMAIN}" ]; then
    rmdir "/etc/letsencrypt/live/${DOMAIN}"
fi

# Start Nginx service
if [ ! -d "${WEB_ROOT_PATH}" ]; then
    mkdir -p "${WEB_ROOT_PATH}"
fi
sudo systemctl enable nginx
sudo systemctl start nginx

# Launch challenge for domain, Nginx must be running with Certbot configuration to resolve
certbot certonly -n --webroot --webroot-path ${WEB_ROOT_PATH} -d ${DOMAIN} --agree-tos --email ${EMAIL}

if [ -f /etc/letsencrypt/live/${DOMAIN}/privkey.pem ] && [ -f /etc/letsencrypt/live/${DOMAIN}/cert.pem ]; then

    # Create PFX file from letsencrypt certificates resolved by Certbot, output on desired path that should be mapped with Docker volume    
    openssl pkcs12 -inkey /etc/letsencrypt/live/${DOMAIN}/privkey.pem -in /etc/letsencrypt/live/${DOMAIN}/cert.pem -export -out ${CERT_PATH} -passout pass:${CERT_PASSWORD}

    # Copy certificates to desired path that should be mapped with Docker volume
    CERT_NAME=$(basename "${CERT_PATH}")
    cp /etc/letsencrypt/live/${DOMAIN}/privkey.pem "$(dirname ${CERT_PATH})/${CERT_NAME}.key"
    cp /etc/letsencrypt/live/${DOMAIN}/cert.pem "$(dirname ${CERT_PATH})/${CERT_NAME}.crt"

else
    exit 1
fi
