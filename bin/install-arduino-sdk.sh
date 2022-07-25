#!/usr/bin/env bash

LINK="https://downloads.arduino.cc/arduino-1.8.19-linux64.tar.xz"
DEST="/tmp/arduino.tar.xz"

if [ -f "${DEST}" ]; then
    echo "Arduino SDK is already downloaded. Unpacking..."
else
    wget "${LINK}" -O "${DEST}"
fi

rm -rf /opt/arduino
tar vxf "${DEST}" -C /opt && ln -s /opt/arduino-1.8.19/ /opt/arduino
