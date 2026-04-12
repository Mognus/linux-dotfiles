#!/bin/bash
# kill any running animation
[ -f /tmp/tux-anim.pid ] && kill "$(cat /tmp/tux-anim.pid)" 2>/dev/null
echo $$ > /tmp/tux-anim.pid

for x in 160 125 90 55 25; do
    eww update tux-x="-${x}px"
    sleep 0.02
done
eww update tux-x="0px"

rm -f /tmp/tux-anim.pid
