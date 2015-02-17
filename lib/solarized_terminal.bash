#!/usr/bin/env bash
# Install solarized colour scheme for the terminal

set -e

install_solarized_Xresources () {

    local XRESOURCES=~/.Xresources
    local XDEFAULTS=~/.Xdefaults

    for file in "$XRESOURCES" "$XDEFAULTS"; do
        [ -w "$file" ] && cp "$file" "$file.bak" &&
            echo -e "${echo_cyan}Your $(basename $file) has been backed up to $file.bak$echo_normal"
    done

    cp 3rdparty/solarized-xresources/solarized $XRESOURCES && cp $XRESOURCES $XDEFAULTS
}

install_solarized_dark_gnome_terminal () {
    ## TODO: Install solarized gnome settings
    echo 'TODO: Install solarized gnome settings'
}

install_solarized_dark_osx_terminal () {

    ## Grab the Terminal settings profile we want
    local TERMINAL_SETTINGS_DIR="3rdparty/osx-terminal.app-colors-solarized"
    local TERMINAL_SETTINGS_FILE="$TERMINAL_SETTINGS_DIR/Solarized Dark.terminal"
    local TERMINAL_SETTINGS_NAME=$(plutil -p "$TERMINAL_SETTINGS_FILE" | grep name | cut -d'"' -f4)

    ## Make customizations to these Terminal settings
    local TMP_SETTINGS_NAME="$TERMINAL_SETTINGS_NAME Custom"
    local TMP_SETTINGS_FILE="preferences/$TMP_SETTINGS_NAME.terminal"
    cp "$TERMINAL_SETTINGS_FILE" "$TMP_SETTINGS_FILE"
    plutil -replace rowCount -integer 33 "$TMP_SETTINGS_FILE"
    plutil -replace columnCount -integer 115 "$TMP_SETTINGS_FILE"
    plutil -replace Font -data "YnBsaXN0MDDUAQIDBAUGGBlYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKQHCBESVSRudWxs1AkKCwwNDg8QViRjbGFzc1ZOU05hbWVWTlNTaXplWE5TZkZsYWdzgAOAAiNALAAAAAAAABAQVk1vbmFjb9ITFBUWWiRjbGFzc25hbWVYJGNsYXNzZXNWTlNGb250ohUXWE5TT2JqZWN0XxAPTlNLZXllZEFyY2hpdmVy0RobVHJvb3SAAQgRGiMtMjc8QktSWWBpa212eH+Ej5ifoqu9wMUAAAAAAAABAQAAAAAAAAAcAAAAAAAAAAAAAAAAAAAAxw==" "$TMP_SETTINGS_FILE"
    plutil -replace shellExitAction -integer 1 "$TMP_SETTINGS_FILE"

    ## TODO: Check that Solarized is not already installed

    ## Import these customized terminal settings by opening a Terminal with them
    open "$TMP_SETTINGS_FILE"

    ## Close the terminal we used for import by terminating the process (so no confirmation dialog appears)
    osascript <<CLOSETERMINAL
tell application "System Events" to tell process "Terminal"
    keystroke "d" using {control down}
    keystroke return
end tell
CLOSETERMINAL

    ## Use the imported settings as the default and current
    osascript <<SECURESETTINGS
tell application "Terminal"
    set default settings to settings set "$TMP_SETTINGS_NAME"
    set current settings of front window to settings set "$TMP_SETTINGS_NAME"
    activate
end tell
SECURESETTINGS
}
