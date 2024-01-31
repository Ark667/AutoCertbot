
# TODO change default.conf file with env ${DOMAIN}
# TODO delete exiting certbot target folder (it will create a new one *-0001)
# rmdir /etc/letsencrypt/live/${DOMAIN} TODO 

sudo systemctl start nginx  # TODO should be done on start
mkdir /var/www/certbot      # TODO should be on Dockerfile

# Launch challenge for domain, Nginx must be running with Certbot configuration to resolve
certbot certonly -n --webroot --webroot-path /var/www/certbot/ -d ${DOMAIN} --agree-tos --email ${EMAIL}

# Create PFX file from letsencrypt certificates resolved by Certbot, output on desired path that should be mapped with Docker volume
openssl pkcs12 -inkey /etc/letsencrypt/live/${DOMAIN}/privkey.pem -in /etc/letsencrypt/live/${DOMAIN}/cert.pem -export -out ${CERT_PATH} -passout pass:${CERT_PASSWORD}
