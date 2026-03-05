param(
  [string]$QuartusBin64 = "D:\altera_lite\25.1std\quartus\bin64"
)

$ErrorActionPreference = "Stop"

function Test-CommandExists {
  param([string]$Name)
  $cmd = Get-Command $Name -ErrorAction SilentlyContinue
  return ($null -ne $cmd)
}

function Install-WingetPackage {
  param(
    [string]$PackageId,
    [string]$DisplayName
  )
  Write-Host "[install] $DisplayName ($PackageId)"
  winget install --id $PackageId --exact --source winget --accept-package-agreements --accept-source-agreements
}

function Add-UserPathEntry {
  param([string]$Entry)
  if (-not (Test-Path -LiteralPath $Entry)) { return $false }
  $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
  $parts = @()
  if ($userPath) { $parts = $userPath -split ";" }
  $exists = ($parts | Where-Object { $_.TrimEnd("\") -ieq $Entry.TrimEnd("\") }).Count -gt 0
  if (-not $exists) {
    $newPath = if ($userPath) { "$userPath;$Entry" } else { $Entry }
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    if (($env:Path -split ";") -notcontains $Entry) {
      $env:Path = "$env:Path;$Entry"
    }
    Write-Host "[path] added to user PATH: $Entry"
  } else {
    Write-Host "[path] already in user PATH: $Entry"
  }
  return $true
}

if (-not (Test-CommandExists "winget")) {
  throw "winget is required for this installer script."
}

$packages = @(
  @{ Cmd = "git"; Id = "Git.Git"; Name = "Git" },
  @{ Cmd = "gh"; Id = "GitHub.cli"; Name = "GitHub CLI" },
  @{ Cmd = "python"; Id = "Python.Python.3.12"; Name = "Python 3.12" },
  @{ Cmd = "rg"; Id = "BurntSushi.ripgrep.MSVC"; Name = "Ripgrep" },
  @{ Cmd = "pdftotext"; Id = "oschwartz10612.Poppler"; Name = "Poppler (pdftotext)" },
  @{ Cmd = "iverilog"; Id = "Icarus.Verilog"; Name = "Icarus Verilog" }
)

foreach ($p in $packages) {
  if (Test-CommandExists $p.Cmd) {
    Write-Host "[skip] $($p.Name) already available"
  } else {
    Install-WingetPackage -PackageId $p.Id -DisplayName $p.Name
  }
}

if (-not (Test-Path -LiteralPath $QuartusBin64)) {
  Write-Host ""
  Write-Host "[quartus] Quartus bin64 path not found: $QuartusBin64"
  Write-Host "[quartus] Install Intel Quartus Prime Lite 25.1 manually, then set PATH."
} else {
  Add-UserPathEntry -Entry $QuartusBin64 | Out-Null
}

# Ensure Icarus path when installed by winget
$icarusBin = "C:\iverilog\bin"
if (Test-Path -LiteralPath $icarusBin) {
  Add-UserPathEntry -Entry $icarusBin | Out-Null
}

Write-Host ""
Write-Host "[done] reopen terminal and run:"
Write-Host "powershell -ExecutionPolicy Bypass -File .\tooling\check_lab4_cli.ps1"
