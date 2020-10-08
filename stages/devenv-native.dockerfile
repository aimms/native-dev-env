ARG VERSION=latest
FROM aimmspro/devenv-native-base:$VERSION

RUN bash -c 'source /root/.bashrc && c dev && pyenv global dev && \n\
            pip install conan ninja cmake && \n\
            ln -s /usr/local/pyenv/shims/cmake /usr/bin/cmake'

# allowing conan to use latest clang
RUN mkdir -p /root/.conan && \
    cp /assets/conan_settings.yml /root/.conan/settings.yml

