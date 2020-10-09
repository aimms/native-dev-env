ARG VERSION=latest
FROM aimmspro/devenv-native:$VERSION
ENV BUILD_USER=builderboy
ENV DEVENV_SSH_SERVER=1

RUN apt update && apt install -y --no-install-recommends openssh-server gdb rsync sudo gdbserver

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

RUN cp /root/.bashrc /home/$BUILD_USER && \
    chown $BUILD_USER /home/$BUILD_USER/.bashrc

RUN chmod -R 777 /usr/local/pyenv/shims && \
    chmod -R 777 /usr/bin/cmake

# allowing conan to use latest clang
RUN mkdir -p /home/$BUILD_USER/.conan && \
    cp /assets/conan_settings.yml /home/$BUILD_USER/.conan/settings.yml && \
    chown -R $BUILD_USER /home/$BUILD_USER/.conan

RUN apt autoremove -y && rm -rf /var/lib/apt/lists/*

# expose sshd port
EXPOSE 22
ENTRYPOINT ["/usr/sbin/sshd -D"]
