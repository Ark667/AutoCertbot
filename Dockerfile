FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt upgrade -y
RUN apt install -y systemctl
RUN apt install -y sudo

# Install Certbot
RUN apt install -y certbot

# Install Ngnix
RUN apt install -y nginx
ENV WEB_ROOT_PATH=/var/www/certbot
COPY ./nginx/conf /etc/nginx/conf.d

EXPOSE 80/tcp

RUN mkdir autocertbot
WORKDIR autocertbot
COPY start.sh start.sh
RUN chmod 777 start.sh

ENTRYPOINT [ "./start.sh" ]
