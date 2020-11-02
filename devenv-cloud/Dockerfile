ARG VERSION=latest
FROM aimmspro/devenv-essentials:$VERSION
ENV TERRAFORM_VERSION="0.12.28"

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

# install .zshrc stuff
RUN zsh -c 'autoload -U zmv && noglob zmv -W -C /install/.* /root/.*'

# Install apps
RUN pip install -U pip wheel && pip install pipx && \
    pipx install azure-cli && \
    pipx install kube-cli

RUN mkdir ~/.dev && \
    python3 -m venv ~/.dev && \
    source ~/.dev/bin/activate && \
    pip install -r /install/requirements.txt

RUN cat /install/.zshrc-cloud.zsh >> /root/.zshrc
