param([string]$Version = "")

$Repo = "Semporchothi-s/Kee-cli"
$BaseUrl = "https://github.com/$Repo/releases"

if (-not $Version) {
    try {
        $release = Invoke-RestMethod "https://api.github.com/repos/$Repo/releases/latest"
        $Version = $release.tag_name
    } catch {
        Write-Error "Could not determine latest version. Pass -Version explicitly: .\install.ps1 -Version 1.5.0"
        exit 1
    }
}

# Ensure tag has lead 'v' for the URL path, but filenames use clean versions
$Tag = if ($Version -like "v*") { $Version } else { "v$Version" }
$CleanVersion = $Tag -replace '^v', ''

$File = "kee-windows-v$CleanVersion.exe"
$Url  = "$BaseUrl/download/$Tag/$File"

Write-Host "Installing kee v$Version..."
Write-Host "Downloading from: $Url"

$Tmp = Join-Path $env:TEMP "kee-install-$PID.exe"
try {
    Invoke-WebRequest -Uri $Url -OutFile $Tmp -UseBasicParsing
} catch {
    Write-Error "Failed to download: $_"
    exit 1
}

if (-not (Test-Path $Tmp)) {
    Write-Error "Download failed - file not found"
    exit 1
}

Write-Host "Running install..."
try {
    $output = & $Tmp install 2>&1
    Write-Host $output
    
    if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne $null) {
        Write-Error "Install failed with exit code $LASTEXITCODE"
        exit $LASTEXITCODE
    }
} catch {
    Write-Error "Failed to run install: $_"
    Remove-Item $Tmp -Force -ErrorAction SilentlyContinue
    exit 1
}

Remove-Item $Tmp -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "kee v$Version installed successfully!"
Write-Host "Restart your terminal, then run: kee version"
