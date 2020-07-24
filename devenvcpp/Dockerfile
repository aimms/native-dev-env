ARG FROM_IMAGE=devenv:latest
FROM $FROM_IMAGE

COPY app /app
RUN zsh -c "source ~/.zshrc && cd /app && ./build.sh"
