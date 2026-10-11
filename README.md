# Minecraft Bingo on Railway

Paper 1.21.5 with [Minecraft Bingo 1.12.1](https://github.com/Extremelyd1/minecraft-bingo/releases/tag/v1.12.1), using the itzg Minecraft server image and Java 21.

## Railway setup

Deploy this repository. Mount a persistent volume at `/data`. Set `OPS` to your Minecraft Java username. Set `EULA=TRUE` only after accepting the [Minecraft EULA](https://www.minecraft.net/eula). Add a TCP proxy for internal port `25565`.

The container uses a 2 GB Java heap, 12 player slots, view distance 6, and simulation distance 4. Microsoft account authentication is enabled. Remote console (RCON) is disabled. Keep one replica; the volume stores worlds and plugin settings.

## Play

Use Minecraft **Java Edition 1.21.5**. In Multiplayer, add the address shown in Railway Settings → Networking → TCP Proxy, including its port. No client mods are required.

As the operator, after everyone joins:

```text
/team random 2
/wincondition lines 1
/timer 30m
/start
```

Right-click the Bingo card to inspect targets. `/bingo` shows progress, `/end` ends the game, and `/reroll` creates a new card. The plugin creates its configuration in `/data/plugins/MinecraftBingo` on first start.

## Administration

Use Railway deployment logs to verify Paper reaches `Done` and MinecraftBingo enables without errors. Restart/redeploy through Railway. World and plugin data survive redeploys via the volume. Railway hosting incurs usage charges under your workspace plan.
