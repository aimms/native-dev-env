# Development Environment for native code from AIMMS

The environment is _Ubuntu 20.04 LTS_ based.

Tools installed:

 * _curl: 7.68.0_
 * _vim: 8.1_
 * _git: 2.25.1_
 * _tmux: 3.0a_
 * _zsh: 5.8_
 * _clang: 10.0.0_
 * _rustc 1.45.0_
 * _pyenv: 1.2.20_
 * _cmake: 3.18.0_
 * _conan: 1.27.1_
 * _ninja: 1.10.0_
 * _azure-cli: 2.9.1_

## Prerequisites

_Docker_: https://www.docker.com

## Building
 
~~~~
./build_env.sh
~~~~

## Using

~~~~
docker run -v`pwd`:/code -it aimmspro/native-devenv:latest
~~~~