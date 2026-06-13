# Shiny Server & RStudio Server

Referencia: <https://www.digitalocean.com/community/tutorials/how-to-set-up-shiny-server-on-ubuntu-20-04>

---

## Servidor completo

```bash
# Reiniciar
sudo shutdown -r now

# Apagar
sudo poweroff
# o bien:
sudo shutdown -h now
```

---

## Shiny Server

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

### Gestión de apps

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

### Permisos de archivos de datos

```bash
# Dar propiedad al usuario 'shiny' para que pueda escribir datos
cd Data
sudo chown shiny Dominancia_Prestigio.csv
```

### R en el servidor

```bash
sudo -i R
```

---

## RStudio Server

Puerto: **8787**

```bash
# Reiniciar (también válido: stop, start)
sudo service rstudio-server restart
```

### Crear usuario

```bash
sudo useradd nombre_usuario
sudo passwd nombre_usuario
sudo mkdir /home/nombre_usuario
sudo chown -R nombre_usuario /home/nombre_usuario
```

---

## Monitoreo y red

```bash
# Monitor de recursos
btop

# IP local
# 192.168.1.17

# IP pública
curl -4 icanhazip.com
```

---

## Pantalla de login (monitor principal)

Si el login aparece en el monitor incorrecto, copiar la configuración de monitores y reiniciar:

```bash
sudo cp ~/.config/monitors.xml /var/lib/gdm3/.config/
sudo reboot
```
