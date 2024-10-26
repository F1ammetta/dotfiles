#!/bin/zsh


cputemp=$(sensors | grep Tctl | sed 's/Tctl: *+//g' | sed 's/\([0-9]*.[0-9]*\).*/\1/g')
gputemp=$(sensors | grep Composite | sed 's/Composite: *+\(.*\) (low.*/\1/g' | sed 's/\([0-9]*.[0-9]*\).*/\1/g')

if [[ $cputemp -gt 90 ]]; then
  cputemp="%F{red}$cputemp°C%f"
elif [[ $cputemp -gt 70 ]]; then
  cputemp="%F{yellow}$cputemp°C%f"
else
  cputemp="%F{green}$cputemp°C%f"
fi

if [[ $gputemp -gt 80 ]]; then
  gputemp="%F{red}$gputemp°C%f"
elif [[ $gputemp -gt 70 ]]; then
  gputemp="%F{yellow}$gputemp°C%f"
else
  gputemp="%F{green}$gputemp°C%f"
fi

print -P "CPU: $cputemp / GPU: $gputemp"
