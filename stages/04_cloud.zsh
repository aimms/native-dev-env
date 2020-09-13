#!/usr/bin/env zsh

# shellcheck disable=SC1090
source ~/.zshrc # pyenv & related

pyenv global $PYTHON_VERSION && c az && pyenv global az
pip install azure-cli
pip install jmespath
pip install typed-argument-parser

# shellcheck disable=SC2046
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/bin/kubectl && \
    echo "kubectl version: $(kubectl version --client)"

pushd /usr/bin || exit
tf_version=0.12.28
terraform_zip=terraform_${tf_version}_linux_amd64.zip
curl -LO https://releases.hashicorp.com/terraform/${tf_version}/${terraform_zip}
unzip $terraform_zip
rm -f $terraform_zip
popd || exit


cat /host/assets/.zshrc_cloud >> $HOME/.zshrc


