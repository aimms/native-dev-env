#!/bin/zsh


source ~/.zshrc

pyenv global 3.8.3 && c dev && pyenv global dev
pip3 install wheel
pip3 install cmake
pip3 install conan
pip3 install ninja
pip3 install sty

c az && pip3 install azure-cli

curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/bin/kubectl && \
    echo "kubectl version: $(kubectl version --client)"


cat << 'EOF' >> ~/.zshrc

alias k=kubectl
source <(kubectl completion zsh)

function info_for_app() {
  # https://stackoverflow.com/questions/1251999/how-can-i-replace-a-newline-n-using-sed
  # https://www.cyberciti.biz/faq/using-sed-to-delete-empty-lines/
  if [ -e $2 ]; then
    local ver_arg="--version"
  else
    local ver_arg=$2
  fi
  local ver=$($1 ${ver_arg} 2>&1 | sed -r '/^\s*$/d' | sed ':a;N;$!ba;s/\n/\n - /g')
  echo "$fg[red] $1:\n  $fg[grey] -${ver}"
}
info() {
  python3 ~/.logo.py

  echo " $fg[red]OS: $fg[grey]`uname -a`"
  a dev
  echo "$fg[blue]Welcome to $fg[red]AIMMS $fg[blue]development environment. Tools installed:"
  info_for_app curl
  echo " $fg[red]vim:\n  $fg[grey] `vim --version | head -1 | cut -d ' ' -f 5`"
  info_for_app git
  info_for_app tmux -V
  info_for_app zsh
  info_for_app clang
  info_for_app rustc
  info_for_app pyenv
  info_for_app cmake
  info_for_app conan
  info_for_app ninja
  #  a az && info_for_app az && a dev
  a az
  echo " $fg[red]az:\n  $fg[grey] `az --version 2>&1  | head -n 1`"
  a dev

  echo "Alias Information:\n"

  echo "$fg[red]vi-zshrc:$fg[blue] vi ~/.zshrc "
  echo "$fg[red]src-zshrc:$fg[blue] source ~/.zshrc "
  echo "$fg[red]vi-zshrc:$fg[blue] vi ~/.zshrc "
  echo "$fg[red]c <env>:$fg[blue] creates and activates new virtualenv with the name <env>"
  echo "$fg[red]a <env>:$fg[blue] activates virtualenv with the name <env>"
  echo "$fg[red]v:$fg[blue] lists installed virtual envs and Python versions$fg[grey]"

  echo "\nTo see this again type 'info'"
}
info
EOF

