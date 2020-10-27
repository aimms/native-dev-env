# Development Environment for native code


## Using

### Native Image

~~~~
docker run -v$(pwd):/code -it aimmspro/devenv-native
info
v
~~~~

### Cloud Image

~~~~
docker run -v$(pwd):/code -it aimmspro/devenv-cloud
info
v
~~~~

## Building locally 

### Using Buildah https://buildah.io
 
~~~~
./build_env.sh <version> [--upload]
~~~~

### Container build using Docker or Podman https://podman.io

~~~~
mkdir -p ~/.local/share/containers
docker run --privileged -v ~/.local/share/containers:/var/lib/containers -v $(pwd):/code  quay.io/buildah/stable /bin/bash -c 'cd /code && ./build.sh test'
~~~~

### Windows Build using Docker

TODO: unsupported for now; needs Windows 10 + WSL to be configured properly 
TODO: or falling back to Docker build (over buildah) should be implemented
