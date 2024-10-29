#!/usr/bin/dumb-init /bin/sh
set -e
cd /opt/app

if [ -f "/config.yaml" ]; then
    echo "Using config.yaml from /"
    cp /config.yaml /opt/app/config.yaml
    chmod 444 /opt/app/config.yaml
    chown app:app /opt/app/config.yaml
fi

chown -R app:app /data/temporary-uploads

echo "Running database migrations"
su-exec app alembic upgrade head

echo "Starting szurubooru API on port ${PORT} - Running on ${THREADS} threads"
exec su-exec app waitress-serve-3 --port ${PORT} --threads ${THREADS} szurubooru.facade:app
