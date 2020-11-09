export PATH="$PATH:$HOME/.local/bin"

# disable heavy zshrc parts
if [ -e $DEVENV_LIGHTWEIGHT ]; then
    # shellcheck disable=SC1090
    source ~/.fzf.zsh
    source ~/.antigen_plugins.zsh
fi

source ~/.key_bindings.zsh

source ~/.devenv_aliases.zsh
