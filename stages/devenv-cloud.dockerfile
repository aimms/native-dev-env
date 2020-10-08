ARG VERSION=latest
FROM aimmspro/devenv-essentials:$VERSION
ENV TERRAFORM_VERSION="0.12.28"

# shellcheck disable=SC2046
RUN release=$(wget -O - https://storage.googleapis.com/kubernetes-release/release/stable.txt | cat -) && \
    wget https://storage.googleapis.com/kubernetes-release/release/$release/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/bin/kubectl && \
    echo "kubectl version: $(kubectl version --client)"

RUN bash -c 'source /root/.bashrc && c az && pyenv global az && \n\
             pip install azure-cli jmespath typed-argument-parser'

RUN cd /usr/bin && \
    terraform_zip=terraform_${TERRAFORM_VERSION}_linux_amd64.zip
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/${terraform_zip}
    unzip $terraform_zip
    rm -f $terraform_zip

RUN cat /assets/.bashrc_cloud >> /root/.bashrc


