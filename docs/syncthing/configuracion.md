---
icon: simple/syncthing
---

# Syncthing

![Syncthing](../assets/logos/syncthing.svg){ width="64" align="right" }

Sincronización de archivos entre PC (CachyOS), laptop (CachyOS) y servidor (Ubuntu),
usando el servidor como puente ya que PC y laptop nunca están encendidos al mismo tiempo.

## Instalación

**CachyOS (PC y laptop):**
​```bash
sudo pacman -S syncthing
systemctl --user enable --now syncthing
​```

**Servidor (Ubuntu):**
​```bash
sudo apt install syncthing
sudo systemctl enable --now syncthing@jdl
​```

## Acceso a la GUI

**PC / laptop (local):**
​```
http://127.0.0.1:8384
​```

**Servidor (remoto, vía túnel SSH):**
​```
ssh -N -L 8385:127.0.0.1:8384 jdl@192.168.1.17
​```
Luego abrir `http://127.0.0.1:8385` en el navegador local.
El `-N` evita que se abra un shell interactivo (que cierra el túnel si el shell termina).
Mantener la terminal abierta mientras se usa la GUI.

## Puertos y firewall (servidor)

​```bash
sudo ufw allow 22000/tcp
sudo ufw allow 22000/udp
sudo ufw allow 21027/udp
​```

## Folder ID compartido

​```
dewju-anyvg
​```
Carpeta: `~/Documents/Sync` (mismo path en los tres equipos)

## Notas

- No sincronizar carpetas de Git (`~/Documents/GitHub`), usar git push/pull para eso.
- Malla completa: los tres dispositivos deben estar agregados entre sí y compartir el mismo Folder ID.