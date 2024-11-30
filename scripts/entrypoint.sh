#!/bin/bash
set -e

sudo crond


# Discord webhook to say starting server 

exec /home/steam/valheim/valheim_server.x86_64 \
    -name "${SERVER_NAME}" \
    -port 2456 \
    -world "${WORLD_NAME}" \
    -password "${SERVER_PASS}" \
    -public "${SERVER_PUBLIC}" \
    -modifier "${MODIFIERS}" \
    -crossplay "true" \
    -nographics


