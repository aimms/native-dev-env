FROM aimmspro/devenv-python:latest

COPY logo.py /root/.logo.py
COPY setup.zsh /tmp/setup.zsh
RUN /tmp/setup.zsh && rm -f /tmp/setup.zsh
RUN zsh --login -c "echo 'Run info for image information.'"

CMD zsh
