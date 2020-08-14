#!/bin/zsh

source ~/.zshrc

pyenv global ${PYTHON_VERSION} && c az && pyenv global az
pip install azure-cli
pip install jmespath
pip install typed-argument-parser
pip install sty

curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/bin/kubectl && \
    echo "kubectl version: $(kubectl version --client)"

pushd /usr/bin
tf_version=0.12.28
terraform_zip=terraform_${tf_version}_linux_amd64.zip
curl -LO https://releases.hashicorp.com/terraform/${tf_version}/${terraform_zip}
unzip ${terraform_zip}
rm -f ${terraform_zip}
popd

cat << 'EOF' >> ~/.zshrc

alias k=kubectl
source <(kubectl completion zsh)

if [[ "${ENABLE_OH_MY_ZSH}" == "YES" ]]; then
    color_red="$fg[red]"
    color_blue="$fg[blue]"
fi

function info_for_app() {
  # https://stackoverflow.com/questions/1251999/how-can-i-replace-a-newline-n-using-sed
  # https://www.cyberciti.biz/faq/using-sed-to-delete-empty-lines/
  if [ -e $2 ]; then
    local ver_arg="--version"
  else
    local ver_arg=$2
  fi

  local ver=$($1 ${ver_arg} 2>&1 | sed -r '/^\s*$/d' | sed ':a;N;$!ba;s/\n/\n   /g')
  echo "${color_red} $1:\n  ${color_blue} ${ver}"
}

cloud_info() {
  if [[ "${ENABLE_OH_MY_ZSH}" == "YES" ]]; then
    python3 ~/.logo.py
  fi

  echo " ${color_red}OS: ${color_blue}`uname -a`"
  echo "${color_blue}Welcome to ${color_red}AIMMS ${color_blue}development environment. Tools installed:"
  info_for_app curl
  echo " ${color_red}vim:\n  ${color_blue} `vim --version | head -1`"
  echo " ${color_red}rsync:\n  ${color_blue} `rsync --version | head -1`"
  info_for_app git
  info_for_app tmux -V
  info_for_app ssh -V
  info_for_app zsh
  info_for_app clang
  info_for_app rustc
  info_for_app pyenv
  echo " ${color_red}az:\n  ${color_blue} type 'a az && az --version' for version information"
  info_for_app terraform
}

alias_info() {
  echo "\nAlias Information:\n"

  echo "${color_red}vi-zshrc:${color_blue} vi ~/.zshrc "
  echo "${color_red}src-zshrc:${color_blue} source ~/.zshrc "
  echo "${color_red}vi-zshrc:${color_blue} vi ~/.zshrc "
  echo "${color_red}c <env>:${color_blue} creates and activates new virtualenv with the name <env>"
  echo "${color_red}a <env>:${color_blue} activates virtualenv with the name <env>"
  echo "${color_red}v:${color_blue} lists installed virtual envs and Python versions"
}

info() {
  cloud_info
  alias_info
}
info
echo "\n${color_blue}To see this again type ${color_red}'info'$fg[grey]"

EOF

