ARG FROM_IMAGE=base:latest
FROM $FROM_IMAGE

RUN apt update -y
RUN apt upgrade -y
RUN apt install -y curl git zsh vim
RUN apt install -y build-essential
RUN apt install -y libssl-dev libbz2-dev zlib1g-dev libreadline-dev libsqlite3-dev
RUN apt install -y clang-10 libc++-dev libc++abi-dev && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-10 100 && \
    update-alternatives --install /usr/bin/clang clang /usr/bin/clang-10 100

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y

RUN curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

COPY setup.zsh /tmp/setup.sh
RUN /usr/bin/zsh -c /tmp/setup.sh
CMD zsh
