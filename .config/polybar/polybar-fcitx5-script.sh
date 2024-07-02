#!/bin/bash

CAPS_SYMBOL="%{F#c0392b}⇧%{F-}"
IMLIST_FILE="/tmp/fcitx5-imlist"
CAPS_RegEx="Caps Lock:[ ]*([a-z]*)[ ]*"

capslock() {
  if [[ $(xset -q) =~ $CAPS_RegEx ]]; then
    if [[ ${BASH_REMATCH[1]} == "on" ]]; then
      echo "on"
    else
      echo "off"
    fi
  fi
}

# Print out identifier of current input method
current() {
  qdbus org.fcitx.Fcitx /inputmethod GetCurrentIM | sed 's/keyboard-//' | sed 's/fcitx-//' | sed 's/hangul/kr/' | sed 's/mozc/jp/'
}


print_pretty_name() {
  name=$(current)
  if [[ -z "$name" ]]; then
    return
  fi
  if capslock | grep -q "on"; then
    # ${var^^} means uppercase, when CapsLock is on, let the name uppercase
    name="${name^^}${CAPS_SYMBOL}"
  fi
  echo "${name}"
}

react() {
  # Without this, Polybar will display empty
  # string until you switch input method.
  print_pretty_name

  # Track input method changes. Each new line read is an event fired from IM switch
  while true; do
    # When read someting from dbus-monitor
    read -r unused
    print_pretty_name
  done
}

# Need --line-buffered to avoid messages being hold in buffer
# dbus-monitor --session destination=org.freedesktop.IBus | grep --line-buffered '65505\|65509' | react
gdbus monitor --session --dest org.fcitx.Fcitx | grep --line-buffered / | react
