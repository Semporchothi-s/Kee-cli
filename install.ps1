param([string]$Version = "")

$Repo = "Semporchothi-s/Project-Kee"
$BaseUrl = "https://github.com/$Repo/releases"

if (-not $Version) {
    try {
        $release = Invoke-RestMethod "https://api.github.com/repos/$Repo/releases/latest"
        $Version = $release.tag_name -replace '^v', ''
    } catch {
        Write-Error "Could not determine latest version. Pass -Version explicitly: .\install.ps1 -Version 1.5.0"
        exit 1
    }
}

$File = "kee-windows-v$Version.exe"
$Url  = "$BaseUrl/download/v$Version/$File"

Write-Host "Installing kee v$Version..."
Write-Host "Downloading from: $Url"

$Tmp = Join-Path $env:TEMP "kee-install.exe"
Invoke-WebRequest -Uri $Url -OutFile $Tmp

Write-Host "Running self-install..."
$process = Start-Process -FilePath $Tmp -ArgumentList "self-install" -NoNewWindow -Wait -PassThru

if ($process.ExitCode -eq 0) {
    Remove-Item $Tmp -Force
    Write-Host ""
    Write-Host "kee v$Version installed successfully!"
    Write-Host "Restart your terminal, then run: kee --version"
} else {
    Write-Error "Self-install failed with exit code $($process.ExitCode)"
    exit 1
}
