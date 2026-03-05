param(
  [switch]$Json
)

$ErrorActionPreference = "Stop"

$tools = @(
  @{ Name = "Quartus Shell"; Commands = @("quartus_sh"); Required = $true; Note = "Intel Quartus Prime Lite 25.1" },
  @{ Name = "Quartus Map"; Commands = @("quartus_map"); Required = $true; Note = "Intel Quartus Prime Lite 25.1" },
  @{ Name = "Quartus Fit"; Commands = @("quartus_fit"); Required = $true; Note = "Intel Quartus Prime Lite 25.1" },
  @{ Name = "Quartus Asm"; Commands = @("quartus_asm"); Required = $true; Note = "Intel Quartus Prime Lite 25.1" },
  @{ Name = "Quartus STA"; Commands = @("quartus_sta"); Required = $true; Note = "Intel Quartus Prime Lite 25.1" },
  @{ Name = "Git"; Commands = @("git"); Required = $true; Note = "Git.Git" },
  @{ Name = "GitHub CLI"; Commands = @("gh"); Required = $true; Note = "GitHub.cli" },
  @{ Name = "Python"; Commands = @("python"); Required = $true; Note = "Python.Python.3.12" },
  @{ Name = "Pip"; Commands = @("pip"); Required = $true; Note = "Bundled with Python" },
  @{ Name = "Icarus Verilog"; Commands = @("iverilog","vvp"); Required = $true; Note = "Icarus.Verilog" },
  @{ Name = "Ripgrep"; Commands = @("rg"); Required = $true; Note = "BurntSushi.ripgrep.MSVC" },
  @{ Name = "pdftotext"; Commands = @("pdftotext"); Required = $true; Note = "oschwartz10612.Poppler" }
)

$results = @()
foreach ($tool in $tools) {
  $missingCommands = @()
  $resolved = @()
  foreach ($cmd in $tool.Commands) {
    $cmdInfo = Get-Command $cmd -ErrorAction SilentlyContinue
    if (-not $cmdInfo) {
      $missingCommands += $cmd
    } else {
      $resolved += @($cmdInfo.Source)
    }
  }

  $ok = $missingCommands.Count -eq 0
  $results += [PSCustomObject]@{
    Tool = $tool.Name
    Required = $tool.Required
    Commands = ($tool.Commands -join ", ")
    Status = if ($ok) { "OK" } else { "MISSING" }
    MissingCommands = ($missingCommands -join ", ")
    Paths = ($resolved -join " | ")
    InstallHint = $tool.Note
  }
}

if ($Json) {
  $results | ConvertTo-Json -Depth 3
} else {
  $results | Format-Table -AutoSize
}

$requiredMissing = 0
foreach ($r in $results) {
  if ([bool]$r.Required -and ($r.Status.ToString().Trim().ToUpper() -eq "MISSING")) {
    $requiredMissing++
  }
}
if ($requiredMissing -gt 0) {
  Write-Host ""
  Write-Host "[check] required_missing=$requiredMissing"
  Write-Host "[check] run: powershell -ExecutionPolicy Bypass -File .\tooling\install_lab4_cli.ps1"
  exit 1
}

Write-Host ""
Write-Host "[check] all required CLI tools are available"
