# Development Environment for native code

The environment is _Ubuntu 20.04 LTS_ based.
The environment consist of several images. End user should use either _devenv_ or _devenv-cpp_ images

#### Basic [devenv]
  - _build-essential_ package
  - tools: _curl_, _vim_, _git_, tmux, _zsh_ with plugins
  - _llvm/clang 10.0.0_
  - _rust_ latest
  - _pyenv_ latest
  - _cmake_ latest
  - _conan_
  - _ninja_
  - _Azure_ cli
  - _Kubernetes_ cli (_kubectl_)

#### with pre-build Boost [devenv-cpp]
  - contains everything from [devenv]
  - _boost 1.73.0_ [debug and release builds]
  - _conan profiles_

## Building

Docker is required. Building image with pre-build boost (devenv-cpp) is optional. Run 
~~~~
./build_env.sh [--build-devenv-cpp]
~~~~

result images will be:

~~~~
aimmspro/native-devenv-base:latest
aimmspro/native-devenv-essentials:latest
aimmspro/native-devenv:latest
~~~~

## Using

~~~~
docker run -v`pwd`:/code -it aimmspro/native-devenv:latest
~~~~

## Shortcuts to use Python virtual environments

This image uses _pyenv_ to install Python environments to avoid 'dependency hell'. E.g., it contains both Conan and Azure
which use different versions of dependencies. There are zsh aliases to handle pyenv

1. creates and activates new _pyenv_ environment and updates _pip3_ to the latest version
~~~~
c <pyenv environment name> 
~~~~

2. activates _pyenv_ environment with the name given
~~~~
a <pyenv environment name> 
~~~~

2. shows _pyenv_ environments installed
~~~~
v
~~~~



