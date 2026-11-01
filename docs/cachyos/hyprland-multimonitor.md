---
icon: simple/hyprland
---

# Multimonitor en Hyprland + Noctalia

![Hyprland](../assets/logos/hyprland.svg){ width="64" align="right" }

Dos guías cortas para la misma configuración (Hyprland con config en **Lua**, Noctalia):
cómo se reparten los workspaces entre monitores, y cómo cambiar rápido entre
distintas configuraciones de monitores (perfiles).

## 1. Workspaces globales con teclado

Probado en el portátil: CachyOS, Hyprland 0.56.2 (config en **Lua**), Noctalia 5.1.0.
Sin plugins: todo es Lua puro en `~/.config/hypr/config/`.

### 1.1 Qué resuelve

- El número que ves en la barra es el que pulsas: `Super + 2` va al workspace 2, esté en el monitor que esté (el foco salta a ese monitor).
- Workspace 1 vive en el monitor 1, el 2 en el monitor 2 y el 3 en el monitor 3 (escritorio). Siempre existen, aunque estén vacíos; el 3 solo cuando la TV está extendida (ver la nota sobre el workspace 3 más abajo).
- Cualquier otro workspace (4, 5…) se crea **en el monitor donde estás** al saltar a él. Antes `Super + Shift + N` daba error si no existía.

### 1.2 Atajos

| Atajo | Acción |
|---|---|
| `Super + [1-0]` | Ir al workspace N (si vive en otro monitor, el foco salta allí; si no existe, se crea en este) |
| `Super + Shift + [1-0]` | Mover la ventana al workspace N y **seguirla** |
| `Super + Ctrl + Shift + [1-0]` | Mandar la ventana al workspace N, **quedándote** donde estás |
| `Super + Ctrl + ←/→` | Workspace anterior/siguiente **abierto** del monitor |
| `Super + Ctrl + ↓` | Ir a un workspace **nuevo vacío** en este monitor |
| `Super + Ctrl + Shift + ↓` | Mover la ventana a un workspace nuevo vacío y seguirla |
| `Super + Alt + [1-3]` | Enfocar el monitor N |
| `Super + Alt + Shift + [1-3]` | Mover la ventana al monitor N |
| `Super + flechas` | Enfocar ventana/monitor en esa dirección (sin cambios) |
| `Super + Shift + flechas` | Mover la ventana (sin cambios) |
| `Super + rueda` | Workspace anterior/siguiente del monitor (sin cambios) |

Cambio respecto a antes: `Super + [1-3]` ya no enfoca monitores (ahora va a los workspaces 1–3); enfocar monitor es `Super + Alt + [1-3]`.

### 1.3 Cómo funciona

Es el modelo normal de Hyprland (IDs globales), con dos reglas: el workspace k queda atado al monitor k y es persistente. El resto no tiene regla, así que Hyprland lo crea en el monitor enfocado y lo borra al quedar vacío. `Super + Ctrl + ↓` busca el primer workspace por encima de los fijos que esté vacío y no pertenezca a otro monitor. Cada barra de Noctalia muestra solo los workspaces de su monitor.

### 1.4 Instalación (portátil o escritorio)

Haz un respaldo primero: `cp -r ~/.config/hypr ~/.config/hypr-backup`

#### 1.4.1 `~/.config/hypr/config/variables.lua`

Solo cambia la sección de monitores y workspaces. En el **equipo de escritorio pon los nombres de tus 3 salidas**, de izquierda a derecha (mira `hyprctl monitors`):

```lua
MONITOR1 = "DP-1"        -- nombres de ejemplo: reemplázalos
MONITOR2 = "DP-2"
MONITOR3 = "HDMI-A-1"
PRIMARY_MONITOR = MONITOR1

NUM_WPM = 10 -- workspaces alcanzables con Super+[1-0] (máx. 10)
```

En el portátil: `MONITOR1 = "eDP-1"`, `MONITOR2 = "HDMI-A-1"`, `MONITOR3 = ""`.

#### 1.4.2 `~/.config/hypr/config/workspaces.lua` (reemplazar todo el archivo)

```lua
-- Global workspaces (HyDE style): the number you see in the bar is the number you press.
--
-- Workspace 1 lives on monitor 1, workspace 2 on monitor 2, workspace 3 on monitor 3
-- (rules below, kept alive even when empty). Any other workspace is created on the
-- monitor you are focused on when you jump to it. Pressing Super+N for a workspace
-- that lives on another monitor moves focus to that monitor.
-- Workspace rules wiki https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Ordered list of the monitors actually in use (skips empty MONITORn = "")
MONITORS = {}
-- MONITOR3_ACTIVE is written by scripts/monitor-profile.sh in monitors.lua (loaded
-- before this file): false when monitor 3 is disabled or mirrored, so it gets no
-- workspace. Otherwise workspace 3 would be persistent on another monitor.
for idx, name in ipairs({ MONITOR1, MONITOR2, MONITOR3 }) do
    local active = not (idx == 3 and MONITOR3_ACTIVE == false)
    if name ~= nil and name ~= "" and active then table.insert(MONITORS, name) end
end

for idx, name in ipairs(MONITORS) do
    hl.workspace_rule({ workspace = tostring(idx), monitor = name, default = true, persistent = true })
end

-- Actions used by binds.lua ---------------------------------------------------

function WS_GOTO(n)
    hl.dispatch(hl.dsp.focus({ workspace = n }))
end

-- follow = true: the view goes with the window; false: send it away silently
function WS_SEND(n, follow)
    hl.dispatch(hl.dsp.window.move({ workspace = n, follow = follow }))
end

-- Lowest-numbered workspace (beyond the per-monitor ones) that is empty and not
-- claimed by another monitor
local function first_free()
    local here = hl.get_active_monitor()
    for n = #MONITORS + 1, 10 do
        local ws = hl.get_workspace(n)
        if ws == nil or (ws.is_empty and (ws.monitor == nil or ws.monitor.name == here.name)) then
            return n
        end
    end
    return nil
end

function WS_GOTO_FREE()
    local n = first_free()
    if n then WS_GOTO(n) end
end

function WS_SEND_FREE(follow)
    local n = first_free()
    if n then WS_SEND(n, follow) end
end
```

#### 1.4.3 `~/.config/hypr/hyprland.lua`

`monitors` debe cargarse **antes** que `workspaces` (workspaces lee `MONITOR3_ACTIVE`, ver sección 2), y `workspaces` antes que `binds` (binds usa `MONITORS` y las funciones `WS_*`):

```lua
require("config.monitors")
require("config.workspaces")
require("config.binds")
```

#### 1.4.4 `~/.config/hypr/config/binds.lua`

Borra de este archivo:
- Los binds `SHIFT + 1/2/3` con `window.move({ monitor = MONITORn })`.
- El bucle `SHIFT + CONTROL + key` con `window.move({ workspace = i })`.
- Toda la sección `-- Focus on monitors`, `-- Focus on workspace number` (Absolute y Relative) y `-- Move to adjacent workspaces...`.

Y en su lugar, dentro de la sección `WORKSPACES & MONITORS`, pega:

```lua
for i = 1, NUM_WPM do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,                   function() WS_GOTO(i) end)
    hl.bind(mainMod .. " + SHIFT + " .. key,           function() WS_SEND(i, true) end)
    hl.bind(mainMod .. " + CONTROL + SHIFT + " .. key, function() WS_SEND(i, false) end)
end

hl.bind(mainMod .. " + CONTROL + Right",        hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + CONTROL + Left",         hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + CONTROL + Down",         function() WS_GOTO_FREE() end)
hl.bind(mainMod .. " + CONTROL + SHIFT + Down", function() WS_SEND_FREE(true) end)

for i, name in ipairs(MONITORS) do
    hl.bind(mainMod .. " + ALT + " .. i,         hl.dsp.focus({ monitor = name }))
    hl.bind(mainMod .. " + ALT + SHIFT + " .. i, hl.dsp.window.move({ monitor = name }))
end
```

Deja intactos los binds de rueda del ratón, `Super + Ctrl + Shift + ←/→` y el scratchpad.

#### 1.4.5 Noctalia

No hace falta cambiar nada: cada barra ya muestra solo los workspaces de su monitor (`show_all_outputs` es `false` por defecto). Si antes agregaste `label_source = "name"` en `[widget.workspaces]`, quítalo.

#### 1.4.6 Aplicar y verificar

```bash
hyprctl reload
hyprctl configerrors                 # debe salir vacío
hyprctl workspacerules | grep -c "Workspace rule"   # 1 por monitor (2 con 2 monitores, 3 con 3)
```

Prueba: `Super + 2` desde el monitor 1 debe saltar al monitor 2; `Super + 4` debe crear el 4 en el monitor donde estés; `Super + Ctrl + ↓` debe llevarte a uno vacío.

### 1.5 Notas y problemas conocidos (workspaces)

- **Migración:** si vienes de la versión anterior de esta guía (IDs por monitor), ventanas en workspaces con IDs viejos (p. ej. 11) quedan sueltas; muévelas con `Super + Shift + [N]`.
- **No hay "workspace anterior" (back-and-forth).** `focus({ workspace = "previous" })` movió un workspace al monitor equivocado en mis pruebas, así que no lo incluí.
- **Probar dispatchers a mano:** `hyprctl dispatch 'hl.dsp.focus({workspace=3})'`. Las funciones propias (`WS_GOTO(3)`) no se pueden llamar así; el envoltorio de `hyprctl` exige un dispatcher. Pruébalas con el teclado.
- **Más de 10 workspaces:** no está previsto; los atajos numéricos llegan hasta 10 (teclas 1–0).
- **Ojo al probar a mano:** `hyprctl dispatch` con `window.move` mueve la ventana activa real (me pasó al probar).
- **Workspace 3 con la TV apagada o en espejo:** el script de perfiles (sección 2) escribe `MONITOR3_ACTIVE = false` en `monitors.lua` para los perfiles dual y mirror, y `workspaces.lua` omite entonces la regla del workspace 3. Sin esto, la regla persistente apuntaba a un monitor inexistente y el workspace 3 quedaba vacío y fijo en otro monitor. Si `MONITOR3_ACTIVE` no está definido (p. ej. en el portátil, sin el script), el comportamiento es el de siempre.
- **Revertir:** restaura el respaldo (`~/.config/hypr-backup`) y `hyprctl reload`. En Noctalia hay un `config.toml.bak-<fecha>` junto al original.

## 2. Perfiles de monitores (dual / extendido / espejo)

Probado en el equipo de escritorio: 3 salidas de la misma resolución: monitor1 (izquierda),
monitor2 (derecha, principal) y una TV montada sobre el monitor2. La TV pasa
la mayoría del tiempo apagada, así que en vez de editar `monitors.lua` a mano
cada vez, esto cambia entre 3 configuraciones con un atajo o un clic:

1. **dual** — solo monitor1 + monitor2, TV apagada.
2. **extended** — los 3 activos, TV extendida sobre el monitor2 (la de siempre).
3. **mirror** — TV en espejo del monitor2.

La implementación completa (script, plugin de barra para Noctalia y fragmento de
atajos) está publicada como plugin en mi repositorio de plugins de Noctalia,
porque es reutilizable en otras máquinas:

**→ <https://github.com/JDLeongomez/noctalia-plugins/tree/master/monitor-profile-switcher>**

Resumen de cómo funciona (detalle completo en el README del plugin):

- No existe plugin oficial ni comunitario de Noctalia para esto. Se evaluaron
  dos externos y ninguno sirve: uno es exclusivo de Niri, el otro usa una
  arquitectura de plugin QML incompatible con el sistema de plugins Luau
  (`plugin.toml` + `.luau`) que usa Noctalia desde la v5.
- Un solo script (`monitor-profile.sh`) reescribe `config/monitors.lua` con el
  bloque de la TV correspondiente al perfil elegido y hace `hyprctl reload`.
  Se reescribe el archivo (en vez de aplicar el cambio solo en vivo con
  `hyprctl eval`) porque una recarga posterior (manual o disparado por otra
  cosa, como un cambio de wallpaper/tema) vuelve a leer ese archivo desde
  cero y descartaría cualquier cambio hecho solo en memoria. Así el perfil
  activo persiste entre recargas.
- El plugin de Noctalia no aplica la lógica por su cuenta: sondea
  `hyprctl monitors all -j` cada segundo para detectar qué perfil está activo
  realmente, y llama al mismo script cuando se hace clic en el widget o llega
  un evento IPC. La lógica vive en un solo lugar, no duplicada en Lua
  (Hyprland) y Luau (Noctalia).
- Los atajos de teclado llaman al script directamente, así que funcionan
  aunque la barra de Noctalia esté caída: `Super+Ctrl+Alt+1` (dual), `+2`
  (extended), `+3` (mirror).
- Nota general de Hyprland con config Lua nativa: `hyprctl keyword monitor ...`
  no funciona ahí ("keyword can't work with non-legacy parsers"); el
  equivalente en vivo es `hyprctl eval` ejecutando `hl.monitor({...})`, la
  misma función que usa `monitors.lua`.

### 2.1 Limitación conocida

Los nombres de salida (`DP-2`, `DP-3`, `HDMI-A-1` en mi caso) vienen de
`config/variables.lua` (`MONITOR1`–`MONITOR3`); en otra máquina, con otro
hardware, hay que editarlos a mano (no es un setting configurable desde la UI
de Noctalia; generalizarlo así solo tendría sentido para publicarlo en el
catálogo comunitario oficial, que no es el objetivo del plugin).
