#!/bin/bash

# --- The Unified Color Utility ---
# Supports Themes: pastel (default), monokai, oldschool
# Modifiers: b: (bold), d: (dim), u: (underline)

CURRENT_THEME="pastel"

color() {
    # 1. No arguments: Show Demo & Usage Guide
    if [ "$#" -eq 0 ]; then
        local sentence="The quick brown fox jumps over the lazy dog."
        local base_keys=(white black red orange yellow green blue purple silver gray cyan magenta pink)

        echo -e "\n$(color white "Theme: $CURRENT_THEME")"
        echo -e "$(color white "----------------------")"

        echo -e "$(color text " ● default"): $sentence"
        echo -e "$(color b:text " ● b:default")  $(color d:text " ● d:default")  $(color u:text " ● u:default")"

        for key in "${base_keys[@]}"; do
            local display_key="$key"
            local tooltip=""
            [[ "$key" == "magenta" || "$key" == "pink" ]] && display_key="pink/magenta"
            [[ "$key" == "white" ]] && tooltip="$(color gray " (white)")"
            [[ "$key" == "black" ]] && tooltip="$(color gray " (black)")"

            echo -e "$(color "$key" " ● $display_key")$tooltip: $(color "$key" "$sentence")"
            echo -ne "$(color "b:$key" " ● b:$key")  $(color "d:$key" " ● d:$key")  $(color "u:$key" " ● u:$key")"
            echo -e "  $(color "b:$key" "d:$key" " ● b:$key on d:$key bg ")"
        done

        color success "SUCCESS" "System check passed"
        color info "INFO" "Logs are rotating"
        color warn "WARN" "High memory usage"
        color danger "DANGER" "Critical kernel panic"
        color dim "DIM" "Background process idling"

        echo -e "\n--- $(color purple "Usage Guide") ---"
        echo -e "$(color yellow "color theme <name>")          # pastel, monokai, oldschool"
        echo -e "$(color yellow "color warn \"Lookout\"")         # Badge only"
        echo -e "$(color yellow "color warn \"Title\" \"Msg\"")     # Badge + Detail Msg"
        echo -e "$(color yellow 'echo -e "... $(color danger \"Careful!\" \"Etc\")\"') # Use single quotes for !"
        echo ""
        return 0
    fi

    # 2. Theme Switcher
    if [ "$1" = "theme" ]; then
        if [[ "$2" =~ ^(pastel|oldschool|monokai)$ ]]; then
            CURRENT_THEME="$2"
            return 0
        fi
        echo -e "\e[31mError:\e[0m Theme '$2' not found."
        return 1
    fi

    # Helper to resolve codes and modifiers
    resolve_code() {
        local input="$1"
        local mods=""
        local base="$input"

        if [[ "$base" == *:* ]]; then
            local mod_part="${base%:*}"
            base="${base#*:}"
            if [[ "$mod_part" == *b* ]] && [[ "$mod_part" == *d* ]]; then
                echo -e "\e[31mError:\e[0m \"$mod_part:$base\" does not go together, pick either bold or dim." >&2
                return 1
            fi
            [[ "$mod_part" == *b* ]] && mods+="1;"
            [[ "$mod_part" == *d* ]] && mods+="2;"
            [[ "$mod_part" == *u* ]] && mods+="4;"
        fi

        [ -z "$base" ] && base="text"

        case "$CURRENT_THEME" in
            "pastel")
                case "$base" in
                    white) code="38;5;255" ;; black) code="38;5;235" ;; red) code="38;5;210" ;;
                    green) code="38;5;120" ;; yellow) code="38;5;229" ;; blue) code="38;5;117" ;;
                    orange) code="38;5;215" ;; pink|magenta) code="38;5;211" ;;
                    purple|violet) code="38;5;183" ;; gray) code="38;5;244" ;;
                    silver) code="38;5;252" ;; cyan) code="38;5;159" ;; text) code="38;5;252" ;;
                    dark_red) code="38;5;124" ;; dark_silver) code="38;5;247" ;; dark_gray) code="38;5;236" ;;
                    success) code="38;5;120;48;5;22" ;;
                    info)    code="38;5;117;48;5;24" ;;
                    warn|warning) code="38;5;229;48;5;130" ;;
                    danger)  code="38;5;210;48;5;52" ;;
                    dim)     code="38;5;252;48;5;235" ;;
                    *) return 1 ;;
                esac
                ;;
            "monokai")
                case "$base" in
                    white) code="38;5;231" ;; black) code="38;5;233" ;; red) code="38;5;197" ;;
                    green) code="38;5;148" ;; yellow) code="38;5;185" ;; blue) code="38;5;81" ;;
                    purple|violet) code="38;5;141" ;; silver) code="38;5;248" ;; gray) code="38;5;242" ;;
                    cyan) code="38;5;81" ;; magenta|pink) code="38;5;197" ;; orange) code="38;5;208" ;;
                    text) code="38;5;252" ;;
                    success) code="38;5;148;48;5;28" ;;
                    info)    code="38;5;81;48;5;25" ;;
                    warn|warning) code="38;5;208;48;5;94" ;;
                    danger)  code="38;5;197;48;5;88" ;;
                    dim)     code="38;5;242;48;5;234" ;;
                    *) return 1 ;;
                esac
                ;;
            "oldschool")
                case "$base" in
                    white) code="38;5;15" ;; black) code="38;5;0" ;; red) code="38;5;9" ;;
                    green) code="38;5;10" ;; yellow) code="38;5;11" ;; blue) code="38;5;12" ;;
                    purple|violet) code="38;5;13" ;; silver) code="38;5;7" ;; gray) code="38;5;8" ;;
                    cyan) code="38;5;14" ;; magenta|pink) code="38;5;13" ;; orange) code="38;5;3" ;;
                    text) code="38;5;15" ;;
                    success) code="38;5;15;48;5;2" ;;
                    info)    code="38;5;15;48;5;4" ;;
                    warn|warning) code="38;5;0;48;5;3" ;;
                    danger)  code="38;5;15;48;5;1" ;;
                    dim)     code="38;5;15;48;5;8" ;;
                    *) return 1 ;;
                esac
                ;;
        esac
        echo "${mods}${code}"
    }

    # 3. Execution Logic
    if [[ "$1" =~ ^(success|info|warn|warning|danger|dim)$ ]]; then
        local icon="" msg_col=""
        case "$1" in
            success) icon="✔ " ; msg_col="green" ;;
            info)    icon="ℹ " ; msg_col="blue" ;;
            warn|warning) icon="⚠ " ; msg_col="orange" ;;
            danger)  icon="⚠ " ; msg_col="red" ;;
            dim)     icon="ℹ " ; msg_col="gray" ;;
        esac

        local full_code=$(resolve_code "$1") || return 1
        local out=""
        if [ "$#" -eq 2 ]; then
            out=$(printf "\e[${full_code}m %s%s \e[0m" "$icon" "$2")
            # If not in a subshell/pipe, add newline
            [[ $- == *i* ]] || [ -t 1 ] && echo -e "$out" || echo -ne "$out"
        elif [ "$#" -eq 3 ]; then
            local badge=$(printf "\e[${full_code}m %s%s \e[0m" "$icon" "$2")
            local details=$(color "$msg_col" "$3")
            out="${badge} ${details}"
            [[ $- == *i* ]] || [ -t 1 ] && echo -e "$out" || echo -ne "$out"
        fi

    elif [ "$#" -eq 2 ]; then
        local fg_seq=$(resolve_code "$1") || return 1
        printf "\e[${fg_seq}m%s\e[0m" "$2"

    elif [ "$#" -eq 3 ]; then
        local fg_seq=$(resolve_code "$1") || return 1
        local bg_seq=$(resolve_code "$2") || return 1
        bg_seq=$(echo "$bg_seq" | sed -E 's/([0-9;]*)38;5;([0-9]+)/\148;5;\2/g')
        printf "\e[${fg_seq};${bg_seq}m %s \e[0m" "$3"
    fi
}

export -f color
