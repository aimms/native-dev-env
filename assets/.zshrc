antigen $HOME/.oh-my-zsh/antigen.zsh

antigen use oh-my-zsh

antigen bundle git
antigen bundle gitignore
antigen bundle pip
antigen bundle pyenv
antigen bundle encode64
antigen bundle colorize
antigen bundle github
antigen bundle kubectl
antigen bundle terraform
antigen bundle tmux
antigen apply

# Bind keys to jump words
bindkey -e
bindkey "[D" backward-word
bindkey "[C" forward-word
bindkey '^[[1;9C' forward-word
bindkey '^[[1;9D' backward-word