# Conda initialize (modern Miniforge)

# Candidate conda executables
$candidates = @(
    'C:\opt\miniforge3\Scripts\conda.exe'
    (Join-Path $HOME 'miniforge3\Scripts\conda.exe')
)

# Pick the first existing path
$exe = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $exe) {
    logging "No conda executable found in: $($candidates -join '; ')" "WARN"
    return
}

$env:CONDA_EXE = $exe
logging "Using conda executable: $exe" "DEBUG"

# Modern hook
try {
    $hook = (& $exe shell.powershell hook) | Out-String
    if ($hook) {
        Invoke-Expression $hook
        logging "Initialized conda via modern hook" "DEBUG"
    } else {
        logging "Conda hook returned empty output" "WARN"
    }
} catch {
    logging "Failed to initialize conda from $exe - $_" "ERROR"
}
