#!/bin/bash
# Watch VS Code extensions directory and auto-update extensions.txt

EXTENSIONS_DIR="$HOME/.vscode/extensions"
REPO_DIR="$HOME/personalRepos/vscodeUserSettings"
EXTENSIONS_FILE="$REPO_DIR/extensions.txt"

if ! command -v inotifywait &> /dev/null; then
    echo "Error: inotify-tools not installed"
    echo "Install with: sudo yum install inotify-tools"
    exit 1
fi

echo "Watching for VS Code extension changes..."
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

    # Auto-commit if there are changes
    if ! git diff --quiet extensions.txt; then
        git add extensions.txt
        git commit -m "Auto-update: Extensions changed"
        echo "Changes committed. Run 'git push' to sync."
    fi
done
