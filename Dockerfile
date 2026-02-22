FROM eclipse-temurin:21-jammy

WORKDIR /headlessmc

# Install Xvfb, VNC, noVNC, screen, and fonts
RUN apt-get update && \
    apt-get install -y xvfb x11vnc novnc websockify screen curl \
    libxi6 libxrender1 libxtst6 fonts-dejavu-core && \
    rm -rf /var/lib/apt/lists/*

# Download HeadlessMC launcher wrapper
RUN curl -Lo /headlessmc/headlessmc-launcher-wrapper.jar \
    'https://github.com/3arthqu4ke/headlessmc/releases/download/2.8.0/headlessmc-launcher-wrapper-2.8.0.jar'

# Create directory structure
RUN mkdir -p /root/.minecraft/mods /headlessmc/HeadlessMC/plugins

# Write Docker-specific config.properties
RUN printf '%s\n' \
    'hmc.always.lwjgl.flag=false' \
    'hmc.invert.lwjgl.flag=false' \
    'hmc.assets.dummy=true' \
    'hmc.auto.download.java=true' \
    'hmc.store.accounts=true' \
    'hmc.account.refresh.on.game.launch=true' \
    'hmc.jline.enabled=false' \
    > /headlessmc/HeadlessMC/config.properties

# Copy hmc-meteor plugin
COPY HeadlessMC/plugins/hmc-meteor-0.2.0.jar /headlessmc/HeadlessMC/plugins/hmc-meteor-0.2.0.jar

# Download Meteor Client (for MC 1.21.4) into default .minecraft/mods
RUN curl -Lo /root/.minecraft/mods/meteor-client.jar \
    'https://meteorclient.com/api/download?version=1.21.4'

# Download Baritone (Meteor fork for MC 1.21.4) into default .minecraft/mods
RUN curl -Lo /root/.minecraft/mods/baritone.jar \
    'https://maven.meteordev.org/snapshots/meteordevelopment/baritone/1.21.4-SNAPSHOT/baritone-1.21.4-20250105.184728-1.jar'

# Expose noVNC web port
EXPOSE 6080

COPY entrypoint.sh /headlessmc/entrypoint.sh
RUN chmod +x /headlessmc/entrypoint.sh

CMD ["/headlessmc/entrypoint.sh"]
