# Initialize starship prompt

# expects starship:
#
# ```pwsh
# winget install starship --silent --accept-source-agreements --accept-package-agreements
# ```

try {
    Invoke-Expression (&starship init powershell)
} catch {
    logging "failed to initialize starship: $_" "ERROR"
}
