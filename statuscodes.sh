#!/bin/bash

# Function to display help
display_help() {
    echo "Usage: $0 [-h] <url_file>"
    echo
    echo "This script tests each URL in the specified file and displays the HTTP status code."
    echo
    echo "  -h         Display this help message."
    echo "  <url_file> Path to the file containing the URLs to test."
    echo
    echo "Example:"
    echo "  $0 urls.txt"
    echo "    This command tests all URLs listed in 'urls.txt' and displays their HTTP status codes."
    echo
    exit 0
}

# Check for help option
if [[ "$1" == "-h" ]]; then
    display_help
fi

# Check if the URL file is provided
if [[ -z "$1" ]]; then
    echo "Error: No URL file specified."
    display_help
fi

url_file="$1"

# Check if the file exists
if [[ ! -f "$url_file" ]]; then
    echo "File not found: $url_file"
    exit 1
fi

# Create a temporary file to store status codes and URLs
temp_file=$(mktemp)

# Initialize a counter variable
count=0

# Process each URL and print status code
while IFS= read -r url; do
    # Increment the counter variable
    count=$((count+1))

    # Print the current progress
    echo "Testing URL $count/$(wc -l < "$url_file")..."

    # Use curl with the -L flag to follow redirects and the -s flag for silent mode
    # Use the -w flag to print the status code and elapsed time
    # Use the -o flag to redirect output to /dev/null
    # Use the -S flag to only show errors and the status code
    # Use the -m flag to set a timeout of 10 seconds
    response=$(curl -L -s -o /dev/null -w "%{http_code} - %{time_total}s" -m 10 "$url" 2>/dev/null)

    # Print the status code and URL
    echo "$url - Status Code: ${response% - *.??}"

    # Save the status code and URL to the temporary file
    echo "$response $url" >> "$temp_file"
done < "$url_file"

# Print all status codes
echo "Showing all status codes:"
cat "$temp_file"

# Ask the user if they want to save the results to a file
read -p "Do you want to save the results to a file? (y/n) " save_to_file

if [[ "$save_to_file" == "y" ]]; then
    # Prompt for the filename
    read -p "Enter the filename to save the results: " filename

    # Save the results to the specified file
    cp "$temp_file" "$filename"
    echo "Results saved to $filename"
else
    echo "Results not saved."
fi

# Clean up temporary files
rm "$temp_file"
