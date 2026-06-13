# Subtítulos y traducciones de videos con IA

Usando [yt-whisper](https://github.com/m1guelpf/yt-whisper) (fork de naresharelli).

---

## Instalación

### 1. Actualizar PowerShell (Windows)

Desinstalar la versión anterior desde Panel de Control, luego:

```cmd
winget install --id Microsoft.Powershell --source winget
```

### 2. Instalar ffmpeg (via Chocolatey)

```powershell
choco install ffmpeg
```

??? note "Instalar Chocolatey si no está disponible"
    ```powershell
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    ```

### 3. Instalar yt-whisper (desde Anaconda)

```bash
pip install git+https://github.com/naresharelli/yt-whisper.git
```

---

## Uso

```bash
# Transcribir en español con el modelo medium
yt_whisper "https://www.youtube.com/watch?v=VIDEO_ID" --language Spanish --model medium

# Traducir al inglés
yt_whisper "https://www.youtube.com/watch?v=VIDEO_ID" --language Spanish --model medium --task translate

# Ver todas las opciones
yt_whisper --help
```
