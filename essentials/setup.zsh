#!/bin/zsh

mv ~/.zshrc ~/.zshrc.oh-my-zsh

cat << 'EOF' >> ~/.zshrc

export PROMPT='%m:%1~ %n%# ' # overwritten by oh-my-zsh

if [[ ${ENABLE_OH_MY_ZSH} == "YES" ]]; then
  source ~/.zshrc.oh-my-zsh

  # zsh plugins
  plugins=(
    git
    cargo
    rust
    rustup
    encode64
    gitignore
    kubectl
    pip
    pyenv
    terraform
    tmux
  )

  # oh-my-zsh theme
  ZSH_THEME="avit"
fi
EOF


