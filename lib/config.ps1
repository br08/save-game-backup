function Parse-Config {
    param (
        [string]$path
    )

    # Read the config file into a hashtable
    $configContent = Get-Content -Path $path | Out-String
    $config = @{}

    foreach ($line in $configContent -split "`n") {
        $line = $line.Trim()
        if ($line -match '^(?<key>[^=]+)=(?<value>.+)$') {
            $key = $matches['key'].Trim()
            $value = $matches['value'].Trim()
            
            # Replace environment variables for their actual values
            if ($value -match "%([^%]+)%") {
                $placeholder = $matches[0]
                $envVarName = $matches[1]
                $envVarValue = [System.Environment]::GetEnvironmentVariable($envVarName)
                if (![string]::IsNullOrEmpty($envVarValue)) {
                    $value = $value -replace [regex]::Escape($placeholder), $envVarValue
                }
            }
            $config[$key] = $value
        }
    }

    return $config
}