alias vi-rc="vi /etc/zsh/zshrc"

autoload -U colors && colors
# shellcheck disable=SC2154
bold="${fg_bold[white]}"
# shellcheck disable=SC2154
normal="${reset_color}"

info_for_app() {
  local name="$1"
  local version_arg="$2"

  if [ -e $version_arg ]; then
    version_arg="--version"
  fi

  # shellcheck disable=SC2046
  echo -e "${bold}$name:${normal}" \
    $("$name" $version_arg | grep -oP "[0-9]+[a-zA-Z]?\.[0-9]+(?:[\.][0-9]+[a-zA-Z]?){0,4}" | head -n 1)
}

upgrade_pip() {
	pip install -U pip setuptools wheel
}

_venv() {
	source "$1/bin/activate"
}

venv() {
	if [ ! -d "$1" ]; then
		python -m venv "$1"
		_venv "$1"
	fi
	_venv "$1"
}

alias_info() {
  echo -e "Alias Information:\n"

  echo -e "${bold}vi-rc:${normal} vi /etc/zsh/zshrc"
  echo -e "${bold}src:${normal} source /etc/zsh/zshrc\n"
  echo -e "${bold}upgrade_pip:${normal} in the current env: upgrades pip, setuptools and wheel"
  echo -e "${bold}venv <path>:${normal} creates (if not created yet) virtual env with <path> and activates it"

}

main_info() {
  neofetch

  alias_info

  echo -e "Tools installed:\n"
  info_for_app zsh --version
  info_for_app tmux -V
  info_for_app curl
  info_for_app wget
  info_for_app vim
  info_for_app git
  info_for_app zip
  info_for_app neofetch
  info_for_app fd
  info_for_app python
  info_for_app pip
  info_for_app gcc
}

info() {
  main_info
}