if [ -d "$HOME/.local/bin" ]
then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.cargo/bin" ]
then
    PATH="$HOME/.cargo/bin:$PATH"
fi

if [ -d "$HOME/bin" ]
then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.nix-profile/bin" ]
then
    PATH="$HOME/.nix-profile/bin:$PATH"
fi

export PATH

export PYTHONPATH="${PYTHONPATH}":$HOME/code
