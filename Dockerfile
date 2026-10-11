# syntax=docker/dockerfile:1.7
FROM itzg/minecraft-server:java25

ENV TYPE=CUSTOM \
    VERSION=26.2 \
    CUSTOM_SERVER=/opt/paper.jar \
    MEMORY=2G \
    MAX_PLAYERS=12 \
    VIEW_DISTANCE=12 \
    SIMULATION_DISTANCE=12 \
    LEVEL=missilewars_lobby \
    ONLINE_MODE=TRUE \
    ENABLE_RCON=FALSE \
    ALLOW_FLIGHT=TRUE \
    ALLOW_NETHER=FALSE \
    MODE=adventure \
    DIFFICULTY=easy \
    SPAWN_PROTECTION=0 \
    SPAWN_MONSTERS=FALSE \
    PVP=TRUE \
    MOTD="Missile Wars | Minecraft 26.2" \
    JVM_OPTS="--enable-preview"

ADD --checksum=sha256:bf1dcf627364f8a631ab15250d240eb5a8e89faaac523b391e1c61367fce9ff1 https://fill-data.papermc.io/v1/objects/bf1dcf627364f8a631ab15250d240eb5a8e89faaac523b391e1c61367fce9ff1/paper-26.2-133.jar /opt/paper.jar
ADD --checksum=sha256:dbfa2f88ae9439b995c64229e922c77c65c3a102a7f5964c971c9584c2925d81 https://github.com/encodeous/MissileWarsX/releases/download/v0.10.2/mwx-2.0-SNAPSHOT.jar /plugins/MissileWarsX.jar
ADD --checksum=sha256:a1706c41412a108e3d2fdbd9e9dd0c60904f2ba45414c6edf11c1262812e1838 https://github.com/IntellectualSites/FastAsyncWorldEdit/releases/download/2.16.1/FastAsyncWorldEdit-Paper-2.16.1.jar /plugins/FastAsyncWorldEdit.jar
ADD --checksum=sha256:ca3ec620315ff92bee2d6d09af297d77362e99b4791b163135b745262df75ecc https://github.com/dmulloy2/ProtocolLib/releases/download/dev-build/ProtocolLib.jar /plugins/ProtocolLib.jar

RUN chmod 644 /opt/paper.jar /plugins/*.jar

COPY --chmod=755 <<'SCRIPT' /start-minigames
#!/bin/bash
set -euo pipefail
cd /data
mkdir -p backups/disabled-plugins
if [ ! -f backups/.before-missilewars-complete ]; then
  echo "Preserving Bingo before activating MissileWarsX"
  tar --exclude='./backups' --exclude='./logs' --exclude='./libraries' --exclude='./cache' --exclude='./.cache' --exclude='./.paper-remapped' -czf backups/bingo-before-missilewars.tar.gz .
  touch backups/.before-missilewars-complete
fi
for jar in plugins/MinecraftBingo*.jar; do
  if [ -f "$jar" ]; then mv "$jar" backups/disabled-plugins/; fi
done
if [ ! -f backups/.missilewars-configured ]; then
  mkdir -p config
  cat > config/paper-global.yml <<'CONFIG'
_version: 31
unsupported-settings:
  allow-headless-pistons: true
  allow-piston-duplication: true
  allow-permanent-block-break-exploits: true
CONFIG
  cat > spigot.yml <<'CONFIG'
config-version: 12
settings:
  moved-too-quickly-multiplier: 200.0
  moved-wrongly-threshold: 100.0
world-settings:
  default:
    view-distance: default
    simulation-distance: default
    entity-tracking-range:
      players: 256
      animals: 256
      monsters: 256
      misc: 256
      other: 256
advancements:
  disable-saving: true
  disabled: ["*"]
CONFIG
  cat > bukkit.yml <<'CONFIG'
settings:
  allow-end: false
spawn-limits:
  water-ambient: 0
  monsters: 0
  animals: 0
  water-animals: 0
  ambient: 0
CONFIG
  touch backups/.missilewars-configured
fi
chown -R "${UID:-1000}:${GID:-1000}" /data/config /data/backups /data/spigot.yml /data/bukkit.yml
exec /start "$@"
SCRIPT

ENTRYPOINT ["/start-minigames"]
EXPOSE 25565
