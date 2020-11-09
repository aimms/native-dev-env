## Development Environment for native code

TODO: make the README.md more verbose


### Using

#### Native Image

~~~
docker run -v$(pwd):/code -it aimmspro/devenv-native
info
v
~~~

#### Cloud Image

~~~
docker run -v$(pwd):/code -it aimmspro/devenv-cloud
info
v
~~~

#### Extended colors support

set `TERM` to `TERM=xterm-256color`.
e.g.:

~~~
 docker run --rm -e TERM=xterm-256color  -it aimmspro/devenv-native
~~~

### Building locally 

#### Using Buildah

Make sure buildah is installed https://buildah.io
 
~~~
./build_env.sh <version> [--upload]
~~~
e.g.
~~~
./build_env.sh 1.6
~~~

#### Rootless build using fuse-overlayfs

Resulting images will be available from host. Make sure `fuse-overlayfs` is installed on host
and `/dev/fuse` device is available

~~~
./container_build.sh <version> [--upload]
~~~
e.g.
~~~
./container_build.sh 1.6
~~~

#### Rootless build without sharing host /dev/fuse

~~~
mkdir -p ~/.local/share/containers
docker run --privileged -v ~/.local/share/containers:/var/lib/containers -v $(pwd):/code  quay.io/buildah/stable /bin/bash -c 'cd /code && ./build.sh <version>'
# e.g.: docker run --privileged -v ~/.local/share/containers:/var/lib/containers -v $(pwd):/code  quay.io/buildah/stable /bin/bash -c 'cd /code && ./build.sh 1.6'
~~~

#### Windows Build using Docker


TODO: WIP. unsupported for now; needs Windows 10 + WSL to be configured properly OR falling back to Docker build should be implemented
