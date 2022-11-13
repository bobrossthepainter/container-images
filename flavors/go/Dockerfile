FROM ghcr.io/bobrossthepainter/ubuntu-jammy:rolling@sha256:d07c99ab3a87b76e4a8460d5d6c2c3ff18d55c20f84e777aa3c2db698e1db075

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION

# ENV CGO_ENABLED=0 \
#   GOPATH=/go \
#   GOBIN=/go/bin \
#   GO111MODULE=on

WORKDIR /go/src/coredns

# We apply cap_net_bind_service so that coredns can be run as
# non-root and still listen on port less than 1024

# hadolint ignore=DL4006
# RUN \
#   export GOOS \
#   && GOOS=$(echo ${TARGETPLATFORM} | cut -d / -f1) \
#   && export GOARCH \
#   && GOARCH=$(echo ${TARGETPLATFORM} | cut -d / -f2) \
#   && export GOARM \
#   && GOARM=$(echo ${TARGETPLATFORM} | cut -d / -f3 | cut -c2-) \
#   && apk --no-cache --no-progress add ca-certificates git libcap \
#   && git clone https://github.com/coredns/coredns.git --branch "v${VERSION}" --depth 1 --single-branch .

RUN \
  export GO_VERSION=1.18 \
  && export GOPATH=/go \
  && \
  apt-get update -yq \
  && apt-get install -yq \
  gnupg \
  lsb-release \
  && export DISTRO="$(lsb_release -s -c)" \
  && apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 52B59B1571A79DBC054901C0F6BC817356A3D45E \
  && echo "deb http://ppa.launchpad.net/longsleep/golang-backports/ubuntu $DISTRO main" | tee /etc/apt/sources.list.d/gosource.list \
  && echo "deb-src http://ppa.launchpad.net/longsleep/golang-backports/ubuntu $DISTRO main" | tee -a /etc/apt/sources.list.d/gosource.list \
  && apt-get update -yq \
  && apt-get install -yq \
  golang-${GO_VERSION} \
  && \
  /usr/lib/go-${GO_VERSION}/bin/go install github.com/drone/envsubst/cmd/envsubst@latest \
  && mv /go/bin/envsubst /usr/local/bin/envsubst \
  && envsubst --version \
  && \
  apt-key del 52B59B1571A79DBC054901C0F6BC817356A3D45E \
  && \
  apt-get remove -y gnupg golang-${GO_VERSION} lsb-release \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && apt-get autoremove -y \
  && apt-get clean \
  && unset GO_VERSION \
  && unset GOPATH \
  && unset DISTRO \
  && \
  rm -rf \
  /go \
  /etc/apt/sources.list.d/gosource.list \
  /tmp/* \
  /var/lib/apt/lists/* \
  /var/cache/apt/* \
  /var/tmp/*

LABEL org.opencontainers.image.title="GoLang" \
  org.opencontainers.image.version="${VERSION}"
