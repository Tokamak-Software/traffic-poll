#!/bin/sh
# https://stackoverflow.com/questions/42735121/ffmpeg-continuously-stream-refreshing-image-to-rtmp/42736726#42736726
# output images into a ffmpeg stream
ffmpeg -f image2 -stream_loop -1  -i ./261 -framerate 1  -f mpegts udp://localhost:909

ffmpeg -f image2 -stream_loop -1  -i ./544 -framerate 1 -c:v h264 -profile:v main -g 48 -keyint_min 48 -hls_time 4 -hls_playlist_type void -hls_segment_filename 544/%03d.ts 544/544.m3u8

ffmpeg -f image2 -stream_loop -1  -i ./1172 -framerate 1  -f mpegts udp://localhost:9099

ffmpeg -i udp://localhost:9099 -f hls -hls_time 4 -hls_playlist_type event stream.m3u


# injest ffmpeg stream into hls
