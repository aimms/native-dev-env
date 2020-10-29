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

RUN zsh -c "source ~/.zshrc && \
            pipz instal --cmd az azure-cli && \
            pipz instal --cmd kube kube-cli && \



RUN mkdir ~/.dev && python3 -m venv ~/.dev && source ~/.dev/bin/activate && \
        echo 'source ~/.dev/bin/activate' >> /root/.zshrc && \
        pip install -U pip wheel && pip install \
                typed-argument-parser \
                azure-mgmt-dns \
                azure-identity \
                psycopg2cffi \
                pony \
                requests \
                py-flags


RUN cat /install/.zshrc-cloud.zsh >> /root/.zshrc
