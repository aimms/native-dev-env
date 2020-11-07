FROM ubuntu:20.04

ENV PYTHON_VERSION=3.9.0
ENV PYTHON_VERSION_MAJOR=3.9
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends checkinstall ca-certificates build-essential \
    libreadline-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libbz2-dev wget

RUN cd /usr/src && wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz && \
    tar xvf Python-$PYTHON_VERSION.tgz

RUN export MAKE_OPTS=-j16 && \
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
    apt autoremove -y && rm -rf /var/lib/apt/lists/*
