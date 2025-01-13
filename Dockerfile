# Use eclipse-temurin JRE

# Stage 1: Build the Suwayomi-Server app
FROM ghcr.io/linuxserver/baseimage-alpine:3.21

# set version label
ARG BUILD_DATE
ARG VERSION
ARG SUWAYOMI_RELEASE
LABEL maintainer="taos15"

# Install dependencies
RUN  apk add -U --upgrade --no-cache curl openjdk21-jre tzdata jq

# Create the /config directory
RUN mkdir -p /app/suwayomi-server
RUN mkdir -p /build

RUN \
      if [ -z ${SUWAYOMI_RELEASE+x} ];  then \
      SUWAYOMI_RELEASE=$(curl -sX GET "https://api.github.com/repos/Suwayomi/Suwayomi-Server-preview/releases/latest" \
      | awk '/tag_name/{print $4;exit}' FS='[""]'); \
      fi && \
      curl -o \
      /build/Suwayomi-Server.jar -L \
      "https://github.com/Suwayomi/Suwayomi-Server-preview/releases/download/${SUWAYOMI_RELEASE}/Suwayomi-Server-${SUWAYOMI_RELEASE}.jar" 


# Container Labels
LABEL maintainer="Taos15" \
      org.opencontainers.image.title="Tachi-docker" \
      org.opencontainers.image.authors="https://github.com/taos15" \
      org.opencontainers.image.url="https://github.com/suwayomi/docker-Suwayomi-Server/pkgs/container/Suwayomi-Server" \
      org.opencontainers.image.source="https://github.com/taos15/tachi-docker" \
      org.opencontainers.image.description="This image is used to start Suwayomi-Server jar executable in a container" \
      org.opencontainers.image.vendor="suwayomi" \
      org.opencontainers.image.licenses="MPL-2.0"


# copy local files
COPY root/ /

# ports and volumes
EXPOSE 4567
VOLUME /config
