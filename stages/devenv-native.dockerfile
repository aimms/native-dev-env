ARG VERSION=latest
FROM aimmspro/devenv-native-base:$VERSION

RUN cat /assets/.zshrc-native.zsh >> /root/.zshrc

RUN zsh -c 'source ~/.zshrc && \
             c dev && pyenv global dev && \
             pip install --use-feature=2020-resolver \
                conan \
                ninja \
                cmake && \
             ln -s /usr/local/pyenv/shims/cmake /usr/bin/cmake'

# allowing conan to use latest clang
RUN mkdir -p /root/.conan && \
    cp /assets/conan_settings.yml /root/.conan/settings.yml
