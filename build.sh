#!/usr/bin/env bash

main() {
    SCRIPT_DIR="$(dirname "$(realpath "$0")")"
    source "$SCRIPT_DIR/.pkgbase/init"

    if [[ $# == 0 ]]
    then
        source "$SCRIPT_DIR/pkg.conf"
    else
        source $1
    fi

    for PKG in ${PB_PKGS[@]}
    do
        echo "Building $PKG"
        build_pkg "$PKG"
    done
}

main "$@"