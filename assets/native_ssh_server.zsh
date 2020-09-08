#!/usr/bin/env zsh

export DEBIAN_FRONTEND=noninteractive

BUILD_USER=builderboy

apt update
apt install -y --no-install-recommends openssh-server gdb rsync sudo

# configure SSH for communication with Visual Studio
mkdir -p /var/run/sshd
echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config && ssh-keygen -A

# create our '$BUILD_USER' user
useradd -m -d /home/$BUILD_USER -s /bin/bash -G sudo $BUILD_USER && echo "$BUILD_USER:$BUILD_USER" | chpasswd

# let $BUILD_USER use sudo with requiring a password
sed -i /etc/sudoers -re 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g'
sed -i /etc/sudoers -re 's/^root.*/root ALL=(ALL:ALL) NOPASSWD: ALL/g'
sed -i /etc/sudoers -re 's/^#includedir.*/## **Removed the include directive** ##"/g'
echo "$BUILD_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

chown root /var/run/sshd
chmod 744 /var/run/sshd

mv /root/.pyenv /home/$BUILD_USER
mv /root/.zshrc /home/$BUILD_USER

chown -R $BUILD_USER /home/$BUILD_USER
sed -i /home/$BUILD_USER/.zshrc -re "s/\/root/\/home\/$BUILD_USER/g"

chsh -s /bin/zsh $BUILD_USER

apt autoremove -y && rm -rf /var/lib/apt/lists/*
