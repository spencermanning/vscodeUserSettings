# VS Code User Settings

This repo tracks VS Code user settings and extensions for easy synchronization across machines.

## Setup on a New Machine

1. Clone this repo
2. Create symlink to settings:
   ```bash
   # Linux
   ln -s $(pwd)/settings.json ~/.config/Code/User/settings.json
   
   # Windows (run as Administrator)
   mklink %APPDATA%\Code\User\settings.json %CD%\settings.json
   ```
3. Install all extensions:
   ```bash
   ./install-extensions.sh
   ```

## Settings

The `settings.json` file in this repo is a symlink to the actual VS Code settings file:
- **Linux**: `~/.config/Code/User/settings.json`
- **Windows**: `%APPDATA%\Code\User\settings.json`

Any changes made in VS Code are automatically reflected in this repo. Simply commit and push to sync.

## Extensions

The `extensions.txt` file lists all installed VS Code extensions.

**Update extensions list after installing new extensions:**
```bash
./update-extensions.sh
git add extensions.txt
git commit -m "Update extensions list"
git push
```

## Other VS Code Locations

**Extensions directory:**
- **Linux**: `~/.vscode/extensions`
- **Windows**: `C:\Users\YourUsername\.vscode\extensions`

**Keybindings:**
- **Linux**: `~/.config/Code/User/keybindings.json`
- **Windows**: `%APPDATA%\Code\User\keybindings.json`

