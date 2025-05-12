#!/bin/bash

mkdir -p "${XDG_CONFIG_HOME}/mpd/playlists"

/app/bin/mpd --no-daemon --stderr /app/etc/mpd.conf &
mpd_pid=$!

/app/bin/cantata

kill -SIGTERM "${mpd_pid}"
