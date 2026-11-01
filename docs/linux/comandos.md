---
icon: simple/linux
---

# Comandos de Linux

![Tux](../assets/logos/tux.svg){ width="72" align="right" }

Referencia organizada por tarea (no alfabética), para encontrar el comando según lo que
se quiere lograr, aunque no se recuerde su nombre. El menú lateral de esta página sigue
estas mismas secciones.

## 1. Navegar y explorar

### 1.1 `pwd`

Muestra la ruta completa del directorio en el que se está parado (*print working directory*).

### 1.2 `cd`

Cambia de directorio.

```bash
cd ruta/relativa
cd /ruta/absoluta
cd ..        # sube un nivel
cd -         # vuelve al directorio anterior
cd ~         # va al home del usuario
```

### 1.3 `ls`

Lista el contenido de un directorio.

```bash
ls [opciones] [ruta]
```

- `-l`: formato largo (permisos, dueño, tamaño, fecha).
- `-a`: incluye archivos ocultos (los que empiezan con `.`).
- `-h`: tamaños legibles para humanos (KB, MB, GB) junto con `-l`.
- `-t`: ordena por fecha de modificación (más reciente primero).
- `-S`: ordena por tamaño (más grande primero).
- `-R`: lista recursivamente subdirectorios.

Combinación típica: `ls -lah`.

### 1.4 `lc` (alias de `colorls`)

`colorls` es un reemplazo de `ls` con iconos y colores por tipo de archivo. En este sistema
`lc` es un alias definido en la configuración de zsh:

```bash
lc='colorls -g --sd'
```

- `-g`: formato largo, igual que `ls -l` pero sin mostrar la columna del dueño.
- `--sd` (`--sort-dirs` / `--group-directories-first`): muestra los directorios antes que los
  archivos.

Otras opciones útiles de `colorls` que no están en el alias:

- `-a` / `--all`: incluye archivos ocultos.
- `-l` / `--long`: formato largo completo (con dueño).
- `--gs` / `--git-status`: muestra el estado de git de cada archivo.
- `--tree=2`: vista de árbol hasta el nivel de profundidad indicado.

### 1.5 `tree`

Muestra la estructura de carpetas y archivos de una ubicación en forma de árbol.

```bash
tree [opciones] [ruta]
```

- `-L 2`: limita la profundidad a 2 niveles (sin esto, recorre todos los subdirectorios).
- `-a`: incluye archivos ocultos.
- `-d`: muestra solo directorios, sin archivos.
- `-I "patrón"`: excluye del listado los archivos/carpetas que coincidan con el patrón, por
  ejemplo `-I "node_modules|.git"`.

```bash
tree -L 2
```

### 1.6 `broot`

Navegador de árbol de archivos interactivo (no solo imprime el árbol, se navega dentro de él):
se escribe para filtrar con búsqueda difusa, se entra a carpetas y se puede incluso hacer
`cd` a la carpeta donde se quedó al salir. Dentro de `broot`, `?` muestra la ayuda completa
de atajos.

En este sistema está instalado como la función de shell `br` (en vez del binario `broot`
directo), que es la forma recomendada de lanzarlo porque permite ese `cd` al salir:

```bash
br [opciones] [ruta]
```

- `-h` / `--hidden`: muestra archivos ocultos.
- `-g` / `--show-git-info`: muestra el estado de git de cada archivo (repetir `-gg` para
  mostrar solo los archivos con cambios).
- `-p` / `--permissions`: muestra permisos.
- `-d` / `--dates`: muestra la fecha de última modificación.
- `--max-depth <n>`: limita la profundidad inicial del árbol (equivalente al `-L` de `tree`).
- `-f` / `--only-folders`: muestra solo carpetas.

## 2. Archivos y directorios

### 2.1 `mkdir`

Crea directorios.

- `-p`: crea toda la ruta de directorios intermedios que no existan (sin error si ya existen).

```bash
mkdir -p proyecto/datos/crudos
```

### 2.2 `touch`

Crea un archivo vacío si no existe, o actualiza su fecha de modificación si ya existe.

### 2.3 `cp`

Copia archivos o directorios.

```bash
cp origen destino
```

- `-r`: copia directorios de forma recursiva (obligatorio para copiar carpetas).
- `-v`: modo verboso, muestra qué se está copiando.
- `-i`: pregunta antes de sobrescribir un archivo existente.
- `-p`: conserva permisos, dueño y fechas originales.

Las llaves `{}` permiten expandir varios nombres en una sola llamada:

```bash
cp -r ~/Downloads/{carpeta_1,carpeta_2} /destino/
```

### 2.4 `mv`

Mueve o renombra archivos y directorios (misma sintaxis que `cp`, pero sin dejar copia en el origen).

### 2.5 `rm`

Elimina archivos o directorios. **No manda nada a una papelera**, el borrado es definitivo.

- `-r`: elimina directorios y su contenido de forma recursiva.
- `-f`: fuerza el borrado sin pedir confirmación ni avisar si el archivo no existe.
- `-i`: pregunta antes de borrar cada archivo.

`rm -rf` es la combinación más peligrosa del sistema: no verifica nada antes de borrar.

### 2.6 `ln`

Crea enlaces entre archivos.

- `-s`: crea un enlace simbólico (como un acceso directo) en vez de un enlace físico.

```bash
ln -s /ruta/real /ruta/enlace
```

## 3. Ver contenido de archivos

### 3.1 `cat`

Muestra el contenido completo de un archivo en la terminal. Útil para archivos cortos o para
concatenar varios archivos.

### 3.2 `less`

Muestra el contenido de un archivo página por página, sin cargarlo todo en memoria. Mejor que
`cat` para archivos largos. Flechas o `Page Up`/`Page Down` para moverse, `/texto` para buscar,
`q` para salir.

### 3.3 `head` / `tail`

Muestran el principio (`head`) o el final (`tail`) de un archivo.

- `-n 20`: muestra 20 líneas en vez de las 10 por defecto.
- `-f` (solo `tail`): sigue el archivo en tiempo real a medida que crece, muy usado para ver logs
  (`tail -f /var/log/algo.log`).

### 3.4 `wc`

Cuenta líneas, palabras o caracteres de un archivo (*word count*).

- `-l`: solo cuenta líneas.
- `-w`: solo cuenta palabras.
- `-c`: solo cuenta bytes.

## 4. Buscar archivos y comandos

### 4.1 `find`

Busca archivos y directorios recorriendo el árbol de carpetas, filtrando por nombre, tipo,
tamaño o fecha.

```bash
find <ruta> [opciones]
```

- `-name "patrón"`: busca por nombre exacto, sensible a mayúsculas y minúsculas.
- `-iname "patrón"`: igual que `-name` pero sin distinguir mayúsculas de minúsculas.
- `-type f` / `-type d`: filtra solo archivos (`f`) o solo directorios (`d`).
- `-mtime -7`: modificados en los últimos 7 días.
- `-size +100M`: mayores a 100 MB.
- `-exec comando {} \;`: ejecuta `comando` sobre cada resultado encontrado (`{}` se reemplaza
  por la ruta de cada resultado).

```bash
find . -iname "*.tmp" -mtime +30 -exec rm {} \;
```

### 4.2 `locate`

Busca archivos por nombre usando un índice precalculado del sistema de archivos, mucho más
rápido que `find` pero puede estar desactualizado si no se ha regenerado el índice reciente
(`sudo updatedb` lo regenera).

### 4.3 `which`

Muestra la ruta completa del ejecutable que se usaría al invocar un comando.

```bash
which python3
```

### 4.4 `whereis`

Similar a `which`, pero además busca el binario, su código fuente y su página de manual.

### 4.5 `type`

Indica si un nombre es un comando interno de la shell (*builtin*), un alias, una función o un
ejecutable externo, y en este último caso su ruta.

## 5. Buscar texto dentro de archivos

### 5.1 `grep`

Busca líneas que coincidan con un patrón de texto dentro de uno o varios archivos.

```bash
grep [opciones] "patrón" archivo
```

- `-r`: busca recursivamente dentro de un directorio y sus subdirectorios.
- `-i`: ignora mayúsculas y minúsculas.
- `-n`: muestra el número de línea de cada coincidencia.
- `-v`: invierte la búsqueda, muestra las líneas que **no** coinciden.
- `-E`: habilita expresiones regulares extendidas (equivalente a `egrep`).
- `-l`: solo muestra los nombres de los archivos con coincidencias, no las líneas.
- `-c`: cuenta el número de líneas coincidentes por archivo.

```bash
grep -rni "error" /var/log/
```

## 6. Permisos, dueños y privilegios

### 6.1 `chmod`

Cambia los permisos de lectura, escritura y ejecución de un archivo o directorio.

- Modo simbólico: `chmod u+x archivo` (agrega ejecución al dueño), `chmod go-w archivo` (quita
  escritura a grupo y otros).
- Modo numérico: cada permiso es la suma de lectura (4), escritura (2) y ejecución (1), un
  dígito por dueño/grupo/otros. `chmod 644 archivo` = dueño lee y escribe, grupo y otros solo
  leen. `chmod 755 archivo` = dueño lee, escribe y ejecuta, grupo y otros leen y ejecutan.
- `-R`: aplica el cambio recursivamente a un directorio y su contenido.

### 6.2 `chown`

Cambia el dueño (y opcionalmente el grupo) de un archivo o directorio.

```bash
chown usuario:grupo archivo
```

- `-R`: aplica el cambio recursivamente.

### 6.3 `sudo`

Ejecuta un único comando con privilegios de administrador (root), pidiendo la contraseña del
usuario actual (si pertenece al grupo con permiso de `sudo`).

### 6.4 `su`

Abre una sesión como otro usuario (por defecto, root), pidiendo la contraseña de **ese**
usuario, no la propia. `su -` además carga el entorno completo de ese usuario (como si hubiera
iniciado sesión directamente).

## 7. Usuarios y grupos

Los usuarios de RStudio Server son usuarios normales del sistema, así que se crean y eliminan
con estos mismos comandos.

### 7.1 Ver usuarios

```bash
# Usuarios "humanos" (UID ≥ 1000), sin las cuentas de sistema
awk -F: '$3 >= 1000 && $3 < 65534 {print $1, $6, $7}' /etc/passwd

# Todos los usuarios (incluye cuentas de sistema)
getent passwd

# Quién tiene una sesión abierta ahora
who

# Últimos inicios de sesión
last -n 20
```

### 7.2 `id` / `groups`

Muestran el UID, el grupo principal y los grupos de un usuario (sin argumento, del usuario actual).

```bash
id nombre_usuario
groups nombre_usuario
```

### 7.3 Crear un usuario

```bash
sudo useradd -m -s /bin/bash nombre_usuario   # -m crea /home/nombre_usuario, -s define el shell
sudo passwd nombre_usuario                     # asignar contraseña
```

- Con `-m` no hace falta crear la carpeta personal a mano (`mkdir` + `chown`): `useradd` la crea
  con el dueño correcto y copia los archivos base de `/etc/skel`.
- Sin `-s /bin/bash`, en Ubuntu el usuario queda con `/bin/sh`, que es más limitado.
- En Ubuntu también existe `sudo adduser nombre_usuario`, que hace lo mismo de forma
  interactiva (pide contraseña y datos opcionales). En CachyOS/Arch no existe; usar `useradd`.

### 7.4 Cambiar o restablecer una contraseña

```bash
sudo passwd nombre_usuario      # asignar una nueva (no requiere conocer la anterior)
sudo passwd -e nombre_usuario   # obligar a cambiarla en el próximo inicio de sesión
passwd                          # cambiar la propia
```

### 7.5 Dar o quitar permisos de administrador

```bash
# Agregar a un grupo (-a es imprescindible: sin él, reemplaza todos sus grupos)
sudo usermod -aG sudo nombre_usuario    # Ubuntu
sudo usermod -aG wheel nombre_usuario   # CachyOS/Arch

# Quitar de un grupo
sudo gpasswd -d nombre_usuario sudo
```

El cambio de grupos se aplica en el siguiente inicio de sesión del usuario.

### 7.6 Bloquear o desbloquear una cuenta

Impide iniciar sesión con contraseña sin borrar el usuario ni sus archivos:

```bash
sudo usermod -L nombre_usuario   # bloquear
sudo usermod -U nombre_usuario   # desbloquear
```

### 7.7 Eliminar un usuario

```bash
sudo userdel -r nombre_usuario   # -r borra también /home/nombre_usuario y su correo
```

- Sin `-r`, la carpeta personal se conserva (útil si hay que rescatar archivos antes).
- Si el usuario tiene procesos activos (por ejemplo, una sesión abierta de RStudio), `userdel`
  falla; cerrarlos primero con `sudo pkill -u nombre_usuario`.

## 8. Procesos y servicios

### 8.1 `ps`

Muestra los procesos en ejecución.

```bash
ps aux
```

`aux` es la combinación más usada: todos los procesos (`a`), de todos los usuarios (`x`), con
información detallada (`u`).

### 8.2 `top` / `htop`

Muestran los procesos en ejecución de forma interactiva, actualizándose en tiempo real, con uso
de CPU y memoria. `htop` (si está instalado) tiene una interfaz más clara y permite ordenar y
matar procesos con el mouse o teclas de flecha.

### 8.3 `kill` / `killall`

Envían una señal a un proceso, normalmente para terminarlo.

```bash
kill PID
killall nombre_del_proceso
```

- `-9`: señal `SIGKILL`, termina el proceso de forma inmediata y forzada (sin darle oportunidad
  de cerrar limpiamente). Usar solo si el proceso no responde a un `kill` normal.

### 8.4 `systemctl`

Controla servicios del sistema (`systemd`).

```bash
systemctl status nombre.service
systemctl start|stop|restart nombre.service
sudo systemctl enable --now nombre.service
```

- `status`: muestra si el servicio está activo y sus últimas líneas de log.
- `start` / `stop` / `restart`: controla el servicio en la sesión actual.
- `enable`: hace que el servicio arranque automáticamente al iniciar el sistema.
- `--now`: combinado con `enable` o `disable`, aplica el cambio también de inmediato.

## 9. Comprimir y descomprimir

### 9.1 `tar`

Empaqueta (y opcionalmente comprime) archivos y directorios en un solo archivo `.tar`.

```bash
tar -czf archivo.tar.gz carpeta/     # comprimir
tar -xzf archivo.tar.gz              # descomprimir
tar -tf archivo.tar.gz               # listar contenido sin extraer
```

- `-c`: crea un archivo nuevo.
- `-x`: extrae.
- `-t`: lista el contenido.
- `-z`: comprime/descomprime con gzip (`.tar.gz`).
- `-f`: indica el nombre del archivo (va justo antes del nombre).
- `-v`: modo verboso.

### 9.2 `zip` / `unzip`

Comprimen y descomprimen archivos en formato `.zip`, el más compatible con Windows/macOS.

```bash
zip -r archivo.zip carpeta/
unzip archivo.zip
```

## 10. Redirección y tuberías

No son comandos sino operadores de la shell para encadenar o redirigir la salida de los
comandos.

- `|` (tubería o *pipe*): envía la salida de un comando como entrada del siguiente.
  `ls -la | grep ".conf"`.
- `>`: redirige la salida a un archivo, sobrescribiéndolo.
- `>>`: redirige la salida a un archivo, agregándola al final.
- `2>&1`: redirige también los errores (descriptor `2`) al mismo lugar que la salida normal
  (descriptor `1`), útil para guardar todo en un mismo log.
- `&&`: ejecuta el siguiente comando solo si el anterior terminó sin error.

## 11. Documentación de comandos

### 11.1 `man`

Muestra el manual completo de un comando (`man comando`). `q` para salir.

### 11.2 `--help`

La mayoría de comandos aceptan `--help` (o `-h`) para un resumen rápido de sus opciones, más
corto que el manual completo.

## 12. Monitores y pantallas

### 12.1 `xrandr`

Lista y configura las pantallas conectadas (resolución, posición, orientación). Es una
herramienta de X11, así que en una sesión Wayland (como esta) corre contra Xwayland y muestra
una advertencia al respecto, pero sigue sirviendo para **ver** qué pantallas están conectadas
y su nombre de conector (`eDP-1` para el panel del laptop, `HDMI-A-1`/`DP-1` para externos).

```bash
xrandr --listmonitors   # resumen: cuántas pantallas y sus nombres
xrandr                  # detalle: todas las resoluciones que soporta cada pantalla
```

- `--listmonitors`: lista corta, una línea por pantalla activa.
- Sin opciones: lista todas las pantallas (conectadas o no) con todas sus resoluciones
  soportadas; la que tiene `*` al lado es la resolución activa, la que tiene `+` es la
  preferida/nativa.

Para cambiar algo (en vez de solo consultar) hace falta `--output NOMBRE` con la opción
deseada, por ejemplo `xrandr --output HDMI-A-1 --primary`. En Wayland esos cambios no siempre
se aplican al compositor real (solo a Xwayland); conviene usar la herramienta propia del
compositor (p.ej. `wlr-randr`, o la configuración de Hyprland/niri) para configurar pantallas
de la sesión gráfica real.

### 12.2 `hwinfo --monitor`

Muestra información detallada de los monitores detectados vía EDID (el identificador que
envía cada pantalla): marca, modelo, tamaño físico, año de fabricación y todas las
resoluciones/frecuencias soportadas. A diferencia de `xrandr`, no depende de X11/Wayland ni
necesita una sesión gráfica activa, y no indica qué conector (`eDP-1`, `HDMI-A-1`, etc.) usa
cada pantalla.

```bash
hwinfo --monitor
```

Útil para identificar el modelo exacto de una pantalla (ej. al buscar drivers o perfiles de
color) cuando `xrandr` solo da el nombre genérico del conector.

