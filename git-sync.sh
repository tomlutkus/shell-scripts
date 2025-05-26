#!/bin/bash

set -euo pipefail

HOSTNAME=$(hostname)
DATE=$(date +%F)
COMMIT_MSG="$HOSTNAME sync $DATE"

TARGET_DIRS=( "$HOME/code" "$HOME/env" "$HOME/obsidian" )

echo "🔍 Scanning for git repos in selected dirs..."

for dir in "${TARGET_DIRS[@]}"; do
    [ -d "$dir" ] || continue
    find "$dir" -type d -name ".git" 2>/dev/null | while read -r gitdir; do
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

        git add -A

        if git diff --cached --quiet; then
            echo "    ✅ Nothing to commit"
            continue
        fi

        git commit -m "$COMMIT_MSG" && git push && echo "    🚀 Sync done"
    done
done

