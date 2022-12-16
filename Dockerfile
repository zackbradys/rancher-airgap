FROM alpine:latest

LABEL maintainer="zack.brady@rancherfederal.com"

RUN apk -U add curl skopeo openssl bash

WORKDIR /output/

COPY rancher-offline-installer.sh /

ENTRYPOINT [ "/rancher-offline-installer.sh build" ]