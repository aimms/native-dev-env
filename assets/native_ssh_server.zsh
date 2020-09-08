#!/usr/bin/env zsh

export DEBIAN_FRONTEND=noninteractive

apt update
apt install -y --no-install-recommends openssh-server gdb rsync sudo

# configure SSH for communication with Visual Studio
mkdir -p /var/run/sshd
echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config && ssh-keygen -A

# create our 'builderboy' user
useradd -m -d /home/builderboy -s /bin/bash -G sudo builderboy && echo "builderboy:builderboy" | chpasswd

# let builderboy use sudo with requiring a password
sed -i /etc/sudoers -re 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g'
sed -i /etc/sudoers -re 's/^root.*/root ALL=(ALL:ALL) NOPASSWD: ALL/g'
sed -i /etc/sudoers -re 's/^#includedir.*/## **Removed the include directive** ##"/g'
echo "builderboy ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

apt autoremove -y && rm -rf /var/lib/apt/lists/*