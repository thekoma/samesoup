#!/bin/bash
PATH=$PATH:/root/.local/bin
# Installing Web frontend from: https://github.com/khaledosman/angular-realworld-example-app

export DEBIAN_FRONTEND=noninteractive
TMPDIR=$(mktemp -d)



id -g webapp >/dev/null || groupadd webapp

if [[ ! -d /opt/realdemo ]]; then
    mkdir -p /opt/realdemo
    chgrp webapp /opt/realdemo
    chmod 775 /opt/realdemo
fi

if [[ ! $(command -v npm) ]]; then
    apt-get remove -y docker docker-engine docker.io containerd runc man-db
    apt autoremove
    sudo apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release \
        git \
        htop \
        ncdu \
        nginx \
        wget \
        rsync \
        python3 \
        python3-distutils
    systemctl enable --now nginx
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
    apt-get install -y nodejs
fi

# Installing Frontend
if [[ ! -d /opt/realdemo/frontend ]]; then
    git clone https://github.com/khaledosman/angular-realworld-example-app /opt/realdemo/frontend
else
    cd opt/realdemo/frontend || exit
    git pull
fi
cd /opt/realdemo/frontend || exit
npm install -g @angular/cli
npm install -g yarn
yarn install
ng build --configuration=production
rsync -vaz --delete /opt/realdemo/frontend/dist/* /usr/share/nginx/html/


# Install Backend
id -g backend >/dev/null || (groupadd backend && useradd backend -m -g backend)
su backend -c 'curl -sSL https://install.python-poetry.org | python3 -'

if [[ ! -d /opt/realdemo/backend ]]; then
    su backend -c 'git clone https://github.com/nsidnev/fastapi-realworld-example-app /opt/realdemo/backend'
    su backend -c 'cd /opt/realdemo/backend; /home/backend/.local/bin/poetry install'
else
    su backend -c 'cd /opt/realdemo/backend; git pull'
    su backend -c 'cd /opt/realdemo/backend; /home/backend/.local/bin/poetry update'
fi

DB=$(gcloud secrets versions access  latest --secret="postgress-db-name")
DB_PASSWORD=$(gcloud secrets versions access  latest --secret="postgress-password")
DB_USER=$(gcloud secrets versions access  latest --secret="postgress-user")
DB_IP=$(gcloud secrets versions access  latest --secret="postgress-ip")
SECRET_KEY=$(gcloud secrets versions access  latest --secret="secret-key")

DATABASE_URL=postgresql://${DB_USER}:${DB_PASSWORD}@${DB_IP}:5432/${DB}
