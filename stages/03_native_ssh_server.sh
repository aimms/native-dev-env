#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

BUILD_USER=builderboy

apt update
apt install -y --no-install-recommends openssh-server gdb rsync sudo gdbserver

# configure SSH for communication with Visual Studio
mkdir -p /var/run/sshd
echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config && ssh-keygen -A

# create our builderboy user
useradd -m -d /home/$BUILD_USER -s /bin/bash -G sudo $BUILD_USER && echo "$BUILD_USER:$BUILD_USER" | chpasswd

# let builderboy use sudo with requiring a password
sed -i /etc/sudoers -re 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g'
sed -i /etc/sudoers -re 's/^root.*/root ALL=(ALL:ALL) NOPASSWD: ALL/g'
sed -i /etc/sudoers -re 's/^#includedir.*/## **Removed the include directive** ##"/g'
echo "$BUILD_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

chown root /var/run/sshd
chmod 744 /var/run/sshd

cp /root/.bashrc /home/$BUILD_USER
chown $BUILD_USER /home/$BUILD_USER/.bashrc

chmod -R 777 /usr/local/pyenv/shims
chmod -R 777 /usr/bin/cmake

mkdir -p /home/$BUILD_USER/.conan
# allowing conan to use latest clang
cp /host/assets/settings.yml /home/$BUILD_USER/.conan
chown -R $BUILD_USER /home/$BUILD_USER/.conan

chsh -s /bin/zsh $BUILD_USER

apt autoremove -y && rm -rf /var/lib/apt/lists/*
