FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ="Europe/Amsterdam"
ENV GIT_EDITOR=vim
ENV LANG=en_US.utf8
ENV LC_ALL=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV TERM=xterm

# install basic tools
RUN apt-get update && apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y git highlight pcre2-utils zsh \
    python3 python3-venv python3-dev python3-pip libpython3-dev python-is-python3 \
    build-essential tmux vim wget curl zip unzip locales libpq-dev neofetch fd-find dos2unix \
    iputils-ping traceroute net-tools openssh-client sudo


RUN chsh -s /bin/zsh

RUN ln -s /bin/fdfind /bin/fd

# generate locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  dpkg-reconfigure --frontend=noninteractive locales && update-locale LANG=en_US.UTF-8

#fzf; config is embedded into .zshrc.zsh
RUN git clone --depth 1 https://github.com/junegunn/fzf.git /usr/local/fzf && \
        /usr/local/fzf/install --no-bash --no-fish --no-zsh

# antigen
RUN curl -L git.io/antigen > /root/.antigen.zsh

# install .zshrc.zsh stuff
RUN zsh -c 'autoload -U zmv && noglob zmv -W -C /install/.* /root/.*' && cd /root && mv .zshrc.zsh .zshrc

# init; ensure theme support is installed; prepare python env
RUN TERM=xterm-256color zsh -ci 'pip3 install -U pip wheel setuptools'

RUN apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

CMD zsh
