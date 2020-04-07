#!/bin/bash

# | Class          | Command              |
# | ---            | ---                  |
# | Opera          | opera                |
# | Google-chrome  | google-chrome-stable |
# | Firefox        | firefox              |
# | Xfce4-terminal | xfce4-terminal       |
# | Discord        | /snap/bin/discord    |
# | Slack          | slack                |
# | Skype          | skypeforlinux        |
# | Spotify        | spotify              |

if [ "$#" != 2 ]; then
  echo "Usage: ./launcher.sh win_class prog_exec"
  exit 1
fi

PROG_CLASS=$1
PROG_EXEC=$2

# If no windows exist, launch the program and stop.
exists_str=$(xdotool search --class $PROG_CLASS)
if [[ -z "${exists_str// }" ]]; then
  $PROG_EXEC &
  exit 0
fi

# If focused window is in the list we got earlier, minimize it.
found_it=false
focus=$(xdotool getwindowfocus)
mapfile -t exists <<< "$exists_str"
for i in "${exists[@]}"; do
  if [ "$i" == "$focus"  ]; then
    found_it=true
  fi
done

# Minimize active window.
if $found_it; then
  xdotool search --class $PROG_CLASS \
    | xargs -I % sh -c 'echo minimizing %; xdotool windowminimize %'
  exit 0
fi

# Bring window to focus.
mapfile -t allofthem <<< "$exists_str"
for id in "${allofthem[@]}"; do
  [ -z $(xdotool windowactivate $id 2&>1) ] && true || exit 0
done

exit 1
