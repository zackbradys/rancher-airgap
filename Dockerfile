FROM alpine

ARG BUILD_DATE

LABEL org.opencontainers.image.authors="zack.brady@rancherfederal.com" \
      org.opencontainers.image.source="https://github.com/zackbradys/rancher-offline" \
      org.opencontainers.image.created=$BUILD_DATE \
      org.opencontainers.image.title="zackbradys/rancher-offline" \
      org.opencontainers.image.description="A simple script to pull down all the off line"  \
      org.opencontainers.image.build="docker build -t zackbradys/rancher-offline --build-arg BUILD_DATE=$(date +%D) ." \
      org.opencontainers.image.run="docker run --rm -v /output/:/output/ zackbradys/rancher-offline" 

RUN apk -U add curl skopeo openssl bash

WORKDIR /output/

COPY rancher-offline-installer.sh /

ENTRYPOINT [ "/rancher-offline-installer.sh build" ]