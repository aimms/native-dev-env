FROM ubuntu:20.04

ENV PYTHON_VERSION=3.8.6
ENV PYTHON_VERSION_MAJOR=3.8
ENV DEBIAN_FRONTEND=noninteractive

ENV GIT_EDITOR=vim
ENV LANG=en_US.utf8
ENV LC_ALL=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV TERM=xterm

ENV CFLAGS="-march=native -O3 -pipe -flto -ffat-lto-objects"
ENV LDFLAGS="-fuse-ld=gold -fuse-linker-plugin"

RUN apt-get update && apt-get install -y --no-install-recommends build-essential libssl-dev zlib1g-dev libbz2-dev \
    ca-certificates gnupg libreadline-dev libsqlite3-dev wget  libncurses5-dev libncursesw5-dev libgdbm-dev  \
    xz-utils tk-dev libffi-dev liblzma-dev checkinstall locales

# generate locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  dpkg-reconfigure --frontend=noninteractive locales && update-locale LANG=en_US.UTF-8

RUN cd /usr/src && wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz && \
    tar xvf Python-$PYTHON_VERSION.tgz

RUN env; cd /usr/src/Python-$PYTHON_VERSION && \
    ./configure --enable-shared --enable-optimizations --with-computed-gotos && \
    make -j$(nproc --all) altinstall

RUN  update-alternatives --install /usr/local/bin/python3 python3 /usr/local/bin/python$PYTHON_VERSION_MAJOR 100
RUN  update-alternatives --install /usr/local/bin/python python /usr/local/bin/python$PYTHON_VERSION_MAJOR 100
RUN  update-alternatives --install /usr/local/bin/pip3 pip3 /usr/local/bin/pip$PYTHON_VERSION_MAJOR 100
RUN  update-alternatives --install /usr/local/bin/pip pip /usr/local/bin/pip$PYTHON_VERSION_MAJOR 100

RUN ldconfig

RUN pip install -U pip wheel setuptools

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

RUN rm -rf /usr/src/* && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/*


CMD zsh