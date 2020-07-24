FROM aimmspro/native-devenv-essentials:0.1

COPY setup.zsh /tmp/setup.zsh
RUN /usr/bin/zsh -c /tmp/setup.zsh
RUN rm -rf /tmp/*

CMD zsh
