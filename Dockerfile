# syntax=docker/dockerfile:1.2
# Previous line is not a comment
# https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/syntax.md

# essentials
FROM ubuntu:20.10 as essentials

ARG BUILDKIT_CACHE_DIR=/var/cache/buildkit
ARG ZINIT_CACHE_DIR=$BUILDKIT_CACHE_DIR/zinit
ARG FZF_CACHE_DIR=$BUILDKIT_CACHE_DIR/fzf
ARG PIP_CACHE_DIR=$BUILDKIT_CACHE_DIR/pip


ENV DEBIAN_FRONTEND=noninteractive
ENV TZ="Europe/Amsterdam"
ENV GIT_EDITOR=vim
ENV LANG=en_US.utf8
ENV LC_ALL=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV TERM=xterm

ENV PIPX_HOME=/usr/local/pipx
ENV PIPX_BIN_DIR=/usr/local/bin
ENV USE_EMOJI=0
ENV ZINIT_HOME=/usr/local/zinit
ENV ZDOTDIR=/etc/zsh

# without dot in /etc/zsh
ENV ZSHRC_NAME=zshrc

## https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/syntax.md
RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' \
    > /etc/apt/apt.conf.d/keep-cache

RUN --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt \
    apt-get update && apt-get --no-install-recommends install -y \
    zsh exa neofetch fd-find  \
#        git highlight pcre2-utils \
        python3.9 python3.9-venv python3-pip \
#        python3.9-dev python3-pip \
#         libpython3.9-dev  \
         vim git curl zip unzip p7zip patch locales && \
#        build-essential tmux libpq-dev  libpq-dev wget
        update-alternatives --install /usr/bin/python3  python3 /usr/bin/python3.9 1 && \
        update-alternatives --install /usr/bin/python  python /usr/bin/python3.9 1 && \
        chsh -s /bin/zsh && \
        ln -s /bin/fdfind /bin/fd

# generate locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  dpkg-reconfigure --frontend=noninteractive locales && update-locale LANG=en_US.UTF-8

# python / pipx (for standalone installations)
RUN --mount=type=cache,target=$PIP_CACHE_DIR pip install pipx

# zinit
RUN --mount=type=bind,target=/mnt,readonly \
    --mount=type=cache,target=$ZINIT_CACHE_DIR \
    zsh -c "set -e ; mkdir -p $ZINIT_CACHE_DIR ; cd $ZINIT_CACHE_DIR ; \
        [[ -f install.sh ]] || curl -L -o install.sh https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh && \
        patch -p0 < /mnt/essentials/zinit.patch ; \
        chmod +x install.sh"

# 'y' for installing plugins
RUN --mount=type=cache,target=$ZINIT_CACHE_DIR \
    zsh -c '$ZINIT_CACHE_DIR/install.sh < <(echo y)'

RUN --mount=type=bind,target=/mnt,readonly \
    --mount=type=cache,target=$FZF_CACHE_DIR \
    zsh -c " set -e ; [[ -d $FZF_CACHE_DIR ]] || git clone --depth 1 https://github.com/junegunn/fzf.git $FZF_CACHE_DIR && \
        cd $FZF_CACHE_DIR && patch -p0 < /mnt/essentials/fzf.patch ; \
        cp -R $FZF_CACHE_DIR /usr/local"

RUN /usr/local/fzf/install --all --no-fish --no-bash


RUN --mount=type=bind,target=/mnt,readonly \
        cat /mnt/essentials/zshrc.zsh >>  /etc/zsh/zshrc && \
        cp /mnt/essentials/devenv_aliases.zsh /etc/zsh/ && \
        cp /mnt/essentials/devenv_bindings.zsh /etc/zsh/

RUN zsh -ci 'echo Initializing zsh...'

## copy dotfiles
#RUN --mount=type=bind,target=/mnt,readonly,readonly zsh -c 'autoload -U zmv && noglob zmv -W -C /mnt/essentials/.* /root/.*' && \
#        cd /root && mv zshrc.zsh .zshrc
#
##fzf; config is embedded into zshrc.zsh
#RUN --mount=type=cache,target=$BUILDKIT_CACHE_DIR \
#        git clone --depth=1 https://github.com/junegunn/fzf.git $BUILDKIT_CACHE_DIR/fzf && \
#        cp -R=$BUILDKIT_CACHE_DIR/fzf /usr/local/fzf && \
#        /usr/local/fzf/install --no-bash --no-fish --no-zsh
#
## antigen
#RUN curl -L git.io/antigen > /root/.antigen.zsh
#
## cache theming (inside the image also); install pipx
#RUN --mount=type=cache,target=/root/.antigen --mount=type=cache,target=/root/.cache && \
#    TERM=xterm-256color zsh -ci 'pip install pipx'

CMD zsh

###
# cloud image
###
FROM essentials as cloud

RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update && apt-get --no-install-recommends install -y \
        iputils-ping traceroute net-tools openssh-client dos2unix && \
    rm -rf /var/lib/apt/lists/*

# shellcheck disable=SC2046npx
RUN release=$(wget -O - https://storage.googleapis.com/kubernetes-release/release/stable.txt | cat -) && \
    wget https://storage.googleapis.com/kubernetes-release/release/$release/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/bin/kubectl

RUN --mount=type=bind,target=/mnt,readonly \
    zsh -ci 'venv /tools && pip install -r /mnt/cloud/tools.txt && \
             venv /devenv && pip install -r /mnt/cloud/devenv.txt'

RUN --mount=type=bind,target=/mnt,readonly cat /mnt/cloud/.zshrc.zsh >> /root/.zshrc

# native image
FROM essentials as native

RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update && apt-get --no-install-recommends install -y \
        autoconf automake doxygen graphviz ccache gdb && \
    rm -rf /var/lib/apt/lists/*

RUN --mount=type=cache,target=/root/.cache --mount=type=bind,target=/mnt,readonly \
    pip install -r /mnt/native/native.txt

###
# native-server
###
FROM native as native-server
ENV BUILD_USER=builderboy

RUN --mount=type=cache,target=/var/cache/apt \
       apt-get update && apt-get install -y --no-install-recommends \
       openssh-server rsync gdbserver sudo && \
       rm -rf /var/lib/apt/lists/*

# configure SSH for communication with Visual Studio
RUN mkdir -p /var/run/sshd && \
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config && ssh-keygen -A

# create our builderboy user
# let builderboy use sudo with requiring a password
RUN useradd -m -d /home/$BUILD_USER -s /bin/bash -G sudo $BUILD_USER && echo "$BUILD_USER:$BUILD_USER" | chpasswd && \
    sed -i /etc/sudoers -re 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g' && \
    sed -i /etc/sudoers -re 's/^root.*/root ALL=(ALL:ALL) NOPASSWD: ALL/g' && \
    sed -i /etc/sudoers -re 's/^#includedir.*/## **Removed the include directive** ##"/g' && \
    echo "$BUILD_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN chown root /var/run/sshd && \
    chmod 744 /var/run/sshd

COPY --from=native /.* /home/$BUILD_USER/
RUN chown -R $BUILD_USER:$BUILD_USER /home/$BUILD_USER/*

# expose sshd port
EXPOSE 22
ENTRYPOINT ["/usr/sbin/sshd", "-D"]

####
## go
####
#FROM $BUNDLE_BASE as go
#
#RUN --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/root/go \
#       apt-get update && apt-get install -y --no-install-recommends golang
#
####
## rust
####
#FROM $BUNDLE_BASE as rust
#
#RUN --mount=type=cache,target=/root/.cargo \
#    sh -c $(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs) -y