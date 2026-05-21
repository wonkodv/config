# Requires: nix-locate (from nix-index)

if command -v nix-locate >/dev/null 2>&1; then

update_nix_db() {
    mkdir -p ~/.cache/nix-index
    curl -L --progress-bar \
        -o ~/.cache/nix-index/files \
        "https://github.com/nix-community/nix-index-database/releases/latest/download/index-$(
            nix eval --impure --raw --expr builtins.currentSystem
        )"
    }

_CNF_FILE=~/tmp/.command-not-found

command_not_found_handle() {
    printf '%q ' "$@" > "$_CNF_FILE"
    echo "bash: $1: command not found, try 'argh'" >&2
    return 127
}

argh() {
    [ -s "$_CNF_FILE" ] || { echo "no recent missing command" >&2; return 2; }
    local cmdline cmd _rest
    cmdline=$(cat "$_CNF_FILE")
    read -r cmd _rest <<<"$cmdline"

    local pkg
    pkg=$(nix-locate --minimal --at-root --whole-name "/bin/$cmd" 2>/dev/null | head -n1)
    [ -z "$pkg" ] && { echo "no nixpkgs package provides /bin/$cmd" >&2; return 1; }

    read -r -p "install nixpkgs#$pkg and run '$cmdline'? [Y/n] " ans
    case $ans in n|N|no|NO) return 1 ;; esac

    local out
    out=$(nix build --no-link --print-out-paths "nixpkgs#$pkg") || return
    export PATH=$PATH:$out/bin
    eval "$cmdline"
}
fi
