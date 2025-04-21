#!/bin/bash

# Get the path to the CSV file from the first argument
CSV_FILE="$1"

# Check if the CSV file exists
if [[ ! -f "$CSV_FILE" ]]; then
    echo "Usage: $0 path/to/input.csv"
    exit 1
fi

# Ask the user for variable input
read -p "What is the domain name? " DOMAIN_NAME
read -p "What is the project name? " PROJECT_NAME
read -sp "Enter your username: " USERNAME
echo # Move to a new line after reading the username
read -sp "Enter your password: " PASSWORD
echo # Move to a new line after reading the password
read -p "Enter the VPC ID: " VPC_ID

# Skip the header row (first line), extract column A (first field),
# and loop over each non-empty, trimmed line
tail -n +2 "$CSV_FILE" | cut -d',' -f1 | while IFS= read -r name; do
    # Trim leading/trailing whitespace from the name
    name=$(echo "$name" | xargs)

    # Only proceed if the name is not empty
    if [[ -n "$name" ]]; then
        echo "Creating security group: $name"

        # Execute the symp command to create the security group with the user-provided inputs
        symp -k --url https://127.0.0.1 \
            --domain "$DOMAIN_NAME" \
            --project "$PROJECT_NAME" \
            --username "$USERNAME" \
            --password "$PASSWORD" \
            vpc security-group create "$name" "$VPC_ID"
    fi
done