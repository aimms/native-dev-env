# syntax=docker/dockerfile:experimental

# essentials
FROM ubuntu:20.10 as essentials

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ="Europe/Amsterdam"
ENV GIT_EDITOR=vim
ENV LANG=en_US.utf8
ENV LC_ALL=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV TERM=xterm

# https://vsupalov.com/buildkit-cache-mount-dockerfile/
RUN rm -f /etc/apt/apt.conf.d/docker-clean

RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update && apt-get upgrade -y && \
    apt-get --no-install-recommends install -y git highlight pcre2-utils zsh \
    python3.9 python3.9-venv python3.9-dev python3-pip libpython3.9-dev  \
    build-essential tmux vim wget curl zip unzip locales libpq-dev neofetch fd-find dos2unix \
    iputils-ping traceroute net-tools openssh-client sudo && \
    rm -rf /var/lib/apt/lists/* && \
    update-alternatives --install /usr/bin/python3  python3 /usr/bin/python3.9 1 && \
    update-alternatives --install /usr/bin/python  python /usr/bin/python3.9 1

RUN chsh -s /bin/zsh
RUN ln -s /bin/fdfind /bin/fd

# generate locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  dpkg-reconfigure --frontend=noninteractive locales && update-locale LANG=en_US.UTF-8

#fzf; config is embedded into .zshrc.zsh
RUN --mount=type=cache,target=/usr/local/fzf \
    git clone --depth 1 https://github.com/junegunn/fzf.git /usr/local/fzf && \
        /usr/local/fzf/install --no-bash --no-fish --no-zsh

# antigen
RUN --mount=type=cache,target=/root/.antigen.zsh curl -L git.io/antigen > /root/.antigen.zsh

# host mount using new BuildKit feture
# install .zshrc.zsh stuff
RUN --mount=type=bind,target=/tmp \
    zsh -c 'autoload -U zmv && noglob zmv -W -C /tmp/essentials/.* /root/.*' && cd /root && mv .zshrc.zsh .zshrc

# init; ensure theme support is installed; update pip
RUN --mount=type=cache,target=/root/.cache TERM=xterm-256color zsh -ci 'pip install -U pip wheel setuptools'

CMD zsh

# cloud
FROM essentials as cloud

# shellcheck disable=SC2046npx
RUN --mount=type=cache,target=/usr/bin/kubectl \
    release=$(wget -O - https://storage.googleapis.com/kubernetes-release/release/stable.txt | cat -) && \
    wget https://storage.googleapis.com/kubernetes-release/release/$release/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/bin/kubectl

RUN zsh -ci 'venv /tools && pip install -r /install/tools.txt && \
             venv /devenv && pip install -r /install/devenv.txt'

RUN --mount=type=bind,target=/tmp \
    cat /tmp/cloud/.zshrc.zsh >> /root/.zshrc



