#!/usr/bin/env zsh

set -e

# shellcheck disable=SC1090
source $HOME/.bashrc

c az
pyenv global az
pip install azure-cli jmespath typed-argument-parser

apt update && apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
apt install -y kubectl

pushd /usr/bin || exit
tf_version=0.12.28
terraform_zip=terraform_${tf_version}_linux_amd64.zip
wget https://releases.hashicorp.com/terraform/${tf_version}/${terraform_zip}
unzip $terraform_zip
rm -f $terraform_zip
popd || exit

cat /host/assets/.bashrc_cloud >> $HOME/.bashrc


