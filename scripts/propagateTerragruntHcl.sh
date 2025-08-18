#!/bin/bash

# Script to recursively copy terragrunt.hcl files from one folder structure to another
# Usage: ./propagateTerragruntHcl.sh <source_folder> <destination_folder>
# Example: ./propagateTerragruntHcl.sh env/dev env/staging

SOURCE_FOLDER=$1
DEST_FOLDER=$2

if [ -z "$SOURCE_FOLDER" ] || [ -z "$DEST_FOLDER" ]; then
  echo "Usage: $0 <source_folder> <destination_folder>"
  echo "Example: $0 env/dev env/staging"
  exit 1
fi

if [ ! -d "$SOURCE_FOLDER" ]; then
  echo "Error: Source folder '$SOURCE_FOLDER' does not exist."
  exit 1
fi

if [ ! -d "$DEST_FOLDER" ]; then
  echo "Error: Destination folder '$DEST_FOLDER' does not exist."
  exit 1
fi

echo "Copying terragrunt.hcl files from $SOURCE_FOLDER to $DEST_FOLDER..."

# Find all terragrunt.hcl files in source folder and copy to corresponding destination
find "$SOURCE_FOLDER" -name "terragrunt.hcl" -type f | while read -r source_file; do
  # Get the relative path from source folder
  relative_path=${source_file#$SOURCE_FOLDER/}
  
  # Construct destination path
  dest_file="$DEST_FOLDER/$relative_path"
  dest_dir=$(dirname "$dest_file")
  
  # Copy the file
  echo "Copying: $source_file -> $dest_file"
  cp "$source_file" "$dest_file"
  
  if [ $? -eq 0 ]; then
    echo "✓ Successfully copied $relative_path"
  else
    echo "✗ Failed to copy $relative_path"
  fi
done

echo "Copy operation completed."