#!/bin/bash
PATH=$PATH:/root/.local/bin
# Installing Web frontend from: https://github.com/khaledosman/angular-realworld-example-app

export DEBIAN_FRONTEND=noninteractive
TMPDIR=$(mktemp -d)



id -g webapp >/dev/null || groupadd webapp
id -g frontend >/dev/null || (groupadd frontend && useradd frontend -m -g frontend -G webapp -s /bin/bash)
id -g backend >/dev/null || (groupadd backend && useradd backend -m -g backend -G webapp -s /bin/bash)

set -e

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
    su frontend -c 'git clone https://github.com/khaledosman/angular-realworld-example-app /opt/realdemo/frontend'
else
    cd opt/realdemo/frontend || exit
    su frontend -c 'git pull'
fi

npm install -g @angular/cli
npm install -g yarn
su frontend -c 'cd /opt/realdemo/frontend && yarn install'
su frontend -c 'cd /opt/realdemo/frontend && ng build --configuration=production'
# rsync -vaz --delete /opt/realdemo/frontend/dist/* /var/www/html


# Install Backend

su backend -c 'curl -sSL https://install.python-poetry.org | python3 -'

if [[ ! -d /opt/realdemo/backend ]]; then
    su backend -c 'git clone https://github.com/nsidnev/fastapi-realworld-example-app /opt/realdemo/backend'
    su backend -c 'cd /opt/realdemo/backend; /home/backend/.local/bin/poetry install'
    su backend -c 'touch /opt/realdemo/backend/.env'
else
    su backend -c 'cd /opt/realdemo/backend; git pull'
    su backend -c 'cd /opt/realdemo/backend; /home/backend/.local/bin/poetry update'
    su backend -c 'touch /opt/realdemo/backend/.env'
fi

DB=$(gcloud secrets versions access  latest --secret="postgress-db-name")
DB_PASSWORD=$(gcloud secrets versions access  latest --secret="postgress-password")
DB_USER=$(gcloud secrets versions access  latest --secret="postgress-user")
DB_HOST=$(gcloud secrets versions access  latest --secret="db-host")
SECRET_KEY=$(gcloud secrets versions access  latest --secret="secret-key")

DATABASE_URL=postgresql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:5432/${DB}
echo $DATABASE_URL
echo $SECRET_KEY

cat << EOF > /opt/realdemo/backend/.env
DATABASE_URL=postgresql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:5432/${DB}
SECRET_KEY=$SECRET_KEY
APP_ENV=dev
EOF



# Configurazione systemd
cat << EOF > /etc/systemd/system/backend.service
[Unit]
Description=backend
After=network.target

[Service]
Type=simple
User=backend
Group=backend
DynamicUser=true
WorkingDirectory=/opt/realdemo/backend
PrivateTmp=true
EnvironmentFile=/opt/realdemo/backend/.env
ExecStartPre=/home/backend/.local/bin/poetry run \
    alembic upgrade head
ExecStart=/home/backend/.local/bin/poetry run \
    uvicorn app.main:app --reload
ExecReload=/bin/kill -HUP \${MAINPID}
RestartSec=5
Restart=always

[Install]
WantedBy=multi-user.target
EOF


cat << EOF > /etc/systemd/system/frontend.service
[Unit]
Description=frontend
After=network.target

[Service]
Type=simple
User=frontend
Group=frontend
DynamicUser=true
WorkingDirectory=/opt/realdemo/frontend
PrivateTmp=true
EnvironmentFile=-/opt/realdemo/frontend/.env
ExecStart=/usr/bin/ng serve --open --disable-host-check --configuration=production
ExecReload=/bin/kill -HUP \${MAINPID}
RestartSec=5
Restart=always

[Install]
WantedBy=multi-user.target
EOF


cat << EOF > /etc/nginx/sites-enabled/api
server {
  listen 80;
  client_max_body_size 4G;

  server_name api.*;

  location / {
    proxy_set_header Host \$http_host;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection \$connection_upgrade;
    proxy_redirect off;
    proxy_buffering off;
    proxy_pass http://uvicorn;
  }

}

map \$http_upgrade \$connection_upgrade {
  default upgrade;
  '' close;
}

upstream uvicorn {
  server 127.0.0.1:8000;
}
EOF

cat << EOF > /etc/nginx/sites-enabled/www
server {
  listen 80;
  client_max_body_size 4G;

  server_name www.*;

  location / {
    proxy_set_header Host \$http_host;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection \$connection_upgrade;
    proxy_redirect off;
    proxy_buffering off;
    proxy_pass http://npm;
  }

}

map \$http_upgrade \$connection_upgrade {
  default upgrade;
  '' close;
}

upstream npm {
  server 127.0.0.1:4200;
}
EOF

systemctl daemon-reload
systemctl enable --now frontend
systemctl enable --now backend
systemctl enable --now nginx
systemctl restart nginx
