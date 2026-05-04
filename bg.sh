#!/bin/bash

# --- The Unified BG Color Utility ---
# For use with dark terminal.
#
# @usage:
# bg            (pick random color)
# bg off|reset  (turn off)
# bg red        (red BG)

# Persistent variable to track the last used color
LAST_BG_COLOR=""

bg() {
    # Define the mapping of names to "super dark" hex codes
    declare -A colors
    colors=(
        ["white"]="#1a1a1a"   ["black"]="#000000"  ["red"]="#1a0000"
        ["green"]="#001a00"   ["yellow"]="#1a1a00" ["blue"]="#00001a"
        ["purple"]="#15001a"  ["violet"]="#15001a" ["silver"]="#121212"
        ["gray"]="#0f0f0f"    ["cyan"]="#001a1a"   ["magenta"]="#1a001a"
        ["pink"]="#1a001a"    ["orange"]="#1a0a00" ["teal"]="#001515"
        ["olive"]="#101000"   ["moon"]="#0a0a10"   ["forest"]="#001000"
        ["sea"]="#000510"     ["onyx"]="#050505"
    )

    # 1. Reset/Off Logic
    if [[ "$1" == "off" ]] || [[ "$1" == "reset" ]]; then
        printf "\e]111\e\\"
        LAST_BG_COLOR=""
        return 0
    fi

    # 2. Random Logic
    if [[ -z "$1" ]]; then
        # Create a pool for random selection (excluding black, onyx, and white)
        local pool=()
        for key in "${!colors[@]}"; do
            if [[ "$key" != "black" && "$key" != "onyx" && "$key" != "white" ]]; then
                # Ensure we don't pick the same color as the last one
                if [[ "${colors[$key]}" != "$LAST_BG_COLOR" ]]; then
                    pool+=("$key")
                fi
            fi
        done

        local random_key=${pool[$RANDOM % ${#pool[@]}]}
        local random_code=${colors[$random_key]}

        printf "\e]11;%s\e\\" "$random_code"
        LAST_BG_COLOR="$random_code"
        echo "Random Dark Mood: $random_key"
        return 0
    fi

    # 3. Specific Named Color Logic
    local input=$(echo "$1" | tr '[:upper:]' '[:lower:]')

    if [[ -n "${colors[$input]}" ]]; then
        printf "\e]11;%s\e\\" "${colors[$input]}"
        LAST_BG_COLOR="${colors[$input]}"
    else
        echo "Unknown color. Try: bg, bg off, or bg [colorname]"
        return 1
    fi
}
