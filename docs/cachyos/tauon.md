---
icon: material/music
---

# Tauon Music Box: configuración y reorganización de biblioteca

![Tauon](../assets/logos/tauon.svg){ width="64" align="right" }

## 1. Entorno

- CachyOS + Hyprland + Noctalia (shell Quickshell, sin Waybar).
- Tauon instalado vía pacman (`cachyos-extra-znver4/tauon-music-box`), versión 12.1.0.
- NAS montado en `/mnt/NAS_Public/`. Música en `/mnt/NAS_Public/Shared Music/` (el nombre tiene un espacio, usar siempre comillas).
- Playlists originales de Windows Media Player en formato `.wpl`, usadas también por el sistema Sonos (rutas UNC `\\CLOUDJDL\Public\Shared Music\...`). Versión convertida a `.m3u8` para Tauon en `~/Music/Playlists-m3u8/`.

## 2. Tauon: configuración confirmada

- Cierra a la bandeja del sistema al cerrar la ventana.
- Carpeta de datos (instalación por pacman, confirmada en el manual oficial): `~/.local/share/TauonMusicBox/`.
- Tema Dracula: archivo `.ttheme` dentro de `<carpeta de datos>/theme/`.
- Tauon no vigila carpetas. Para importar hay que arrastrar las carpetas desde el gestor de archivos a la ventana ("Import Music Folder" del menú solo toma `~/Music`).
- "Rescan Folders" (clic derecho en la pestaña de la playlist) solo vuelve a escanear la primera carpeta que se importó a esa pestaña, no las que se agreguen después. Si la estructura de carpetas cambia de forma importante, conviene reimportar en vez de confiar en Rescan Folders.
- Soporte de M3U/M3U8 desde la versión 7.0.0 de Tauon.
- Botón en la esquina superior izquierda abre el panel lateral con todas las playlists, útil cuando no caben todas las pestañas arriba.
- Hyprland la abría en mosaico (tiling) por defecto. Se agregó una regla de ventana en `~/.config/hypr/config/windowrules.lua` (`class = "tauonmb|Tauon Music Box"`) para que abra siempre flotante y centrada, al 50 % del ancho y alto del monitor (el tamaño por defecto de Tauon, 1120x600 px, se veía muy pequeño).

## 3. Reorganización de la biblioteca (octubre 2026)

**Problema**: Tauon asigna una sola carátula por carpeta. En 25 carpetas de la colección (1729 pistas en total) había canciones de distintos álbumes o artistas mezcladas en la misma carpeta: las 3 carpetas "Varios" originales, más 22 carpetas de un solo artista con pistas sueltas de varios álbumes sin subcarpeta propia (Led Zeppelin, Hendrix, Soda Stereo, Tool, Piazzolla, Pixies, entre otras). Esto mostraba una carátula equivocada en parte de esas canciones.

**Solución aplicada**:

- Se reorganizaron 207 pistas a la convención `Artista/Álbum/` (una carpeta por álbum), incluyendo 3 colisiones con carpetas de artista que ya existían (Massive Attack, Pulp, Pixies), que se convirtieron de carpeta plana de un álbum a carpeta con subcarpetas por álbum.
- Se incrustó carátula (ID3 APIC en mp3, WM/Picture en wma) en el 100% de la colección (1727 pistas): en las carpetas que ya eran un álbum correcto se reutilizó el `Folder.jpg` que ya estaba ahí; en las carpetas nuevas se buscó la carátula en MusicBrainz y Cover Art Archive; los casos sin coincidencia se completaron a mano con imágenes guardadas en `~/Downloads/Portadas/`.
- Se actualizaron las 24 playlists (`.wpl` y `.m3u8`) para apuntar a las rutas nuevas, incluyendo el único caso con rutas relativas (`Humberto, Piazzolla.wpl`, que usaba `..\Piazzolla\...`).
- Se borró `DeBorges-Rhizomaut.mp3` (en Clásica) a pedido del usuario, tras confirmar que no aparecía en ninguna playlist.

**Casos especiales** (documentados en `overrides.py` del proyecto): "Lluvia con Nieve" identificada como Mon Rivera, álbum *Que Gente Averiguá* (Alegre Records, 1961); "Five Pieces for Orchestra, Op. 16" de Schoenberg identificada por el usuario en archive.org (LP Nonesuch H-71192, 1968, con Webern y Stravinsky).

**Huecos previos a esta reorganización que siguen pendientes** (no los causó este proceso): 19 pistas que ya faltaban en playlists puntuales (Amor, Calexico, Reuniones, Reuniones light, Rock Clásico, Santiago final), más 1 pista de "Astor Piazzola - Adios Nonino" que nunca existió en el disco.

**Auditoría y corrección de huecos (4 de octubre de 2026)**: al preparar la migración al PC del laboratorio se revisaron en detalle los 20 huecos anteriores (comparando cada entrada de los `.m3u8` contra el sistema de archivos real) y se encontró que la mayoría no eran pistas perdidas, sino rutas obsoletas. Se corrigieron 12 entradas, tanto en los `.m3u8` (`~/Music/Playlists-m3u8/`) como en los `.wpl` equivalentes en `/mnt/NAS_Public/Shared Music/Playlists/` (con respaldo `.bak-20261004` de ambos formatos antes de editar):

- `Rock Clásico`: "Hey Joe" de Hendrix apuntaba a `Hendrix/Hey Joe.mp3` (no existe); la pista real está en `Jimi Hendrix Experience/Are You Experienced-/12 Hey Joe.mp3` (la discografía de Hendrix está repartida entre dos nombres de carpeta de artista distintos, "Hendrix" y "Jimi Hendrix Experience", algo previo a la reorganización de octubre).
- `Santiago final`: "Roads" y "Glory Box" de Portishead apuntaban a archivos sueltos (`Portishead/Roads.mp3`, `Portishead/Glory Box.mp3`); las pistas reales están dentro del álbum `Portishead/Dummy/`.
- `Santiago final`: 9 de las 10 pistas de Jane's Addiction (álbum *Strays*) fallaban porque la playlist usa `Jane´s Addiction` con acento agudo (´, U+00B4) en vez del apóstrofe recto real (`Jane's Addiction`), y además los nombres de archivo correspondían a una edición con numeración de pistas distinta a la que hay en disco (que tiene dos variantes por pista, `-orn` y `-rep`, de un CD doble). Se repuntaron a los archivos reales, usando la versión `-rep` cuando existía y `-orn` cuando era la única disponible.

Los 8 huecos restantes se confirmaron como genuinamente ausentes (no están en ningún lugar del NAS ni en `.Trash-1000`): 2 pistas de Enigma (álbum *MCMXC A.D.*, ausente por completo), "Stray (LIVE...)" de Calexico (la carpeta `Calexico/LIVE/` solo tiene la carátula), "Hey ya.mp3" en `Varios (Raras)`, toda la carpeta del artista Snow Patrol, "06 Sister Awake" de The Tea Party (el álbum *The Edges of Twilight* no existe, solo *The Interzone Mantras*), "07-Bring the Mood" de Jane's Addiction (no existe en ninguna de las dos ediciones en disco), y la pista de Piazzolla ya documentada arriba. A pedido del usuario, se eliminaron las 8 entradas correspondientes de las playlists afectadas (`Amor`, `Calexico`, `Humberto, Piazzolla`, `Reuniones light`, `Reuniones`, `Rock Clásico`, `Santiago final`), tanto en `.m3u8` como en los `.wpl` del NAS (con respaldo `.bak-20261004` de cada archivo antes de editar, y los `ItemCount`/`itemCount` de los `.wpl` ajustados). Con esto, las 24 playlists quedan sin huecos: las 443 entradas restantes apuntan a archivos que existen.

## 4. Scripts del proyecto

Todo en `~/Music/tauon-reorg/` (con su propio entorno virtual en `venv/`, creado con el Python del sistema para evitar conflicto con miniconda):

- `scan_library.py`: escanea la biblioteca y propone movimientos sin ejecutarlos, genera `plan_moves.csv`.
- `overrides.py`: casos manuales (artistas, álbumes, carátulas específicas).
- `apply_moves.py`: ejecuta los movimientos aprobados, genera `path_rewrite_map.json`.
- `embed_art.py` / `embed_manual_covers.py`: incrustan carátula (local, MusicBrainz, o manual).
- `update_playlists.py`: corrige `.wpl` y `.m3u8` con las rutas nuevas, a partir del mapa de rutas.
- `identify_unresolved.py`: identificación por huella acústica (AcoustID/Chromaprint), usada para los casos sin tag de álbum.
- `.acoustid_key`: clave de aplicación de AcoustID, uso local, no compartir.
- `backup-20261004/`: respaldo de las playlists originales, antes de cualquier cambio.