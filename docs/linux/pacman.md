---
icon: simple/archlinux
---

# Gestión de paquetes: `pacman` (CachyOS)

![CachyOS](../assets/logos/cachyos.svg){ width="64" align="right" }

| Acción                                                         | Comando                                                          | Notas                                                                                                                                 |
| -------------------------------------------------------------- | ---------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| Instalar un paquete                                            | `sudo pacman -S paquete`                                         |                                                                                                                                       |
| Actualizar todo el sistema                                     | `sudo pacman -Syu`                                               | Siempre actualizar el sistema completo, nunca solo un paquete suelto (`pacman -Syu` sin exclusiones) para evitar romper dependencias. |
| Buscar un paquete                                              | `pacman -Ss nombre`                                              | Busca en los repositorios remotos.                                                                                                    |
| Ver si un paquete está instalado                               | `pacman -Qs nombre`                                              | Busca entre los paquetes ya instalados localmente.                                                                                    |
| Ver información de un paquete                                  | `pacman -Qi paquete` (instalado) / `pacman -Si paquete` (remoto) |                                                                                                                                       |
| Ver qué archivos instaló un paquete                            | `pacman -Ql paquete`                                             |                                                                                                                                       |
| Eliminar un paquete                                            | `sudo pacman -R paquete`                                         |                                                                                                                                       |
| Eliminar un paquete y sus dependencias no usadas por nadie más | `sudo pacman -Rns paquete`                                       |                                                                                                                                       |
| Eliminar dependencias huérfanas (de paquetes ya desinstalados) | `sudo pacman -Rns $(pacman -Qtdq)`                               | `-Qtdq` lista esas dependencias huérfanas.                                                                                            |
| Limpiar la caché de paquetes descargados                       | `sudo pacman -Sc`                                                | Borra versiones viejas en caché; `-Scc` las borra todas, incluida la versión actual.                                                  |
