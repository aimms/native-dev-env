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
