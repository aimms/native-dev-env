ARG VERSION=latest
FROM aimmspro/devenv-native-base:$VERSION

ENV TERM="xterm"

# install .zshrc stuff
RUN zsh -c 'autoload -U zmv && noglob zmv -W -C /install/.* /root/.*'

RUN pip install conan ninja cmake