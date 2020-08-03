FROM aimmspro/cloud-devenv-base:latest

RUN apt update
COPY setup.zsh /tmp/setup.zsh
COPY logo.py /root/.logo.py
RUN /usr/bin/zsh -c /tmp/setup.zsh
RUN rm -rf /tmp/*
RUN /usr/bin/zsh -c "source ~/.zshrc && echo 'Run info for image information.'"

CMD zsh
