#!/bin/bash
# HeadlessMC setup script - runs inside container
# Disables JLine for scriptable interaction
export JAVA_OPTS="-Dhmc.jline.enabled=false"

cd /headlessmc

# Run login command
echo "=== Starting HeadlessMC Login ==="
echo "login" | java -Dhmc.jline.enabled=false -jar headlessmc-launcher-wrapper.jar --command login

echo "=== Login complete. Starting setup... ==="
