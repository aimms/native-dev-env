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

# 1. Install azure-cli and kube-cli as standalone applications
# 2. install python deps from requirements.txt
RUN zsh -c 'source /venv/bin/activate && \
            pip install -r /install/requirements.txt && \
            deactivate && \
            python -m venv ~/.cli && source ~/.cli/bin/activate && \
            pip install -U pip wheel && \
            pip install typed-argument-parser azure-cli kube-cli && \
            echo "alias az=$(which az)" >> ~/.zshrc && \
            echo "alias kube=$(which kube)" >> ~/.zshrc'

RUN cat /install/.zshrc.zsh >> /root/.zshrc