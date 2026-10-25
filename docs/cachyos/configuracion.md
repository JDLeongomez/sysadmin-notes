---
icon: simple/archlinux
---

# CachyOS + Noctalia — Configuración

![CachyOS](../assets/logos/cachyos.svg){ width="64" align="right" }

## 1. Pantalla de inicio de sesión (greetd + Noctalia Greeter)

El login ya no usa SDDM, sino `greetd` con `noctalia-greeter`
(ver `/etc/greetd/config.toml`, `command = "/usr/bin/noctalia-greeter-session"`).

### 1.1 Tema y fondo de pantalla

Noctalia Greeter sincroniza automáticamente el fondo de pantalla y la paleta de colores
desde Noctalia Shell. Esto se controla en `~/.config/noctalia/config.toml`:

```toml
[shell.greeter_sync]
auto_sync = true
```

Con `auto_sync = true`, no hay que configurar nada aparte en el greeter: el fondo de
pantalla que se defina desde Noctalia Shell (guardado en `~/.local/state/noctalia/settings.toml`,
sección `[wallpaper]`) se aplica también en la pantalla de login.

`greeter_sync` solo sincroniza fondo de pantalla y paleta de colores. **No** sincroniza el
avatar: ese se maneja aparte (ver 1.2).

### 1.2 Imagen de perfil de usuario (avatar)

Hay dos avatares independientes que mantener sincronizados, cada uno con su propia fuente:

**Noctalia Shell** (el que se ve dentro de la sesión, panel, bloqueo, etc.) lee la ruta
definida en `~/.config/noctalia/config.toml`:

```toml
[shell]
avatar_path = "~/Pictures/Fotos Perfil/avatar.jpg"
```

**Noctalia Greeter** (la pantalla de login) no lee esta ruta: obtiene la foto vía D-Bus de
AccountsService, propiedad `IconFile`, que ya está configurada para apuntar a
`/var/lib/AccountsService/icons/jdl`. Como ese directorio es de `root` y mi usuario no
pertenece al grupo `root`, hace falta `sudo` para sobrescribir el archivo (no hace falta
tocar `IconFile`, solo reemplazar el contenido):

```bash
sudo cp ~/"Pictures/Fotos Perfil/avatar.jpg" /var/lib/AccountsService/icons/jdl
sudo chown root:root /var/lib/AccountsService/icons/jdl
sudo chmod 644 /var/lib/AccountsService/icons/jdl
```

Es decir, para cambiar la foto de perfil en todas partes hay que: 

1. reemplazar `/home/jdl/Pictures/Fotos Perfil/avatar.jpg` (actualiza Noctalia Shell)
2. correr el bloque de arriba (actualiza el Greeter).

### 1.3 Si los cambios no se reflejan en el login

El `auto_sync` de 1.1 no siempre se dispara al instante. Si el fondo, la paleta o el avatar
no aparecen actualizados en la pantalla de login:

```bash
# Forzar que el greeter vuelva a aplicar la apariencia actual
noctalia-greeter-apply-appearance

# o, si eso no basta, reiniciar el greeter (cierra la sesión de login, no la de usuario)
sudo systemctl restart greetd.service
```

### 1.4 zsh prompt

Configuración en `/usr/share/oh-my-zsh/zshrc`.

---

## 2. Paquetes de R

Con frecuencia hay problemas al instalar paquetes como `xml2`. Esto funciona:

```r
Sys.unsetenv(c("INCLUDE_DIR", "LIB_DIR", "PKG_CFLAGS", "PKG_LIBS"))
install.packages("xml2")
```

---

## 3. Transparencia y apariencia de ventanas (Hyprland)

Esto **no** se configura en Noctalia. Noctalia Shell (`~/.config/noctalia/config.toml`) solo
controla la apariencia de la barra, el panel y los widgets; la transparencia, los bordes y el
desenfoque de las ventanas los controla Hyprland directamente, en
`~/.config/hypr/config/decorations.lua`:

```lua
hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 8,
        border_size = 2,
        col = {
            active_border = { colors = { CACHYLGREEN, CACHYDGREEN }, angle = 45 },
            inactive_border = CACHYGRAY,
        },
    },
    decoration = {
        rounding = 10,
        active_opacity = 0.95,
        inactive_opacity = 0.65,
        fullscreen_opacity = 1,
        blur = {
            size = 5,
            passes = 4,
            special = true,
        },
    },
})
```

- `decoration.active_opacity`: opacidad de la ventana con foco (1 = opaca, 0 = invisible).
- `decoration.inactive_opacity`: opacidad de las ventanas sin foco (la que normalmente se quiere
  bajar para distinguir cuál está activa).
- `decoration.fullscreen_opacity`: opacidad en modo pantalla completa.
- `decoration.rounding`: redondeo de esquinas.
- `decoration.blur`: desenfoque del fondo detrás de ventanas transparentes (`size`, `passes`).
- `general.border_size`, `general.gaps_in`, `general.gaps_out`: tamaño de borde y espacios entre
  ventanas.
- `general.col.active_border` / `inactive_border`: color del borde según foco.

Después de editar y guardar el archivo, los cambios se aplican solos (Hyprland recarga la
configuración Lua automáticamente). Si no se reflejan, forzar con:

```bash
hyprctl reload
```

### 3.1 Por qué la transparencia se ve distinta según la aplicación

`active_opacity` / `inactive_opacity` no se ven igual en todas las aplicaciones porque dependen
de si la ventana expone un canal alfa real al compositor:

- **Aplicaciones con alfa real** (VSCodium, terminales como kitty): Hyprland puede mezclar de
  verdad el fondo detrás de la ventana, así que se ve la transparencia **y** el desenfoque
  (`blur`) tal como se configuraron.
- **Aplicaciones sin alfa real** (p. ej. Tauon Music Box, que usa un renderizador propio en vez
  de GTK, o GNOME Text Editor en GTK4/libadwaita): al no exponer un canal alfa, Hyprland no
  tiene nada que mezclar detrás y solo puede simular la opacidad oscureciendo/aclarando los
  píxeles ya renderizados de toda la ventana (texto e iconos por igual). Se ve "lavado" al
  perder el foco, y sin ningún desenfoque real.
- **Zen Browser** (y Firefox): no es una limitación técnica sino una regla explícita en
  `windowrules.lua` que fuerza opacidad 1.0 para esas clases, porque los navegadores basados en
  Gecko suelen tener artefactos visuales con transparencia real.

Para evitar el efecto "lavado" en aplicaciones sin alfa real, se les fuerza opacidad 1.0 igual
que a Zen/Firefox o a los reproductores de video, en
`~/.config/hypr/config/windowrules.lua`:

```lua
hl.window_rule({ match = { class = "^(tauonmb|org\\.gnome\\.TextEditor)$" }, opacity = "1.0 override" })
```

Para agregar otra aplicación a esta lista, hay que conocer su `class` de ventana. Se obtiene con
la sesión de Hyprland activa:

```bash
hyprctl clients | grep -B2 "class:"
```

---

## 4. Fuentes

Las fuentes de usuario se guardan en `/usr/local/share/fonts` (requiere `sudo`).

Para copiar varias carpetas de fuentes desde `~/Downloads/` de una sola vez:

```bash
sudo cp -r ~/Downloads/{fuente_1,fuente_2,fuente_3} /usr/local/share/fonts/
sudo fc-cache -f -v
```

- `-r` copia carpetas recursivamente
- Las llaves `{}` expanden múltiples nombres en un solo comando
- `fc-cache` obliga al sistema a reconocer las nuevas fuentes
