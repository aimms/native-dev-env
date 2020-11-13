ARG VERSION=latest
FROM aimmspro/devenv-essentials:$VERSION
ENV TERRAFORM_VERSION="0.12.28"

# shellcheck disable=SC2046npx
RUN release=$(wget -O - https://storage.googleapis.com/kubernetes-release/release/stable.txt | cat -) && \
    wget https://storage.googleapis.com/kubernetes-release/release/$release/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/bin/kubectl

RUN cd /usr/bin && \
    TERRAFORM_ZIP="terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    wget "https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/$TERRAFORM_ZIP" && \
    unzip "$TERRAFORM_ZIP" && rm -f "$TERRAFORM_ZIP"

RUN cat /install/.zshrc.zsh >> /root/.zshrc

RUN python -m venv /tools
RUN python -m venv /devenv

RUN zsh -c 'source /tools/bin/activate && \
            pip install -U pip wheel setuptools && \
            pip install --use-feature=2020-resolver -r /install/tools.txt && \
            deactivate && \
            source /devenv/bin/activate && \
            pip install -U pip wheel setuptools && \
            pip install --use-feature=2020-resolver -r /install/devenv.txt'


