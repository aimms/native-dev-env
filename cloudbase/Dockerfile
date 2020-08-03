FROM aimmspro/native-devenv-essentials:latest

RUN apt update
RUN apt install -y dos2unix
COPY setup.zsh /tmp/setup.zsh
RUN zsh -c /tmp/setup.zsh
RUN rm -rf /tmp/*

CMD zsh
