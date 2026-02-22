FROM 3arthqu4ke/headlessmc:latest

WORKDIR /headlessmc

# Install Xvfb, VNC, noVNC, screen, and fonts
RUN apt-get update && \
    apt-get install -y xvfb x11vnc novnc websockify screen \
    libxi6 libxrender1 libxtst6 fonts-dejavu-core && \
    rm -rf /var/lib/apt/lists/*

# Pre-create mod directories (gamedir is /headlessmc/HeadlessMC/run)
RUN mkdir -p /headlessmc/HeadlessMC/run/mods /headlessmc/HeadlessMC/plugins

# Copy hmc-meteor plugin
COPY HeadlessMC/plugins/hmc-meteor-0.2.0.jar /headlessmc/HeadlessMC/plugins/hmc-meteor-0.2.0.jar

# Download Meteor Client (latest, targets MC 1.21.11)
RUN curl -Lo /headlessmc/HeadlessMC/run/mods/meteor-client.jar 'https://meteorclient.com/api/download'

# Download Baritone (Meteor fork for MC 1.21.11)
RUN curl -Lo /headlessmc/HeadlessMC/run/mods/baritone.jar \
    'https://maven.meteordev.org/snapshots/meteordevelopment/baritone/1.21.11-SNAPSHOT/baritone-1.21.11-20260103.131549-1.jar'

# Config: use Xvfb instead of LWJGL patching, disable dummy assets
RUN sed -i 's/hmc.always.lwjgl.flag=true/hmc.always.lwjgl.flag=false/' /headlessmc/HeadlessMC/config.properties && \
    sed -i 's/hmc.invert.lwjgl.flag=true/hmc.invert.lwjgl.flag=false/' /headlessmc/HeadlessMC/config.properties && \
    echo 'hmc.account.refresh.on.game.launch=true' >> /headlessmc/HeadlessMC/config.properties && \
    echo 'hmc.jline.enabled=false' >> /headlessmc/HeadlessMC/config.properties

# Expose noVNC web port
EXPOSE 6080

COPY entrypoint.sh /headlessmc/entrypoint.sh
RUN chmod +x /headlessmc/entrypoint.sh

CMD ["/headlessmc/entrypoint.sh"]
