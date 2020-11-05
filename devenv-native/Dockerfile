ARG VERSION=latest
FROM aimmspro/devenv-native-base:$VERSION

ENV TERM="xterm"

# install .zshrc stuff
RUN zsh -c 'autoload -U zmv && noglob zmv -W -C /install/.* /root/.*'

RUN zsh -c 'source ~/.zshrc && \
            pip install conan ninja cmake'