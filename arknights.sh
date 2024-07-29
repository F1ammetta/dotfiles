#!/bin/bash

# Path to your Genymotion emulator
GENYMOTION_PATH="/opt/genymotion"
EMULATOR_NAME="Arknights"
ADB_PATH="/opt/android-sdk/platform-tools"

# Start the Genymotion emulator
$GENYMOTION_PATH/player --vm-name "$EMULATOR_NAME" &

# Wait for the emulator to boot up
sleep 16

genymotion-shell -c "rotation setangle 90"
# Connect to the emulator
$ADB_PATH/adb connect 127.0.0.1:6555

# Start the Arknights app
$ADB_PATH/adb shell monkey -p com.YoStarEN.Arknights -c android.intent.category.LAUNCHER 1
