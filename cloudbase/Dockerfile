FROM aimmspro/native-devenv-essentials:latest

COPY setup.zsh /tmp/setup.zsh
RUN /usr/bin/zsh -c /tmp/setup.zsh
RUN rm -rf /tmp/*

CMD zsh
