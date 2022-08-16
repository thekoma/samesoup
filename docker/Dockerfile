FROM ghcr.io/kanboard/kanboard:latest as plugin_installer
RUN apk --no-cache add curl jq unzip
ARG DEFAULT_PLUGINS="s3"
ENV PLUGINS=$DEFAULT_PLUGINS
ENV DEBUG=true
COPY download_plugins.sh /
ENV PLUGIN_INSTALLER=true
ENV PLUGINS_DIR=plugins_static
RUN mkdir /var/www/app/plugins_static; chmod 755 /var/www/app/plugins_static
RUN sh -x /download_plugins.sh
RUN echo BUILDER; ls /var/www/app/plugins_static/

FROM ghcr.io/kanboard/kanboard:latest
ENV PLUGINS_DIR=plugins_static
RUN apk add --no-cache jq
COPY --from=plugin_installer /var/www/app/plugins_static /var/www/app/plugins_static/
COPY modifications/ /