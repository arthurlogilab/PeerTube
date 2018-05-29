#!/bin/sh
set -e

# Populate config directory
if [ -z "$(ls -A /config)" ]; then
    cp /app/support/docker/production/config/* /config
fi

# Always copy default and custom env configuration file, in cases where new keys were added
cp /app/config/default.yaml /config
cp /app/config/custom-environment-variables.yaml /config
chown -R peertube:peertube /config

# first arg is `-f` or `--some-option`
# or first arg is `something.conf`
if [ "${1#-}" != "$1" ] || [ "${1%.conf}" != "$1" ]; then
    set -- npm "$@"
fi

# allow the container to be started with `--user`
if [ "$1" = 'npm' -a "$(id -u)" = '0' ]; then
    chown -R peertube:peertube /data
    exec gosu peertube "$0" "$@"
fi

exec "$@"
