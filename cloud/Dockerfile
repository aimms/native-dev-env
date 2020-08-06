FROM aimmspro/devenv-essentials:latest

COPY logo.py /root/.logo.py
COPY setup.zsh /tmp/setup.zsh
RUN /tmp/setup.zsh
RUN rm -f /tmp/setup.zsh
RUN zsh -c "source ~/.zshrc && echo 'Run info for image information.'"

CMD zsh
