ARG VERSION=latest
FROM aimmspro/devenv-ext-shell:$VERSION

RUN apt update && apt install -y --no-install-recommends gnupg ca-certificates

# add latest clang / llvm repo
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN echo 'deb http://apt.llvm.org/focal/ llvm-toolchain-focal-11 main' >> /etc/apt/sources.list && \
    echo 'deb-src http://apt.llvm.org/focal/ llvm-toolchain-focal-11 main' >> /etc/apt/sources.list

# installing dev tools
RUN apt update && apt install -y --no-install-recommends \
      make autoconf automake doxygen graphviz ccache \
      llvm-11 clang-format-11 clang-tidy-11 clang-tools-11 clang-11 clangd-11 libc++-11-dev \
      libc++1-11 libc++abi-11-dev libc++abi1-11 libclang1-11 lld-11 llvm-11-runtime llvm-11 && \
      /install/update_alternatives.sh 11 100

RUN apt autoremove -y && rm -rf /var/lib/apt/lists/*
