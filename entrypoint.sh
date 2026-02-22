#!/bin/bash
# Start Xvfb virtual framebuffer
Xvfb :99 -screen 0 1280x720x24 -nolisten tcp &
export DISPLAY=:99
sleep 1
echo "Xvfb started on display :99"

# Start x11vnc to serve the Xvfb display
x11vnc -display :99 -nopw -listen 0.0.0.0 -rfbport 5900 -shared -forever -noxdamage &
sleep 1
echo "VNC server started on port 5900"

# Start noVNC web client (browser access)
websockify --web /usr/share/novnc 6080 localhost:5900 &
sleep 1
echo "================================================"
echo "  noVNC available at: http://localhost:6080"
echo "  Open in browser to see Minecraft!"
echo "================================================"

# Start HeadlessMC wrapper in a screen session
screen -dmS hmc bash -c "cd /headlessmc && DISPLAY=:99 java -jar headlessmc-launcher-wrapper.jar 2>&1 | tee /tmp/hmc.log"
echo "HeadlessMC started in screen session 'hmc'"
sleep 2
tail -f /tmp/hmc.log
