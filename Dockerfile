FROM alpine:3.16

# Actualizar el sistema e instalar dependencias
RUN apk update && apk upgrade && \
    apk add --no-cache sudo nginx certbot sed openssl

# Configuración del directorio raíz para webs
ENV WEB_ROOT_PATH=/var/www/certbot

# Copiar las configuraciones de nginx
COPY ./nginx /etc/nginx

EXPOSE 80

WORKDIR /autocertbot
COPY start.sh start.sh
RUN chmod 777 start.sh

ENTRYPOINT ["./start.sh"]
