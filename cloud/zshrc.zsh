alias k=kubectl

cloud_info() {
  info_for_app az
  # shellcheck disable=SC2154
  # shellcheck disable=SC2046
  # shellcheck disable=SC2154
  # shellcheck disable=SC2046
  echo -e "${bold}kube:${normal}" $(pip show kube-cli | grep -oP "[0-9]+[a-zA-Z]?\.[0-9]+(?:[\.][0-9]+[a-zA-Z]?){0,4}" | head -n 1)
}

info() {
  main_info
  cloud_info
}
