FROM aimmspro/cloud-devenv-base:latest

RUN apt update
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y
COPY setup.zsh /tmp/setup.zsh
COPY logo.py /root/.logo.py
RUN zsh -c /tmp/setup.zsh
RUN rm -rf /tmp/*
RUN zsh -c "source ~/.zshrc && echo 'Run info for image information.'"

CMD zsh
