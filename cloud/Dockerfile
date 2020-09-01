FROM aimmspro/devenv-python:latest


COPY setup.zsh /tmp/setup.zsh
RUN /tmp/setup.zsh && rm -f /tmp/setup.zsh
RUN zsh  -c "source ~/.zshrc && info"

CMD zsh
