# Conda initialize (Windows)

$candidates = @(
    'C:\opt\miniforge3\Scripts\conda.exe'
    (Join-Path $HOME 'miniforge3\Scripts\conda.exe')
)

$exe = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $exe) {
    logging "No conda executable found" "WARN"
    return
}

$env:CONDA_EXE = $exe
logging "Using conda executable: $exe" "DEBUG"

# TODO: Windows uses the legacy hook on 2026-03-06
$hookScript = Join-Path (Split-Path $exe -Parent) "..\shell\condabin\conda-hook.ps1"

if (Test-Path $hookScript) {
    & $hookScript
    logging "Loaded conda-hook.ps1 (Windows legacy activation)" "DEBUG"
} else {
    logging "conda-hook.ps1 not found at $hookScript" "ERROR"
}
