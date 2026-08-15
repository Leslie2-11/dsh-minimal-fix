$ErrorActionPreference = 'Stop'
$src = 'F:\deepseek Harness\agent-presets\minimal-win'
$home = if ($env:DSH_HOME) { $env:DSH_HOME } else { Join-Path $env:USERPROFILE '.dsh' }
$dst = Join-Path $home '.agent-presets\minimal-win'
New-Item -ItemType Directory -Force -Path $dst | Out-Null
Copy-Item (Join-Path $src '*') $dst -Force
Write-Host "user preset synced: $dst"
Get-ChildItem $dst | Select-Object Name, Length
