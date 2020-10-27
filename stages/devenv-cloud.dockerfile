ARG VERSION=latest
FROM aimmspro/devenv-cloud-ext-shell:$VERSION

ENV TERM="xterm"

RUN cat /assets/.zshrc > /root/.zshrc
RUN cat /assets/.zshrc-info.zsh >> /root/.zshrc
RUN cat /assets/.zshrc-cloud.zsh >> /root/.zshrc

