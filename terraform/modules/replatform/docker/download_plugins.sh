
#!/bin/bash
PLUGINS_URL=https://kanboard.org/plugins.json
env
for PLUGIN in $PLUGINS; do
  PLUGIN_URL=$(curl ${PLUGINS_URL} |jq -r ".${PLUGIN}.download")
  cd /var/www/app
  ./cli plugin:install $PLUGIN_URL
done
ls /var/www/app/plugins
