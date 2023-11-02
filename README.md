# AutoCertbot

https://phoenixnap.com/kb/letsencrypt-docker

docker-compose run --rm certbot certonly --webroot --webroot-path /var/www/certbot/ --dry-run -d [domain-name]

docker-compose run --rm certbot renew


## Build image
docker build . -t autocertbot:latest

## Remove all exited containers
docker rm $(docker ps -a -f status=exited -f status=exited -q)


## Depurar Nginx
systemctl status nginx
sudo systemctl start nginx

## Depurar Certbot
certbot certonly --webroot --webroot-path /var/www/certbot/ --dry-run -d dev.mydance.zone


# Lanzar desafío de creación de certificado
docker run -it -p 80:80 -v ${HOME}/letsencrypt/keys:/etc/letsencrypt/keys/ -v ${HOME}/letsencrypt/csr:/etc/letsencrypt/csr/ --restart always  autocertbot

# Crear certificado PFX
openssl pkcs12 -inkey /etc/letsencrypt/live/dev.mydance.zone/privkey.pem -in /etc/letsencrypt/live/dev.mydance.zone/cert.pem -export -out /etc/letsencrypt/live/dev.mydance.zone/cert.pfx -passout pass:certPassword01
