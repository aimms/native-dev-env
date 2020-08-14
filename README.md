# Development Environment for native code

_Ubuntu 20.04 LTS_ based; tools installed:

 * _clang 10.0.0+_
 * _build-essential_
 * _curl: 7.68.0+_
 * _vim: 8.1+_
 * _git: 2.25.1+_
 * _tmux: 3.0a+_
 * _zsh: 5.8+_
 * _openssh server: 8.2p1+_
 * _rsync 3.1.3_
 * _clang: 10.0.0+_
 * _rustc 1.45.2+_
 * _pyenv: 1.2.20+_
 * _python 3.8.5+_
 * _cmake: 3.18.0+_
 * _conan: 1.27.1+_
 * _ninja: 1.10.0+_
 * _azure-cli: 2.9.1+_

## Prerequisites

_Docker_: https://www.docker.com

## Using

### Basic
~~~~
docker run -v`pwd`:/code -it aimmspro/devenv-native
~~~~
### With zsh plugins and coloring

Using https://github.com/ohmyzsh/ohmyzsh

~~~~
docker run -v`pwd`:/code -it aimmspro/devenv-native-ohmyzsh
~~~~

## Building locally
 
~~~~
./build_env.sh <version> [--upload]
~~~~
