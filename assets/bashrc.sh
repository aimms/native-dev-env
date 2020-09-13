export PYENV_ROOT="/usr/local/pyenv"
export PATH="${PYENV_ROOT}/bin:${PATH}"

if [ "$SHELL" == "/bin/zsh" ]; then
  alias vi-zshrc="vi ~/.zshrc"
  alias src-zshrc="source ~/.zshrc"
else
  alias vi-bashrc="vi ~/.bashrc"
  alias src-bashrc="source ~/.bashrc"
fi

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

alias a="pyenv activate"
alias v="pyenv versions"
alias c='(){ pyenv virtualenv $1 && pyenv activate $1 && pip install -U pip && pip install -U wheel && pip install -U setuptools ;}'

if [[ "$ENABLE_THEMING" == "YES" ]]; then
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

main_info() {
  echo "${color_blue}Tools:"

  info_for_app $SHELL
  info_for_app python
  info_for_app pyenv
  info_for_app clang
  info_for_app cmake
  info_for_app conan
  info_for_app ninja
  echo ""

  # clear color
  if [[ "$ENABLE_THEMING" == "YES" ]]; then
    echo -e "\033[0m"
  fi
}

print_help_msg(){
  echo "\n${color_blue}Type ${color_red}'info' ${color_blue}for the image information."

  # clear color_blue
  if [[ "$ENABLE_THEMING" == "YES" ]]; then
    echo -e "\033[0m"
  fi
}

info(){
    main_info
}
