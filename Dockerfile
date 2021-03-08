# syntax=docker/dockerfile:1.2
# Previous line is not a comment
# https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/syntax.md

# ----------------------------------------------------------------------------------------------------------------------
FROM ubuntu:20.10 as essentials


ENV DEBIAN_FRONTEND=noninteractive
ENV TZ="Europe/Amsterdam"
ENV GIT_EDITOR=vim
ENV LANG=en_US.utf8
ENV LC_ALL=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV TERM=xterm

ENV PIPX_HOME=/opt/pipx
ENV PIPX_BIN_DIR=/opt/bin
ENV USE_EMOJI=0
# for installer

## https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/syntax.md
RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' \
    > /etc/apt/apt.conf.d/keep-cache

RUN --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt \
    apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
    zsh exa neofetch fd-find git wget \
        python3.9 python3.9-venv python3-pip \
         vim curl zip unzip p7zip patch locales  \
         build-essential tmux libpq-dev  libpq-dev highlight tmux libncurses-dev autoconf automake  \
         iputils-ping traceroute net-tools openssh-client && \
         apt-get autoremove && \
        update-alternatives --install /usr/bin/python3  python3 /usr/bin/python3.9 1 && \
        update-alternatives --install /usr/bin/python  python /usr/bin/python3.9 1 && \
        chsh -s /bin/zsh && \
        ln -s /bin/fdfind /bin/fd

# generate locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  dpkg-reconfigure --frontend=noninteractive locales && update-locale LANG=en_US.UTF-8

# python / pipx (for standalone installations)
RUN --mount=type=cache,target=$PIP_CACHE_DIR pip install pipx


# shell
FROM essentials as shell

ARG BUILDKIT_CACHE_DIR=/var/cache/buildkit
ARG ZINIT_CACHE_DIR=$BUILDKIT_CACHE_DIR/zinit
ARG FZF_CACHE_DIR=$BUILDKIT_CACHE_DIR/fzf
ARG PIP_CACHE_DIR=$BUILDKIT_CACHE_DIR/pip
ENV ZINIT_HOME=/opt/zinit
ENV ZDOTDIR=/etc/zsh
# without dot in /etc/zsh
ENV ZSHRC_NAME=zshrc

# zinit
RUN --mount=type=bind,target=/mnt,ro \
    --mount=type=cache,target=$ZINIT_CACHE_DIR \
    ZDOTDIR=/mnt/essentials ZINIT_HOME=$ZINIT_CACHE_DIR zsh -c "set -e ; \
        test -d $ZINIT_CACHE_DIR || \
        git clone https://github.com/zdharma/zinit.git $ZINIT_CACHE_DIR && \
        source /mnt/essentials/zinit_vars.zsh && \
        source $ZINIT_CACHE_DIR/zinit.zsh && zinit module build && \
        source /mnt/essentials/zshrc.zsh"

## fzf
#RUN --mount=type=bind,target=/mnt,ro \
#    --mount=type=cache,target=$FZF_CACHE_DIR \
#    zsh -c "set -e ; test -d $FZF_CACHE_DIR  || git clone --depth 1 https://github.com/junegunn/fzf.git $FZF_CACHE_DIR && \
#        cd $FZF_CACHE_DIR && patch -p0 < /mnt/essentials/fzf.patch ; \
#        cp -R $FZF_CACHE_DIR /opt"
#RUN /opt/fzf/install --all --no-fish --no-bash


#RUN --mount=type=cache,target=$ZINIT_CACHE_DIR \
#    $ZINIT_CACHE_DIR/install.sh
#

## adding shell files
#RUN --mount=type=bind,target=/mnt,ro \
#    cat /mnt/essentials/zinit_vars.zsh >> /etc/zsh/zshrc
#
## zinit initialization
#RUN --mount=type=bind,target=/mnt,ro \
#    cat /mnt/essentials/zinit.zsh >> /etc/zsh/zshrc

#
#RUN --mount=type=bind,target=/mnt,ro \
#        cat /mnt/essentials/zshrc.zsh >>  /etc/zsh/zshrc && \
#        cp /mnt/essentials/devenv_aliases.zsh /etc/zsh/ && \
#        cp /mnt/essentials/devenv_key_bindings.zsh /etc/zsh/
#
#RUN zsh -c "source /opt/zinit/bin/zinit.zsh && zinit compile --all"

CMD zsh


# cloud image
FROM essentials as cloud

# shellcheck disable=SC2046npx
RUN release=$(wget -O - https://storage.googleapis.com/kubernetes-release/release/stable.txt | cat -) && \
    cd /opt/bin && \
    wget https://storage.googleapis.com/kubernetes-release/release/$release/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl

RUN --mount=type=cache,target=$PIP_CACHE_DIR \
    pipx install azure-cli && \
    pipx install kube

RUN --mount=type=bind,target=/mnt,ro cat /mnt/cloud/zshrc.zsh >> /etc/zsh/zshrc

# native image
FROM essentials as native

RUN --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt \
    apt-get update && apt-get --no-install-recommends install -y \
        doxygen graphviz ccache gdb && \

RUN --mount=type=bind,target=/mnt,ro \
    --mount=type=cache,target=$PIP_CACHE_DIR \
    pipx inject conan && \
    pipx install ninja && \
    pipx install cmake

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
# assume ubuntu
#    sudo add-apt-repository ppa:longsleep/golang-backports
#    sudo apt update
#    sudo apt install golang-go
####
## rust
####
#FROM $BUNDLE_BASE as rust
#
#RUN --mount=type=cache,target=/root/.cargo \
#    sh -c $(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs) -y