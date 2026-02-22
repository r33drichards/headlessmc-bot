# HeadlessMC Bot - 2b2t with Baritone + Meteor Client

## Directory Structure
```
headlessmc-bot/
  hmc                          # Native HeadlessMC launcher
  headlessmc-launcher-wrapper.jar  # Wrapper (needed for plugins)
  HeadlessMC/
    config.properties           # Launcher config
    plugins/
      hmc-meteor-0.2.0.jar     # Meteor Client plugin
    auth/                       # Auth tokens (auto-created)
  .minecraft/
    mods/                       # Minecraft mods (auto-created)
```

## Quick Start

1. `cd ~/headlessmc-bot`
2. `java -jar headlessmc-launcher-wrapper.jar` (use wrapper for plugin support)
3. `login` - follow the Microsoft link to authenticate
4. `download fabric:1.21.4` - download Minecraft + Fabric
5. `specifics <version-id> hmc-specifics` - install CLI control mod
6. `specifics <version-id> hmc-optimizations` - install performance mod
7. `meteor` - download Meteor Client via plugin
8. Install Baritone manually into .minecraft/mods/
9. `mod add <version-id> fabric-api` - install Fabric API
10. `launch fabric:1.21.4 -lwjgl` - launch headless
11. `connect 2b2t.org` - connect to 2b2t

## Notes
- 2b2t queue can take hours - the session must stay alive
- Auth tokens auto-refresh every 24 hours via hmc-specifics
- Baritone commands via chat: `msg #goto X Y Z`
- Meteor commands via hmc-meteor: check `meteor` command in-game
