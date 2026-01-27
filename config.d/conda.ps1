# Conda initialize

# conda config --set changeps1 False
# starship config conda.ignore_base false

# Candidate conda executables
$candidateExe = @(
    'C:\opt\miniforge3\Scripts\conda.exe'
    (Join-Path $HOME 'miniforge3\Scripts\conda.exe')
)

# Candidate conda.bat paths
$candidateBat = @(
    'C:\opt\miniforge3\Library\bin\conda.bat'
    (Join-Path $HOME 'miniforge3\Library\bin\conda.bat')
)

# Find conda.exe
$exe = Find-FirstExisting $candidateExe

if (-not $exe) {
    logging "No conda executable found in: $($candidateExe -join '; ')" "WARN"
    return
}

$env:CONDA_EXE = $exe
logging "Using conda executable: $exe" "DEBUG"

# Initialize conda for PowerShell
try {
    $hook = (& $env:CONDA_EXE shell.powershell hook) | Out-String
    if ($hook) { Invoke-Expression $hook }
    logging "Initialized conda from $env:CONDA_EXE" "DEBUG"
} catch {
    logging "Failed to initialize conda from $env:CONDA_EXE - $_" "ERROR"
}

# Find conda.bat
$bat = Find-FirstExisting $candidateBat

if ($bat) {
    $env:CONDA_BAT = $bat
    logging "Found conda.bat at $bat" "DEBUG"

    try {
        & $bat > $null
        logging "Sourced conda.bat from $bat" "DEBUG"
    } catch {
        logging "Failed to source conda.bat from $bat - $_" "ERROR"
    }
} else {
    logging "No conda.bat found in candidate paths" "WARN"
}

