#!/bin/sh
# ~/.xinitrc
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

LANG="en_GB.UTF-8"

[[ -f ~/.Xdefaults ]] && xrdb -merge ~/.Xdefaults

if [[ `uname -n` == "mikepjb-laptop" ]]; then
  xrdb -merge ~/.Xdefaults_acer
fi

xmodmap ~/.Xmodmap

xset r rate 200 25
exec startfluxbox
