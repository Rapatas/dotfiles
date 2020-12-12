# If running bash
[ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"

# My Paths
[ -d "/usr/games"       ] && PATH="/usr/games:$PATH"
[ -d "$HOME/bin"        ] && PATH="$HOME/bin:$PATH"
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"

# Colors!!
export TERM=xterm-256color

# XDG Base Directory specification.
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# De-clutter the home dir.
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
export LESSHISTFILE="${XDG_CONFIG_HOME}/less/history"
export LESSKEY="${XDG_CONFIG_HOME}/less/keys"
export ICEAUTHORITY=${XDG_CACHE_HOME}/ICEauthority
xrdb -load "$XDG_CONFIG_HOME/X11/xresources"
