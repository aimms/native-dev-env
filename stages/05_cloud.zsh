#!/usr/bin/env zsh

set -e

# shellcheck disable=SC1090
source $HOME/.bashrc

c az
pyenv global az
pip install azure-cli jmespath typed-argument-parser

# shellcheck disable=SC2046
release=$(wget -O - https://storage.googleapis.com/kubernetes-release/release/stable.txt | cat -)
wget https://storage.googleapis.com/kubernetes-release/release/$release/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/bin/kubectl && \
    echo "kubectl version: $(kubectl version --client)"

pushd /usr/bin || exit
tf_version=0.12.28
terraform_zip=terraform_${tf_version}_linux_amd64.zip
wget https://releases.hashicorp.com/terraform/${tf_version}/${terraform_zip}
unzip $terraform_zip
rm -f $terraform_zip
popd || exit


cat /host/assets/.bashrc_cloud >> $HOME/.bashrc


