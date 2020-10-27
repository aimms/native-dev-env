ARG VERSION=latest
FROM aimmspro/devenv-native-ext-shell:$VERSION

ENV TERM="xterm"

RUN cat /assets/.zshrc > /root/.zshrc
RUN cat /assets/.zshrc-info.zsh >> /root/.zshrc
RUN cat /assets/.zshrc-native.zsh >> /root/.zshrc

