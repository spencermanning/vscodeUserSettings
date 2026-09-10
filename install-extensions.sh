#!/bin/bash
# Install all VS Code extensions from extensions.txt

while IFS= read -r extension; do
    echo "Installing $extension..."
    code --install-extension "$extension"
done < extensions.txt

echo "All extensions installed!"
