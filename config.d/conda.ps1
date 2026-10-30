# Conda initialize (Windows)

$ExecCandidates = @(
    '/opt/miniforge3/Scripts/conda.exe'
    '/opt/miniforge3/Scripts/conda'
    (Join-Path $HOME 'miniforge3/Scripts/conda.exe')
    (Join-Path $HOME 'miniforge3/Scripts/conda')
)

$exe = $ExecCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $exe) {
    logging "No conda executable found" "WARN"
    return
}

$parentDir = Split-Path -Path $exe -Parent
$baseDir   = Split-Path -Path $parentDir -Parent

$condaPaths = @(
    $parentDir,
    "$baseDir/Scripts",
    "$baseDir/Library/bin",
    "$baseDir/Library/usr/bin",
    "$baseDir/Library/mingw-w64/bin"
) -join ';'

$env:_CONDA_PATHS = $condaPaths
$env:PATH = "$condaPaths;$env:PATH"

$env:CONDA_EXE = $exe
logging "Using conda executable: $exe" "DEBUG"

$hookScript = Join-Path (Split-Path $exe -Parent) "../shell/condabin/conda-hook.ps1"

if (Test-Path $hookScript) {
    . $hookScript
    logging "Loaded conda-hook.ps1 (Windows legacy activation)" "DEBUG"

    conda activate base
    logging "Activated conda base environment" "DEBUG"
} else {
    logging "conda-hook.ps1 not found at $hookScript" "ERROR"
}
