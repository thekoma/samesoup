#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
TMPDIR=$(mktemp -d)
SOCKSDIR=/opt/socks
apt-get remove -y docker docker-engine docker.io containerd runc man-db
apt autoremove
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    git \
    htop \
    ncdu

if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
  mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
fi
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose

mkdir -p "${SOCKSDIR}"
git clone https://github.com/microservices-demo/user-contribs $TMPDIR/user-contribs
cp "${TMPDIR}/user-contribs/deploy/docker-compose-weave/docker-compose.yml" "${SOCKSDIR}/docker-compose.yml"
docker compose -f "${SOCKSDIR}/docker-compose.yml" up -d