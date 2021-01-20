ARG VERSION=latest
FROM aimmspro/devenv-essentials:$VERSION

# shellcheck disable=SC2046npx
RUN release=$(wget -O - https://storage.googleapis.com/kubernetes-release/release/stable.txt | cat -) && \
    wget https://storage.googleapis.com/kubernetes-release/release/$release/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/bin/kubectl

RUN zsh -ci 'venv /tools && \
            pip install -r /install/tools.txt && \
            az extension add -n application-insights && \
            venv /devenv && \
            pip install -r /install/devenv.txt'

RUN cat /install/.zshrc.zsh >> /root/.zshrc

