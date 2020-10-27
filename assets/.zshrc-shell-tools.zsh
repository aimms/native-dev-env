export FZF_DEFAULT_COMMAND='fd --type f'

# keybindings
# https://wiki.archlinux.org/index.php/Zsh#Key_bindings
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

# shellcheck disable=SC2154
key[Home]=${terminfo[khome]}

key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
# shellcheck disable=SC2154
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

# Zsh rehash automatically
# Tab completion after installation/removal
# http://www.ephexeve.com/2012/10/zsh-rehash-automatically.html
# TRAPUSR1() { rehash}; precmd() { [[ $history[$[ HISTCMD -1 ]] == *(pacman|yaourt)* ]] && killall -USR1 zsh }
# https://bbs.archlinux.org/viewtopic.php?pid=1369287#p1369287
zstyle ':completion:*' rehash true

# Zsh: Smart autocompletion feature?
# http://stackoverflow.com/questions/23404412/zsh-smart-autocompletion-feature
zstyle ':completion:*' matcher-list 'l:|=* r:|=*'

# Search history up and down arrows
# http://superuser.com/questions/585003/searching-through-history-with-up-and-down-arrow-in-zsh
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# shellcheck disable=SC1090
source ~/.antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Load bundles from external repos.

antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting

antigen bundle copybuffer
antigen bundle copyfile
antigen bundle encode64
antigen bundle zsh_reload
antigen bundle fzf
antigen bundle fd
antigen bundle zsh-interactive-cd
antigen bundle tmux
antigen bundle sudo
antigen bundle python
antigen bundle pyenv
antigen bundle pip
antigen bundle history
antigen bundle history-substring-search

antigen theme jackharrisonsherlock/common

antigen apply


bold="$(tput bold)"
normal="$(tput sgr0)"

info_for_app(){
  local name="$1"
  local version_arg="$2"

  if [ -e $version_arg ]; then
    version_arg="--version"
  fi

  # shellcheck disable=SC2046
  echo -e "${bold}$name:${normal}" $("$name" $version_arg | grep -oP  "[0-9]+[a-zA-Z]?\.[0-9]+(?:[\.][0-9]+[a-zA-Z]?){0,4}" | head -n 1)
}

alias_info(){
  echo -e "Alias Information:\n"

  echo -e "${bold}vi-rc:${normal} vi $HOME/.zshrc"
  echo -e "${bold}src:${normal} source $HOME/.zshrc"
  echo -e "${bold}c <env>:${normal} creates and activates new virtualenv with the name <env>"
  echo -e "${bold}a <env>:${normal} activates virtualenv with the name <env>"
  echo -e "${bold}v:${normal} lists installed virtual envs and Python versions\n"
}

main_info() {
  neofetch

  echo -e "${normal}Welcome to ${bold}AIMMS ${normal}development environment. Alias information:\n"
  alias_info
  echo -e "Tools installed:\n"
  info_for_app curl
  info_for_app vim
  info_for_app git
  info_for_app tmux -V
  info_for_app python
  info_for_app pyenv
  info_for_app gcc
}
