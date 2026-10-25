---
icon: simple/ubuntu
---

# Gestión de paquetes: `apt` y `nala` (Ubuntu Server 24.04)

![Ubuntu](../assets/logos/ubuntu.svg){ width="64" align="right" }

`nala` es un envoltorio sobre `apt` con una interfaz más clara (resume cambios, muestra
descargas en paralelo) y la misma sintaxis básica de subcomandos.

| Acción                                      | `apt`                      | `nala`                      |
| ------------------------------------------- | -------------------------- | --------------------------- |
| Actualizar la lista de paquetes disponibles | `sudo apt update`          | `sudo nala update`          |
| Actualizar todos los paquetes instalados    | `sudo apt upgrade`         | `sudo nala upgrade`         |
| Instalar un paquete                         | `sudo apt install paquete` | `sudo nala install paquete` |
| Eliminar un paquete                         | `sudo apt remove paquete`  | `sudo nala remove paquete`  |
| Eliminar un paquete y su configuración      | `sudo apt purge paquete`   | `sudo nala purge paquete`   |
| Eliminar dependencias que ya nadie usa      | `sudo apt autoremove`      | `sudo nala autoremove`      |
| Buscar un paquete                           | `apt search nombre`        | `nala search nombre`        |
| Ver información de un paquete               | `apt show paquete`         | `nala show paquete`         |
| Ver historial de instalaciones/cambios      | —                          | `nala history`              |
