#!/usr/bin/env bash

export logger_LvlUnset="unset"
export logger_LvlUnsetInt=0
export logger_LvlNone="none"
export logger_LvlNoneInt=0
export logger_LvlCrit="critical"
export logger_LvlCritInt=10
export logger_LvlError="error"
export logger_LvlErrorInt=20
export logger_LvlWarn="warning"
export logger_LvlWarnInt=30
export logger_LvlInfo="info"
export logger_LvlInfoInt=40
export logger_LvlDebug="debug"
export logger_LvlDebugInt=50
export logger_LvlDDebug="ddebug"
export logger_LvlDDebugInt=60

export logger_Lvl=$logger_LvlErrorInt

logger_GetLogLevel() {
    loggger_LevelInt2Str "$logger_Lvl"
}

logger_SetLogLevel() {
    newLvl="$(echo "$1" | tr "[:upper:]" "[:lower:]")"
    lvlInt="$(loggger_LevelStr2Int "$newLvl")"

    if [ $lvlInt -eq $logger_LvlUnsetInt ]; then
        ERROR "Invalid LogLevel: $newLvl"
    else
        logger_Lvl="$lvlInt"
    fi
}

loggger_LevelStr2Int() {
    case "$1" in
    $logger_LvlNone)
        echo "$logger_LvlNoneInt" ;;
    $logger_LvlCrit)
        echo "$logger_LvlCritInt" ;;
    $logger_LvlError)
        echo "$logger_LvlErrorInt" ;;
    $logger_LvlWarn)
        echo "$logger_LvlWarnInt" ;;
    $logger_LvlInfo)
        echo "$logger_LvlInfoInt" ;;
    $logger_LvlDebug)
        echo "$logger_LvlDebugInt" ;;
    $logger_LvlDDebug)
        echo "$logger_LvlDDebugInt" ;;
    *)
        echo $logger_LvlUnsetInt ;;
    esac
}

loggger_LevelInt2Str() {
    case "$1" in
    $logger_LvlNoneInt)
        echo "$logger_LvlNone" ;;
    $logger_LvlCritInt)
        echo "$logger_LvlCrit" ;;
    $logger_LvlErrorInt)
        echo "$logger_LvlError" ;;
    $logger_LvlWarnInt)
        echo "$logger_LvlWarn" ;;
    $logger_LvlInfoInt)
        echo "$logger_LvlInfo" ;;
    $logger_LvlDebugInt)
        echo "$logger_LvlDebug" ;;
    $logger_LvlDDebugInt)
        echo "$logger_LvlDDebug" ;;
    *)
        echo "$logger_LvlUnset" ;;
    esac
}

CRITICAL() {
    if [ $logger_Lvl -le $logger_LvlCritInt ]; then return; fi
    msg="$1"
    tag="[CRITICAL]"
    printf "%s %s\n" "$tag" "$msg"
}

CRIT() {
    CRITICAL "$1"
}

ERROR() {
    if [ $logger_Lvl -le $logger_LvlErrorInt ]; then return; fi
    msg="$1"
    tag="[ERROR   ]"
    printf "%s %s\n" "$tag" "$msg"
}

WARNING() {
    if [ $logger_Lvl -le $logger_LvlWarnInt ]; then return; fi
    msg="$1"
    tag="[WARNING ]"
    printf "%s %s\n" "$tag" "$msg"
}

WARN() {
    WARNING "$1"
}

INFO() {
    if [ $logger_Lvl -le $logger_LvlInfoInt ]; then return; fi
    msg="$1"
    tag="[INFO    ]"
    printf "%s %s\n" "$tag" "$msg"
}

DEBUG() {
    if [ $logger_Lvl -le $logger_LvlDebugInt ]; then return; fi
    msg="$1"
    tag="[DEBUG   ]"
    printf "%s %s\n" "$tag" "$msg"
}

DDEBUG() {
    if [ $logger_Lvl -le $logger_LvlDDebugInt ]; then return; fi
    msg="$1"
    tag="[DDEBUG  ]"
    printf "%s %s\n" "$tag" "$msg"
}

