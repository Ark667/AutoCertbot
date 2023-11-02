# AutoCertbot

```bash
docker run -rm -it \
  -p 80:80 \
  -v ${HOME}/.aspnet/https/:/home/autocertbot \
  -e CERT_PATH=/home/autocertbot/aspnetapp.pfx \
  -e CERT_PASSWORD=certPassword01 \
  -e DOMAIN=dev.mydance.zone \
  -e EMAIL=it@mydance.zone \
  autocertbot
```
  
#1 - Arrancar cosas
```bash
sudo systemctl start nginx
mkdir /var/www/certbot
```

#2 - Lanzar desafío de creación de certificado
```bash
certbot certonly -n --webroot --webroot-path /var/www/certbot/ -d ${DOMAIN} --agree-tos --email ${EMAIL}
```

#3 - Crear certificado PFX
```bash
openssl pkcs12 -inkey /etc/letsencrypt/live/${DOMAIN}/privkey.pem -in /etc/letsencrypt/live/${DOMAIN}/cert.pem -export -out ${CERT_PATH} -passout pass:${CERT_PASSWORD}
```


## Build image
docker build . -t autocertbot:latest

## Remove all exited containers
docker rm $(docker ps -a -f status=exited -f status=exited -q) && docker image prune --all

## Depurar Nginx
systemctl status nginx
sudo systemctl start nginx

## Depurar Certbot
certbot certonly --webroot --webroot-path /var/www/certbot/ --dry-run -d dev.mydance.zone
