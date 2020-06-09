#!/bin/sh
# https://stackoverflow.com/questions/42735121/ffmpeg-continuously-stream-refreshing-image-to-rtmp/42736726#42736726
# output images into a ffmpeg stream
# ffmpeg -f image2 -stream_loop -1  -i ./261 -framerate 1  -f mpegts udp://localhost:909



# injest ffmpeg stream into hls
