# AutoCertbot

## Build image

```bash
docker build . -t autocertbot:latest
```

## Launch container

```bash
docker run --rm -it \
  -p 80:80 \
  -v ${HOME}/.aspnet/https/:/home/autocertbot \
  -e CERT_PATH=/home/autocertbot/aspnetapp.pfx \
  -e CERT_PASSWORD=certPassword01 \
  -e DOMAIN=www.domain.com \
  -e EMAIL=email@domain.com \
  ghcr.io/ark667/autocertbot:latest
```

