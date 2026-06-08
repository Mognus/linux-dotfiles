#!/bin/bash
# Source for the eww picture-frame widget.
# Reads images from $dir (symlinks allowed), derives title/author from the
# filename (scheme: book-title_Firstname_Lastname.ext) and prints one JSON line
# per interval, consumed by `deflisten` in eww.

# >>> Change the folder here if desired. <<<
dir="$HOME/Pictures/Slideshow"
interval=30                       # seconds per image

shopt -s nullglob nocaseglob

# Turns "der-name-der-rose" -> "Der Name Der Rose" (capitalize every word).
cap_words() {
    local out="" w
    for w in ${1//-/ }; do
        out+="${w^} "
    done
    echo "${out% }"
}

# JSON string escaping for backslash and double quotes.
json_escape() {
    local s=${1//\\/\\\\}
    echo "${s//\"/\\\"}"
}

emit() {
    printf '{"image":"%s","title":"%s","author":"%s"}\n' \
        "$(json_escape "$1")" "$(json_escape "$2")" "$(json_escape "$3")"
}

i=0
while true; do
    # Re-scan every cycle so freshly symlinked images show up without an
    # eww restart.
    files=("$dir"/*.{jpg,jpeg,png,gif,webp,bmp})

    if (( ${#files[@]} == 0 )); then
        emit "" "Keine Bilder" "Lege welche in $dir"
        sleep "$interval"
        continue
    fi

    (( i >= ${#files[@]} )) && i=0
    file="${files[$i]}"
    ((i++))

    name=$(basename "$file")
    name=${name%.*}                       # strip file extension
    IFS='_' read -r raw_title raw_first raw_last <<< "$name"

    title=$(cap_words "$raw_title")
    author=$(cap_words "${raw_first} ${raw_last}")

    emit "$file" "$title" "$author"
    sleep "$interval"
done
