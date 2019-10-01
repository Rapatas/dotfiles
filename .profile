# If running bash
[ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"

# My Paths
[ -d "/usr/games"       ] && PATH="/usr/games:$PATH"
[ -d "$HOME/bin"        ] && PATH="$HOME/bin:$PATH"
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"

# Colors!!
export TERM=xterm-256color

# Map Control to Caps
setxkbmap -layout us -option ctrl:nocaps

# Autostart
if xset q &> /dev/null; then
  autokey-gtk &
  $HOME/bin/settings/mouse/HVTG587_deceleration.sh &
  $HOME/bin/settings/mouse/PixArtMicrosoft_deceleration.sh &
  compton &
  sxhkd &
  tilda &
  ulauncher &
fi

