#!/bin/sh

# Check env vars with value
for VAR in DOMAIN WEB_ROOT_PATH EMAIL CERT_PATH CERT_PASSWORD; do
    eval "value=\$$VAR"
    if [ -z "$value" ]; then
        echo "Error: La variable de entorno ${VAR} no está definida."
        exit 1
    fi
done

# Change default.conf file with env ${DOMAIN}
sed -i "s/DOMAIN/${DOMAIN}/g" /etc/nginx/nginx.conf

# Delete existing certbot target folder (it will create a new one *-0001)
if [ -d "/etc/letsencrypt/live/${DOMAIN}" ]; then
    rmdir "/etc/letsencrypt/live/${DOMAIN}"
fi

# Start Nginx service
if [ ! -d "${WEB_ROOT_PATH}" ]; then
    mkdir -p "${WEB_ROOT_PATH}"
fi

# Start Nginx service
nginx
if [ $? -ne 0 ]; then
    echo "Error: Nginx did not launch properly. Exiting..."
    exit 1
fi

# Launch challenge for domain, Nginx must be running with Certbot configuration to resolve
certbot certonly -n --webroot --webroot-path ${WEB_ROOT_PATH} -d ${DOMAIN} --agree-tos --email ${EMAIL}

# Stop Nginx service
nginx -s stop

if [ -f /etc/letsencrypt/live/${DOMAIN}/privkey.pem ] && [ -f /etc/letsencrypt/live/${DOMAIN}/cert.pem ]; then

    # Create PFX file from letsencrypt certificates resolved by Certbot, output on desired path that should be mapped with Docker volume    
    openssl pkcs12 -inkey /etc/letsencrypt/live/${DOMAIN}/privkey.pem -in /etc/letsencrypt/live/${DOMAIN}/cert.pem -export -out ${CERT_PATH} -passout pass:${CERT_PASSWORD}

    # Copy certificates to desired path that should be mapped with Docker volume
    CERT_NAME=$(basename "${CERT_PATH}")
    CERT_NAME="${CERT_NAME%.*}"
    cp /etc/letsencrypt/live/${DOMAIN}/privkey.pem "$(dirname ${CERT_PATH})/${CERT_NAME}.key"
    cp /etc/letsencrypt/live/${DOMAIN}/cert.pem "$(dirname ${CERT_PATH})/${CERT_NAME}.crt"

else
    exit 1
fi
