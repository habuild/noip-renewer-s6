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
FROM docker.io/simaofsilva/noip-renewer:latest AS builder


# Copy addon root filesystem and then s6 and apparmor.txt should set permissions of all files. 
COPY rootfs /

RUN chmod -Rv a+x /etc/cont-init.d/** /etc/services.d/**

WORKDIR /etc/cont-init.d

ENTRYPOINT ["python3", "noip-options.py"]


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
    org.opencontainers.image.url="https://github.com/habuild/noip-renewer-s6/tree/main/noip-renewer-s6" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/tree/main/noip-renewer-s6/README.md" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.revision="${BUILD_REF}" \
    org.opencontainers.image.version="${BUILD_VERSION}"
