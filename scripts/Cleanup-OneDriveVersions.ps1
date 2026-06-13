
# ==============================
# CONFIGURATION
# ==============================
$FolderPath = "Documents/Zotero"      # Change to your OneDrive folder path
$KeepVersions = 1            # How many versions to keep (1 = only latest)
$DryRun = $true              # Set to $false to actually delete
$LogFile = "OneDriveVersionCleanup.log"

# ==============================
# CONNECT TO GRAPH
# ==============================
Connect-MgGraph -Scopes "Files.ReadWrite.All"
Select-MgProfile -Name "beta"  # Needed for versions API

# ==============================
# GET DRIVE INFO
# ==============================
$drive = Get-MgDrive -ConsistencyLevel eventual
Write-Host "Connected to OneDrive: $($drive.Id)"

# ==============================
# GET TARGET FOLDER
# ==============================
$folder = Get-MgDriveItem -DriveId $drive.Id -ItemId "root" -ExpandProperty Children | Where-Object { $_.Name -eq "Zotero" }
if (-not $folder) {
    Write-Host "Folder '$FolderPath' not found!" -ForegroundColor Red
    exit
}

# ==============================
# GET ALL FILES IN FOLDER (Recursive)
# ==============================
function Get-AllFiles($parentId) {
    $items = Get-MgDriveItemChild -DriveId $drive.Id -ItemId $parentId
    foreach ($item in $items) {
        if ($item.Folder) {
            Get-AllFiles $item.Id
        }
        elseif ($item.File) {
            $item
        }
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

        # Delete old versions
        for ($i = 0; $i -lt ($versions.Count - $KeepVersions); $i++) {
            $versionId = $versions[$i].Id
            if ($DryRun) {
                Write-Host "[DryRun] Would delete version $versionId of $($file.Name)"
            }
            else {
                Remove-MgDriveItemVersion -DriveId $drive.Id -ItemId $file.Id -DriveItemVersionId $versionId
                Write-Host "Deleted version $versionId of $($file.Name)"
            }
        }
    }
}

