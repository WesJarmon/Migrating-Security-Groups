#!/bin/bash

# Prompt the user for input values
read -p "Enter domain: " domain
read -p "Enter project: " project
read -p "Enter username: " username
read -s -p "Enter password: " password
echo  # Print a new line after the password prompt

INPUT_CSV="$1"
OUTPUT_CSV="output_with_ids.csv"

if [[ ! -f "$INPUT_CSV" ]]; then
    echo "Usage: $0 path/to/input.csv"
    exit 1
fi

# Read the header and write it to the output file
head -n 1 "$INPUT_CSV" | awk -F',' 'BEGIN{OFS=","} { $2="SecurityGroupID"; print }' > "$OUTPUT_CSV"

# Process rows starting from the second line
tail -n +2 "$INPUT_CSV" | while IFS= read -r line; do
    # Extract the first field (Group Name)
    name=$(echo "$line" | cut -d',' -f1 | xargs)

    # Default ID to empty
    id=""

    if [[ -n "$name" ]]; then
        echo "Fetching ID for: $name"

        # Run symp command and extract the ID
        id=$(symp -k --url https://127.0.0.1 \
              --domain "$domain" \
              --project "$project" \
              --username "$username" \
              --password "$password" \
              vpc security-group list --name "$name" \
              | grep -E '^| id\s+\|' | awk -F'|' '{gsub(/ /, "", $2); print $2}' | head -n 1)
    fi

    # Insert the ID as the second field (Column B)
    echo "$line" | awk -F',' -v id="$id" 'BEGIN{OFS=","} {$2=id; print}' >> "$OUTPUT_CSV"
done

echo "Done! Modified CSV saved to: $OUTPUT_CSV"