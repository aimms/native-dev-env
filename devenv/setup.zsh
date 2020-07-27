#!/bin/zsh


#source ~/.zshrc
#
#CC=clang CXX=clang++ pyenv install 3.8.3 --verbose
pyenv global 3.8.3 && c dev && pyenv global dev
pip3 install cmake
pip3 install conan
pip3 install ninja

c az && pip3 install azure-cli

curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/bin/kubectl && \
    echo "kubectl version: $(kubectl version --client)"