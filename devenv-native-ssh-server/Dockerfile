ARG VERSION=latest
FROM aimmspro/devenv-native:$VERSION
ENV BUILD_USER=builderboy
ENV DEVENV_SSH_SERVER=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server rsync gdbserver

# configure SSH for communication with Visual Studio
RUN mkdir -p /var/run/sshd && \
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config && ssh-keygen -A

# create our builderboy user
# let builderboy use sudo with requiring a password
RUN useradd -m -d /home/$BUILD_USER -s /bin/bash -G sudo $BUILD_USER && echo "$BUILD_USER:$BUILD_USER" | chpasswd && \
    sed -i /etc/sudoers -re 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g' && \
    sed -i /etc/sudoers -re 's/^root.*/root ALL=(ALL:ALL) NOPASSWD: ALL/g' && \
    sed -i /etc/sudoers -re 's/^#includedir.*/## **Removed the include directive** ##"/g' && \
    echo "$BUILD_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN chown root /var/run/sshd && \
    chmod 744 /var/run/sshd

RUN curl -L git.io/antigen > /home/$BUILD_USER/.antigen.zsh

RUN cat /root/.zshrc > /home/$BUILD_USER/.zshrc && \
    chown $BUILD_USER:$BUILD_USER /home/$BUILD_USER/.zshrc

RUN apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

# expose sshd port
EXPOSE 22
ENTRYPOINT ["/usr/sbin/sshd", "-D"]
