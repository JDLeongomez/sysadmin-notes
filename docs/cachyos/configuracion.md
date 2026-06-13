# CachyOS + HyDE Project — Configuración

## 1. SDDM login screen

### 1.1 Tema

Ver <https://github.com/HyDE-Project/HyDE/discussions/998>.

Archivo de configuración: `/etc/sddm/conf.d/the_hyde_project.conf`

Seleccionar por ejemplo `Corners`:

```ini
[Theme]
Current=Corners
```

Para cambiar el fondo de pantalla, guardar la imagen en `/usr/share/sddm/themes/Corners/backgrounds/`
y editar `/usr/share/sddm/themes/Corners/theme.conf`:

```ini
[General]
Background="backgrounds/your_image.jpg"
```

### 1.2 Imagen de perfil de usuario

Guardar la imagen en `/usr/share/sddm/faces/` con el nombre de usuario, por ejemplo `jdl.face.icon`,
y ajustar permisos:

```bash
sudo chown root:root /usr/share/sddm/faces/jdl.face.icon
sudo chmod 644 /usr/share/sddm/faces/jdl.face.icon
```

### 1.3 zsh prompt

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
