# Project: Geneva Driving Open World (Roblox)

This repo contains **Lua scripts only** for a Roblox driving game.
I manually copy scripts from this repo into Roblox Studio.

## Environment

- Target: Roblox, Luau syntax compatible with Lua 5.1.
- No external Lua libraries.
- Use only standard Roblox APIs (game:GetService, Players, ReplicatedStorage, etc).
- There is **no test harness** in this repo. Do not try to run tests, just write clean code.

## Folder structure

- `shared/`:
  - `Config.lua`: global constants (economy, distance ratios, etc).
  - `VehicleStats.lua`: stats per car (speed, acceleration, handling).

- `server/` (goes to ServerScriptService):
  - `PlayerData.server.lua`: handle DataStore, loading/saving, leaderstats.
  - `DistanceReward.server.lua`: track distance driven and give money.
  - `CarSpawn.server.lua`: spawn/despawn cars for each player.
  - `GarageServer.server.lua`: handle RemoteEvents for buying/equipping cars.

- `client/` (client scripts / GUIs):
  - `CarController.client.lua`: local input & camera handling for the player car.
  - `HUD.client.lua`: UI for speed, money, km.
  - `GarageUI.client.lua`: open/close garage, show cars list, send requests to server.

## Code style

- Prefer clear, small modules.
- Use `local` everywhere.
- Use explicit types in comments if needed, no fancy OOP framework.
- Comment your code in simple English.

## Gameplay rules (high level)

- Players earn **1000 cash per kilometer** driven.
- Distance is computed from car movement in **studs**.
- Use `1 stud ≈ 0.28 meters`, so `1 km ≈ 3571 studs`.
- Keep money and owned cars persistent using Roblox DataStore.
- Cars have stats: `MaxSpeed`, `Acceleration`, `Handling`.

