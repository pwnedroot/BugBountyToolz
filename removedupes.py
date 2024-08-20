import sys

# Script to remove duplicate lines from a file.
# Created by pwnedroot
# Usage:
#   python3 remove_duplicates.py <file_path>
# Example:
#   python3 remove_duplicates.py your_file.txt
# This script reads the file specified by <file_path>, removes duplicate lines,
# and writes the unique lines back to the file. It also prints the number of duplicates removed.

def remove_duplicate_lines(file_path):
    try:
        # Read lines from the file
        with open(file_path, 'r') as file:
            lines = file.readlines()
        
        # Count original lines
        original_line_count = len(lines)
        
        # Remove duplicates by converting the list to a set and back to a list
        unique_lines = list(set(lines))
        
        # Count unique lines
        unique_line_count = len(unique_lines)
        
        # Calculate the number of duplicates removed
        duplicates_removed = original_line_count - unique_line_count
        
        # Optionally, sort the lines if you want them to be in a consistent order
        unique_lines.sort()
        
        # Write unique lines back to the file
        with open(file_path, 'w') as file:
            file.writelines(unique_lines)
        
        print(f"Removed {duplicates_removed} duplicates from {file_path}.")
    
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 remove_duplicates.py <file_path>")
    else:
        file_path = sys.argv[1]
        
        # Check if the provided argument is actually a file
        try:
            with open(file_path, 'r'):
                remove_duplicate_lines(file_path)
        except FileNotFoundError:
            print(f"File '{file_path}' not found.")
        except Exception as e:
            print(f"An error occurred: {e}")
