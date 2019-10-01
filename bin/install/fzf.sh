#!/bin/sh

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# Remap C-t to C-p
sed -i 's/"\\C-t"/"\\C-p"/' ~/.fzf/shell/key-bindings.bash