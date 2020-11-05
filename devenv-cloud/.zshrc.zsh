alias k=kubectl

alias az="/root/.cli/bin/az"
alias kube="/root/.cli/bin/az"

# shellcheck disable=SC1090
source <(kubectl completion zsh)

cloud_info() {
  info_for_app /root/.cli/bin/az
  info_for_app /root/.cli/bin/kube
  info_for_app terraform
}

info() {
  main_info
  cloud_info
}

# shellcheck disable=SC2154
echo "${normal}Type ${bold}'info' ${normal}for the image information."

