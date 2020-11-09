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
