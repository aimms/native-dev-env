FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV GIT_EDITOR=vim
ENV LANG=en_US.utf8
ENV LC_ALL=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV TERM=xterm

# install basic tools
RUN apt update && apt upgrade -y && \
    apt --no-install-recommends install -y git highlight pcre2-utils zsh \
    python3 python3-venv python3-dev python3-pip libpython3-dev python-is-python3 \
    build-essential tmux vim wget curl zip unzip locales libpq-dev neofetch fd-find

RUN chsh -s /bin/zsh

RUN ln -s /bin/fdfind /bin/fd

# generate locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  dpkg-reconfigure --frontend=noninteractive locales && update-locale LANG=en_US.UTF-8

#fzf; config is embedded into .zshrc
RUN git clone --depth 1 https://github.com/junegunn/fzf.git /usr/local/fzf && \
        /usr/local/fzf/install --no-bash --no-fish --no-zsh

# antigen
RUN curl -L git.io/antigen > /root/.antigen.zsh

# install .zshrc stuff
RUN zsh -c 'autoload -U zmv && noglob zmv -W -C /install/.* /root/.*'

# init; ensure theme support is installed; prepare python env
RUN pip3 install --user pip && \
    mkdir /venv && python -m venv /venv

RUN zsh -c 'TERM=xterm-256color source ~/.zshrc && pip install -U pip wheel setuptools'

RUN apt autoremove -y && rm -rf /var/lib/apt/lists/*

CMD zsh