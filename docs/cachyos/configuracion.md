# CachyOS + Noctalia — Configuración

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

## 3. Fuentes

Las fuentes de usuario se guardan en `/usr/local/share/fonts` (requiere `sudo`).

Para copiar varias carpetas de fuentes desde `~/Downloads/` de una sola vez:

```bash
sudo cp -r ~/Downloads/{fuente_1,fuente_2,fuente_3} /usr/local/share/fonts/
sudo fc-cache -f -v
```

- `-r` copia carpetas recursivamente
- Las llaves `{}` expanden múltiples nombres en un solo comando
- `fc-cache` obliga al sistema a reconocer las nuevas fuentes
