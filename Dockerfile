# Inspired from https://github.com/seblucas/alpine-homeassistant
ARG ARCH=amd64
FROM multiarch/alpine:${ARCH}-v3.9 as builder

ARG VERSION=master

# # Set CC to musl for smaller binaries
# # https://github.com/JonathonReinhart/staticx#from-source
# ENV CC=/usr/local/musl/bin/musl-gcc

RUN apk add --no-cache \
        # Requirements for running staticx
        binutils \
        patchelf \
        python3 \
    && apk add --no-cache --virtual build-deps \
        # Requirements for building staticx
        gcc \
        scons \
        # Requirements for a succesful pip install
        python3-dev \
        libffi-dev \
        gcc \
        musl-dev \
        libressl-dev \
        make \
        linux-headers

RUN pip3 install \
      patchelf-wrapper \
      https://github.com/JonathonReinhart/staticx/archive/${VERSION}.zip

RUN apk del build-deps

CMD ["/usr/bin/staticx"]