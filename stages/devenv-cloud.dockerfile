ARG VERSION=latest
FROM aimmspro/devenv-shell-tools:$VERSION
ENV TERRAFORM_VERSION="0.12.28"

# shellcheck disable=SC2046
RUN release=$(wget -O - https://storage.googleapis.com/kubernetes-release/release/stable.txt | cat -) && \
    wget https://storage.googleapis.com/kubernetes-release/release/$release/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/bin/kubectl

RUN cd /usr/bin && \
    TERRAFORM_ZIP="terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    wget "https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/$TERRAFORM_ZIP" && \
    unzip "$TERRAFORM_ZIP" && rm -f "$TERRAFORM_ZIP"

RUN zsh -c 'source ~/.zshrc && c az && \
             pip install --use-feature=2020-resolver \
                azure-cli \
                typed-argument-parser && \
             c dev && pyenv global dev && \
             pip install --use-feature=2020-resolver \
                kube-cli \
                typed-argument-parser \
                azure-mgmt-dns \
                azure-identity \
                psycopg2cffi \
                pony \
                requests \
                py-flags'

RUN cat /assets/.zshrc-cloud.zsh >> /root/.zshrc
