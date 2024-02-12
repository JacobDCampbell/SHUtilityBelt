#!/usr/bin/env bash


# exportLibFunctions is a bit hacky but it will comb through library files for non-indented
# functions and export them for use by child scripts
exportLibFunctions() {
    libPath="$1"
    while read -r fnc; do
        export -f $fnc
    done < <(grep -o "^[[:alnum:]_]\+(" "$libPath" | tr -d "(")
}

