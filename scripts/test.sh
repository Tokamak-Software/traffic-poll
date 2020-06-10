#!/bin/sh
CAMERA=$1
./poller -prefix ./data/ -poll 10 $CAMERA

ffmpeg -f image2 -stream_loop -1  -i "/root/data/$CAMERA" -framerate .1  -f mpegts udp://localhost:9099&

ffmpeg -i udp://localhost:9099 -f hls  -hls_playlist_type event /root/stream/stream.m3u
