export PATH="$PATH:/tools/bin"

alias k=kubectl

# shellcheck disable=SC1090
source <(kubectl completion zsh)

cloud_info() {
  info_for_app az
  info_for_app terraform
}

info() {
  main_info
  cloud_info
}

# shellcheck disable=SC1090
source /devenv/bin/activate

# shellcheck disable=SC2086
if [ -e $DEVENV_LIGHTWEIGHT ]; then # declared in devenv-cloud
  # shellcheck disable=SC2154
  echo "${normal}Type ${bold}'info' ${normal}for the image information."
fi
