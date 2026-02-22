#!/bin/bash
# Downloads HeadlessMC binaries from GitHub releases
set -euo pipefail

HMC_VERSION="${HMC_VERSION:-2.8.0}"
BASE_URL="https://github.com/headlesshq/headlessmc/releases/download/${HMC_VERSION}"

echo "Downloading HeadlessMC ${HMC_VERSION}..."

# Detect platform for native binary
OS="$(uname -s)"
ARCH="$(uname -m)"
case "${OS}-${ARCH}" in
    Darwin-arm64) NATIVE="headlessmc-launcher-macos-arm64" ;;
    Darwin-x86_64) NATIVE="headlessmc-launcher-macos-x64" ;;
    Linux-aarch64) NATIVE="headlessmc-launcher-linux-arm64" ;;
    Linux-x86_64)  NATIVE="headlessmc-launcher-linux-x64" ;;
    *)             NATIVE="" ;;
esac

# Download wrapper jar (needed for plugin support)
curl -Lo headlessmc-launcher-wrapper.jar "${BASE_URL}/headlessmc-launcher-wrapper-${HMC_VERSION}.jar"
echo "Downloaded headlessmc-launcher-wrapper.jar"

# Download native binary
if [ -n "${NATIVE}" ]; then
    curl -Lo hmc "${BASE_URL}/${NATIVE}"
    chmod +x hmc
    echo "Downloaded hmc (${NATIVE})"
else
    echo "Warning: No native binary for ${OS}-${ARCH}, use the wrapper jar instead"
fi

echo "Done."
