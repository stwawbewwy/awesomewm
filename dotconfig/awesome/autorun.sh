!/bin/sh

run () {
        if ! pgrep -f "$1"; then
                "$@" &
        fi
}

run "thorium-browser"
run "discord"
