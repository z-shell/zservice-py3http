#
# A z-service file that runs python3 module http.server to serve a directory.
#
# Use with plugin manager that supports single plugin load per all active Zsh
# sessions. The p-m should set parameters ZSRV_WORK_DIR and ZSRV_ID.
#
# You should copy `py3http.conf.default' to `py3http.conf' and adapt it to your
# needs. The service will use the `*.default' file if there is no `*.conf' file.
#

0="${${ZERO:-${(M)0##/*}}:-${(%):-%N}}"  # try ZERO, filter absolute path from $0, fallback to %N

(( ! ${+ZSRV_WORK_DIR} || ! ${+ZSRV_ID} )) && { print "Error: plugin \`zservices/py3http' needs to be loaded as service, aborting."; return 1; }

typeset -g ZSRV_DIR="${0:h}"
typeset -g ZSRV_PID

local pidfile="$ZSRV_WORK_DIR"/"$ZSRV_ID".pid logfile="$ZSRV_WORK_DIR"/"$ZSRV_ID".log
local cfg="${ZSRV_DIR}/py3http.conf"
[[ ! -f "$cfg" ]] && cfg="${ZSRV_DIR}/py3http.conf.default"

if [[ -f "$cfg" ]]; then
    { local pid="$(<$pidfile)"; } 2>/dev/null
    if [[ ${+commands[pkill]} = 1 && "$pid" = <-> && $pid -gt 0 ]]; then
        if command pkill -HUP -f -F "$pidfile" py3http.py; then
            builtin print "ZSERVICE: Stopped previous py3http.py instance, PID: $pid" >>! "$logfile"
            LANG=C sleep 1.5
        else
            builtin print "ZSERVICE: Previous py3http.py instance (PID:$pid) not running" >>! "$logfile"
        fi
    fi

    builtin cd "$ZSRV_DIR"
    builtin trap 'kill -HUP $ZSRV_PID; command sleep 2; builtin exit 1' HUP
    "$ZSRV_DIR"/py3http.py "$cfg" >>!"$logfile" 2>&1 &; ZSRV_PID=$!
    builtin echo "$ZSRV_PID" >! "$pidfile"
    LANG=C command sleep 0.7
    builtin return 0
else
    builtin print "ZSERVICE: No py3http.conf found, py3http.py did not run" >>! "$logfile"
    builtin return 1
fi
