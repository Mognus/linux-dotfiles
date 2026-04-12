#!/bin/bash
# kill any running animation
[ -f /tmp/tux-anim.pid ] && kill "$(cat /tmp/tux-anim.pid)" 2>/dev/null
echo $$ > /tmp/tux-anim.pid

for x in 25 55 90 125 160 200; do
    eww update tux-x="-${x}px"
    sleep 0.02
done

rm -f /tmp/tux-anim.pid
