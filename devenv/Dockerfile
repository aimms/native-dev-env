FROM aimmspro/native-devenv-essentials:latest

COPY setup.zsh /tmp/setup.zsh
COPY logo.py /root/.logo.py
RUN /usr/bin/zsh -c /tmp/setup.zsh
RUN rm -rf /tmp/*
RUN /usr/bin/zsh -c "source ~/.zshrc && info && echo 'Run info for image information.'"

CMD zsh
