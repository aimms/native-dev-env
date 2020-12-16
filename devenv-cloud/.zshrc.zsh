export PATH="$PATH:/tools/bin"

alias k=kubectl

# shellcheck disable=SC1090
source <(kubectl completion zsh)

cloud_info() {
  info_for_app az
  info_for_app terraform
  # shellcheck disable=SC2154
  # shellcheck disable=SC2046
  echo -e "${bold}kube:${normal}" $(pip show kube-cli | grep -oP "[0-9]+[a-zA-Z]?\.[0-9]+(?:[\.][0-9]+[a-zA-Z]?){0,4}" | head -n 1)
}

info() {
  main_info
  cloud_info
}

# shellcheck disable=SC1090
source /devenv/bin/activate

