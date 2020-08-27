#!/bin/zsh

source ~/.zshrc

pyenv global ${PYTHON_VERSION} && c dev && pyenv global dev
pip install cmake==3.18.0 # 3.18.2 setup is broken
pip install conan
pip install ninja
pip install sty

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

