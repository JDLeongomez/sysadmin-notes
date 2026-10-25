---
icon: simple/linux
---

# Comandos de Linux

![Tux](../assets/logos/tux.svg){ width="72" align="right" }

Referencia organizada por tarea (no alfabética), para encontrar el comando según lo que
se quiere lograr, aunque no se recuerde su nombre. El menú lateral de esta página sigue
estas mismas secciones.

---

## 1. Navegar y explorar

### `pwd`

Muestra la ruta completa del directorio en el que se está parado (*print working directory*).

### `cd`

Cambia de directorio.

```bash
cd ruta/relativa
cd /ruta/absoluta
cd ..        # sube un nivel
cd -         # vuelve al directorio anterior
cd ~         # va al home del usuario
```

### `ls`

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

### `lc` (alias de `colorls`)

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

### `tree`

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

### `broot`

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

---

## 2. Archivos y directorios

### `mkdir`

Crea directorios.

- `-p`: crea toda la ruta de directorios intermedios que no existan (sin error si ya existen).

```bash
mkdir -p proyecto/datos/crudos
```

### `touch`

Crea un archivo vacío si no existe, o actualiza su fecha de modificación si ya existe.

### `cp`

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

### `mv`

Mueve o renombra archivos y directorios (misma sintaxis que `cp`, pero sin dejar copia en el origen).

### `rm`

Elimina archivos o directorios. **No manda nada a una papelera**, el borrado es definitivo.

- `-r`: elimina directorios y su contenido de forma recursiva.
- `-f`: fuerza el borrado sin pedir confirmación ni avisar si el archivo no existe.
- `-i`: pregunta antes de borrar cada archivo.

`rm -rf` es la combinación más peligrosa del sistema: no verifica nada antes de borrar.

### `ln`

Crea enlaces entre archivos.

- `-s`: crea un enlace simbólico (como un acceso directo) en vez de un enlace físico.

```bash
ln -s /ruta/real /ruta/enlace
```

---

## 3. Ver contenido de archivos

### `cat`

Muestra el contenido completo de un archivo en la terminal. Útil para archivos cortos o para
concatenar varios archivos.

### `less`

Muestra el contenido de un archivo página por página, sin cargarlo todo en memoria. Mejor que
`cat` para archivos largos. Flechas o `Page Up`/`Page Down` para moverse, `/texto` para buscar,
`q` para salir.

### `head` / `tail`

Muestran el principio (`head`) o el final (`tail`) de un archivo.

- `-n 20`: muestra 20 líneas en vez de las 10 por defecto.
- `-f` (solo `tail`): sigue el archivo en tiempo real a medida que crece, muy usado para ver logs
  (`tail -f /var/log/algo.log`).

### `wc`

Cuenta líneas, palabras o caracteres de un archivo (*word count*).

- `-l`: solo cuenta líneas.
- `-w`: solo cuenta palabras.
- `-c`: solo cuenta bytes.

---

## 4. Buscar archivos y comandos

### `find`

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

### `locate`

Busca archivos por nombre usando un índice precalculado del sistema de archivos, mucho más
rápido que `find` pero puede estar desactualizado si no se ha regenerado el índice reciente
(`sudo updatedb` lo regenera).

### `which`

Muestra la ruta completa del ejecutable que se usaría al invocar un comando.

```bash
which python3
```

### `whereis`

Similar a `which`, pero además busca el binario, su código fuente y su página de manual.

### `type`

Indica si un nombre es un comando interno de la shell (*builtin*), un alias, una función o un
ejecutable externo, y en este último caso su ruta.

---

## 5. Buscar texto dentro de archivos

### `grep`

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

---

## 6. Permisos, dueños y privilegios

### `chmod`

Cambia los permisos de lectura, escritura y ejecución de un archivo o directorio.

- Modo simbólico: `chmod u+x archivo` (agrega ejecución al dueño), `chmod go-w archivo` (quita
  escritura a grupo y otros).
- Modo numérico: cada permiso es la suma de lectura (4), escritura (2) y ejecución (1), un
  dígito por dueño/grupo/otros. `chmod 644 archivo` = dueño lee y escribe, grupo y otros solo
  leen. `chmod 755 archivo` = dueño lee, escribe y ejecuta, grupo y otros leen y ejecutan.
- `-R`: aplica el cambio recursivamente a un directorio y su contenido.

### `chown`

Cambia el dueño (y opcionalmente el grupo) de un archivo o directorio.

```bash
chown usuario:grupo archivo
```

- `-R`: aplica el cambio recursivamente.

### `sudo`

Ejecuta un único comando con privilegios de administrador (root), pidiendo la contraseña del
usuario actual (si pertenece al grupo con permiso de `sudo`).

### `su`

Abre una sesión como otro usuario (por defecto, root), pidiendo la contraseña de **ese**
usuario, no la propia. `su -` además carga el entorno completo de ese usuario (como si hubiera
iniciado sesión directamente).

---

## 7. Procesos y servicios

### `ps`

Muestra los procesos en ejecución.

```bash
ps aux
```

`aux` es la combinación más usada: todos los procesos (`a`), de todos los usuarios (`x`), con
información detallada (`u`).

### `top` / `htop`

Muestran los procesos en ejecución de forma interactiva, actualizándose en tiempo real, con uso
de CPU y memoria. `htop` (si está instalado) tiene una interfaz más clara y permite ordenar y
matar procesos con el mouse o teclas de flecha.

### `kill` / `killall`

Envían una señal a un proceso, normalmente para terminarlo.

```bash
kill PID
killall nombre_del_proceso
```

- `-9`: señal `SIGKILL`, termina el proceso de forma inmediata y forzada (sin darle oportunidad
  de cerrar limpiamente). Usar solo si el proceso no responde a un `kill` normal.

### `systemctl`

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

---

## 8. Comprimir y descomprimir

### `tar`

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

### `zip` / `unzip`

Comprimen y descomprimen archivos en formato `.zip`, el más compatible con Windows/macOS.

```bash
zip -r archivo.zip carpeta/
unzip archivo.zip
```

---

## 9. Redirección y tuberías

No son comandos sino operadores de la shell para encadenar o redirigir la salida de los
comandos.

- `|` (tubería o *pipe*): envía la salida de un comando como entrada del siguiente.
  `ls -la | grep ".conf"`.
- `>`: redirige la salida a un archivo, sobrescribiéndolo.
- `>>`: redirige la salida a un archivo, agregándola al final.
- `2>&1`: redirige también los errores (descriptor `2`) al mismo lugar que la salida normal
  (descriptor `1`), útil para guardar todo en un mismo log.
- `&&`: ejecuta el siguiente comando solo si el anterior terminó sin error.

---

## 10. Documentación de comandos

### `man`

Muestra el manual completo de un comando (`man comando`). `q` para salir.

### `--help`

La mayoría de comandos aceptan `--help` (o `-h`) para un resumen rápido de sus opciones, más
corto que el manual completo.

