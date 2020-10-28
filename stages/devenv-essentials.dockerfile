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
    python3 python3-venv python3-dev libpython3-dev python-is-python3 \
    build-essential tmux vim wget curl zip unzip locales libpq-dev neofetch fd-find

RUN chsh -s /bin/zsh

RUN ln -s /bin/fdfind /bin/fd

#fzf
RUN touch /root/.zshrc && git clone --depth 1 https://github.com/junegunn/fzf.git /usr/local/fzf && /usr/local/fzf/install

# generate locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  dpkg-reconfigure --frontend=noninteractive locales && update-locale LANG=en_US.UTF-8

# antigen
RUN curl -L git.io/antigen > /root/.antigen.zsh
RUN cat /assets/.zshrc.zsh >> /root/.zshrc

RUN zsh -c 'source ~/.zshrc'

RUN apt autoremove -y && rm -rf /var/lib/apt/lists/*

CMD /bin/zsh
