#!/bin/sh

ctags -f "$HOME/.vim/tags/system" --tag-relative=no /usr/include
ctags -f "$HOME/.vim/tags/qt5" --tag-relative=no /opt/Qt5.7.1/5.7/gcc_64/include/
