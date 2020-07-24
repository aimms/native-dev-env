ARG FROM_IMAGE=devenv:latest
FROM $FROM_IMAGE

COPY app /exampleapp
RUN zsh -c /app/exampleapp/build.sh