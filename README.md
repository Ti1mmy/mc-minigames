# Minecraft minigames on Railway

The active game is **MissileWarsX**, running on **Minecraft Java 26.2**, Paper build 133 and Java 25. No client mods are required. Bingo is preserved and disabled while Missile Wars is active.

## Join and play

Server: `mainline.proxy.rlwy.net:49105`

Players join the Missile Wars lobby automatically. Step onto the team pads to join a team. With players on both teams, run `/mwx start`. Useful commands: `/mwx lobby`, `/mwx spectate`, and `/mwx help`. Operator `Ti1mmy` can run `/mwx info`, `/mwx end`, and `/mwx team <player> <red|green>`.

The default classic arena, five missile types, fireballs, arrows and shields are included. View distance is 12 chunks, simulation distance is 12, and the maximum player count is 12. Microsoft account authentication stays enabled; RCON stays disabled.

## Deployment

Deploy the Dockerfile from this repository. Keep one replica and a persistent volume mounted at `/data`. Railway variables include `OPS=Ti1mmy`, `VIEW_DISTANCE=12`, and `EULA=TRUE` (the owner accepted the Minecraft EULA). The TCP proxy forwards to internal port 25565.

Paper, MissileWarsX, FAWE and ProtocolLib downloads are checked against SHA-256 hashes. ProtocolLib uses the upstream development build with 26.2 support; if upstream replaces its download, update the URL/hash together after testing compatibility.

On first Missile Wars startup, the wrapper archives the existing data to `/data/backups/bingo-before-missilewars.tar.gz`, then moves the Bingo jar to `/data/backups/disabled-plugins`. Bingo world folders and `/data/plugins/MinecraftBingo` remain preserved. The active Minecraft level is `missilewars_lobby` and the plugin arena is `missilewars_game`.

## Return to Bingo

Stop the Missile Wars server before restoring data. Preserve any Missile Wars progress separately. Restore the original server properties and Paper/Bukkit/Spigot configurations from the backup; move the Bingo jar back from `backups/disabled-plugins` to `plugins`, and move MissileWarsX/FAWE/ProtocolLib jars outside `plugins`. Restore the original Bingo Dockerfile from commit `ac3f0efb0d1249e47448dc839041a127ef0fd8e9` and redeploy (Paper 1.21.5, Java 21). Keep `VIEW_DISTANCE=12` in Railway. Do not open worlds upgraded to 26.2 with 1.21.5; use the preserved Bingo worlds.

Bingo commands after switching back: `/team random 2`, `/wincondition lines 1`, `/timer 30m`, `/start`.

## Upstream projects

- [MissileWarsX](https://github.com/encodeous/MissileWarsX)
- [FastAsyncWorldEdit](https://github.com/IntellectualSites/FastAsyncWorldEdit)
- [ProtocolLib](https://github.com/dmulloy2/ProtocolLib)
- [Minecraft Bingo](https://github.com/Extremelyd1/minecraft-bingo)
