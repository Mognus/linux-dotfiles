#!/bin/bash
if pgrep -x wf-recorder > /dev/null; then
    pkill -INT wf-recorder
else
    mkdir -p ~/Videos
    wf-recorder -c libx264 -p crf=27 -f ~/Videos/$(date +%Y-%m-%d_%H-%M-%S).mp4 &
fi
