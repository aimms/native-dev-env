## Development Images

### Essentials

Based on Ubuntu 20.04 LTS. Contains (as of _v1.7.1_):

- _zsh: 5.8_
- _tmux: 3.0_
- _curl: 7.68.0_
- _wget: 1.20.3_
- _vim: 8.1_
- _git: 2.25.1_
- _zip: 3.0_
- _neofetch: 7.0.0_
- _fd: 7.4.0_
- _python: 3.8.5_
- _pip: 20.2.4_
- _gcc: 9.3.0_

#### Usage

~~~
docker run -v$(pwd):/code -it aimmspro/devenv-essentials
info
~~~
 
### Native Development Environment

Based on _Essentials_ image. C++ development tools. Contains (as of _v1.7.1_):

- _doxygen: 1.8.17_
- _ccache: 3.7.7_
- _clang: 11.0.1_
- _clang-tidy: 11.0.1_
- _clang-format: 11.0.1_
- _gdb: 9.2_
- _cmake: 3.18.2_
- _conan: 1.31.0_
- _ninja: 1.10.0_

#### Usage

~~~
docker run -v$(pwd):/code -it aimmspro/devenv-native
info
~~~

### Cloud Image

Based on _Essentials_ image. Tuned for internal use.
Azure and Kubernetes Focused image. Contains (as of _v1.7.1_)

- _az: 2.14.2_
- _terraform: 0.12.28_
- _kubectl_
- _kube_ (_pip install kube-cli_)

#### Usage
 
~~~
docker run -v$(pwd):/code -it aimmspro/devenv-cloud
info
~~~

### Extras

##### Extended colors support

set `TERM=xterm-256color`
e.g.:

~~~
 docker run --rm -e TERM=xterm-256color  -it aimmspro/devenv-native
~~~

##### Disable zsh plugins

set `DEVENV_LIGHTWEIGHT=1`
e.g.:

~~~
 docker run --rm -e DEVENV_LIGHTWEIGHT=1  -it aimmspro/devenv-native
~~~

## Building images

#### Using Buildah

Make sure _buildah_ is installed: https://buildah.io

~~~
./build_env.sh <version> [--upload] [--rootless] [--use_cache]
~~~

e.g.:

~~~
./build_env.sh 1.7.1 --rootless
~~~

##### CLI Options
###### --rootless

By default `build_env.sh` builds using _buildah_ `chroot` isolation.
However, `--rootless` switches to rootless isolation. e.g.:

###### --upload
Tries to upload the image to container registry. e.g.:

###### --use_cache

Debug option. Enables layered builds

 

#### Container build

Using Fedora _buildah_ image. The process will run _buildah_ from inside a container

Resulting images will be available from host. Make sure `fuse-overlayfs` is installed on host
and `/dev/fuse` device is available

~~~
./container_build.sh <version> [--upload]
~~~
e.g.
~~~
./container_build.sh 1.7.1
~~~

#### Container build without sharing host /dev/fuse

~~~
mkdir -p ~/.local/share/containers
docker run --privileged -v ~/.local/share/containers:/var/lib/containers -v $(pwd):/code  quay.io/buildah/stable /bin/bash -c 'cd /code && ./build.sh <version>'
# e.g.: docker run --privileged -v ~/.local/share/containers:/var/lib/containers -v $(pwd):/code  quay.io/buildah/stable /bin/bash -c 'cd /code && ./build.sh 1.6'
~~~

#### Podman / Docker

Not supported. TODO: implement compatibility

#### Windows Build using Docker

TODO: WIP. unsupported for now; needs Windows 10 + WSL to be configured properly OR falling back to Docker build should be implemented
