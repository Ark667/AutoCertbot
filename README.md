# AutoCertbot

https://phoenixnap.com/kb/letsencrypt-docker

docker-compose run --rm certbot certonly --webroot --webroot-path /var/www/certbot/ --dry-run -d [domain-name]

docker-compose run --rm certbot renew
