# Ensure Composer dependencies are installed
function Install-ComposerDependencies {
    Write-Host "Running composer install..." -ForegroundColor Yellow
    & composer install
}

# Get current and latest versions
function Get-ComposerVersions {
    Write-Host "Fetching current and latest versions..." -ForegroundColor Yellow
    $outdatedOutput = & composer outdated --direct
    $outdatedOutput | Out-File -Encoding UTF8 versions.txt
    Write-Host "versions.txt content:" -ForegroundColor Green
    Get-Content -Path "versions.txt"
}

# Get license information
function Get-ComposerLicenses {
    Write-Host "Fetching license information..." -ForegroundColor Yellow
    $licensesOutput = & composer licenses
    $licensesOutput | Out-File -Encoding UTF8 licenses.txt
    Write-Host "licenses.txt content:" -ForegroundColor Green
    Get-Content -Path "licenses.txt"
}

# Parse text files and create a formatted table
function Create-DependencyTable {
    Write-Host "Creating dependency table..." -ForegroundColor Yellow

    # Read versions
    $versionsText = Get-Content -Path "versions.txt"

    # Read licenses
    $licensesText = Get-Content -Path "licenses.txt"

    # File to save the output
    $outputFile = "php_dependencies_list.txt"

    # Write header to the file
    $tableHeader = "Package Name".PadRight(50) + "Current Version".PadRight(20) + "Latest Version".PadRight(20) + "License"
    $tableSeparator = "=" * $tableHeader.Length

    Add-Content -Path $outputFile -Value $tableHeader
    Add-Content -Path $outputFile -Value $tableSeparator

    # Initialize arrays for storing package details
    $packageNames = @()
    $packageCurrentVersions = @()
    $packageLatestVersions = @()
    $packageLicenses = @()

    # Parse versions text to get package names and versions
    foreach ($line in $versionsText) {
        if ($line -match "^(\S+)\s+(\S+)\s+(\S+)") {
            $packageName = $matches[1]
            $packageCurrentVersion = $matches[2]
            $packageLatestVersion = $matches[3]

            # Store package details
            $packageNames += $packageName
            $packageCurrentVersions += $packageCurrentVersion
            $packageLatestVersions += $packageLatestVersion
        }
    }

    # Parse licenses text to get license names
    foreach ($line in $licensesText) {
        if ($line -match "^(\S+)\s+:\s+(.+)$") {
            $packageName = $matches[1]
            $packageLicense = $matches[2]

            # Store package license
            $packageLicenses[$packageName] = $packageLicense
        }
    }

    # Combine and write package information to the file
    for ($i = 0; $i -lt $packageNames.Count; $i++) {
        $packageName = $packageNames[$i]
        $packageCurrentVersion = $packageCurrentVersions[$i]
        $packageLatestVersion = $packageLatestVersions[$i]
        $packageLicense = $packageLicenses[$packageName]

        # Format the row and add to output file
        $tableRow = $packageName.PadRight(50) + $packageCurrentVersion.PadRight(20) + $packageLatestVersion.PadRight(20) + $packageLicense
        Add-Content -Path $outputFile -Value $tableRow
    }

    Write-Host "Dependency information has been saved to $outputFile"
}

# Main script execution
Install-ComposerDependencies
Get-ComposerVersions
Get-ComposerLicenses
Create-DependencyTable
