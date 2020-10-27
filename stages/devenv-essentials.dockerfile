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
    build-essential zsh tmux vim wget curl git zip unzip python3-dev libpython3-dev \
    python-is-python3 python3-venv locales libpq-dev neofetch fd-find

RUN ln -s /bin/fdfind /bin/fd

RUN chsh -s /bin/zsh

# generate locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  dpkg-reconfigure --frontend=noninteractive locales && update-locale LANG=en_US.UTF-8

RUN cp /assets/.zshrc ~/.zshrc && \
    chown root:root ~/.zshrc

# pyenv
RUN curl https://pyenv.run | bash
RUN zsh -c 'source ~/.zshrc && pyenv global system'

RUN apt autoremove -y && rm -rf /var/lib/apt/lists/*

CMD /bin/zsh
