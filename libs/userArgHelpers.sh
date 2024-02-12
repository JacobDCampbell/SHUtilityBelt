#!/usr/bin/env bash

export userArg_DEFAULTTARGETFUNCNAME="parseUserArgs"

userArg_getValFromArg() {
    # TODO: Add logic for space delimited values (e.g. --foo bar) in addition to '=' delimited args
    echo "$1" | cut -d= -f2-
}

userArg_printArgMetadata() {
    line="$1"
    INDENT=""
    if echo "$line" | grep -q "DESC"; then
        INDENT="  "
    fi

    output_line=$(echo $line | cut -f2- -d\= | cut -c2- | rev | cut -c3- | rev | sed -e 's/\([\-\|\<\>]\)/\\\1/g')
    eval "echo \"$INDENT\"$output_line"
}

userArg_printHelpDialog() {
    TARGETFUNCNAME="$1"
    if [ -z "$TARGETFUNCNAME" ]; then
        TARGETFUNCNAME="$userArg_DEFAULTTARGETFUNCNAME"
    fi

    lines=$(type $TARGETFUNCNAME 2>/dev/null)

    echo "Commands:"
    echo "$lines" | while read -r line ; do
        # Argument Keys
        if echo "$line" | grep -qi "^__CMD__="; then
            userArg_printArgMetadata "$line"
        fi

        # Argument Descriptions
        if echo "$line" | grep -qi "^__CMD_DESC__="; then
            userArg_printArgMetadata "$line"
        fi
    done

    echo ""

    echo "Arguments:"
    echo "$lines" | while read -r line ; do
        # Argument Keys
        if echo "$line" | grep -qi "^__ARG__="; then
            userArg_printArgMetadata "$line"
        fi

        # Argument Descriptions
        if echo "$line" | grep -qi "^__DESC__="; then
            userArg_printArgMetadata "$line"
        fi
    done
}

