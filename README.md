# VS Code User Settings

This repo tracks VS Code user settings via symlinks for automatic synchronization.

## Setup

The `settings.json` file in this repo is a symlink to the actual VS Code settings file:
- **Linux**: `~/.config/Code/User/settings.json`
- **Windows**: `%APPDATA%\Code\User\settings.json`

Any changes made in VS Code are automatically reflected in this repo. Simply commit and push to sync.

## Other VS Code Locations

**Extensions:**
- **Linux**: `~/.vscode/extensions`
- **Windows**: `C:\Users\YourUsername\.vscode\extensions`

**Keybindings:**
- **Linux**: `~/.config/Code/User/keybindings.json`
- **Windows**: `%APPDATA%\Code\User\keybindings.json`

