#!/bin/bash
# Daily commit and push for settings.json if there are changes

REPO_DIR="$HOME/personalRepos/vscodeUserSettings"

cd "$REPO_DIR"

# Check if settings.json has uncommitted changes
if ! git diff --quiet settings.json; then
    echo "$(date): Settings changes detected, committing and pushing..."
    git add settings.json
    git commit -m "Auto-update: Daily settings sync"

    if git push; then
        echo "$(date): ✓ Successfully pushed settings to GitHub"
    else
        echo "$(date): ✗ Push failed"
        exit 1
    fi
else
    echo "$(date): No settings changes to commit"
fi
