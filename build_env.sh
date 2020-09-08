#!/usr/bin/env bash

if [[ $# -lt 1 || "$1" == "-h" || "$1" == "--help" || ( $# -eq 2 && "$2" != "--upload" ) || $# -gt 2  ]]; then
    echo "Usage: $0 <version>"
    exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

os=ubuntu:20.04
container=build

prefix=aimmspro/devenv
img_essentials=$prefix-essentials
img_cloud=$prefix-cloud
img_cloud_theming=$prefix-cloud-theming

img_native=$prefix-native
img_build=$prefix-build
img_native_theming=$prefix-native-theming

b_echo(){
  # shellcheck disable=SC2145
  echo "[build_env] $@"
}

maybe_create(){
  container=$1
  image=$2

  if [ -e $container_exists ]; then
    b_echo "(Re)creating container: $container from: $image"
    buildah rm $container 2> /dev/null
    container=$(buildah from --name $container $image)
    container_exists=1
  else
    b_echo "Using existing container: $container"
  fi
  echo "$container"
}

image_exists(){
  if [ "$(buildah images --format '{{.Name}}' | grep $1)" != "" ]; then
    echo 1
  else
    echo 0
  fi
}

pushd $script_dir || exit

# shellcheck disable=SC2046
if [ $(image_exists $img_essentials) -eq 0 ]; then
  maybe_create $container $os

  buildah config --env DEBIAN_FRONTEND=noninteractive $container
  buildah config --env GIT_EDITOR=vim $container
  buildah config --env PYENV_VIRTUALENV_DISABLE_PROMPT=1 $container
  buildah config --entrypoint /bin/zsh $container
  buildah config --env LANG=en_US.utf8 $container
  buildah config --env LC_ALL=en_US.UTF-8 $container
  buildah config --env LANGUAGE=en_US:en $container
  buildah config --entrypoint "/usr/bin/zsh" $container

  buildah unshare ./buildah_run_in_chroot.sh $container ./assets/fakeroot_mknod.sh
  buildah unshare ./buildah_run_in_chroot.sh $container ./assets/essentials.sh

  buildah commit $container $img_essentials
fi

# shellcheck disable=SC2046
if [ $(image_exists $img_native) -eq 0 ]; then
  maybe_create $container $img_essentials

  buildah unshare ./buildah_run_in_chroot.sh $container ./assets/native.zsh

  buildah commit $container $img_native
fi


## shellcheck disable=SC2046
#if [ $(image_exists $img_cloud) -eq 0 ]; then
#  maybe_create $container $img_essentials
#
#  buildah copy --chown root $container $script_dir/assets/cloud.zsh /tmp/
#  b /tmp/cloud.zsh && rm -f /tmp/cloud.zsh
#  buildah commit $container $img_cloud
#fi

#
#  b apt install -y --no-install-recommends doxygen graphviz ccache wget gnupg \
#    lsb-release software-properties-common make autoconf automake
#  b bash -c 'curl https://apt.llvm.org/llvm.sh | bash'
#  b apt install -y --no-install-recommends libc++-dev libc++abi-dev clang-tidy-11
#  b update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-11 100
#  b update-alternatives --install /usr/bin/clang clang /usr/bin/clang-11 100
#  b update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-11 100
#  b update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100
#  b update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100
#  b update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-11 100
#
#  b rm -rf /var/lib/apt/lists/*
#  b apt remove -y software-properties-common
#  b apt autoclean
#
#  buildah copy --chown root $container $script_dir/assets/native.zsh /tmp/
#  b /tmp/native.zsh && rm -f /tmp/native.zsh
#
#  buildah commit $container $img_native
#fi
#
## shellcheck disable=SC2046
#if [ $(image_exists $img_build) -eq 0 ]; then
#  maybe_create $container $img_native
#
#  b apt install -y --no-install-recommends openssh-server gdb rsync sudo
#
#  b mkdir -p /var/run/sshd
#
#  b bash -c 'echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && ssh-keygen -A'
#  buildah config --port 22 $container
#
#  b bash -c 'useradd -m -d /home/builderboy -s /bin/bash -G sudo builderboy && echo "builderboy:builderboy" | chpasswd && \
#          sed -i /etc/sudoers -re "s/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g" && \
#          sed -i /etc/sudoers -re "s/^root.*/root ALL=(ALL:ALL) NOPASSWD: ALL/g" && \
#          sed -i /etc/sudoers -re "s/^#includedir.*/## **Removed the include directive** ##/g" && \
#          echo "foo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'
#
#  buildah config --entrypoint "/usr/sbin/sshd -D" $container
#  buildah commit $container $img_build
#fi

# shellcheck disable=SC2046
#if [ $(image_exists $img_cloud_theming) -eq 0 ]; then
#  maybe_create $container $img_cloud
#
#  buildah copy --chown root $container $script_dir/assets /tmp
#  b /tmp/theming.zsh && rm -f /tmp/*
#  buildah commit $container $img_cloud_theming
#fi

#ARG BASE
#FROM aimmspro/devenv-$BASE:latest
#
#ENV TERM=xterm-256color
#ENV ENABLE_THEMING=YES
#
#COPY ../assets/logo.py /root/.logo.py
#COPY MesloLGS* /usr/share/fonts/truetype/
#RUN fc-cache -vf
#COPY ../assets/.p10k.zsh /root/
#COPY ../assets/theming.zsh /tmp/setup.zsh
#RUN /tmp/setup.zsh && rm -f /tmp/setup.zsh
#RUN zsh -c "source ~/.zshrc && info"
#
#CMD zsh

popd || exit # script_dir
