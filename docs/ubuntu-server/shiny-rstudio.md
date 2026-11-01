---
icon: simple/rstudioide
---

# Shiny Server & RStudio Server

![RStudio](../assets/logos/rstudio.svg){ width="64" align="right" } ![R](../assets/logos/r.svg){ width="64" align="right" }

Referencia: <https://www.digitalocean.com/community/tutorials/how-to-set-up-shiny-server-on-ubuntu-20-04>

## 1. Servidor completo

```bash
# Reiniciar
sudo shutdown -r now

# Apagar
sudo poweroff
# o bien:
sudo shutdown -h now
```

## 2. Shiny Server

```bash
# Iniciar
sudo systemctl start shiny-server

# Detener
sudo systemctl stop shiny-server

# Instalar paquete (ejemplo: shiny)
sudo su - -c "R -e \"install.packages('shiny', repos='http://cran.rstudio.com/')\""

# Actualizar todos los paquetes
sudo su - -c "R -e \"update.packages(repos='http://cran.rstudio.com/')\""

# Alternativa si el anterior falla
sudo su - -c "R -e \"update.packages(oldPkgs = old.packages(), ask = FALSE, repos='http://cran.rstudio.com/')\""
```

### 2.1 Gestión de apps

```bash
# Carpeta de apps Shiny
cd /srv/shiny-server

# Descargar carpeta del servidor al PC local (ejecutar en el PC local, no en el servidor)
scp -r jdlsvr:/srv/shiny-server/Palabras_SS ~/Palabras_SS

# Git clone de una app
sudo git clone https://github.com/JDLeongomez/ProbDnD

# Git pull (desde el directorio del proyecto)
sudo git pull

# Pull de todos los repos en un directorio
ls | sudo xargs -I{} git -C {} pull

# Resetear al estado remoto (descartar cambios locales)
sudo git fetch
sudo git reset --hard HEAD
sudo git merge '@{u}'

# Eliminar directorio completamente (cuidado)
sudo rm -rf nombre-carpeta
```

### 2.2 Permisos de archivos de datos

```bash
# Dar propiedad al usuario 'shiny' para que pueda escribir datos
cd Data
sudo chown shiny Dominancia_Prestigio.csv
```

### 2.3 R en el servidor

```bash
sudo -i R
```

## 3. RStudio Server

Puerto: **8787**

```bash
# Reiniciar (también válido: stop, start)
sudo service rstudio-server restart
```

### 3.1 Usuarios

Los usuarios de RStudio Server son usuarios del sistema. Para verlos, crearlos, cambiar su
contraseña o eliminarlos, ver [Comandos de Linux → Usuarios y grupos](../linux/comandos.md#7-usuarios-y-grupos).

```bash
# Crear usuario (con carpeta personal y bash) y asignarle contraseña
sudo useradd -m -s /bin/bash nombre_usuario
sudo passwd nombre_usuario
```

## 4. Monitoreo y red

```bash
# Monitor de recursos
btop

# IP local
# 192.168.1.17

# IP pública
curl -4 icanhazip.com
```

## 5. Pantalla de login (monitor principal)

Si el login aparece en el monitor incorrecto, copiar la configuración de monitores y reiniciar:

```bash
sudo cp ~/.config/monitors.xml /var/lib/gdm3/.config/
sudo reboot
```

## 6. Instalación en un servidor nuevo

Las versiones de los paquetes `.deb` de abajo son las que se usaron en su momento; antes de
instalar, consultar la versión actual en la página de Posit.

### 6.1 R

```bash
sudo apt-get install r-base
sudo apt-get install r-base-dev
```

### 6.2 Dependencias del sistema para compilar paquetes de R

```bash
sudo nala install cmake libharfbuzz-dev libfribidi-dev libxml2-dev \
  libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev \
  libcurl4-openssl-dev libfontconfig1-dev libmpfr-dev libarchive-dev \
  libmagick++-dev libpoppler-cpp-dev libgsl-dev libudunits2-dev cargo
```

### 6.3 RStudio Server

Instrucciones actualizadas: <https://posit.co/download/rstudio-server/>

```bash
sudo apt-get install gdebi-core
wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2024.09.0-375-amd64.deb
sudo gdebi rstudio-server-2024.09.0-375-amd64.deb
```

### 6.4 Shiny Server

```bash
sudo apt-get install gdebi-core
wget https://download3.rstudio.org/ubuntu-18.04/x86_64/shiny-server-1.5.22.1017-amd64.deb
sudo gdebi shiny-server-1.5.22.1017-amd64.deb

# Verificar que está escuchando (puerto 3838)
sudo ss -plut | grep -i shiny

sudo ufw allow 3838
```

### 6.5 Cloudflare Tunnel (si se usa)

```bash
# Verificar que el servicio de Cloudflare está activo
systemctl status cloudflared

# Si no funciona, desinstalar y volver a instalar el servicio
sudo cloudflared service uninstall
# Copiar el comando con el token desde el panel de Cloudflare
sudo cloudflared service install <token>
```
