FROM ubuntu:20.04
# https://askubuntu.com/questions/909277/avoiding-user-interaction-with-tzdata-when-installing-certbot-in-a-docker-contai
ENV TZ=Europe/Amsterdam
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezon

RUN apt update

RUN apt install -y zsh vim tmux
RUN apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils libffi-dev liblzma-dev python-openssl git zip openssh-server rsync
RUN apt install -y clang-10 libc++-dev libc++abi-dev && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-10 100 && \
    update-alternatives --install /usr/bin/clang clang /usr/bin/clang-10 100 && \
    update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100 && \
    update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y
ENV CC clang
ENV CXX clang++

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

RUN curl https://pyenv.run | bash
ENV PYTHON_VERSION 3.8.5
RUN zsh -c "LLVM_PROFDATA=/usr/bin/llvm-profdata-10 CONFIGURE_OPTS=--enable-optimizations ~/.pyenv/bin/pyenv install $PYTHON_VERSION --verbose"

COPY setup.zsh /tmp/setup.sh
RUN /tmp/setup.sh $PYTHON_VERSION
RUN rm -f /tmp/setup.zsh

CMD zsh
