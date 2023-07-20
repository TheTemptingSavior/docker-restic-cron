FROM golang:1.20-alpine as builder

RUN apk add git && \
    git clone https://github.com/restic/restic /go/src/github.com/restic/restic
WORKDIR /go/src/github.com/restic/restic
RUN go run build.go -v -o /usr/bin/restic


FROM ghcr.io/linuxserver/baseimage-alpine:3.18

# packages as variables
ARG BUILD_PACKAGES=""
ARG RUNTIME_PACKAGES="\
    fuse curl openssh"

COPY --from=builder /usr/bin/restic /bin/restic

RUN \
 if [ -n "${BUILD_PACKAGES}" ]; then \
    echo "**** install build packages ****" && \
    apk add --no-cache \
        --virtual=build-dependencies \
        $BUILD_PACKAGES; \
 fi && \
 if [ -n "${RUNTIME_PACKAGES}" ]; then \
    echo "**** install runtime packages ****" && \
    apk add --no-cache \
        $RUNTIME_PACKAGES; \
 fi && \
 echo "**** cleanup ****" && \
 if [ -n "${BUILD_PACKAGES}" ]; then \
    apk del --purge \
        build-dependencies; \
 fi && \
 rm -rf \
    /root/.cache \
    /tmp/*

# copy local files
COPY root /

# docker mods
ENV DOCKER_MODS linuxserver/mods:universal-cron
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS 1

ENV RESTIC_KEEP_DAILY 7
ENV RESTIC_KEEP_WEEKLY 4
ENV RESTIC_KEEP_MONTHLY 6
ENV RESTIC_KEEP_YEARLY 2
ENV RESTIC_COMPRESSION max
ENV RESTIC_CACHE_DIR /config/cache

VOLUME /config /ssh
