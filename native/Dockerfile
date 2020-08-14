FROM aimmspro/devenv-cloud:latest

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y

COPY setup.zsh /tmp/setup.zsh
RUN /tmp/setup.zsh
RUN rm -f /tmp/setup.zsh
RUN zsh -c "source ~/.zshrc && echo 'Run info for image information.'"

CMD zsh
