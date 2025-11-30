#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON_SCRIPT="$SCRIPT_DIR/yanix-launcher.py"
DESKTOP_FILE="$HOME/.local/share/applications/yanix-launcher.desktop"
ICON_PATH="$HOME/.local/share/yanix-launcher/data/yanix.py"

cat > "$DESKTOP_FILE" <<EOL
[Desktop Entry]
Name=Yanix Launcher
Comment=Launch Yanix Launcher
Exec=python3 "$PYTHON_SCRIPT"
Icon=$ICON_PATH
Terminal=false
Type=Application
Categories=Game;
EOL

chmod +x "$DESKTOP_FILE"

echo "Installing system packages..."
if command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y wine winetricks python3-pip || { sudo dnf install -y wine python3-pip; echo "winetricks not found"; }
elif command -v apt >/dev/null 2>&1; then
    sudo apt update
    sudo apt install -y wine winetricks python3-pip || { sudo apt install -y wine python3-pip; echo "winetricks not found"; }
elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -Sy --noconfirm wine winetricks python-pip || { sudo pacman -Sy --noconfirm wine python-pip; echo "winetricks not found"; }
elif command -v zypper >/dev/null 2>&1; then
    sudo zypper install -y wine winetricks python3-pip || { sudo zypper install -y wine python3-pip; echo "winetricks not found"; }
elif command -v rpm >/dev/null 2>&1; then
    echo "Please install wine and pip manually with RPM, winetricks may not be available"
fi

if ! command -v pip3 >/dev/null 2>&1; then
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3
fi

echo "Installing Python packages..."
python3 -m pip install --upgrade pip
python3 -m pip install PyQt6 PyQt6-WebEngine requests pygame

echo "Yanix Launcher installation complete."
