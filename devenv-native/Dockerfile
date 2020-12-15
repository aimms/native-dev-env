ARG VERSION=latest
FROM aimmspro/devenv-essentials:$VERSION

ENV TERM="xterm"
ENV LLVM_VERSION=11

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates gnupg

# add latest clang / llvm repo
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -

RUN echo "deb http://apt.llvm.org/focal/ llvm-toolchain-focal-$LLVM_VERSION main" >> /etc/apt/sources.list && \
    echo "deb-src http://apt.llvm.org/focal/ llvm-toolchain-focal-$LLVM_VERSION main" >> /etc/apt/sources.list

# installing dev tools
RUN apt-get update && apt-get install -y --no-install-recommends \
      autoconf automake doxygen graphviz ccache gdb \
      llvm-$LLVM_VERSION clang-format-$LLVM_VERSION clang-tidy-$LLVM_VERSION \
      clang-tools-$LLVM_VERSION clang-$LLVM_VERSION clangd-$LLVM_VERSION libc++-$LLVM_VERSION-dev \
      libc++1-$LLVM_VERSION libc++abi-$LLVM_VERSION-dev libc++abi1-$LLVM_VERSION libclang1-$LLVM_VERSION \
      lld-$LLVM_VERSION llvm-$LLVM_VERSION-runtime llvm-$LLVM_VERSION && \
      /install/update_alternatives.sh $LLVM_VERSION 100

# install .zshrc stuff
RUN cat /install/.zshrc.zsh >> /root/.zshrc
RUN mkdir -p /root/.conan && cp /install/conan_settings.yml /root/.conan/settings.yml

RUN pip install -r /install/native.txt

RUN apt-get autoremove -y && rm -rf /var/lib/apt/lists/*