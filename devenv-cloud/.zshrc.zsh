alias k=kubectl

# shellcheck disable=SC1090
source <(kubectl completion zsh)

cloud_info() {
  info_for_app az
  info_for_app kube
  info_for_app terraform
}

info() {
  main_info
  cloud_info
}

# shellcheck disable=SC2154
echo "${normal}Type ${bold}'info' ${normal}for the image information."

pushd "$HOME"/.venvs/dev || exit
# shellcheck disable=SC1090
activate # activate dev virtual env
popd || exit
