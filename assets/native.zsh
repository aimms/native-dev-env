#!/usr/bin/env zsh

c dev && pyenv global dev
pip install cmake
pip install conan
pip install ninja

cat << 'EOF' >> ~/.zshrc

native_info() {
  echo "${color_blue}Additional Native Tools:"

  info_for_app clang
  info_for_app cmake
  info_for_app conan
  info_for_app ninja
  echo ""
}

info(){
  cloud_info
  native_info
  alias_info
  print_help_msg
}


EOF

