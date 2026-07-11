#!/usr/bin/env bash
# Rofi submenu: pick a screen, then pick its orientation. Only that screen's
# transform changes; the other screen is left as-is. Updates monitors.conf
# and, for any touchscreen bound to that output in input.conf, its transform
# too, then does one hyprctl reload so display and touch stay in sync.

LEFT="HDMI-A-2"    # sits at 0x0
RIGHT="HDMI-A-1"   # sits to the right of LEFT
MON_CONF="$HOME/.config/hypr/monitors.conf"
INPUT_CONF="$HOME/.config/hypr/input.conf"
RES_W=1024
RES_H=600

get_transform() {
    grep "^monitor = $1," "$MON_CONF" | grep -oP '(?<=transform, )\d+'
}

# updates transform inside whichever `device { ... }` block in input.conf
# has `output = <target>` (a no-op if that output has no touch device yet)
sync_touch_transform() {
    local target="$1" newt="$2"
    awk -v target="$target" -v newt="$newt" '
        /^device[ \t]*\{/ { in_block=1; matched=0; block=$0"\n"; next }
        in_block && /^\}/ {
            block = block $0 "\n"
            if (matched) gsub(/transform = [0-9]+/, "transform = " newt, block)
            printf "%s", block
            in_block = 0
            next
        }
        in_block {
            block = block $0 "\n"
            if ($0 ~ ("output = " target)) matched = 1
            next
        }
        { print }
    ' "$INPUT_CONF" > "$INPUT_CONF.tmp" && mv "$INPUT_CONF.tmp" "$INPUT_CONF"
}

# a transform of 1 or 3 (90°/270°) swaps width and height
effective_width() {
    if (( $1 % 2 == 1 )); then
        echo "$RES_H"
    else
        echo "$RES_W"
    fi
}

SCREEN_CHOICE=$(printf 'Left Screen\nRight Screen\n' | rofi -dmenu -i -p "Which Display?")
[ -z "$SCREEN_CHOICE" ] && exit 0

case "$SCREEN_CHOICE" in
    "Left Screen")  TARGET="$LEFT" ;;
    "Right Screen") TARGET="$RIGHT" ;;
    *) exit 1 ;;
esac

LABELS=("Normal" "Portrait")
VALUES=(0 3)

ORIENT_CHOICE=$(printf '%s\n' "${LABELS[@]}" | rofi -dmenu -i -p "Orientation: $SCREEN_CHOICE")
[ -z "$ORIENT_CHOICE" ] && exit 0

NEW_T=""
for i in "${!LABELS[@]}"; do
    [ "${LABELS[$i]}" = "$ORIENT_CHOICE" ] && NEW_T="${VALUES[$i]}"
done
[ -z "$NEW_T" ] && exit 1

if [ "$TARGET" = "$LEFT" ]; then
    LEFT_T="$NEW_T"
    RIGHT_T="$(get_transform "$RIGHT")"
else
    RIGHT_T="$NEW_T"
    LEFT_T="$(get_transform "$LEFT")"
fi

[ -z "$LEFT_T" ] && LEFT_T=0
[ -z "$RIGHT_T" ] && RIGHT_T=0

LEFT_W=$(effective_width "$LEFT_T")

sed -i \
    -e "s|^monitor = $LEFT,.*|monitor = $LEFT, preferred, 0x0, 1, transform, $LEFT_T|" \
    -e "s|^monitor = $RIGHT,.*|monitor = $RIGHT, preferred, ${LEFT_W}x0, 1, transform, $RIGHT_T|" \
    "$MON_CONF"

sync_touch_transform "$LEFT" "$LEFT_T"
sync_touch_transform "$RIGHT" "$RIGHT_T"

hyprctl reload

notify-send "Display Orientation" "$SCREEN_CHOICE set to $ORIENT_CHOICE"
