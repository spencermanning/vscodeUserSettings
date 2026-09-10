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

Any changes made in VS Code are automatically reflected in this repo.

**With daily sync enabled:** Settings are automatically committed and pushed once per day (6 PM) if there are changes.  
**Without daily sync:** Manually commit and push changes as needed.

## Extensions

The `extensions.txt` file lists all installed VS Code extensions.

### Manual Update
```bash
./update-extensions.sh
git add extensions.txt
git commit -m "Update extensions list"
git push
```

### Automatic Update (Optional)

Set up a background watcher that auto-updates `extensions.txt` when extensions change:

**1. Install inotify-tools (requires dzdo):**
```bash
dzdo yum install inotify-tools
```

**2. Option A - Run manually in background:**
```bash
./watch-extensions.sh &
```

**3. Option B - Run as systemd user service (survives reboots):**
```bash
# Install the extension watcher service
mkdir -p ~/.config/systemd/user
cp vscode-extensions-watcher.service ~/.config/systemd/user/

# Enable and start
systemctl --user enable vscode-extensions-watcher.service
systemctl --user start vscode-extensions-watcher.service

# Install the daily settings sync timer
cp vscode-daily-settings-sync.service ~/.config/systemd/user/
cp vscode-daily-settings-sync.timer ~/.config/systemd/user/

# Enable and start the timer
systemctl --user enable vscode-daily-settings-sync.timer
systemctl --user start vscode-daily-settings-sync.timer

# Check status
systemctl --user status vscode-extensions-watcher.service
systemctl --user list-timers  # See when next settings sync will run
```

**Extension watcher:** Automatically commits and pushes when extensions are installed/removed (immediate).

**Settings sync:** Automatically commits and pushes settings changes once per day at 6 PM (if there are any).

## Other VS Code Locations

**Extensions directory:**
- **Linux**: `~/.vscode/extensions`
- **Windows**: `C:\Users\YourUsername\.vscode\extensions`

**Keybindings:**
- **Linux**: `~/.config/Code/User/keybindings.json`
- **Windows**: `%APPDATA%\Code\User\keybindings.json`

