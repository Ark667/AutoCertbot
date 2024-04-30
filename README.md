# AutoCertbot

## Build image

```bash
docker build . -t autocertbot:latest
```

## Launc container

```bash
docker run --rm -it \
  -p 80:80 \
  -v ${HOME}/.aspnet/https/:/home/autocertbot \
  -e WEB_ROOT_PATH=/var/www/certbot \
  -e CERT_PATH=/home/autocertbot/aspnetapp.pfx \
  -e CERT_PASSWORD=certPassword01 \
  -e DOMAIN=dev.mydance.zone \
  -e EMAIL=it@mydance.zone \
  ghcr.io/ark667/autocertbot:main
```


### Remove all exited containers
docker rm $(docker ps -a -f status=exited -f status=exited -q) && docker image prune --all

### Remove current image
docker rmi ghcr.io/ark667/autocertbot:main --force

### Debug Nginx
systemctl status nginx

