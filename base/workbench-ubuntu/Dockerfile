ARG BASE_VERSION

FROM ubuntu:${BASE_VERSION}

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
  BASE_VERSION="${BASE_VERSION}" \
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

# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
  # [IntelliJ] JBR font rendering and X11 graphics pipeline
  libfontconfig1 \
  fontconfig \
  fonts-dejavu-core \
  libfreetype6 \
  libxi6 \
  libxrender1 \
  libxtst6 \
  libxext6 \
  # [IntelliJ] JCEF (Java Chromium Embedded Framework) — Markdown preview, embedded browser, Jupyter
  libnss3 \
  libnspr4 \
  libgbm1 \
  libasound2 \
  libcups2 \
  libdrm2 \
  libatk1.0-0 \
  libatk-bridge2.0-0 \
  libatspi2.0-0 \
  libcairo2 \
  libpango-1.0-0 \
  libpangocairo-1.0-0 \
  libxcomposite1 \
  libxdamage1 \
  libxfixes3 \
  libxrandr2 \
  libxkbcommon0 \
  libdbus-1-3 \
  libexpat1 \
  libglib2.0-0 \
  # [VS Code] credential / secret storage
  libsecret-1-0 \
  gnome-keyring \
  # general developer tooling
  build-essential \
  make \
  dnsutils \
  iputils-ping \
  netcat-openbsd \
  file \
  patch \
  git-lfs \
  software-properties-common \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# docker
ARG DOCKER_VERSION=29.2.1
RUN mkdir -p /opt && \
  curl -qL https://download.docker.com/linux/static/stable/$(uname -m)/docker-${DOCKER_VERSION}.tgz | tar xvz -C /opt && \
  ln -s /opt/docker/docker /usr/local/bin/docker
# docker-buildx
RUN mkdir -p /usr/libexec/docker/cli-plugins && \
    curl -sSL https://github.com/docker/buildx/releases/latest/download/buildx-$(uname -s)-$(uname -m) -o /usr/libexec/docker/cli-plugins/docker-buildx && \
    chmod +x /usr/libexec/docker/cli-plugins/docker-buildx

# go-task
ENV GO_TASK_VERSION=3.48.0
RUN curl -sSLo - https://github.com/go-task/task/releases/download/v${GO_TASK_VERSION}/task_${TARGETOS}_${TARGETARCH}.tar.gz | tar xzf - -C /usr/local/bin/

COPY ./base/workbench-ubuntu/shim /shim

COPY ./base/workbench-ubuntu/shim/greetings.txt /usr/local/etc/vscode-dev-containers/first-run-notice.txt

# RUN printf "$(cat /insertions/bash_config.sh)\n" >> /etc/bash.bashrc \
#   && printf "/bin/bash /shim/greeting.sh\n" >> /etc/bash.bashrc

# ENTRYPOINT [ "/usr/bin/tini", "--" ]
ENTRYPOINT [ "/shim/shell.sh" ]

LABEL \
  org.opencontainers.image.base.name="ghcr.io/bobrossthepainter/container-images/workbench-ubuntu" \
  org.opencontainers.image.base.version="${BASE_VERSION}" \
  org.opencontainers.image.authors="Robert Lang <mail@roblang.de>"
