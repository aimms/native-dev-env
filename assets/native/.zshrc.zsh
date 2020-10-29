native_info(){
  info_for_app clang
  info_for_app cmake
  info_for_app conan
  info_for_app ninja
}

info(){
  main_info
  native_info
}

# shellcheck disable=SC2086
if [ -e $DEVENV_SSH_SERVER ]; then
  # shellcheck disable=SC2154
  echo "${normal}Type ${bold}'info' ${normal}for the image information."
fi
