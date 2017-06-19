# Author: Salam Hiyali
# Created at: 2017-06-13

# info
FROM ubuntu:latest
MAINTAINER Salam Hiyali "hiyali920@gmail.com"
ENV REFRESHED_AT 2017-06-15

# apt source
RUN apt -y update && apt -y upgrade

RUN apt -y install curl
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - # has update

RUN apt install -y nodejs bzip2 libfontconfig # bzip2 for install PhantomJS and libfontconfig for PhantomJS
RUN apt install -y mongodb
RUN apt install -y git-core ca-certificates ssh  # ca-certificates & ssh for git clone
RUN apt install -y cron
RUN apt install -y vim # The reason is that for edit file in docker sometimes

# work folder
RUN mkdir -p /hunt
WORKDIR /hunt

# n & yarn
RUN npm i -g n yarn http-server && n latest

# run mongo
RUN mkdir -p ./db && mkdir -p ./log && touch ./log/mongod.log

# for git clone
ENV HOME /root
ADD .ssh/ /root/.ssh/
RUN chmod 600 /root/.ssh/*
RUN ssh-keyscan -p8080 some-gitlab.com > /root/.ssh/known_hosts

# crawler repo install
RUN git clone ssh://git@yourdomain.com:8080/salam/ticket-crawler.git crawler
RUN cd ./crawler && npm i
RUN git clone ssh://git@some-gitlab.com:8080/salam/hunt-crawler-admin.git admin
RUN cd ./admin && npm i
RUN cd ./admin && yarn run build:prod

# volume
VOLUME ["/hunt/db"]

# copy run script
COPY run.sh /hunt/
RUN chmod +x /hunt/run.sh

# expose
EXPOSE 5555
EXPOSE 80

# ENTRYPOINT ["./run.sh"]
