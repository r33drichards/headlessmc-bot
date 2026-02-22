# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Headless Minecraft bot for 2b2t using HeadlessMC + Fabric 1.21.1 with Meteor Client and Baritone. Runs Minecraft without a real display via Xvfb, with optional VNC/noVNC for visual monitoring.

## Architecture

- **`hmc`** — Native HeadlessMC launcher binary (arm64 macOS). For local use without Docker.
- **`headlessmc-launcher-wrapper.jar`** — Java wrapper that enables HeadlessMC plugin support. Always use this instead of `hmc` when plugins (like hmc-meteor) are needed.
- **`HeadlessMC/`** — Launcher config and plugins directory. `config.properties` controls headless mode, auth, and asset settings. The `plugins/` subdirectory holds HeadlessMC plugins (e.g., hmc-meteor for Meteor Client integration).
- **`Dockerfile`** — Based on `3arthqu4ke/headlessmc:latest`. Sets up Xvfb + VNC + noVNC, downloads Meteor Client and Baritone, configures HeadlessMC to use Xvfb instead of LWJGL patching.
- **`entrypoint.sh`** — Starts Xvfb (:99), x11vnc, noVNC (port 6080), then launches HeadlessMC wrapper in a `screen` session named `hmc`.
- **`docker-compose.yml`** — Manages the container with persistent volumes for game data (`hmc-run`) and auth tokens (`hmc-auth`). Exposes noVNC on port 6080.

## Key Commands

### Setup
```bash
./download-deps.sh            # Download hmc + wrapper jar from GitHub releases
HMC_VERSION=2.8.0 ./download-deps.sh  # Pin a specific version
```

### Docker (primary workflow)
```bash
docker compose build          # Build the container
docker compose up -d          # Start in background
docker attach headlessmc-bot  # Attach to HeadlessMC console
docker compose down           # Stop
```

### Inside HeadlessMC console
```
login                                    # Microsoft auth (follow link)
download fabric:1.21.1                   # Download Minecraft + Fabric
specifics <version-id> hmc-specifics     # Install CLI control mod
specifics <version-id> hmc-optimizations # Install performance mod
meteor                                   # Download Meteor Client (via plugin)
mod add <version-id> fabric-api          # Install Fabric API
launch fabric:1.21.1 -lwjgl             # Launch headless (local, no Xvfb)
launch fabric:1.21.1                     # Launch with Xvfb (Docker)
connect 2b2t.org                         # Connect to server
```

### In-game commands
- Baritone: `msg #goto X Y Z`
- Meteor: use `meteor` command

### Local (without Docker)
```bash
java -jar headlessmc-launcher-wrapper.jar   # Start with plugin support
```

## Important Notes

- The Dockerfile switches from LWJGL patching to Xvfb (`hmc.always.lwjgl.flag=false`), while local `config.properties` uses LWJGL patching (`hmc.always.lwjgl.flag=true`). These are intentionally different.
- 2b2t queue can take hours — the session must stay alive throughout.
- Auth tokens auto-refresh every 24 hours via hmc-specifics.
- Game data lives at `/headlessmc/HeadlessMC/run/` inside the container (persisted via Docker volume).
- noVNC is accessible at `http://localhost:6080` when the container is running.
