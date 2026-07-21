
_nix_dev_env_file(){
    test -f flake.nix || return 1
    local h="$( find . -name target -prune -o \( -name '*.nix' -o -name 'flake.lock' \) -exec cat {} + | sha256sum | cut -d' ' -f1)"
    echo ".direnv/flake-cache-$h"
}

build_dev_shell(){
    local d=$(_nix_dev_env_file)
    mkdir -p "$d"
    if ! [ -s "$d/env" ]; then
        nix print-dev-env --profile "$d/gc-root" -Lv > "$d/env"
    fi
    echo "$d/env"
}

dev(){
    source "$(build_dev_shell)"
    _DONT_SPAM_DEV_SHELL="$d"
}

devbg(){
    build_dev_shell &>/dev/null &
}

lazy-dev-shell() {
    local d=$(_nix_dev_env_file) || return 0
    if [ "$_DONT_SPAM_DEV_SHELL" != "$d" ]; then
        if [ -s "$d/env" ]; then
            source  "$d/env" # > /dev/null # ignore welcome messages
        elif [ -s "flake.nix" ]; then
            echo 'run `dev` to build build and enter'
        fi
        _DONT_SPAM_DEV_SHELL="$d"
    fi
}

PROMPT_COMMAND="lazy-dev-shell${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
