FROM ghcr.io/kanboard/kanboard:latest as plugin_installer
RUN apk add curl jq unzip
ARG DEFAULT_PLUGINS="s3 PITM"
ENV PLUGINS=$DEFAULT_PLUGINS
ENV DEBUG=true
ADD download_plugins.sh /
ENV PLUGIN_INSTALLER=true
ENV PLUGINS_DIR=plugins_static
RUN mkdir /var/www/app/plugins_static; chmod 755 /var/www/app/plugins_static
RUN sh -x /download_plugins.sh
RUN echo BUILDER; ls /var/www/app/plugins_static/

FROM ghcr.io/kanboard/kanboard:latest
ENV PLUGINS_DIR=plugins_static
RUN mkdir /var/www/app/plugins_static; chmod 755 /var/www/app/plugins_static
COPY --from=plugin_installer /var/www/app/plugins_static /var/www/app/plugins_static/
ADD config.php /var/www/app/
ADD env.conf /etc/php8/php-fpm.d/