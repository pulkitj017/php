# # #!/bin/bash
# # Install the dependencies
# composer install --ignore-platform-req=ext-simplexml 
# composer show --no-ansi > dependency.csv
# # Generate a CSV of outdated dependencies
# composer outdated --no-ansi > outdated-dependencies.csv
# # Generate a JSON file of the licenses
# composer licenses --format=json > sbom-licenses.json
# # Step 1: Clean outdated dependencies and add ** to the names
# inputFilePath="outdated-dependencies.csv"
# outputFilePath="cleaned-outdated-dependencies.csv"
# # Remove unwanted characters and add ** to dependency names, skipping the header
# tail -n +2 "$inputFilePath" | awk -F, '{
#     gsub(/[!~]/, "", $1); 
#     print $1 $2 
# }' > "$outputFilePath"
# echo "Outdated dependencies marked and saved to $outputFilePath"
# # Step 2: Convert licenses.json to licenses.csv
# jsonFilePath="sbom-licenses.json"
# # Path to the output text file
# txtFilePath="sbom-licenses.csv"
# # Create the header with increased spacing
# columnHeaders=("Dependency" "Version" "License")
# headerLine=$(printf "%-40s %-15s %s\n" "${columnHeaders[0]}" "${columnHeaders[1]}" "${columnHeaders[2]}")
# underline=$(printf "%0.s-" {1..70})
# # Start the formatted data with the header and underline
# formattedData="$headerLine\n$underline"
# # Iterate through the dependencies and format each entry with increased spacing
# dependencies=$(jq -r '.dependencies | to_entries[] | "\(.key),\(.value.version),\(.value.license | join(" "))"' "$jsonFilePath")
# while IFS=, read -r name version license; do
#     formattedLine=$(printf "%-40s %-15s %s\n" "$name" "$version" "$license")
#     formattedData="$formattedData\n$formattedLine"
# done <<< "$dependencies"
# # Export the formatted data to the text file
# echo -e "$formattedData" > "$txtFilePath"
# echo "The license information has been exported to $txtFilePath"

#!/bin/bash
set -e

# Install dependencies
composer install --ignore-platform-req=ext-simplexml 
composer show --no-ansi > dependency.csv

# Generate outdated dependencies
composer outdated --no-ansi > outdated-dependencies.csv
composer licenses --format=json > sbom-licenses.json

# Step 1: Clean outdated dependencies
inputFilePath="outdated-dependencies.csv"
outputFilePath="cleaned-outdated-dependencies.csv"

tail -n +2 "$inputFilePath" | awk -F, '{
    gsub(/[!~]/, "", $1); 
    print $1 $2 
}' > "$outputFilePath"
echo "Outdated dependencies marked and saved to $outputFilePath"

# Step 2: Convert licenses.json → licenses.csv
jsonFilePath="sbom-licenses.json"
txtFilePath="sbom-licenses.csv"

# Header
printf "%-40s %-15s %s\n" "Dependency" "Version" "License" > "$txtFilePath"
printf "%0.s-" {1..70} >> "$txtFilePath"
echo "" >> "$txtFilePath"

# Iterate through dependencies
jq -r '.dependencies | to_entries[] | "\(.key),\(.value.version),\(.value.license | join(" "))"' "$jsonFilePath" |
while IFS=, read -r name version license; do
    printf "%-40s %-15s %s\n" "$name" "$version" "$license" >> "$txtFilePath"
done

echo "The license information has been exported to $txtFilePath"

