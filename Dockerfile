FROM ubuntu:20.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

RUN apt update
RUN apt upgrade
RUN apt install -y systemctl
RUN apt install -y sudo


# Install Certbot
RUN apt install -y certbot

# Install Ngnix
RUN apt update
RUN apt install -y nginx

COPY ./nginx/conf /etc/nginx/conf.d

RUN sudo systemctl enable nginx
RUN sudo systemctl start nginx

EXPOSE 80/tcp

RUN mkdir autocertbot
WORKDIR autocertbot

ENTRYPOINT [ "/bin/bash" ]
