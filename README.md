## Development Images

Release v1.8

### Essentials
 
There is base layer for all the images called `essentials`.

It's based on `Ubuntu 20.10` and contains the following tools:

- `zsh` as shell
- `git`
- `python 3.9+` + `venv` + `pip`
- `Ubuntu `build-essential` package (includes `gcc-10`)
- `tmux` 
- `vim` 
- `wget` 
- `curl`
- `zip / unzip` 
- `neofetch` 
- `fd-find` 


#### Extra

These tools are always built as the part of `essentials` phase, but they can be
switched off in runtime using `DEVENV_LIGHTWEIGH=1` var definition (see `Usage` section).

- `fzf`
- `antigen` as `zsh` plugin manager with plugins:
    - `zsh-users/zsh-syntax-highlighting`
    - `zsh-users/zsh-completions`
    - `zsh-users/zsh-autosuggestions`
    - `copybuffer`
    - `copyfile`
    - `encode64`
    - `zsh_reload`
    - `fzf`
    - `fd`
    - `zsh-interactive-cd`
    - `tmux`
    - `sudo`
    - `python`
    - `pip`
    - `history`
    - `history-substring-search` 
    - theme: `jackharrisonsherlock/common`

### Development Images

#### devenv-cloud
based on `essentials`.

Contains:
- `azure-cli`
- `kube-cli`

#### devenv-native
based on `essentials` (configurable to `cloud`).

Contains:

- `cmake`
- `conan`
- `ninja`
- `clang-format`
- `clang-tidy`
- `gdb`

#### devenv-native-ssh-server
based on `devenv-native` image.

Contains:

- `openssh-server`
- `rsync`
- `gdbserver`


#### devenv-go
based on `essentials`. Contains `golang` compiler

#### devenv-rust
based on `essentials`. Contains `rustc` compiler and `cargo`

### Bundled images

There are also way of bundling images together. See 

- based on `essentials`
  - `devenv-go-bundle` image is `devenv-native` plus `devenv-go`
  - `devenv-ultimate-bundle` image is `devenv-native` plus `devenv-go` and `devenv-rust`

- based on `cloud`
  - `devenv-cloud-go-bundle` image is `devenv-native` plus `devenv-go`
  - `devenv-cloud-ultimate-bundle` image is `devenv-native` plus `devenv-go` and `devenv-rust`


#### Usage

All the images are hosted at `Docker Hub` and can be run directly:

```
docker run -v $(pwd):/code -it aimmspro/devenv-<image name>
```

Run inside the container

```
info
```

##### Visuals

To enable maximum visual features use `TERM=xterm-256color` var definition:
```
docker run -e TERM=xterm-256color -v $(pwd):/code -it aimmspro/devenv-<image name>
```

##### Lightweight Mode

`antigen` plugins for `zsh` as well as `zsh` theme takes time to load. To disable this
when not needed use `DEVENV_LIGHTWEIGHT=1` var definition:

```
docker run -e DEVENV_LIGHTWEIGHT=1 -v $(pwd):/code -it aimmspro/devenv-<image name>
```

### Build

#### Prerequisites
latest `Docker` with integrated `buildkit` support:
  - `Dockerfile` `v1.2`
  - `cache mounts`
  - `bind mounts` to mount directories from host

#### BuildKit Cache
`buildkit cache` is extensively used during build as it significantly speeds up process. But, if something goes wrong,
cache should be manually dropped:

```
docker builder prune -af
```
optionally, faulty images may be deleted with `docker rmi -f`, as usual.

####

