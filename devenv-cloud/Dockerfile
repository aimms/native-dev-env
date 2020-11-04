ARG VERSION=latest
FROM aimmspro/devenv-essentials:$VERSION
ENV TERRAFORM_VERSION="0.12.28"
#
## shellcheck disable=SC2046npx
#RUN release=$(wget -O - https://storage.googleapis.com/kubernetes-release/release/stable.txt | cat -) && \
#    wget https://storage.googleapis.com/kubernetes-release/release/$release/bin/linux/amd64/kubectl && \
#    chmod +x ./kubectl && \
#    mv ./kubectl /usr/bin/kubectl
#
#RUN cd /usr/bin && \
#    TERRAFORM_ZIP="terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
#    wget "https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/$TERRAFORM_ZIP" && \
#    unzip "$TERRAFORM_ZIP" && rm -f "$TERRAFORM_ZIP"




# 1. Install azure-cli and kube-cli as standalone applications
# 2. install python deps from requirements.txt
RUN zsh -c 'source ~/.zshrc && \
            cd /root && activate && \
            pip install -U typed-argument-parser && \
            pipx install azure-cli && \
            pipx install kube-cli && \
            deactivate && \
            mkdir -p /root/.venvs/dev && cd /root/.venvs/dev && \
            touch SHOULD_BE_EMPTY && activate && \
            pip install -U pip wheel setuptools && \
            pip install -r /install/requirements.txt'

RUN cat /install/.zshrc.zsh >> /root/.zshrc