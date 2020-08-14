FROM aimmspro/devenv-essentials:latest

RUN curl https://pyenv.run | bash
ENV PYTHON_VERSION 3.8.5
RUN zsh -c "LLVM_PROFDATA=/usr/bin/llvm-profdata-10 CONFIGURE_OPTS=--enable-optimizations ~/.pyenv/bin/pyenv install $PYTHON_VERSION --verbose"

COPY setup.zsh /tmp/setup.zsh
RUN /tmp/setup.zsh
RUN rm -f /tmp/setup.zsh

CMD zsh
