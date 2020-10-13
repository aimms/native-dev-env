ARG VERSION=latest
FROM aimmspro/devenv-native-base:$VERSION

RUN cat /assets/.bashrc_utils >> /root/.bashrc
RUN cat /assets/.bashrc_native >> /root/.bashrc

RUN bash -c 'source /root/.bashrc && c dev && pyenv global dev && \
            pip install conan ninja cmake && \
            ln -s /usr/local/pyenv/shims/cmake /usr/bin/cmake'

# allowing conan to use latest clang
RUN mkdir -p /root/.conan && \
    cp /assets/conan_settings.yml /root/.conan/settings.yml
