## hadolint ignore=DL3006 
## Always tag the version of an image explicitly
## hadolint ignore=DL3007
## Using latest is prone to errors if the image will ever update. Pin the version explicitly to a release tag

# hadolint ignore=DL3006
# Use base Home Assistant container
ARG BUILD_FROM=ghcr.io/home-assistant/base:latest 
FROM ${BUILD_FROM}

# hadolint ignore=DL3007
# Add Simoa's if he updates the renew.py or habuild renew.py docker container.
FROM docker.io/habuild/noip-renewer-base:latest@sha256:30ca1f73c576bcb3858ee3789419ff976a0ed046c30e97196083c13aaa027287 AS builder

#ENV NO_IP_USERNAME="Email" \
#    NO_IP_PASSWORD="Password" \
#    NO_IP_TOTP_KEY="NOIP_TOTP_KEY" \
#    TRANSLATE_ENABLED="false"


# Build arguments    <<<< Need to remove this to build or add to build_arch to ignore builder
ARG BUILD_ARCH  
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version="${BUILD_VERSION}" \
    maintainer="Hasqt <https://community.home-assistant.io/u/hasqt>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Hasqt" \
    org.opencontainers.image.authors="Hasqt <https://community.home-assistant.io/u/hasqt>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/habuild/noip-renewer-ha/tree/main/noip-renewer-ha" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/noip-renewer-ha/README.md" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.revision="${BUILD_REF}" \
    org.opencontainers.image.version="${BUILD_VERSION}"
