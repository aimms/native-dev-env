FROM aimmspro/devenv-cloud:latest

COPY setup.zsh /tmp/setup.zsh
RUN /tmp/setup.zsh
RUN rm -f /tmp/setup.zsh
RUN zsh -c "source ~/.zshrc && echo 'Run info for image information.'"

CMD zsh