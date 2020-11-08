FROM ubuntu:20.04

ENV PYTHON_VERSION=3.9.0
ENV PYTHON_VERSION_MAJOR=3.9
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends build-essential libssl-dev zlib1g-dev libbz2-dev \
    ca-certificates gnupg libreadline-dev libsqlite3-dev wget  libncurses5-dev libncursesw5-dev libgdbm-dev  \
    xz-utils tk-dev libffi-dev liblzma-dev checkinstall locales

# generate locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  dpkg-reconfigure --frontend=noninteractive locales && update-locale LANG=en_US.UTF-8

RUN cd /usr/src && wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz && \
    tar xvf Python-$PYTHON_VERSION.tgz

RUN export MAKE_OPTS=-j$(nproc --all) && \
    export CFLAGS="-march=native -O3 -pipe -flto -ffat-lto-objects" && \
    export LDFLAGS="-fuse-ld=gold -fuse-linker-plugin" && \
    cd /usr/src/Python-$PYTHON_VERSION && \
    ./configure --enable-shared --enable-optimizations --with-computed-gotos && \
    make altinstall

RUN  update-alternatives --install /usr/local/bin/python3 python3 /usr/local/bin/python$PYTHON_VERSION_MAJOR 100
RUN  update-alternatives --install /usr/local/bin/python python /usr/local/bin/python$PYTHON_VERSION_MAJOR 100
RUN  update-alternatives --install /usr/local/bin/pip3 pip3 /usr/local/bin/pip$PYTHON_VERSION_MAJOR 100
RUN  update-alternatives --install /usr/local/bin/pip pip /usr/local/bin/pip$PYTHON_VERSION_MAJOR 100

RUN ldconfig

RUN pip install -U pip wheel setuptools

RUN rm -rf /usr/src/* && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/*
