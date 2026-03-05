param(
  [string]$QuartusBin64 = "D:\altera_lite\25.1std\quartus\bin64"
)

$ErrorActionPreference = "Stop"

function Test-CommandExists {
  param([string]$Name)
  & where.exe $Name 1>$null 2>$null
  return ($LASTEXITCODE -eq 0)
}

function Install-WingetPackage {
  param(
    [string]$PackageId,
    [string]$DisplayName
  )
  Write-Host "[install] $DisplayName ($PackageId)"
  winget install --id $PackageId --exact --source winget --accept-package-agreements --accept-source-agreements
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
  $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
  $parts = @()
  if ($userPath) { $parts = $userPath -split ";" }
  $exists = ($parts | Where-Object { $_.TrimEnd("\") -ieq $QuartusBin64.TrimEnd("\") }).Count -gt 0
  if (-not $exists) {
    $newPath = if ($userPath) { "$userPath;$QuartusBin64" } else { $QuartusBin64 }
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "[quartus] added to user PATH: $QuartusBin64"
  } else {
    Write-Host "[quartus] already in user PATH"
  }
}

Write-Host ""
Write-Host "[done] reopen terminal and run:"
Write-Host "powershell -ExecutionPolicy Bypass -File .\tooling\check_lab4_cli.ps1"
