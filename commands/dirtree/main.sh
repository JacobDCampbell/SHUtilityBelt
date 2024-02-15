#!/usr/bin/env bash

# Command Globals
subCmd=""
subCmdArgs=()

dirPath="$(pwd)"
showSymlinkTarget="false"
showHidden="false"

findCmdArgs="-maxdepth 1"
indent="  "

tChar="├"
lChar="└"
xChar="─"
yChar="│"

main() {
    DEBUG "Running Command: dirtree"

    parseUserArgs "$@"

    DEBUG "Parameters:"
    DEBUG "  --dir ............... $dirPath"
    DEBUG "  --symlink-targets ... $showSymlinkTarget"
    DEBUG "  --hidden ............ $showHidden"

    runCmd
}

parseUserArgs() {
    # First positional arg is the utility belt command to run
    while [ -n "$1" ]; do
        case "$1" in
        --help)
            __ARG__='--help'
            __DESC__='Displays this help dialog and exits.'
            if [ -z "$subCmd" ]; then
                userArg_printHelpDialog
                exit 0
            else
                subCmdArgs+=("$1")
            fi
            ;;
        --dir=*|-d=*)
            __ARG__='--dir | -d <DIR PATH>'
            __DESC__='Directory to create tree for.'
            __DESC__='Defaults to the current working directory'
            dirPath="$(userArg_getValFromArg "$1")"
            ;;
        --symlink-targets|-s)
            __ARG__='--symlink-targets | -s '
            __DESC__='Toggles inclusion of Symlink targets to the directory tree.'
            __DESC__='Note: Symlink target is not expanded and ony the path '
            showSymlinkTarget="true"
            ;;
        --hidden|-h)
            __ARG__='--hidden | -h '
            __DESC__='Toggles inclusion of if hidden files / folders to the directory tree.'
            showHidden="true"
            ;;
        *)
            subCmdArgs+=("$1")
            shift
            ;;
        esac
        shift
    done
}

runCmd() {
    if [ "$showHidden" != "true" ]; then findCmdArgs="$findCmdArgs -not -name '.*'"; fi

    echo "$(basename "$dirPath")/"

    recursiveTreeBranch "$dirPath"
}

recursiveTreeBranch() {
    local dirPath="$1"
    local prefix="$2"

    cmd="find \"$dirPath\" $findCmdArgs -not -wholename '$dirPath' -exec basename {} \; |  sort -fV"
    local entries="$(eval "$cmd")"
    local count="$(echo "$entries" | wc -l)"
    local i=1
    while read -r ent; do
        if [ -z "$ent" ]; then continue; fi
        entPath="$dirPath/$ent"

        if [ $count -eq $i ]; then
            key="$lChar$xChar "
            nextPrefix="$prefix$indent "
        else
            key="$tChar$xChar "
            nextPrefix="$prefix$yChar$indent"
        fi

        if [ -L "$entPath" ] && [ "$showSymlinkTarget" == "true" ]; then
            entDest="$(readlink "$entPath")"
            echo "$prefix$key$ent -> $entDest"
        elif [ -d "$entPath" ]; then
            echo "$prefix$key$ent/"
            recursiveTreeBranch "$entPath" "$nextPrefix"
        elif [ -f "$entPath" ]; then
            echo "$prefix$key$ent"
        fi

        i=$(expr $i + 1)
    done < <(echo "${entries[@]}")
}

main "$@"

