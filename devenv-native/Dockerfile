ARG VERSION=latest
FROM aimmspro/devenv-native-ext-shell:$VERSION

ENV TERM="xterm"

# install .zshrc stuff
RUN zsh -c 'autoload -U zmv && noglob zmv -W -C /install/.* /root/.*'
