FROM aimmspro/native-devenv-base:latest

RUN apt update
RUN apt install -y zsh vim tmux
RUN apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils libffi-dev liblzma-dev python-openssl git zip
RUN apt install -y clang-10 libc++-dev libc++abi-dev && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-10 100 && \
    update-alternatives --install /usr/bin/clang clang /usr/bin/clang-10 100 && \
    update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100 && \
    update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
ENV CC clang
ENV CXX clang++

CMD zsh
