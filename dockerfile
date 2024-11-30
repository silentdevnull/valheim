# Dockerfile
FROM archlinux:latest

# Install required packages and setup base
RUN pacman -Sy --noconfirm \
    base-devel \
    git \
    lib32-gcc-libs \
    lib32-glibc \
    screen \
    python \
    iproute2 \
    sudo \
    cronie \
    wget \
    libgl \
    vulkan-intel \
    mesa \
    xorg-server-xvfb && \
    rm -rf /var/cache/pacman/pkg/*

# Create steam user
RUN useradd -m steam && \
    usermod -aG wheel steam && \
    echo "steam ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Create required directories and set permissions
RUN mkdir -p /scripts && \
    mkdir -p /home/steam/.config/unity3d/IronGate/Valheim/worlds_local && \
    mkdir -p /home/steam/.config/unity3d/IronGate/Valheim/worlds && \
    mkdir -p /backups && \
    chown -R steam:steam /home/steam/.config && \
    chown -R steam:steam /backups && \
    chmod -R 755 /home/steam/.config && \
    chmod 755 /scripts

# Copy scripts first and set permissions
COPY scripts/ /scripts/
RUN chmod 755 /scripts/*.sh && \
    chown -R steam:steam /scripts

# Install steamcmd manually
RUN mkdir -p /home/steam/steamcmd && \
    cd /home/steam/steamcmd && \
    wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && \
    tar -xvzf steamcmd_linux.tar.gz && \
    rm steamcmd_linux.tar.gz && \
    chown -R steam:steam /home/steam/steamcmd

# Switch to steam user
USER steam
WORKDIR /home/steam

# Create required Steam directories
RUN mkdir -p /home/steam/.steam/sdk64 && \
    mkdir -p /home/steam/valheim

# Install Valheim server using the correct path
RUN /home/steam/steamcmd/steamcmd.sh +force_install_dir /home/steam/valheim +login anonymous +app_update 896660 validate +quit

# Setup cron jobs
USER root
RUN echo "0 */6 * * * /scripts/backup.sh" >> /etc/cron.d/valheim-cron && \
    echo "0 */12 * * * /scripts/update.sh" >> /etc/cron.d/valheim-cron && \
    chmod 0644 /etc/cron.d/valheim-cron && \
    crontab -u steam /etc/cron.d/valheim-cron

# Switch back to steam user
USER steam

# Create default world data
RUN mkdir -p /home/steam/.config/unity3d/IronGate/Valheim/worlds && \
    mkdir -p /home/steam/.config/unity3d/IronGate/Valheim/characters && \
    touch /home/steam/.config/unity3d/IronGate/Valheim/adminlist.txt && \
    touch /home/steam/.config/unity3d/IronGate/Valheim/bannedlist.txt && \
    touch /home/steam/.config/unity3d/IronGate/Valheim/permittedlist.txt

# Verify script is executable in the shell
SHELL ["/bin/bash", "-c"]
RUN ls -la /scripts/entrypoint.sh && \
    test -x /scripts/entrypoint.sh

# Set entry point
ENTRYPOINT ["/bin/bash", "/scripts/entrypoint.sh"]
