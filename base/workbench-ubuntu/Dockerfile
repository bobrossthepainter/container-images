ARG VERSION

FROM ubuntu:${VERSION}

ARG VERSION
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ENV TARGETPLATFORM=${TARGETPLATFORM:-linux/amd64}

# BUILDPLATFORM — matches the current machine. (e.g. linux/amd64)
# BUILDOS — os component of BUILDPLATFORM, e.g. linux
# BUILDARCH — e.g. amd64, arm64, riscv64
# BUILDVARIANT — used to set ARM variant, e.g. v7
# TARGETPLATFORM — The value set with --platform flag on build
# TARGETOS - OS component from --platform, e.g. linux
# TARGETARCH - Architecture from --platform, e.g. arm64
# TARGETVARIANT — used to set ARM variant, e.g. v7

# DEBIAN_FRONTEND: https://askubuntu.com/questions/972516/debian-frontend-environment-variable
# APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE: http://stackoverflow.com/questions/48162574/ddg#49462622
ENV \
  VERSION="${VERSION}" \
  DEBCONF_NONINTERACTIVE_SEEN=true \
  DEBIAN_FRONTEND="noninteractive" \
  APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

RUN mkdir -p /config

# hadolint ignore=DL3008,DL3015
RUN \
  set -eux \
  && echo 'APT::Install-Recommends "false";' >/etc/apt/apt.conf.d/00recommends \
  && echo 'APT::Install-Suggests "false";' >>/etc/apt/apt.conf.d/00recommends \
  && echo 'APT::Get::Install-Recommends "false";' >>/etc/apt/apt.conf.d/00recommends \
  && echo 'APT::Get::Install-Suggests "false";' >>/etc/apt/apt.conf.d/00recommends

COPY ./devcontainer-features/src/common-utils /usr/local/etc/vscode-dev-containers/common-utils

ENV USERNAME=root \
    ADD_NON_FREE_PACKAGES=true \
    CONFIGUREZSHASDEFAULTSHELL=true
RUN /usr/local/etc/vscode-dev-containers/common-utils/install.sh

# docker
ARG DOCKER_VERSION=25.0.4
RUN mkdir -p /opt && \
  curl -qL https://download.docker.com/linux/static/stable/$(uname -m)/docker-${DOCKER_VERSION}.tgz | tar xvz -C /opt && \
  ln -s /opt/docker/docker /usr/local/bin/docker

# go-task
ENV GO_TASK_VERSION=3.35.1
RUN curl -sSLo - https://github.com/go-task/task/releases/download/v${GO_TASK_VERSION}/task_${TARGETOS}_${TARGETARCH}.tar.gz | tar xzf - -C /usr/local/bin/

COPY ./base/workbench-ubuntu/shim /shim

COPY ./base/workbench-ubuntu/shim/greetings.txt /usr/local/etc/vscode-dev-containers/first-run-notice.txt

# RUN printf "$(cat /insertions/bash_config.sh)\n" >> /etc/bash.bashrc \
#   && printf "/bin/bash /shim/greeting.sh\n" >> /etc/bash.bashrc 

# ENTRYPOINT [ "/usr/bin/tini", "--" ]
ENTRYPOINT [ "/shim/shell.sh" ]

LABEL \
  org.opencontainers.image.base.name="ghcr.io/bobrossthepainter/container-images/workbench-ubuntu" \
  org.opencontainers.image.base.version="${VERSION}" \
  org.opencontainers.image.authors="Robert Lang <mail@roblang.de>"
