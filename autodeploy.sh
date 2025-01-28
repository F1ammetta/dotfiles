while true; do
    h=$(adb shell wm size | grep -o "\([0-9]*x[0-9]*\)" | sed "s/.*x//")
    w=$(adb shell wm size | grep -o "\([0-9]*x[0-9]*\)" | sed "s/x.*//")
    adb -s 192.168.240.112:5555 shell input touchscreen tap $((7 * $w / 8)) $((7 * $h / 8))
    sleep 3
done
