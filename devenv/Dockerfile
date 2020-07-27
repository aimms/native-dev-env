ARG IMG_VERSION=latest
FROM aimmspro/native-devenv-essentials:${IMG_VERSION}

COPY setup.zsh /tmp/setup.zsh
RUN /usr/bin/zsh -c /tmp/setup.zsh
RUN rm -rf /tmp/*

CMD zsh
