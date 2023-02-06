ARG VERSION

FROM ubuntu:${VERSION}

ARG VERSION
ARG TARGETPLATFORM
ARG TARGETOS
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
  && echo 'APT::Get::Install-Suggests "false";' >>/etc/apt/apt.conf.d/00recommends \
  && \
  apt-get -qq update \
  && \
  apt-get install -y \
  bash \
  zsh \
  ca-certificates \
  curl \
  dnsutils \
  jq \
  locales \
  tini \
  git \
  openssh-client \
  bash-completion \
  tzdata \
  vim-tiny \
  && \
  localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
  && ln -s /usr/bin/vim.tiny /usr/local/bin/vi \
  && ln -s /usr/bin/vim.tiny /usr/local/bin/vim \
  && ln -s /usr/bin/vim.tiny /usr/local/bin/nano \
  && ln -s /usr/bin/vim.tiny /usr/local/bin/emacs \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && apt-get autoremove -y \
  && apt-get clean \
  && \
  rm -rf \
  /tmp/* \
  /var/lib/apt/lists/* \
  /var/cache/apt/* \
  /var/tmp/*

ENV LANG en_US.UTF-8

# install arkade
RUN curl -sLS https://get.arkade.dev | sh

ENV PATH=$PATH:$HOME/.arkade/bin/
ENV COLORTERM=xterm-color
ENV TERM=xterm-color

# go-task
ENV GO_TASK_VERSION=3.20.0
RUN curl -sSLo - https://github.com/go-task/task/releases/download/v${GO_TASK_VERSION}/task_${TARGETOS}_${TARGETARCH}.tar.gz | tar xzf - -C /usr/local/bin/

COPY ./base/workbench-ubuntu/shim /shim
COPY ./base/workbench-ubuntu/insertions /insertions

RUN printf "$(cat /insertions/bash_config.sh)\n" >> /etc/bash.bashrc \
  && printf "/bin/bash /shim/greeting.sh\n" >> /etc/bash.bashrc 

ENTRYPOINT [ "/usr/bin/tini", "--" ]

LABEL \
  org.opencontainers.image.base.name="ghcr.io/bobrossthepainter/container-images/workbench-ubuntu" \
  org.opencontainers.image.base.version="${VERSION}" \
  org.opencontainers.image.authors="Robert Lang <mail@roblang.de>"
