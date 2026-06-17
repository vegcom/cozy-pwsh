# Helper function to find and configure VS Code executables
# Single Responsibility: finds executable, sets env var, optionally runs version command
function Find-CodeExecutable {
    param(
        [string]$Name,
        [string]$EnvVarName,
        [string[]]$CandidatePaths,
        [scriptblock]$VersionCommand,
        [string]$VersionLabel,
        [scriptblock]$VersionPath
    )

    # Search for executable in candidate paths
    $found = @()
    foreach ($p in $CandidatePaths) {
        if (Test-Path $p) {
            $found += (Get-Item -LiteralPath $p).FullName
        }
    }

    # Handle not found
    if ($found.Count -eq 0) {
        if (Get-Command logging -ErrorAction SilentlyContinue) {
            logging "No $Name executable found" "DEBUG"
        }
        return
    }

    # Handle multiple found (use first)
    if ($found.Count -gt 1) {
        if (Get-Command logging -ErrorAction SilentlyContinue) {
            logging "Multiple $Name executables found - using first: $($found[0])" "WARN"
        }
    }

    # Set environment variable
    Set-Item -Path "env:$EnvVarName" -Value $found[0]

    # Execute version command if provided
    if ($VersionCommand) {
        try {
            & $VersionCommand
            $path = & $VersionPath
            if (Get-Command logging -ErrorAction SilentlyContinue) {
                logging "$VersionLabel applied with path: $path" "DEBUG"
            }
        } catch {
            $path = & $VersionPath
            if (Get-Command logging -ErrorAction SilentlyContinue) {
                logging "$VersionLabel failed with path: $path" "WARN"
            }
        }
    }
}

# Find VS Code
Find-CodeExecutable -Name "VS Code" -EnvVarName "CODE_EXE" `
    -CandidatePaths @(
        (Join-Path $env:PROGRAMFILES "Microsoft VS Code/Code.exe"),
        (Join-Path $env:LOCALAPPDATA "Programs\Microsoft VS Code/Code.exe")
    )

# Find VS Code Insiders
Find-CodeExecutable -Name "VS Code Insiders" -EnvVarName "CODE_INSIDERS_EXE" `
    -CandidatePaths @(
        (Join-Path $env:PROGRAMFILES "Microsoft VS Code Insiders/Code - Insiders.exe"),
        (Join-Path $env:LOCALAPPDATA "Programs\Microsoft VS Code Insiders/Code - Insiders.exe")
    )

# Find VS Code CLI
Find-CodeExecutable -Name "VS Code CLI" -EnvVarName "CODE_CMD_EXE" `
    -CandidatePaths @(
        (Join-Path $env:PROGRAMFILES "WinGet/Links/code.exe"),
        (Join-Path $env:LOCALAPPDATA "Microsoft/WinGet/Links/code.exe")
    ) `
    -VersionCommand {
        & $env:CODE_CMD_EXE version use stable --install-dir (Split-Path -Parent $env:CODE_EXE) 1>$null 2>$null
    } `
    -VersionLabel "Vscode CLI" `
    -VersionPath { Split-Path -Parent $env:CODE_INSIDERS_EXE }

# Find VS Code Insiders CLI
Find-CodeExecutable -Name "VS Code Insiders CLI" -EnvVarName "CODE_INSIDERS_CMD_EXE" `
    -CandidatePaths @(
        (Join-Path $env:PROGRAMFILES "WinGet/Links/code-insiders.exe"),
        (Join-Path $env:LOCALAPPDATA "Microsoft/WinGet/Links/code-insiders.exe")
    ) `
    -VersionCommand {
        & $env:CODE_INSIDERS_CMD_EXE version use insider --install-dir (Split-Path -Parent $env:CODE_INSIDERS_EXE) 1>$null 2>$null
    } `
    -VersionLabel "Vscode Insiders CLI" `
    -VersionPath { Split-Path -Parent $env:CODE_INSIDERS_EXE }

# Load shell integration if running in VS Code
if ($env:TERM_PROGRAM -eq "vscode") {
    try {
        $shellIntegration = & $env:CODE_EXE --locate-shell-integration-path pwsh 2>$null
        if ($shellIntegration -and (Test-Path $shellIntegration)) {
            . $shellIntegration
            if (Get-Command logging -ErrorAction SilentlyContinue) {
                logging "VS Code shell integration loaded" "DEBUG"
            }
        }
    } catch {
        if (Get-Command logging -ErrorAction SilentlyContinue) {
            logging "VS Code shell integration failed: $_" "WARN"
        }
    }
}
