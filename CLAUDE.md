# myaquarium

A Roblox game project synced via [Rojo](https://rojo.space/).

## Layout

| Path           | Roblox location                                  |
| -------------- | ------------------------------------------------ |
| `src/client/`  | `StarterPlayer.StarterPlayerScripts.Client`      |
| `src/server/`  | `ServerScriptService.Server`                     |
| `src/shared/`  | `ReplicatedStorage.Shared`                       |

The Rojo project file is `default.project.json`.

## Luau conventions

- Every script starts with `--!strict`.
- Use `.luau` extension (not `.lua`).
- `init.client.luau` / `init.server.luau` / `init.luau` become the parent folder's Instance when a folder is converted to a Script/LocalScript/ModuleScript.
- Tabs for indentation, double quotes for strings, snake_case for files-as-modules only when conventional; otherwise PascalCase module names (`Greeting.luau` returns `Greeting`).
- Prefer `task.wait` / `task.spawn` over `wait` / `spawn`.
- Get services via `game:GetService("ReplicatedStorage")` at the top of the file.
- Use string interpolation (`` `text {var}` ``) over `..` concatenation.

## Workflow

1. Run `rojo serve` locally.
2. In Roblox Studio with the Rojo plugin installed, click Connect.
3. Edit files here; they sync into Studio live.

To build a place file without Studio: `rojo build -o myaquarium.rbxlx`.
