# Path to the JSON file
$jsonFilePath = "licenses.json"

# Path to the output text file
$txtFilePath = "licenses.txt"

# Read the JSON file
$jsonContent = Get-Content -Path $jsonFilePath -Raw | ConvertFrom-Json

# Prepare column headers
$columnHeaders = "Dependency", "Version", "License"

# Create a formatted header line with increased spacing between columns
$headerLine = "{0,-40} {1,-15} {2}" -f $columnHeaders[0], $columnHeaders[1], $columnHeaders[2]
$underline = "-" * $headerLine.Length

# Create an array to store the formatted data
$formattedData = @()

# Add headers and underline to the formatted data
$formattedData += $headerLine
$formattedData += $underline

# Iterate through the dependencies and format each entry with increased spacing
foreach ($dependency in $jsonContent.dependencies.PSObject.Properties) {
    $name = $dependency.Name
    $version = $dependency.Value.version
    $license = -join $dependency.Value.license

    $formattedLine = "{0,-40} {1,-15} {2}" -f $name, $version, $license
    $formattedData += $formattedLine
}

# Export the formatted data to a text file
$formattedData | Out-File -FilePath $txtFilePath -Encoding UTF8

Write-Output "The license information has been exported to $txtFilePath"
