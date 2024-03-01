#!/usr/bin/env bash

# UtilityBelt is a collection of scripts to simplify common tasks for managing processes. This is a
# very specific collection of tools written for the personal use of the author to use on their
# Linux systems (though if done correctly, should work on most any *nix based system with bash).
# While there are better languages to do this in (Python comes to mind), shell script is the most
# guaranteed to be consistent across multiple systems ... though if being honest it is more likely
# because the author is will sometimes prioritize "can I?" over "should I?".

__AUTHOR__="Jacob Campbell"
__AUTHOR_EMAIL__="JacobDCampbell@gmail.com"

if [ -L "$0" ]; then
    scriptRootDir="$(cd "$(dirname "$(readlink "$0")")" && pwd)"
else
    scriptRootDir="$(cd "$(dirname "$0")" && pwd)"
fi

ingressScriptName="main.sh"
cmdIngress=""
libDirName="libs"
libDirPath="$scriptRootDir/$libDirName"
cmdDirName="commands"
cmdDirPath="$scriptRootDir/$cmdDirName"
cmd=""
cmdArgs=()

source "$libDirPath/exportLibFunctions.sh"
source "$libDirPath/logger.sh"

logLvl="$logger_LvlInfo"
logger_SetLogLevel "$logLvl"

# Load lib files
# TODO: Is there a smarter / more efficient / cleaner way to load libraries?
while read -r libPath; do
    if [ -f "$libPath" ]; then
        # TODO: Add error capturing
        DDEBUG "Loading Lib: $libPath"
        source "$libPath"
        exportLibFunctions "$libPath"
    fi
done < <(ls -1 "$libDirPath/"*)

main() {
    parseUserArgs "$@"

    logger_SetLogLevel "$logLvl"

    preflightChecks

    "$cmdIngress" "${cmdArgs[@]}"
}

# TODO: Can this be converted into a parameterized method to reduce redundancies and simplify utilization?
parseUserArgs() {
    # First positional arg is the utility belt command to run
    if echo "$1" | grep -vq "^-"; then
        __CMD__="dirtree"
        __CMD_DESC__="Prints an ASCII representation of a directory tree."
        cmd="$1"
        shift
    fi

    while [ -n "$1" ]; do
        case "$1" in
        --help)
            __ARG__='--help'
            __DESC__='Displays this help dialog and exits.'
            if [ -z "$cmd" ]; then
                userArg_printHelpDialog
                exit 0
            fi
            cmdArgs+=("$1")
            ;;
        --log-level=*)
            __ARG__='--log-level=<LEVEL>'
            __DESC__='Sets the log level.'
            __DESC__='Default: $logLvl'
            logLvl="$(userArg_getValFromArg "$1")"
            ;;
        *)
            cmdArgs+=("$1")
            shift
            ;;
        esac
        shift
    done
}

preflightChecks() {
    checkFailed() {
        CRITICAL "$1"
        userArg_printHelpDialog
        exit 1
    }

    cmdDirPath="$cmdDirPath/$cmd"
    cmdIngress="$cmdDirPath/$ingressScriptName"

    if [ -z "$cmd" ]; then checkFailed "Missing required command"; fi
    if [ ! -d "$cmdDirPath" ]; then checkFailed "Invalid command: $cmd"; fi
    if [ ! -f "$cmdIngress" ]; then checkFailed "Missing expected command script: $cmdIngress"; fi
}

main "$@"

