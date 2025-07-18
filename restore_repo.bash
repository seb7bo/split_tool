#!/bin/bash

# restore_repo.bash
# This script restores the current Git repository by deleting the current folder and re-cloning it.

restore_this_repo() {
    local inputString="$1"
    local gitUrl
    gitUrl=$(git config --get remote.origin.url)

    # Check if gitUrl is empty
    if [[ -z "$gitUrl" ]]; then
        echo "❌ Error: No remote.origin.url found. Are you in a Git repository?"
        return 1
    fi

    # Prompt for confirmation
    read -p "⚠️  This will DELETE the current folder and clone the repository again. Continue? (y/n): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "✅ Operation cancelled."
        return 1
    fi

    local currPath
    currPath=$(pwd)
    local repoName
    repoName=$(basename "$currPath")

    cd .. || {
        echo "❌ Failed to move to parent directory."
        return 1
    }

    echo "🧹 Removing current repository folder: $currPath"
    rm -rf "$currPath"

    echo "📥 Cloning repository from: $gitUrl"
    git clone "$gitUrl"

    echo "📂 Entering repository folder: $repoName"
    cd "$repoName" || {
        echo "❌ Failed to enter newly cloned folder."
        return 1
    }

    # Optional: handle additional logic
    # if [[ "$inputString" == "meta_branch" ]]; then
    #     echo "Switching to meta_branch..."
    #     git checkout meta_branch
    # fi

    echo "✅ Repository restored successfully."
}

# Entry point
restore_this_repo "$1"
