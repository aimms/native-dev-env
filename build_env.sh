#!/usr/bin/env bash



script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

./buildah_run_in_chroot

pfx=aimmspro/devenv
img_essentials=$pfx-essentials
img_cloud=$pfx-cloud
img_cloud_theming=$pfx-cloud-theming

img_native=$pfx-native
img_build=$pfx-build
img_native_theming=$pfx-native-theming

echo '[build] Creating container'
buildah

# essentials
container=build
#buildah rm $container 2> /dev/null

b(){
  # shellcheck disable=SC2068
  buildah run --runtime /usr/bin/crun $container -- "$@"
}

image_exists(){
  if [ "$(buildah images --format '{{.Name}}' | grep $1)" != "" ]; then
    echo 1
  else
    echo 0
  fi
}

maybe_create(){
  if [ -e $no_container ]; then
    buildah from --name $1 $2
    no_container=1
    echo "Created container: $1 from image: $2"
  fi
}


# shellcheck disable=SC2046
if [ $(image_exists $img_essentials) -eq 0 ]; then
  maybe_create $container ubuntu:20.04

  buildah config --env DEBIAN_FRONTEND=noninteractive $container
  buildah config --env GIT_EDITOR=vim $container
  buildah config --env PYENV_VIRTUALENV_DISABLE_PROMPT=1 $container
  buildah config --entrypoint /bin/zsh $container
  buildah config --env LANG=en_US.utf8 $container
  buildah config --env LC_ALL=en_US.UTF-8 $container
  buildah config --env LANGUAGE=en_US:en $container

  b apt update
  b apt upgrade -y

  b apt install -y --no-install-recommends \
    zsh vim tmux wget curl fontconfig git zip unzip git ca-certificates \
    python-is-python3 python3-venv locales

  b bash -c 'sed -i -e "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8'


  b rm -rf /var/lib/apt/lists/*

  b bash -c 'curl https://pyenv.run | bash'

  buildah copy --chown root $container $script_dir/assets/.zshrc /root/.zshrc
  b zsh -c 'source ~/.zshrc ; pyenv global system'

  buildah commit $container $img_essentials
fi

# shellcheck disable=SC2046
if [ $(image_exists $img_cloud) -eq 0 ]; then
  maybe_create $container $img_essentials

  buildah copy --chown root $container $script_dir/assets/cloud.zsh /tmp/
  b /tmp/cloud.zsh && rm -f /tmp/cloud.zsh
  buildah commit $container $img_cloud
fi

# shellcheck disable=SC2046
if [ $(image_exists $img_native) -eq 0 ]; then
  maybe_create $container $img_cloud

  b apt install -y --no-install-recommends doxygen graphviz ccache wget gnupg \
    lsb-release software-properties-common make autoconf automake
  b bash -c 'curl https://apt.llvm.org/llvm.sh | bash'
  b apt install -y --no-install-recommends libc++-dev libc++abi-dev clang-tidy-11
  b update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-11 100
  b update-alternatives --install /usr/bin/clang clang /usr/bin/clang-11 100
  b update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-11 100
  b update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100
  b update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100
  b update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-11 100

  b rm -rf /var/lib/apt/lists/*
  b apt remove -y software-properties-common
  b apt autoclean

  buildah copy --chown root $container $script_dir/assets/native.zsh /tmp/
  b /tmp/native.zsh && rm -f /tmp/native.zsh

  buildah commit $container $img_native
fi

# shellcheck disable=SC2046
if [ $(image_exists $img_build) -eq 0 ]; then
  maybe_create $container $img_native

  b apt install -y --no-install-recommends openssh-server gdb rsync sudo

  b mkdir -p /var/run/sshd

  b bash -c 'echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && ssh-keygen -A'
  buildah config --port 22 $container

  b bash -c 'useradd -m -d /home/builderboy -s /bin/bash -G sudo builderboy && echo "builderboy:builderboy" | chpasswd && \
          sed -i /etc/sudoers -re "s/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g" && \
          sed -i /etc/sudoers -re "s/^root.*/root ALL=(ALL:ALL) NOPASSWD: ALL/g" && \
          sed -i /etc/sudoers -re "s/^#includedir.*/## **Removed the include directive** ##/g" && \
          echo "foo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'

  buildah config --entrypoint "/usr/sbin/sshd -D" $container
  buildah commit $container $img_build
fi

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
