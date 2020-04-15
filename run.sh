#!/bin/bash

videoUrl="$1"
watermark="/root/watermark.jpg"
textFile="/root/text.txt"
fontFile="/root/simhei.ttf"
filename=$(youtube-dl $videoUrl -f 'best[height<=1080]' --get-filename)

watermark_name="${filename}_watermark.mp4"

echo "Rclone config detected"
echo -e "[DRIVE]\n$RCLONE_CONFIG" > rclone.conf

youtube-dl ${videoUrl} -f 'best[height<=1080]' -v

ffmpeg -i "${filename}" -i "${watermark}" -filter_complex "[0:v][1:v]overlay=main_w-overlay_w-5:main_h-overlay_h-5:enable='lt(mod(t\,60)\,5)',drawtext=fontfile=${fontFile}:textfile=${textFile}:y=10:x=(w-text_w)/2:fontsize=34:fontcolor=yellow@0.5:enable='lt(mod(t\,60)\,5)'" "${watermark_name}"

echo "start Rclone"
rclone -v --config="rclone.conf" copy "${watermark_name}" "DRIVE:$RCLONE_DESTINATION" 2>&1

rm -rf "${filename}"
rm -rf "${watermark_name}"
