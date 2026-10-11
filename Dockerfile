FROM itzg/minecraft-server:java21

ENV TYPE=PAPER \
    VERSION=1.21.5 \
    MEMORY=2G \
    MAX_PLAYERS=12 \
    VIEW_DISTANCE=6 \
    SIMULATION_DISTANCE=4 \
    ONLINE_MODE=TRUE \
    ENABLE_RCON=FALSE \
    MOTD="Minecraft Bingo" \
    PLUGINS="https://github.com/Extremelyd1/minecraft-bingo/releases/download/v1.12.1/MinecraftBingo-1.12.1.jar"

EXPOSE 25565
