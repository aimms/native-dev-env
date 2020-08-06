#!/bin/zsh

source ~/.zshrc

pyenv global ${PYTHON_VERSION} && c dev && pyenv global dev
pip3 install cmake
pip3 install conan
pip3 install ninja
pip3 install sty

cat << 'EOF' >> ~/.zshrc

echo "${color_blue}Additional Native Tools:"

native_info() {
  info_for_app cmake
  info_for_app conan
  info_for_app ninja
  echo ""
}
native_info

info(){
  cloud_info
  native_info
  alias_info
}
echo "\n${color_blue}To see this again type ${color_red}'info'$fg[grey]"

EOF

