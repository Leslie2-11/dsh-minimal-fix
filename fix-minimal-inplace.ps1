$ErrorActionPreference = 'Stop'
$log = 'F:\deepseek Harness\fix-minimal-inplace.log'
function Log($m) { "[{0}] {1}" -f (Get-Date -Format o), $m | Out-File -FilePath $log -Append -Encoding utf8 }
try {
  $src = 'F:\deepseek Harness\agent-presets\minimal-win\agent.cordis.yml'
  $dst = 'F:\nodejs\node_global\node_modules\@deepseek-ai\dsh\config\agent-presets\minimal\agent.cordis.yml'
  Log "start (elevated): src=$src"
  if (-not (Test-Path $src)) { throw "source missing: $src" }
  if (-not (Test-Path (Split-Path $dst))) { throw "target dir missing: $(Split-Path $dst)" }
  if (Test-Path $dst) { Copy-Item $dst "$dst.orig" -Force; Log "backup -> $dst.orig" }
  Copy-Item $src $dst -Force
  Log "copied -> $dst ($((Get-Item $dst).Length) bytes)"
} catch {
  Log "FAILED: $($_.Exception.Message)"
  throw
}
