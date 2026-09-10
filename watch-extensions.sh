#!/bin/bash
# Watch VS Code extensions directory and settings file for auto-sync

EXTENSIONS_DIR="$HOME/.vscode/extensions"
SETTINGS_FILE="$HOME/.config/Code/User/settings.json"
REPO_DIR="$HOME/personalRepos/vscodeUserSettings"
EXTENSIONS_FILE="$REPO_DIR/extensions.txt"

if ! command -v inotifywait &> /dev/null; then
    echo "Error: inotify-tools not installed"
    echo "Install with: dzdo yum install inotify-tools"
    exit 1
fi

echo "Watching for VS Code changes..."
echo "  - Extensions: $EXTENSIONS_DIR"
echo "  - Settings: $SETTINGS_FILE"
echo "Press Ctrl+C to stop"

# Initial update
cd "$REPO_DIR"
./update-extensions.sh

# Function to commit and push changes
commit_and_push() {
    local message="$1"
    local files="$2"

    cd "$REPO_DIR"
    git add $files

    if ! git diff --cached --quiet; then
        git commit -m "$message"
        echo "Changes committed. Pushing to GitHub..."
        if git push; then
            echo "✓ Successfully pushed to GitHub"
        else
            echo "✗ Push failed - you may need to push manually later"
        fi
    fi
}

# Watch for changes in BOTH extensions directory and settings file
inotifywait -m -r \
    -e create -e delete -e moved_to -e moved_from "$EXTENSIONS_DIR" \
    -e modify -e close_write "$SETTINGS_FILE" |
while read -r directory events filename; do
    echo "Change detected: $events in $directory$filename"
    sleep 2  # Debounce multiple rapid changes

    # Check what changed and act accordingly
    if [[ "$directory$filename" == *"settings.json"* ]]; then
        echo "Settings file changed"
        commit_and_push "Auto-update: Settings changed" "settings.json"
    else
        echo "Extension change detected"
        cd "$REPO_DIR"
        ./update-extensions.sh
        commit_and_push "Auto-update: Extensions changed" "extensions.txt"
    fi
done
