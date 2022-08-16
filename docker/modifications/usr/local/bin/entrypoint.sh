#!/bin/bash

#This script extract variables and put them into the config.php
#!/bin/bash

# Generate a new self signed SSL certificate when none is provided in the volume

CONFIG_FILE="/var/www/app/config.php"
PROJECT_ID=$(curl -s "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google")
TOKEN=$(curl -s "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token" -H "Metadata-Flavor: Google" | jq -r .access_token)
KEYS=(
  AWS_KEY:hmac_secret_id
  AWS_SECRET:hmac_secret_key
  AWS_S3_BUCKET:bucket-id
  DB_USERNAME:postgress-user
  DB_PASSWORD:postgress-password
  DB_HOSTNAME:db-host
  DB_NAME:postgress-db-name
)



function getvalue() {
    SECRET_ID=$1
    PAYLOAD=$(curl -s "https://secretmanager.googleapis.com/v1/projects/${PROJECT_ID}/secrets/${SECRET_ID}/versions/latest:access" \
    --request "GET" \
    --header "authorization: Bearer ${TOKEN}" \
    --header "content-type: application/json"|jq -r ".payload.data")
    if [[ "${PAYLOAD}" != "" ]]; then
      echo $PAYLOAD|base64 -d
    else
      exit 99
    fi
}

function setvalue() {
  SECRET_KEY=$1
  VARIABLE_KEY=$2
  VALUE=$(getvalue $1|sed 's#^gs://##g')
  cat <<EOF >> ${CONFIG_FILE}
define('$VARIABLE_KEY', '$VALUE');
EOF
}

cat /config.php.tpl > ${CONFIG_FILE}
for KEY in ${KEYS[@]}; do
  SECRET_KEY=$(echo $KEY |awk -F: '{print $2}')
  VARIABLE_KEY=$(echo $KEY |awk -F: '{print $1}')
  echo "Extractinc secret $SECRET_KEY to set $VARIABLE_KEY in config.php"
  setvalue ${SECRET_KEY} ${VARIABLE_KEY}
done

if [ ! -f /etc/nginx/ssl/kanboard.key  ] || [ ! -f /etc/nginx/ssl/kanboard.crt ]
then
    openssl req -x509 -nodes -newkey rsa:2048 -keyout /etc/nginx/ssl/kanboard.key -out /etc/nginx/ssl/kanboard.crt -subj "/C=GB/ST=London/L=London/O=Self Signed/OU=IT Department/CN=kanboard.org"
fi

chown -R nginx:nginx /var/www/app/data
chown -R nginx:nginx /var/www/app/plugins


exec /bin/s6-svscan /etc/services.d