
CAPS_RegEx="Caps Lock:[ ]*([a-z]*)[ ]*"

if [[ $(xset -q) =~ $CAPS_RegEx ]]; then
  if [[ ${BASH_REMATCH[1]} == "on" ]]; then
     echo "on"
  else
     echo "off"
  fi
fi
