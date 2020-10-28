ARG VERSION=latest
FROM aimmspro/devenv-native-base:$VERSION

RUN pipx install conan && \
    pipx install ninja && \
    pipx install cmake

RUN cat /assets/.zshrc-info.zsh >> /root/.zshrc
RUN cat /assets/.zshrc-native.zsh >> /root/.zshrc

# allowing conan to use latest clang
RUN mkdir -p /root/.conan && \
    cp /assets/conan_settings.yml /root/.conan/settings.yml
