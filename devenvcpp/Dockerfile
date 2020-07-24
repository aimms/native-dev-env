ARG FROM_IMAGE=devenv:latest
FROM $FROM_IMAGE

COPY app /demoapp
RUN zsh -c /app/demoapp/build.sh