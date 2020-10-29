alias vi-rc="vi ~/.zshrc"

autoload -U colors && colors
# shellcheck disable=SC2154
bold="${fg_bold[white]}"
# shellcheck disable=SC2154
normal="${reset_color}"

info_for_app(){
  local name="$1"
  local version_arg="$2"

  if [ -e $version_arg ]; then
    version_arg="--version"
  fi

  # shellcheck disable=SC2046
  echo -e "${bold}$name:${normal}" \
    $("$name" $version_arg | grep -oP  "[0-9]+[a-zA-Z]?\.[0-9]+(?:[\.][0-9]+[a-zA-Z]?){0,4}" | head -n 1)
}

alias_info(){
  echo -e "Alias Information:\n"

  echo -e "${bold}vi-rc:${normal} vi $HOME/.zshrc"
  echo -e "${bold}src:${normal} source $HOME/.zshrc\n"
  echo -e "${bold}zpy${normal} alias information can be found here: https://github.com/andydecleyre/zpy"
}

main_info() {
  neofetch

  alias_info

  echo -e "Tools installed:\n"
  info_for_app curl
  info_for_app vim
  info_for_app git
  info_for_app tmux -V
  info_for_app python
  info_for_app pip
  info_for_app gcc
}