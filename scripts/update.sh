#!/bin/bash

# Check if players are online
player_count=$(netstat -nap | grep :2456 | grep ESTABLISHED | wc -l)



if [ "$player_count" -eq 0 ]; then
    echo "No players online, proceeding with update..."
# Add discord webhook    
    # Stop the server
    screen -S valheim -X quit
    
    # Update the server
    steamcmd +force_install_dir /home/steam/valheim +login anonymous +app_update 896660 validate +quit
    
    # Restart the server
    /scripts/entrypoint.sh
else
    echo "Players are online, skipping update"
    # Add discord web   
fi
