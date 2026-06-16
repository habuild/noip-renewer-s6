# Use base Home Assistant container
FROM ghcr.io/home-assistant/base:latest 

# Add Simoa's if he updates the renew.py or habuild renew.py docker container.
FROM ghcr.io/habuild/noip-renewer:latest@sha256:1cf246d0198dc748ea75ade475407abb05029ab652509d060f71ec0029cb9a72 AS builder

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
ARG MY_BUILD_ARG="default-value"

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
