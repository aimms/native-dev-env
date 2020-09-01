ARG BASE
FROM aimmspro/devenv-$BASE:latest

ENV TERM=xterm-256color
ENV ENABLE_THEMING=YES

COPY MesloLGS* /usr/share/fonts/truetype/
RUN fc-cache -vf
COPY .p10k.zsh /root/
COPY setup.zsh /tmp/setup.zsh
RUN /tmp/setup.zsh && rm -f /tmp/setup.zsh
CMD zsh
