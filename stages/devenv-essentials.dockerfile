FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYENV_ROOT="/usr/local/pyenv"
ENV PATH="$$PYENV_ROOT/bin:$$PATH"
ENV GIT_EDITOR=vim
ENV PYENV_VIRTUALENV_DISABLE_PROMPT=1
ENV LANG=en_US.utf8
ENV LC_ALL=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV TERM=xterm-256color

# install basic tools
RUN apt update && apt upgrade -y && apt install -y --no-install-recommends \
    vim wget curl git zip unzip python3 python-is-python3 python3-venv locales

# generate locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  dpkg-reconfigure --frontend=noninteractive locales && update-locale LANG=en_US.UTF-8

# pyenv
RUN curl https://pyenv.run | bash

RUN cp /assets/.bashrc /root/.bashrc && \
    chown root:root /root/.bashrc

RUN bash -c 'source /root/.bashrc && c default && pyenv global default'

RUN apt autoremove -y && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/bin/bash"]
