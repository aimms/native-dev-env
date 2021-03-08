# Skip the not really helping Ubuntu global compinit
# shellcheck disable=SC2034
skip_global_compinit=1

# shellcheck disable=SC1090
source ${ZDOTDIR}/devenv_aliases.zsh
source ${ZDOTDIR}/devenv_key_bindings.zsh


# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

# PROMPT='%(?.%F{green}❯.%F{red}?%?)%f %B%F{240}%1~%f%b %# '
# shellcheck disable=SC2034
#PROMPT='%(?.%F{green}>.%F{red}?%?)%f %B%F{240}%1~%f%b %# ' # overridden by antigen theme

# shellcheck disable=SC1090
zinit snippet OMZP::kubectl

# Load the pure theme, with zsh-async library that's bundled with it.
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

zinit wait lucid for \
    zsh-users/zsh-autosuggestions \
    zdharma/history-search-multi-word

zinit wait lucid atload"zicompinit; zicdreplay" blockf for \
  zsh-users/zsh-completions

zinit wait lucid atinit'zicompinit' blockf for \
  zsh-users/zsh-syntax-highlighting

autoload -Uz compinit
compinit

zinit cdreplay -q # -quietly replays all 'compdefs', caught before compinit call
zinit cdlist # look at gathered compdefs

# shellcheck disable=SC2154
if [ -e $DEVENV_LIGHTWEIGHT  ]; then
  echo "${normal}Type ${bold}'info' ${normal}for the image information."
fi
