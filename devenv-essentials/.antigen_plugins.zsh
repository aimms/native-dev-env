# shellcheck disable=SC1090
source ~/.antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Load bundles from external repos.
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions

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
antigen bundle pip
antigen bundle history
antigen bundle history-substring-search
antigen bundle andydecleyre/zpy

# PROMPT='%(?.%F{green}❯.%F{red}?%?)%f %B%F{240}%1~%f%b %# '
# shellcheck disable=SC2034
PROMPT='%(?.%F{green}>.%F{red}?%?)%f %B%F{240}%1~%f%b %# ' # overridden by antigen theme

# shellcheck disable=SC2086
if [[ ! -e $TERM && "$TERM" == "xterm-256color" ]]; then
  antigen theme jackharrisonsherlock/common
fi

antigen apply
