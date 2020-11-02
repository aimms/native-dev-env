#init

# shellcheck disable=SC1090
source <(antibody init)

antibody bundle "
  zsh-users/zsh-syntax-highlighting
  zsh-users/zsh-completions
  zsh-users/zsh-autosuggestions
"

antibody bundle robbyrussell/oh-my-zsh

# shellcheck disable=SC2155
export ZSH=$(antibody path robbyrussell/oh-my-zsh)

antibody bundle "
  robbyrussell/oh-my-zsh path:plugins/copybuffer
  robbyrussell/oh-my-zsh path:plugins/copyfile
  robbyrussell/oh-my-zsh path:plugins/encode64
  robbyrussell/oh-my-zsh path:plugins/zsh_reload
  robbyrussell/oh-my-zsh path:plugins/fzf
  robbyrussell/oh-my-zsh path:plugins/fd
  robbyrussell/oh-my-zsh path:plugins/zsh-interactive-cd
  robbyrussell/oh-my-zsh path:plugins/tmux
  robbyrussell/oh-my-zsh path:plugins/sudo
  robbyrussell/oh-my-zsh path:plugins/python
  robbyrussell/oh-my-zsh path:plugins/pip
  robbyrussell/oh-my-zsh path:plugins/history
  robbyrussell/oh-my-zsh path:plugins/history-substring-search
"


# PROMPT='%(?.%F{green}❯.%F{red}?%?)%f %B%F{240}%1~%f%b %# '
# shellcheck disable=SC2034
PROMPT='%(?.%F{green}>.%F{red}?%?)%f %B%F{240}%1~%f%b %# ' # overridden by antigen theme

# shellcheck disable=SC2086
if [[ ! -e $TERM && "$TERM" == "xterm-256color" ]]; then
    antibody bundle jackharrisonsherlock/common
fi

antigen apply