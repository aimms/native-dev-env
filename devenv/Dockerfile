ARG FROM_IMAGE=essentials:latest
FROM $FROM_IMAGE

COPY setup.zsh /tmp/setup.zsh
RUN /usr/bin/zsh -c /tmp/setup.zsh

CMD zsh
