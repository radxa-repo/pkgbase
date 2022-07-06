#!/usr/bin/env bash

main() {
    LC_ALL="C"
    LANG="C"
    LANGUAGE="C"

    SCRIPT_DIR="$(dirname "$(realpath "$0")")"
    source "$SCRIPT_DIR/.pkgbase/init"

    if [[ $# == 0 ]]
    then
        PKG_FILE="$SCRIPT_DIR/pkg.conf"
    else
        PKG_FILE="$(realpath $1)"
    fi

    PKG_DIR=$(dirname "PKG_FILE")
    source $PKG_FILE

    for PKG in ${PB_PKGS[@]}
    do
        echo "Building $PKG"
        build_pkg "$PKG"
    done
}

main "$@"