ARG IMG_TAG=latest
FROM aimmspro/native-devenv:${IMG_TAG}

COPY conan_profiles /tmp/conan_profiles
COPY conanfile.txt /tmp/conanfile.txt
COPY install_dependencies.sh /tmp/install_dependencies.sh

RUN zsh -c "source ~/.zshrc && cd /tmp && ./install_dependencies.sh"
RUN rm -rf /tmp/*
