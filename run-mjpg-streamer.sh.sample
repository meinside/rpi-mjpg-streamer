#!/bin/sh
#
# created by : meinside@duck.com
#
# last update: 2018.08.14.
#

################
# customize these:

# mjpg_streamer's install location
# XXX - edit this location to yours!!!
MJPG_STREAMER_DIR="/home/pi/builds/mjpg-streamer"

# mjpg_streamer excutable's location
MJPG_STREAMER_BIN="$MJPG_STREAMER_DIR/bin/mjpg_streamer"

# mjpg_streamer plugins' location
MJPG_STREAMER_PLUGINS_DIR="$MJPG_STREAMER_DIR/lib/mjpg-streamer"

# streaming port
MJPG_STREAMER_PORT="8080"

# htmls and related files' location
MJPG_STREAMER_WWW="$MJPG_STREAMER_DIR/share/mjpg-streamer/www"

# video device
DEVICE_IN="/dev/video0"

# video settings
RESOLUTION="640x480"
FPS=24

# authentication
# XXX - change these values before exposing your Pi to the outer world!!!
USERNAME="pi"
PASSWORD="raspberry"
if [ ! -z $USERNAME ] && [ ! -z $PASSWORD ]; then
	AUTH="-c $USERNAME:$PASSWORD"
else
	AUTH=""
fi

# LED blink
LED="off"	# on/off/blink/auto (may not work on rpi camera modules)

# plugins
PLUGIN_IN="$MJPG_STREAMER_PLUGINS_DIR/input_uvc.so -d $DEVICE_IN -r $RESOLUTION -f $FPS -l $LED"
PLUGIN_OUT="$MJPG_STREAMER_PLUGINS_DIR/output_http.so -p $MJPG_STREAMER_PORT -w $MJPG_STREAMER_WWW $AUTH"



################
# run mjpg_streamer
$MJPG_STREAMER_BIN -i "$PLUGIN_IN" -o "$PLUGIN_OUT"
################

