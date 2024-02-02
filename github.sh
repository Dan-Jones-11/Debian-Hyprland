#!/bin/bash

# Set your GitHub username and repository name
USERNAME="
Elliot-Alderson86"
REPO="Hyprland"

# Set the home directory
HOME_DIR="/home/your_username"

# Temporary file to store directories to upload
TEMP_FILE="/tmp/directories_to_upload.txt"

# Function to recursively find directories containing Git repositories
find_git_directories() {
    find "$1" -type d -name .git -printf '%h\n'
}

# Find Git directories in the home directory
find_git_directories "$HOME_DIR" > "$TEMP_FILE"

# Change to the home directory
cd "$HOME_DIR" || exit

# Initialize array to store unique directories
declare -a UNIQUE_DIRS

# Read the temp file line by line
while IFS= read -r dir; do
    # Extract parent directory
    parent_dir=$(dirname "$dir")
    
    # Check if parent directory is not already added
    if [[ ! " ${UNIQUE_DIRS[@]} " =~ " ${parent_dir} " ]]; then
        # Add parent directory to the array
        UNIQUE_DIRS+=("$parent_dir")
    fi
done < "$TEMP_FILE"

# Remove temporary file
rm "$TEMP_FILE"

# Loop through unique directories and upload them to GitHub
for dir in "${UNIQUE_DIRS[@]}"; do
    # Change to the directory
    cd "$dir" || continue
    
    # Initialize Git repository if not already done
    git init
    
    # Add all files to the repository
    git add .
    
    # Commit changes
    git commit -m "Auto-commit $(date)"
    
    # Set the remote repository URL
    REMOTE_URL="https://github.com/$USERNAME/$REPO.git"
    git remote add origin "$REMOTE_URL"
    
    # Push changes to GitHub
    git push -u origin master
    
    # Change back to home directory
    cd "$HOME_DIR" || exit
done

