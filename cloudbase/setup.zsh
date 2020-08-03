#!/bin/zsh

source ~/.zshrc

pyenv global ${PYTHON_VERSION} && c az
pip3 install azure-cli
pip3 install jmespath
pip3 install typed-argument-parser

curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/bin/kubectl && \
    echo "kubectl version: $(kubectl version --client)"


cat << 'EOF' >> ~/.zshrc

alias k=kubectl
source <(kubectl completion zsh)

EOF

