ARG VERSION=latest
FROM aimmspro/devenv-python-optimized:$VERSION

ENV DEBIAN_FRONTEND=noninteractive
ENV GIT_EDITOR=vim
ENV LANG=en_US.utf8
ENV LC_ALL=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV TERM=xterm

# install basic tools
RUN apt-get update && apt-get --no-install-recommends install -y \
    git highlight pcre2-utils zsh tmux vim curl zip unzip libpq-dev neofetch fd-find

RUN chsh -s /bin/zsh

RUN ln -s /bin/fdfind /bin/fd

#fzf; config is embedded into .zshrc
RUN git clone --depth 1 https://github.com/junegunn/fzf.git /usr/local/fzf && \
        /usr/local/fzf/install --no-bash --no-fish --no-zsh

# antigen
RUN curl -L git.io/antigen > /root/.antigen.zsh

# install .zshrc stuff
RUN zsh -c 'autoload -U zmv && noglob zmv -W -C /install/.* /root/.*'

# 1. ensure theme support is installed;
# 2. prepare 'tools python env for cli tool
RUN zsh -c 'TERM=xterm-256color source ~/.zshrc'

RUN apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

CMD zsh