# Limpieza de versiones antiguas de OneDrive

Script de PowerShell que usa la API de Microsoft Graph para eliminar versiones antiguas
de archivos en OneDrive (útil para carpetas grandes como Zotero).

!!! warning
    Ajustar `$FolderPath` y ejecutar primero con `$DryRun = $true` para verificar qué se borraría.

## Configuración y script

```powershell
# ==============================
# CONFIGURATION
# ==============================
$FolderPath = "Documents/Zotero"  # Cambiar según la carpeta deseada
$KeepVersions = 1                  # Versiones a conservar (1 = solo la última)
$DryRun = $true                    # Cambiar a $false para borrar de verdad
$LogFile = "OneDriveVersionCleanup.log"

# ==============================
# CONNECT TO GRAPH
# ==============================
Connect-MgGraph -Scopes "Files.ReadWrite.All"
Select-MgProfile -Name "beta"  # Necesario para la API de versiones

# ==============================
# GET DRIVE INFO
# ==============================
$drive = Get-MgDrive -ConsistencyLevel eventual
Write-Host "Connected to OneDrive: $($drive.Id)"

# ==============================
# GET TARGET FOLDER
# ==============================
$folder = Get-MgDriveItem -DriveId $drive.Id -ItemId "root" -ExpandProperty Children |
    Where-Object { $_.Name -eq "Zotero" }
if (-not $folder) {
    Write-Host "Folder '$FolderPath' not found!" -ForegroundColor Red
    exit
}

# ==============================
# GET ALL FILES (recursive)
# ==============================
function Get-AllFiles($parentId) {
    $items = Get-MgDriveItemChild -DriveId $drive.Id -ItemId $parentId
    foreach ($item in $items) {
        if ($item.Folder) { Get-AllFiles $item.Id }
        elseif ($item.File) { $item }
    }
}

$files = Get-AllFiles $folder.Id
Write-Host "Found $($files.Count) files in '$FolderPath'"

# ==============================
# PROCESS FILES
# ==============================
foreach ($file in $files) {
    $versions = Get-MgDriveItemVersion -DriveId $drive.Id -ItemId $file.Id
    if ($versions.Count -gt $KeepVersions) {
        Write-Host "File: $($file.Name) has $($versions.Count) versions"
        Add-Content $LogFile "File: $($file.Name) - Versions: $($versions.Count)"

        for ($i = 0; $i -lt ($versions.Count - $KeepVersions); $i++) {
            $versionId = $versions[$i].Id
            if ($DryRun) {
                Write-Host "[DryRun] Would delete version $versionId of $($file.Name)"
            } else {
                Remove-MgDriveItemVersion -DriveId $drive.Id -ItemId $file.Id -DriveItemVersionId $versionId
                Write-Host "Deleted version $versionId of $($file.Name)"
            }
        }
    }
}
```

## Requisitos

- Módulo `Microsoft.Graph` instalado en PowerShell
- Cuenta con permisos `Files.ReadWrite.All` en el tenant de Microsoft 365
