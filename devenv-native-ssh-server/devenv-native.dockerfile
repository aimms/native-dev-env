ARG VERSION=latest
FROM aimmspro/devenv-native-ext-shell:$VERSION

ENV TERM="xterm"

RUN cat /install/.zshrc > /root/.zshrc
RUN cat /install/.zshrc-info.zsh >> /root/.zshrc
RUN cat /install/.zshrc-native.zsh >> /root/.zshrc

