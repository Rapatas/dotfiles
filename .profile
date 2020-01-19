# If running bash
[ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"

# My Paths
[ -d "/usr/games"       ] && PATH="/usr/games:$PATH"
[ -d "$HOME/bin"        ] && PATH="$HOME/bin:$PATH"
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"

# Colors!!
export TERM=xterm-256color
