#!/bin/bash

# Script: git-sync.sh
# Author: Thomas Lutkus
# Purpose: Sync all git repos under key folders with minimal fuss

set -euo pipefail
trap 'echo "❌ Script failed at line $LINENO."' ERR

HOSTNAME=$(hostname)
DATE=$(date +%F)
COMMIT_MSG="$HOSTNAME sync $DATE"

TARGET_DIRS=( "$HOME/code" "$HOME/env" "$HOME/obsidian" )

echo "🔍 Scanning for git repos in selected dirs..."

for dir in "${TARGET_DIRS[@]}"; do
    echo "📁 Checking: $dir"
    [ -d "$dir" ] || { echo "    ❌ Skipping (not a dir): $dir"; continue; }

    while IFS= read -r gitdir; do
        repo=$(dirname "$gitdir")
        echo -e "\n==> Syncing: $repo"
        cd "$repo" || continue

        if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
            echo "    ❌ Not a valid Git repo"
            continue
        fi

        if ! git remote | grep -q .; then
            echo "    🚫 No remote set"
            continue
        fi

        git checkout main || echo "    ⚠️ Could not checkout main (may already be on it)"
        git pull --ff-only || echo "    ⚠️ Could not pull (check upstream)"

        git add -A

        if git diff --cached --quiet; then
            echo "    ✅ Nothing to commit"
            continue
        fi

        git commit -m "$COMMIT_MSG" && git push && echo "    🚀 Sync done"
    done < <(find "$dir" -type d -name ".git" 2>/dev/null)

done

