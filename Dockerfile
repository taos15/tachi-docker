# Use eclipse-temurin JRE
FROM ghcr.io/linuxserver/baseimage-alpine:3.17

ARG VERSION

# Install dependencies
RUN apk add -U --upgrade --no-cache curl openjdk8-jre-base tzdata jq

# Create the /config directory
RUN mkdir -p /app/tachidesk

WORKDIR /app/tachidesk

# Download the latest release from the GitHub repository
RUN if [ -z "$VERSION" ]; then \
      curl -s https://api.github.com/repos/Suwayomi/Suwayomi-Server/releases/latest \
      | jq -r ".assets[] | select(.name | test(\"Suwayomi-Server-v[0-9.]*-r[0-9]*\\.jar$\")) | .browser_download_url" \
      | xargs curl -L -o Tachidesk-Server-Latest.jar; \
      else \
      curl -L -o Tachidesk-Server-Latest.jar "https://github.com/Suwayomi/Suwayomi-Server/releases/download/v${VERSION}/Suwayomi-Server-v${VERSION}.jar"; \
      fi


# Container Labels
LABEL maintainer="Taos15" \
      org.opencontainers.image.title="Tachi-docker" \
      org.opencontainers.image.authors="https://github.com/taos15" \
      org.opencontainers.image.url="https://github.com/suwayomi/docker-tachidesk/pkgs/container/tachidesk" \
      org.opencontainers.image.source="https://github.com/taos15/tachi-docker" \
      org.opencontainers.image.description="This image is used to start tachidesk jar executable in a container" \
      org.opencontainers.image.vendor="suwayomi" \
      org.opencontainers.image.licenses="MPL-2.0"


# copy local files
COPY root/ /

# ports and volumes
EXPOSE 4567
VOLUME /config
