# syntax=docker/dockerfile:1.2

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
    apt-get update && apt-get upgrade && apt-get --no-install-recommends install -y \
        git highlight pcre2-utils zsh \
        python3.9 python3.9-venv python3.9-dev python3-pip libpython3.9-dev  \
        build-essential tmux vim wget curl zip unzip locales libpq-dev neofetch fd-find && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python3  python3 /usr/bin/python3.9 1 && \
    update-alternatives --install /usr/bin/python  python /usr/bin/python3.9 1

RUN chsh -s /bin/zsh
RUN ln -s /bin/fdfind /bin/fd

# generate locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  dpkg-reconfigure --frontend=noninteractive locales && update-locale LANG=en_US.UTF-8

#fzf; config is embedded into .zshrc.zsh
RUN git clone --depth=1 https://github.com/junegunn/fzf.git /usr/local/fzf && \
    /usr/local/fzf/install --no-bash --no-fish --no-zsh

# antigen
RUN curl -L git.io/antigen > /root/.antigen.zsh

# host mount using new BuildKit feture
# install .zshrc.zsh stuff
RUN --mount=type=bind,target=/tmp \
    zsh -c 'autoload -U zmv && noglob zmv -W -C /tmp/essentials/.* /root/.*' && cd /root && mv .zshrc.zsh .zshrc

# init; ensure theme support is installed; update pip
RUN --mount=type=cache,target=/root/.cache TERM=xterm-256color zsh -ci 'pip install -U pip wheel setuptools'

CMD zsh

# cloud image
FROM essentials as cloud

RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update && apt-get --no-install-recommends install -y \
        iputils-ping traceroute net-tools openssh-client dos2unix && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# shellcheck disable=SC2046npx
RUN release=$(wget -O - https://storage.googleapis.com/kubernetes-release/release/stable.txt | cat -) && \
    wget https://storage.googleapis.com/kubernetes-release/release/$release/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/bin/kubectl

RUN --mount=type=bind,target=/tmp \
    zsh -ci 'venv /tools && pip install -r /tmp/cloud/tools.txt && \
             venv /devenv && pip install -r /tmp/cloud/devenv.txt'

RUN --mount=type=bind,target=/tmp cat /tmp/cloud/.zshrc.zsh >> /root/.zshrc

# native image
FROM essentials as native

RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update && apt-get --no-install-recommends install -y \
        autoconf automake doxygen graphviz ccache gdb && \
    rm -rf /var/lib/apt/lists/*

RUN --mount=type=cache,target=/root/.cache --mount=type=bind,target=/tmp \
    pip install -r /tmp/native/native.txt

# native-server
FROM native as native-server
ENV BUILD_USER=builderboy

RUN --mount=type=cache,target=/var/cache/apt \
       apt-get update && apt-get install -y --no-install-recommends \
       openssh-server rsync gdbserver sudo && \
       apt-get autoremove -y && \
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

