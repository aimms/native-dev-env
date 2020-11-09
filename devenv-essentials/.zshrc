export PATH="$PATH:$HOME/.local/bin"

# disable heavy zshrc parts
if [ -e $DEVENV_LIGHTWEIGHT ]; then
    # shellcheck disable=SC1090
    source ~/.fzf.zsh
    source ~/.antigen_plugins.zsh
fi

source ~/.key_bindings.zsh

source ~/.devenv_aliases.zsh

# shellcheck disable=SC2086
if [ -e $DEVENV_LIGHTWEIGHT ]; then # declared in devenv-cloud
  # shellcheck disable=SC2154
  echo "${normal}Type ${bold}'info' ${normal}for the image information."
fi
