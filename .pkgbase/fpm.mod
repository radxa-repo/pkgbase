_PB_INIT_PREFIX="fpm"

fpm_dependency() {
    if ! which ruby >/dev/null
    then
        sudo apt update && sudo apt install -y ruby
    fi
    if ! which fpm >/dev/null
    then
        sudo gem i fpm -f
    fi
}

fpm_prepare() {
    FPM_VERSION=${FPM_VERSION:-"$(cat "$PKG_DIR/VERSION")"}
    FPM_ARCH=${FPM_ARCH:-"all"}
    FPM_URL=${FPM_URL:-"https://github.com/radxa-pkg/$FPM_NAME"}
    FPM_ROOT=${FPM_ROOT:-"./root/"}
    FPM_LICENSE=${FPM_LICENSE:-"GPL-2+"}
    FPM_MAINTAINER=${FPM_MAINTAINER:-"Radxa <dev@radxa.com>"}
    FPM_VENDOR=${FPM_VENDOR:-"Radxa"}
    FPM_INPUT_TYPE=${FPM_INPUT_TYPE:-"dir"}
    FPM_OUTPUT_TYPE=${FPM_OUTPUT_TYPE:-"deb"}
    FPM_PRIORITY=${FPM_PRIORITY:-"extra"}
}

fpm_build() {
    local FPM_MULTI_ARCH
    if [[ "$FPM_ARCH" == "all" ]]
    then
        FPM_MULTI_ARCH=( --deb-field "Multi-Arch: foreign" )
    fi

    local FPM_DEPENDENCY=
    if (( ${#FPM_DEPENDS[@]} != 0 ))
    then
        for i in ${FPM_DEPENDS[@]}
        do
            FPM_DEPENDENCY="$FPM_DEPENDENCY --depends $i"
        done
    fi

    local FPM_INPUT=
    case "$FPM_INPUT_TYPE" in
        dir)
            FPM_INPUT="$FPM_ROOT=/"
            ;;
    esac

    fpm -s "$FPM_INPUT_TYPE" -t "$FPM_OUTPUT_TYPE" \
        -n "$FPM_NAME" -v "$FPM_VERSION" -a "$FPM_ARCH" --url "$FPM_URL" \
		--license "$FPM_LICENSE" -m "$FPM_MAINTAINER" --vendor "$FPM_VENDOR" \
		--description "$FPM_DESCRIPTION" \
        --force --deb-compression xz --deb-priority "$FPM_PRIORITY" \
		$FPM_DEPENDENCY "${FPM_MULTI_ARCH[@]}" \
		$FPM_INPUT
}