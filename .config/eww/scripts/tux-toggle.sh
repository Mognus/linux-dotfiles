#!/bin/bash
if [ "$(eww get tux-visible)" = "true" ]; then
    eww update tux-visible=false
else
    eww update tux-opacity=1
    eww update tux-visible=true
fi
