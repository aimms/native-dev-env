# shellcheck disable=SC2034
# Skip the not really helping Ubuntu global compinit
skip_global_compinit=1
typeset -g ZPLG_MOD_DEBUG=1
zinit module build
zpmod source-study

# PROMPT='%(?.%F{green}❯.%F{red}?%?)%f %B%F{240}%1~%f%b %# '
# shellcheck disable=SC2034
#PROMPT='%(?.%F{green}>.%F{red}?%?)%f %B%F{240}%1~%f%b %# ' # overridden by antigen theme

# shellcheck disable=SC1090
source /etc/zsh/devenv_aliases.zsh
source /etc/zsh/devenv_key_bindings.zsh

# A glance at the new for-syntax – load all of the above
# plugins with a single command. For more information see:
# https://zdharma.org/zinit/wiki/For-Syntax/
zinit wait lucid for \
    light-mode  zsh-users/zsh-autosuggestions \
                zdharma/history-search-multi-word \
    light-mode pick"async.zsh" src"pure.zsh" \
                sindresorhus/pure

zinit wait lucid blockf for \
  zsh-users/zsh-completions

zinit wait lucid atload"zicompinit; zicdreplay" blockf for \
  zsh-users/zsh-completions

zinit wait lucid atinit'zicompinit' blockf for \
  zsh-users/zsh-syntax-highlighting

autoload -Uz compinit
compinit

zinit -q cdreplay # -quietly replays all 'compdefs', caught before compinit call
zinit cdlist # look at gathered compdefs

#
## shellcheck disable=SC1090
#source ~/devenv_aliases.zsh
#
## shellcheck disable=SC2086

# shellcheck disable=SC2154
echo "${normal}Type ${bold}'info' ${normal}for the image information."

