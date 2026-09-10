#!/bin/bash
# Watch VS Code extensions directory for auto-sync

EXTENSIONS_DIR="$HOME/.vscode/extensions"
REPO_DIR="$HOME/personalRepos/vscodeUserSettings"
EXTENSIONS_FILE="$REPO_DIR/extensions.txt"

if ! command -v inotifywait &> /dev/null; then
    echo "Error: inotify-tools not installed"
    echo "Install with: dzdo yum install inotify-tools"
    exit 1
fi

echo "Watching for VS Code extension changes..."
echo "  - Extensions: $EXTENSIONS_DIR"
echo "Press Ctrl+C to stop"

# Initial update
cd "$REPO_DIR"
./update-extensions.sh

# Watch for changes in the extensions directory
inotifywait -m -r -e create -e delete -e moved_to -e moved_from "$EXTENSIONS_DIR" |
while read -r directory events filename; do
    echo "Extension change detected: $events $filename"
    sleep 2  # Debounce multiple rapid changes

    cd "$REPO_DIR"
    ./update-extensions.sh

    # Auto-commit and push if there are changes
    if ! git diff --quiet extensions.txt; then
        git add extensions.txt
        git commit -m "Auto-update: Extensions changed"
        echo "Changes committed. Pushing to GitHub..."
        if git push; then
            echo "✓ Successfully pushed to GitHub"
        else
            echo "✗ Push failed - you may need to push manually later"
        fi
    fi
done
